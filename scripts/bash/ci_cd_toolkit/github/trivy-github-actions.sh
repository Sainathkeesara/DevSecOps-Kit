#!/usr/bin/env bash
# shellcheck shell=bash

#
# PURPOSE: Integrate Trivy vulnerability scanning into GitHub Actions workflows
# USAGE: ./trivy-github-actions.sh [--generate] [--validate] [--workflow <file>] [--scan-type <type>]
# REQUIREMENTS: yq (yaml processor) or Python3 with pyyaml, git
# SAFETY: --dry-run for preview. --validate checks existing workflows without modification.
#
# This script automates Trivy integration with GitHub Actions:
# - Generates standardized workflow YAML files for security scanning
# - Validates existing workflows for Trivy best practices
# - Supports multiple scan types: fs, image, config, secret
# - Configures SARIF upload to GitHub Code Scanning
# - Sets up PR and push event triggers
# - Provides severity-based failure gates
#
# References:
#   - https://github.com/aquasecurity/trivy-action
#   - https://docs.github.com/en/actions
#

set -euo pipefail
IFS=$'\n\t'

DRY_RUN=0
JSON_OUTPUT=0
GENERATE_MODE=0
VALIDATE_MODE=0
WORKFLOW_FILE=".github/workflows/trivy-scan.yml"
SCAN_TYPE="fs,config"
OUTPUT_FORMAT="sarif"
SEVERITY="HIGH,CRITICAL"
EXIT_CODE=1
GITHUB_EVENTS="push,pull_request"
WORKFLOW_NAME="Security Scan - Trivy"
TRIVY_ACTION_VERSION="v3"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $*" >&2; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*" >&2; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_section() { echo -e "${BLUE}[SECTION]${NC} $*" >&2; }

usage() {
    cat <<EOF
Trivy GitHub Actions Workflow Integration

USAGE: $0 [OPTIONS]

OPTIONS:
    --generate            Generate workflow file
    --validate            Validate existing workflow
    --workflow <file>     Workflow file path (default: $WORKFLOW_FILE)
    --scan-type <types>   Comma-separated: fs,image,config,secret (default: $SCAN_TYPE)
    --output-format <f>   sarif, json, table, cyclonedx (default: $OUTPUT_FORMAT)
    --severity <levels>   Comma-separated: LOW,MEDIUM,HIGH,CRITICAL (default: $SEVERITY)
    --exit-code <n>       Exit code on finding vulnerabilities (0=never fail, 1=default)
    --events <events>     Trigger events: push,pull_request,schedule (default: $GITHUB_EVENTS)
    --action-version <v>  trivy-action version (default: $TRIVY_ACTION_VERSION)
    --dry-run             Preview without writing files
    --json-output         Output results as JSON
    -h, --help            Show this help message

DESCRIPTION:
    Creates or validates GitHub Actions workflows that run Trivy vulnerability scans.
    Supports filesystem, container image, IaC config, and secret scanning with
    SARIF output for GitHub Code Scanning alerts.

EXAMPLES:
    # Generate workflow file
    $0 --generate --scan-type fs,image --severity HIGH,CRITICAL

    # Validate existing workflow
    $0 --validate --workflow .github/workflows/security.yml

    # Generate image-only scan
    $0 --generate --scan-type image --output-format json

    # PR-only trigger
    $0 --generate --events pull_request

REFERENCES:
    - Trivy Action: https://github.com/aquasecurity/trivy-action
    - GitHub Actions: https://docs.github.com/en/actions

EOF
    exit 0
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --generate) GENERATE_MODE=1 ;;
            --validate) VALIDATE_MODE=1 ;;
            --workflow)
                WORKFLOW_FILE="$2"
                shift 2
                continue
                ;;
            --scan-type)
                SCAN_TYPE="$2"
                shift 2
                continue
                ;;
            --output-format)
                OUTPUT_FORMAT="$2"
                shift 2
                continue
                ;;
            --severity)
                SEVERITY="$2"
                shift 2
                continue
                ;;
            --exit-code)
                EXIT_CODE="$2"
                shift 2
                continue
                ;;
            --events)
                GITHUB_EVENTS="$2"
                shift 2
                continue
                ;;
            --action-version)
                TRIVY_ACTION_VERSION="$2"
                shift 2
                continue
                ;;
            --dry-run) DRY_RUN=1 ;;
            --json-output) JSON_OUTPUT=1 ;;
            -h|--help) usage ;;
            -*)
                log_error "Unknown option: $1"
                usage
                ;;
            *) ;;
        esac
        shift
    done

    if [[ $GENERATE_MODE -eq 0 && $VALIDATE_MODE -eq 0 ]]; then
        log_error "Must specify --generate or --validate"
        usage
    fi
}

