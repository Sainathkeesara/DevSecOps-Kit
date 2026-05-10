#!/usr/bin/env bash
#
# Trivy Severity-Based Filtering for Vulnerability Triage
# Purpose: Implement severity-based filtering for Trivy vulnerability scanning
# Requirements: trivy, jq (for JSON processing)
# Level: L3
# Safety: --dry-run for preview, --ci-mode for non-interactive output
#
# This script provides severity-based filtering for Trivy vulnerability triage:
# - Run progressive scans based on severity thresholds
# - Generate filtered reports by severity level
# - Support CI/CD pipeline integration with fail-on-vulnerability
# - Count vulnerabilities by severity for triage metrics
#
# References:
#   - https://aquasecurity.github.io/trivy/docs/configuration/filtering/
#

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="trivy-severity-filter"
readonly SCRIPT_VERSION="1.0.0"
readonly DEFAULT_SEVERITY="HIGH,CRITICAL"

SCAN_MODE=0
FILTER_MODE=0
COUNT_MODE=0
DRY_RUN=false
IMAGE_NAME=""
REPORT_PATH="/tmp/trivy-results.json"
SEVERITY=""

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

Purpose: Trivy severity-based filtering for vulnerability triage

Usage: ${SCRIPT_NAME} [OPTIONS]

Options:
    --scan               Run vulnerability scan with severity filtering
    --image <name>      Container image to scan
    --severity <levels>  Severity levels: LOW,MEDIUM,HIGH,CRITICAL (default: ${DEFAULT_SEVERITY})
    --count             Count vulnerabilities by severity
    --filter            Filter existing JSON report by severity
    --report <path>     Report path (default: ${REPORT_PATH})
    --dry-run          Preview without scanning
    --ci-mode         Non-interactive output for CI/CD
    -v, --verbose     Verbose output
    -h, --help        Show this help

Examples:
    # Scan for critical vulnerabilities only
    ${SCRIPT_NAME} --scan --image myapp:latest --severity CRITICAL

    # Count vulnerabilities by severity
    ${SCRIPT_NAME} --count --report results.json

    # Filter existing report
    ${SCRIPT_NAME} --filter --report results.json --severity HIGH,CRITICAL
EOF
}

check_dependencies() {
    if ! command -v jq >/dev/null 2>&1; then
        log_error "Missing dependency: jq"
        exit 1
    fi
}

run_severity_scan() {
    local image="$1"
    local severity="${2:-$DEFAULT_SEVERITY}"

    log_info "Scanning image: $image"
    log_info "Severity filter: $severity"

    if [[ "$DRY_RUN" == "true" ]]; then
        log_warn "[dry-run] Would run: trivy image --severity $severity --ignore-unfixed $image"
        return 0
    fi

    if command -v trivy >/dev/null 2>&1; then
        trivy image \
            --severity "$severity" \
            --ignore-unfixed \
            --exit-code 1 \
            "$image" 2>/dev/null || {
            local exit_code=$?
            log_warn "Vulnerabilities found at or above $severity threshold"
            return $exit_code
        }
        log_success "No vulnerabilities found at specified severity"
        return 0
    else
        log_error "Trivy not found"
        return 1
    fi
}

count_vulnerabilities() {
    local report="$1"

    if [[ ! -f "$report" ]]; then
        log_error "Report not found: $report"
        return 1
    fi

    log_info "Counting vulnerabilities by severity..."

    jq -r '
        .Results[].Vulnerabilities[]?.Severity // empty
    ' "$report" | sort | uniq -c | sort -rn

    echo ""
    log_info "Total counts:"
    jq -r '
        [.Results[].Vulnerabilities[].Severity // empty] |
        group_by(.) |
        map({severity: .[0], count: length}) |
        sort_by(-.count) |
        .[] | "\(.severity): \(.count)"
    ' "$report"
}

filter_report() {
    local report="$1"
    local severity="$2"

    if [[ ! -f "$report" ]]; then
        log_error "Report not found: $report"
        return 1
    fi

    log_info "Filtering report for severity: $severity"

    local filtered_path="${report%.json}-filtered.json"

    jq --arg severities "$severity" '
        .Results[].Vulnerabilities |=
        [.[] | select(.Severity as $s |
            ($severities | split(",")) as $levels |
            any($levels[]; . == $s)
        )]
    ' "$report" > "$filtered_path"

    log_info "Filtered report saved to: $filtered_path"
}

main() {
    log_info "Starting ${SCRIPT_NAME} v${SCRIPT_VERSION}"

    check_dependencies

    if [[ "$COUNT_MODE" == "1" ]]; then
        count_vulnerabilities "$REPORT_PATH"
        exit 0
    fi

    if [[ "$FILTER_MODE" == "1" ]]; then
        filter_report "$REPORT_PATH" "$SEVERITY"
        exit 0
    fi

    if [[ "$SCAN_MODE" == "1" ]]; then
        if [[ -z "$IMAGE_NAME" ]]; then
            log_error "--image required for scan mode"
            usage
            exit 1
        fi
        run_severity_scan "$IMAGE_NAME" "$SEVERITY"
        exit $?
    fi

    usage
    exit 0
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --scan)
            SCAN_MODE=1
            shift
            ;;
        --image)
            IMAGE_NAME="$2"
            shift 2
            ;;
        --severity)
            SEVERITY="$2"
            shift 2
            ;;
        --count)
            COUNT_MODE=1
            shift
            ;;
        --filter)
            FILTER_MODE=1
            shift
            ;;
        --report)
            REPORT_PATH="$2"
            shift 2
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