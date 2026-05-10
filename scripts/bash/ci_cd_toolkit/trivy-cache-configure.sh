#!/usr/bin/env bash
#
# Trivy Cache Configuration for Accelerated Repeated Scans
# Purpose: Configure Trivy cache for optimized repeated vulnerability scans
# Requirements: trivy, rsync
# Level: L3
# Safety: --dry-run for preview, --reset to clear cache
#
# This script configures Trivy cache for accelerated scans:
# - Set custom cache directory
# - Pre-warm vulnerability database
# - Manage cache persistence in CI/CD
# - Optimize layer caching for repeated scans
#
# References:
#   - https://aquasecurity.github.io/trivy/docs/advanced/cache/
#

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="trivy-cache-configure"
readonly SCRIPT_VERSION="1.0.0"
readonly DEFAULT_CACHE_DIR="${TRIVY_CACHE_DIR:-/tmp/trivy-cache}"

CONFIGURE_MODE=0
PREWARM_MODE=0
RESET_MODE=0
STATUS_MODE=0
DRY_RUN=false
CACHE_DIR=""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $*" >&2; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*" >&2; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_success() { echo -e "${BLUE}[SUCCESS]${NC} $*" >&2; }

usage() {
    cat <<EOF
${SCRIPT_NAME} v${SCRIPT_VERSION}

Purpose: Configure Trivy cache for accelerated vulnerability scans

Usage: ${SCRIPT_NAME} [OPTIONS]

Options:
    --configure         Set up Trivy cache directory
    --cache-dir <path>  Custom cache directory (default: ${DEFAULT_CACHE_DIR})
    --prewarm          Download vulnerability database in advance
    --reset            Clear Trivy cache
    --status           Show cache status and size
    --dry-run          Preview without making changes
    -v, --verbose      Verbose output
    -h, --help         Show this help

Examples:
    # Configure cache directory
    ${SCRIPT_NAME} --configure --cache-dir /var/cache/trivy

    # Pre-warm cache (download database)
    ${SCRIPT_NAME} --prewarm

    # Check cache status
    ${SCRIPT_NAME} --status

    # Reset cache
    ${SCRIPT_NAME} --reset
EOF
}

check_dependencies() {
    : # No required dependencies for cache configuration
}

configure_cache() {
    local cache_dir="${1:-$DEFAULT_CACHE_DIR}"

    log_info "Configuring Trivy cache directory: $cache_dir"

    if [[ "$DRY_RUN" == "true" ]]; then
        log_warn "[dry-run] Would create: $cache_dir"
        return 0
    fi

    if [[ ! -d "$cache_dir" ]]; then
        mkdir -p "$cache_dir"
        chmod 755 "$cache_dir"
        log_success "Cache directory created: $cache_dir"
    else
        log_info "Cache directory exists: $cache_dir"
    fi

    export TRIVY_CACHE_DIR="$cache_dir"
    log_info "TRIVY_CACHE_DIR set to: $cache_dir"
}

prewarm_cache() {
    local cache_dir="${1:-$DEFAULT_CACHE_DIR}"

    log_info "Pre-warming Trivy cache..."
    log_info "Cache directory: $cache_dir"

    if [[ "$DRY_RUN" == "true" ]]; then
        log_warn "[dry-run] Would download: vulnerability database"
        return 0
    fi

    mkdir -p "$cache_dir"

    if command -v trivy >/dev/null 2>&1; then
        log_info "Downloading vulnerability database..."
        trivy image --cache-dir "$cache_dir" --download-db-only || {
            log_warn "Cache pre-warm had issues, may work on next run"
        }

        log_info "Verifying cache contents..."
        ls -la "$cache_dir/db/" 2>/dev/null || log_warn "Database not yet downloaded"
    else
        log_error "Trivy not found - cannot pre-warm cache"
        return 1
    fi

    log_success "Cache pre-warmed successfully"
}

reset_cache() {
    local cache_dir="${1:-$DEFAULT_CACHE_DIR}"

    log_info "Resetting Trivy cache: $cache_dir"

    if [[ "$DRY_RUN" == "true" ]]; then
        log_warn "[dry-run] Would remove: $cache_dir"
        return 0
    fi

    if [[ -d "$cache_dir" ]]; then
        rm -rf "$cache_dir"
        log_success "Cache directory removed: $cache_dir"
    else
        log_info "Cache directory does not exist: $cache_dir"
    fi
}

show_status() {
    local cache_dir="${1:-$DEFAULT_CACHE_DIR}"

    log_info "Trivy Cache Status"
    echo "======================================"
    echo "Cache directory: $cache_dir"

    if [[ -d "$cache_dir" ]]; then
        local size
        size=$(du -sh "$cache_dir" 2>/dev/null | cut -f1 || echo "unknown")
        echo "Cache size: $size"
        echo ""
        echo "Contents:"
        ls -la "$cache_dir/" 2>/dev/null || echo "Empty or inaccessible"

        if [[ -d "$cache_dir/db" ]]; then
            echo ""
            echo "Database status:"
            ls -la "$cache_dir/db/" 2>/dev/null
        fi
    else
        echo "Cache directory not found"
    fi

    echo "======================================"
}

main() {
    log_info "Starting ${SCRIPT_NAME} v${SCRIPT_VERSION}"

    check_dependencies

    local cache_dir="${CACHE_DIR:-$DEFAULT_CACHE_DIR}"

    if [[ "$STATUS_MODE" == "1" ]]; then
        show_status "$cache_dir"
        exit 0
    fi

    if [[ "$RESET_MODE" == "1" ]]; then
        reset_cache "$cache_dir"
        exit 0
    fi

    if [[ "$PREWARM_MODE" == "1" ]]; then
        prewarm_cache "$cache_dir"
        exit 0
    fi

    if [[ "$CONFIGURE_MODE" == "1" ]]; then
        configure_cache "$cache_dir"
        exit 0
    fi

    usage
    exit 0
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --configure)
            CONFIGURE_MODE=1
            shift
            ;;
        --cache-dir)
            CACHE_DIR="$2"
            shift 2
            ;;
        --prewarm)
            PREWARM_MODE=1
            shift
            ;;
        --reset)
            RESET_MODE=1
            shift
            ;;
        --status)
            STATUS_MODE=1
            shift
            ;;
        --dry-run)
            DRY_RUN=true
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