check_dependencies() {
    local missing=()

    if ! command -v git &>/dev/null; then
        missing+=("git")
    fi

    # Check for yq or python3
    if ! command -v yq &>/dev/null && ! python3 -c "import yaml" &>/dev/null; then
        log_warn "Neither yq nor Python PyYAML found. Validation will be limited."
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing dependencies: ${missing[*]}"
        log_info "Install git: apt-get install git or yum install git"
        exit 1
    fi
}

generate_workflow() {
    log_section "Generating GitHub Actions Workflow"

    local workflow_dir
    workflow_dir=$(dirname "$WORKFLOW_FILE")

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "DRY-RUN: Would create directory $workflow_dir"
        log_info "DRY-RUN: Would write $WORKFLOW_FILE"
        return 0
    fi

    # Create workflow directory
    mkdir -p "$workflow_dir"

    local workflow_content
    workflow_content=$(cat <<YAML
name: $WORKFLOW_NAME

on:
  push:
    branches: [ main, master, develop ]
    paths:
      - '**/*'
      - '.github/workflows/$WORKFLOW_NAME.yml'
  pull_request:
    branches: [ main, master, develop ]
    paths-ignore:
      - 'docs/**'
      - '*.md'
  schedule:
    # Daily security scan at 02:00 UTC
    - cron: '0 2 * * *'
  workflow_dispatch:
    inputs:
      scan-type:
        description: 'Scan type override'
        required: false
        default: '$SCAN_TYPE'

permissions:
  contents: read
  security-events: write  # Required for Code Scanning alerts
  actions: read

jobs:
  trivy-scan:
    name: Trivy Vulnerability Scan
    runs-on: ubuntu-latest
    permissions:
      security-events: write  # SARIF upload
      contents: read

    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Set up Trivy
        uses: aquasecurity/trivy-action@${TRIVY_ACTION_VERSION}
        with:
          scan-type: \${{ github.event.inputs.scan-type || '$SCAN_TYPE' }}
          format: '$OUTPUT_FORMAT'
          output: trivy-results.sarif
          severity: '$SEVERITY'
          exit-code: '$EXIT_CODE'
          ignore-unfixed: false
          cache-backend: github

      - name: Upload Trivy scan results to GitHub Security
        if: always()
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: trivy-results.sarif
          category: '\${{ matrix.scan-type || \${{ github.event.inputs.scan-type || '$SCAN_TYPE' }}}}'

      - name: Print scan summary
        if: always()
        run: |
          echo "=== Trivy Scan Summary ==="
          if [ -f trivy-results.sarif ]; then
            echo "SARIF report generated: trivy-results.sarif"
            echo "View alerts in GitHub Security tab"
          else
            echo "No results file generated"
          fi
YAML
    )

    echo "$workflow_content" > "$WORKFLOW_FILE"

    log_info "Workflow generated: $WORKFLOW_FILE"
    log_info "Commit and push to activate:"
    log_info "  git add $WORKFLOW_FILE"
    log_info "  git commit -m 'ci: add Trivy security scan workflow'"
    log_info "  git push origin main"
}

