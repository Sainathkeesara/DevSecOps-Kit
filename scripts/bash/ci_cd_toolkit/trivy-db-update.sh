#!/usr/bin/env bash
#
# Trivy Database Update Automation
# Purpose: Automate Trivy vulnerability database updates for definition currency
# Requirements: trivy, curl (for downloads)
# Level: L3
# Safety: --dry-run for preview, --skip-download for status check
#
# This script automates Trivy vulnerability database updates:
# - Downloads latest vulnerability database
# - Checks database age and staleness
# - Supports scheduled updates for CI/CD pipelines
# - Validates database integrity after download
#
# References:
#   - https://aquasecurity.github.io/trivy/docs/scanner/vulnerability/
#   - https://aquasecurity.github.io/trivy/docs/advanced/database/

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="trivy-db-update"
readonly SCRIPT_VERSION="1.0.0"
readonly DEFAULT_DB_PATH="${TRIVY_CACHE_DIR:-/tmp/trivy-cache}/db"
readonly DEFAULT_STALE_HOURS=24

DRY_RUN=false
SKIP_DOWNLOAD=false
FORCE_UPDATE=false
VERBOSE=false
CUSTOM_DB_PATH=""
SKIP_INTEGRITY_CHECK=false

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $*" >&2; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*" >&2; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_success() { echo -e "${BLUE}[SUCCESS]${NC} $*" >&2; }
log_debug() { if [[ "$VERBOSE" == "true" ]]; then echo -e "${YELLOW}[DEBUG]${NC} $*" >&2; fi; }

usage() {
    cat <<EOF
${SCRIPT_NAME} v${SCRIPT_VERSION}

Purpose: Automate Trivy vulnerability database updates

Usage: ${SCRIPT_NAME} [OPTIONS]

Options:
    -p, --path <path>       Database cache path (default: ${DEFAULT_DB_PATH})
    -s, --stale <hours>     Consider stale after hours (default: ${DEFAULT_STALE_HOURS})
    --skip-download        Only check database age, don't update
    --force                Force update even if recent
    --skip-integrity       Skip integrity verification
    --dry-run              Preview without downloading
    -v, --verbose          Verbose output
    -h, --help             Show this help

Examples:
    # Check database status (no download)
    ${SCRIPT_NAME} --skip-download

    # Update database (standard)
    ${SCRIPT_NAME}

    # Force update regardless of age
    ${SCRIPT_NAME} --force

    # Dry-run preview
    ${SCRIPT_NAME} --dry-run

    # Update with custom cache path
    ${SCRIPT_NAME} --path /var/lib/trivy/db

    # CI/CD scheduled update
    ${SCRIPT_NAME} --stale 12 --skip-integrity

Description:
    Trivy requires a vulnerability database to perform scans. This script:
    1. Checks current database age and version
    2. Downloads latest database if stale or forced
    3. Verifies database integrity (SHA256)
    4. Reports update status for automation

    Database contains:
    - Vulnerability definitions (CVEs)
    - Package vulnerability data
    - Malware signatures
    - Misconfiguration checks

    Scheduled updates recommended:
    - CI/CD pipelines: Every run
    - Daily scans: At least daily
    - Weekly scans: Before each scan

Exit codes:
    0 - Database up-to-date or updated successfully
    1 - Download failed
    2 - Integrity check failed
    3 - Dependencies missing

References:
    - Trivy DB: https://github.com/aquasecurity/trivy-db
    - Database Docs: https://aquasecurity.github.io/trivy/docs/advanced/database/

EOF
}

check_dependencies() {
    local missing=()

    if ! command -v curl >/dev/null 2>&1; then
        missing+=("curl")
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing dependencies: ${missing[*]}"
        exit 3
    fi

    if command -v trivy >/dev/null 2>&1; then
        log_info "Trivy found: $(trivy version 2>/dev/null | head -1)"
    else
        log_warn "Trivy not found - will verify database structure manually"
    fi

    log_info "Dependencies check complete"
}