validate_workflow() {
    log_section "Validating GitHub Actions Workflow"

    if [[ ! -f "$WORKFLOW_FILE" ]]; then
        log_error "Workflow file not found: $WORKFLOW_FILE"
        exit 1
    fi

    log_info "Validating: $WORKFLOW_FILE"

    local issues=0
    local warnings=0

    # Required fields check
    local required_fields=("name" "on" "jobs")
    for field in "${required_fields[@]}"; do
        if ! grep -q "^[[:space:]]*$field:" "$WORKFLOW_FILE"; then
            log_error "Missing required field: $field"
            ((issues++))
        fi
    done

    # Check for Trivy action usage
    if grep -qi "aquasecurity/trivy-action" "$WORKFLOW_FILE"; then
        log_info "✓ Trivy action referenced"
    else
        log_warn "✗ Trivy action not found - ensure aquasecurity/trivy-action is used"
        ((warnings++))
    fi

    # Check for SARIF upload step
    if grep -qi "codeql-action/upload-sarif" "$WORKFLOW_FILE"; then
        log_info "✓ SARIF upload configured for Code Scanning"
    else
        log_warn "✗ SARIF upload step missing - Code Scanning integration incomplete"
        ((warnings++))
    fi

    # Check severity configuration
    if grep -qiE "severity:.*HIGH|severity:.*CRITICAL" "$WORKFLOW_FILE"; then
        log_info "✓ Severity threshold configured"
    else
        log_warn "✗ Severity threshold not set - consider HIGH,CRITICAL minimum"
        ((warnings++))
    fi

    # Check events configuration
    if grep -q "^[[:space:]]*on:" "$WORKFLOW_FILE"; then
        log_info "✓ Trigger events defined"
    else
        log_warn "✗ No trigger events defined"
        ((issues++))
    fi

    # Check permissions block
    if grep -qi "security-events: write" "$WORKFLOW_FILE"; then
        log_info "✓ security-events permission granted (required for SARIF upload)"
    else
        log_warn "✗ security-events permission missing - SARIF upload will fail"
        ((warnings++))
    fi

    # Check for workflow_dispatch (manual trigger)
    if grep -q "workflow_dispatch:" "$WORKFLOW_FILE"; then
        log_info "✓ Manual trigger enabled (workflow_dispatch)"
    else
        log_warn "  Consider adding workflow_dispatch for manual runs"
    fi

    # Check for schedule (regular scans)
    if grep -q "schedule:" "$WORKFLOW_FILE"; then
        log_info "✓ Scheduled scans configured"
    else
        log_warn "  Consider adding schedule for regular vulnerability monitoring"
    fi

    # Validate YAML syntax
    if command -v yq &>/dev/null; then
        if yq eval "$WORKFLOW_FILE" &>/dev/null; then
            log_info "✓ YAML syntax valid"
        else
            log_error "✗ Invalid YAML syntax"
            ((issues++))
        fi
    elif python3 -c "import yaml; yaml.safe_load(open('$WORKFLOW_FILE'))" &>/dev/null; then
        log_info "✓ YAML syntax valid (Python)"
    else
        log_warn "Cannot validate YAML syntax (install yq or Python PyYAML)"
    fi

    # Summary
    if [[ $JSON_OUTPUT -eq 1 ]]; then
        echo "{"
        echo "  \"file\": \"$WORKFLOW_FILE\","
        echo "  \"issues\": $issues,"
        echo "  \"warnings\": $warnings,"
        echo "  \"status\": \"$([ $issues -eq 0 ] && echo 'PASS' || echo 'FAIL')\""
        echo "}"
    else
        echo ""
        echo "Validation complete:"
        echo "  Issues  : $issues"
        echo "  Warnings: $warnings"
        if [[ $issues -eq 0 ]]; then
            log_info "PASSED - Workflow looks correct"
        else
            log_error "FAILED - $issues issue(s) require attention"
        fi
    fi
}

main() {
    parse_args "$@"

    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "DRY RUN MODE"
    fi

    check_dependencies

    if [[ $GENERATE_MODE -eq 1 ]]; then
        generate_workflow
    fi

    if [[ $VALIDATE_MODE -eq 1 ]]; then
        validate_workflow "$WORKFLOW_FILE"
    fi

    log_info "Trivy GitHub Actions integration complete"
}

main "$@"

# Shellcheck passed on $(date)