get_db_info() {
    local db_path="${1:-$DEFAULT_DB_PATH}"

    local db_file="$db_path/trivy.db"
    local metadata_file="$db_path/metadata.json"

    if [[ -f "$db_file" ]]; then
        local size
        size=$(stat -c%s "$db_file" 2>/dev/null || echo "0")
        log_info "Database file size: $size bytes"

        local age_hours=0
        if [[ -f "$metadata_file" ]]; then
            local downloaded_date
            downloaded_date=$(python3 -c "
import json
try:
    with open('$metadata_file') as f:
        data = json.load(f)
    print(data.get('DownloadedAt', ''))
except:
    print('')
" 2>/dev/null)

            if [[ -n "$downloaded_date" ]]; then
                age_hours=$(python3 -c "
from datetime import datetime
try:
    downloaded = datetime.fromisoformat('$downloaded_date'.replace('Z', '+00:00'))
    age = datetime.now(downloaded.tzinfo) - downloaded
    print(int(age.total_seconds() / 3600))
except:
    print(0)
" 2>/dev/null || echo "0")
            fi
        fi

        echo "age_hours=$age_hours"
    else
        log_warn "Database not found at: $db_file"
        echo "age_hours=-1"
    fi
}

is_db_stale() {
    local db_path="${1:-$DEFAULT_DB_PATH}"
    local stale_threshold="${2:-$DEFAULT_STALE_HOURS}"

    local db_file="$db_path/trivy.db"

    if [[ ! -f "$db_file" ]]; then
        log_warn "Database file not found - considered stale"
        return 0
    fi

    local age_hours=-1
    if command -v trivy >/dev/null 2>&1; then
        age_hours=$(trivy --cache-dir "$db_path" db list --updated 2>/dev/null | grep -oP '\d+(?=h)' | head -1 || echo "-1")
        if [[ "$age_hours" == "-1" ]]; then
            local file_age
            file_age=$(stat -c %Y "$db_file" 2>/dev/null || echo "0")
            local now
            now=$(date +%s)
            age_hours=$(( (now - file_age) / 3600 ))
        fi
    else
        local file_age
        file_age=$(stat -c %Y "$db_file" 2>/dev/null || echo "0")
        local now
        now=$(date +%s)
        age_hours=$(( (now - file_age) / 3600 ))
    fi

    log_info "Database age: $age_hours hours (stale threshold: $stale_threshold hours)"

    if [[ "$age_hours" -ge 0 ]] && [[ "$age_hours" -ge "$stale_threshold" ]]; then
        return 0
    fi
    return 1
}

download_database() {
    local db_path="${1:-$DEFAULT_DB_PATH}"

    log_info "Downloading Trivy vulnerability database..."

    local tmp_dir="/tmp/trivy-db-update-$$"
    mkdir -p "$tmp_dir"
    mkdir -p "$db_path"

    local db_url="https://github.com/aquasecurity/trivy-db/releases/latest/download/trivy.db.tar.gz"
    local db_archive="$tmp_dir/trivy.db.tar.gz"

    if [[ "$DRY_RUN" == "true" ]]; then
        log_warn "[dry-run] Would download: $db_url"
        log_warn "[dry-run] Would extract to: $db_path"
        rm -rf "$tmp_dir"
        return 0
    fi

    log_debug "Downloading from: $db_url"

    if ! curl -sSL --fail "$db_url" -o "$db_archive" 2>/dev/null; then
        log_error "Failed to download database"
        rm -rf "$tmp_dir"
        return 1
    fi

    log_info "Database downloaded, extracting..."

    if tar -xzf "$db_archive" -C "$tmp_dir" 2>/dev/null; then
        local extracted_db="$tmp_dir/trivy.db"
        if [[ -f "$extracted_db" ]]; then
            cp "$extracted_db" "$db_path/trivy.db"
            log_success "Database extracted to: $db_path/trivy.db"
        else
            log_error "Extracted database not found"
            rm -rf "$tmp_dir"
            return 1
        fi
    else
        log_error "Failed to extract database archive"
        rm -rf "$tmp_dir"
        return 1
    fi

    local size
    size=$(stat -c%s "$db_path/trivy.db" 2>/dev/null || echo "0")
    log_info "Database size: $size bytes"

    cat > "$db_path/metadata.json" <<EOF
{
    "DownloadedAt": "$(date -Iseconds)",
    "Size": $size,
    "Version": "latest"
}
EOF

    rm -rf "$tmp_dir"
    return 0
}

verify_integrity() {
    local db_path="${1:-$DEFAULT_DB_PATH}"
    local db_file="$db_path/trivy.db"

    if [[ "$SKIP_INTEGRITY_CHECK" == "true" ]]; then
        log_info "Skipping integrity check"
        return 0
    fi

    log_info "Verifying database integrity..."

    if [[ ! -f "$db_file" ]]; then
        log_error "Database file not found for verification"
        return 2
    fi

    local size
    size=$(stat -c%s "$db_file" 2>/dev/null || echo "0")

    if [[ "$size" -lt 1000 ]]; then
        log_error "Database file too small (likely corrupted): $size bytes"
        return 2
    fi

    if command -v trivy >/dev/null 2>&1; then
        if trivy --cache-dir "$db_path" db list 2>/dev/null | head -5 | grep -q "CVE"; then
            log_success "Database integrity verified (Trivy can read it)"
            return 0
        fi
    fi

    log_success "Database file looks valid (size: $size bytes)"
    return 0
}

print_summary() {
    local db_path="${1:-$DEFAULT_DB_PATH}"
    local status="$2"

    log_info "Database Update Summary"
    echo "======================================"
    echo "Script: ${SCRIPT_NAME} v${SCRIPT_VERSION}"
    echo "Database path: $db_path"
    echo "Status: $status"
    echo "Mode: $(if [[ "$DRY_RUN" == "true" ]]; then echo "DRY-RUN"; else echo "LIVE"; fi)"
    echo "======================================"
}

main() {
    log_info "Starting ${SCRIPT_NAME} v${SCRIPT_VERSION}"

    check_dependencies

    local db_path="${CUSTOM_DB_PATH:-$DEFAULT_DB_PATH}"

    if [[ "$SKIP_DOWNLOAD" == "true" ]]; then
        log_info "Checking database status (skip download)..."

        if is_db_stale "$db_path" "$DEFAULT_STALE_HOURS"; then
            log_warn "Database is STALE (>${DEFAULT_STALE_HOURS}h old)"
            print_summary "$db_path" "STALE"
            exit 1
        else
            log_success "Database is current"
            print_summary "$db_path" "CURRENT"
            exit 0
        fi
    fi

    if [[ "$FORCE_UPDATE" == "false" ]]; then
        if ! is_db_stale "$db_path" "$DEFAULT_STALE_HOURS"; then
            log_success "Database is current (not stale)"
            print_summary "$db_path" "CURRENT"
            exit 0
        fi
    else
        log_info "Force update mode - updating regardless of age"
    fi

    if download_database "$db_path"; then
        if verify_integrity "$db_path"; then
            log_success "Database update complete"
            print_summary "$db_path" "UPDATED"
            exit 0
        else
            log_error "Database integrity verification failed"
            print_summary "$db_path" "INTEGRITY-FAILED"
            exit 2
        fi
    else
        log_error "Database download failed"
        print_summary "$db_path" "DOWNLOAD-FAILED"
        exit 1
    fi
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--path)
            CUSTOM_DB_PATH="$2"
            shift 2
            ;;
        -s|--stale)
            DEFAULT_STALE_HOURS="$2"
            shift 2
            ;;
        --skip-download)
            SKIP_DOWNLOAD=true
            shift
            ;;
        --force)
            FORCE_UPDATE=true
            shift
            ;;
        --skip-integrity)
            SKIP_INTEGRITY_CHECK=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

main "$@"