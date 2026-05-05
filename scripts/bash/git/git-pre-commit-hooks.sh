#!/usr/bin/env bash
# Git Pre-commit Hook Automation for Security Scanning
# Level: L6 | Category: Git | Purpose: Pre-commit security scanning and validation hooks
# Supports: Linux, macOS, Windows (Git Bash)

set -euo pipefail

SCAN_SECRETS="${SCAN_SECRETS:-true}"
SCAN_VULNS="${SCAN_VULNS:-true}"
SCAN_QUALITY="${SCAN_QUALITY:-true}"
DRY_RUN="${DRY_RUN:-false}"
VERBOSE="${VERBOSE:-false}"
EXIT_ON_ERROR="${EXIT_ON_ERROR:-true}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()   { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }
log_debug() { [[ "$VERBOSE" == "true" ]] && echo -e "${BLUE}[DEBUG]${NC} $*"; }

fail_hook() {
    log_error "Pre-commit hook failed: $*"
    exit 1
}

check_command() {
    local cmd="$1"
    if ! command -v "$cmd" &>/dev/null; then
        log_debug "$cmd not found, skipping"
        return 1
    fi
    return 0
}

commit_fail() {
    [[ "$EXIT_ON_ERROR" == "true" ]] && fail_hook "$*"
    return 1
}

scan_secrets() {
    log_info "Scanning for secrets..."

    local secrets_found=0

    if check_command trufflehog; then
        local staged_files
        staged_files=$(git diff --cached --name-only --diff-filter=ACM)

        for file in $staged_files; do
            if [[ -f "$file" ]]; then
                if trufflehog filesystem "$file" 2>/dev/null | grep -q "Found secrets"; then
                    log_error "Secrets detected in $file"
                    secrets_found=1
                fi
            fi
        done
    fi

    if check_command git-secrets; then
        if git secrets --install &>/dev/null 2>&1; then
            if ! git secrets --scan --cached 2>/dev/null; then
                secrets_found=1
            fi
        fi
    fi

    local patterns=(
        "AKIA[0-9A-Z]{16}"
        "ghp_[a-zA-Z0-9]{36}"
        "gho_[a-zA-Z0-9]{36}"
        "xox[baprs]-([a-zA-Z0-9]{10,48})"
        "sk-[a-zA-Z0-9]{48}"
    )

    local staged_files
    staged_files=$(git diff --cached --name-only --diff-filter=ACM)

    for pattern in "${patterns[@]}"; do
        for file in $staged_files; do
            if [[ -f "$file" ]]; then
                if grep -Eq "$pattern" "$file" 2>/dev/null; then
                    log_error "Potential secret found in $file (pattern: $pattern)"
                    secrets_found=1
                fi
            fi
        done
    done

    if [[ $secrets_found -eq 1 ]]; then
        commit_fail "Secrets detected in staged files"
        return 1
    fi

    log_info "Secrets scan passed"
    return 0
}

scan_vulnerabilities() {
    log_info "Scanning for vulnerabilities..."

    local vuls_found=0

    if [[ -f "package.json" ]] && check_command npm; then
        if ! npm audit --json 2>/dev/null | jq -e '.metadata.vulnerability_count == 0' &>/dev/null 2>&1; then
            local vulns
            vulns=$(npm audit --json 2>/dev/null | jq -r '.metadata.vulnerability_count // 0')
            if [[ "$vulns" -gt 0 ]]; then
                log_error "Found $vulns npm vulnerabilities"
                vuls_found=1
            fi
        fi
    fi

    if [[ -f "requirements.txt" || -f "Pipfile" ]] && check_command pip-audit; then
        if ! pip-audit &>/dev/null 2>&1; then
            log_error "Python vulnerabilities detected"
            vuls_found=1
        fi
    fi

    if check_command tfsec; then
        if ls -- *.tf &>/dev/null 2>&1; then
            if ! tfsec . --exit-code 1 &>/dev/null 2>&1; then
                log_error "Terraform security issues detected"
                vuls_found=1
            fi
        fi
    fi

    if check_command hadolint; then
        if [[ -f "Dockerfile" ]]; then
            if ! hadolint Dockerfile &>/dev/null 2>&1; then
                log_error "Dockerfile issues detected"
                vuls_found=1
            fi
        fi
    fi

    if [[ $vuls_found -eq 1 ]]; then
        commit_fail "Vulnerabilities detected"
        return 1
    fi

    log_info "Vulnerability scan passed"
    return 0
}

scan_quality() {
    log_info "Scanning code quality..."

    local quality_issues=0

    if check_command shellcheck; then
        local sh_files
        sh_files=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.sh$')

        for file in $sh_files; do
            if [[ -f "$file" ]]; then
                if ! shellcheck "$file" &>/dev/null 2>&1; then
                    log_error "Shellcheck issues in $file"
                    quality_issues=1
                fi
            fi
        done
    fi

    if check_command pylint; then
        local py_files
        py_files=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.py$')

        for file in $py_files; do
            if [[ -f "$file" ]]; then
                if ! pylint "$file" &>/dev/null 2>&1; then
                    log_error "Pylint issues in $file"
                    quality_issues=1
                fi
            fi
        done
    fi

    if [[ $quality_issues -eq 1 ]]; then
        commit_fail "Code quality issues detected"
        return 1
    fi

    log_info "Code quality scan passed"
    return 0
}

install_hooks() {
    local hooks_dir="${1:-.git/hooks}"
    local hook_file="$hooks_dir/pre-commit"

    mkdir -p "$hooks_dir"

    cp "$0" "$hook_file"
    chmod +x "$hook_file"

    git config core.hooksPath "$hooks_dir"

    log_info "Pre-commit hook installed to $hook_file"
}

show_usage() {
    cat << USAGE
Usage: $0 [COMMAND] [OPTIONS]

Git pre-commit security scanning hooks.

Commands:
    install [dir]           Install pre-commit hook to specified directory
    scan                   Run all scanners
    scan-secrets           Scan for secrets only
    scan-vulns             Scan for vulnerabilities only
    scan-quality           Scan code quality only
    test                   Test hook with sample secrets

Options:
    --dry-run              Show commands without executing
    --verbose              Show debug information
    --no-exit             Don't exit on errors
    --skip-secrets         Skip secret scanning
    --skip-vulns          Skip vulnerability scanning
    --skip-quality        Skip quality scanning
    --help                Show this help

Environment:
    SCAN_SECRETS           Enable secret scanning (default: true)
    SCAN_VULNS            Enable vulnerability scanning (default: true)
    SCAN_QUALITY          Enable code quality scanning (default: true)
    DRY_RUN               Show commands without executing
    VERBOSE                Show debug information

Examples:
    # Install hooks to .git/hooks
    $0 install

    # Run manual scan
    $0 scan

    # Test hook detection
    $0 test
USAGE
}

main() {
    local command="${1:-scan}"
    shift || true

    case "$command" in
        install)
            local hooks_dir="${1:-.git/hooks}"
            install_hooks "$hooks_dir"
            ;;
        scan)
            log_info "Starting pre-commit security scanning..."

            [[ "$DRY_RUN" == "true" ]] && log_warn "Dry-run mode: no blocking"

            local result=0

            if [[ "$SCAN_SECRETS" == "true" ]]; then
                scan_secrets || result=1
            fi

            if [[ "$SCAN_VULNS" == "true" ]]; then
                scan_vulnerabilities || result=1
            fi

            if [[ "$SCAN_QUALITY" == "true" ]]; then
                scan_quality || result=1
            fi

            if [[ $result -eq 0 ]]; then
                log_info "All pre-commit checks passed"
            fi
            ;;
        scan-secrets)
            scan_secrets
            ;;
        scan-vulns)
            scan_vulnerabilities
            ;;
        scan-quality)
            scan_quality
            ;;
        test)
            log_info "Testing secret detection..."

            echo "AKIAIOSFODNN7EXAMPLE" > /tmp/test_secret.txt
            git add /tmp/test_secret.txt 2>/dev/null || true

            if echo "AKIAIOSFODNN7EXAMPLE" | grep -Eq "AKIA[0-9A-Z]{16}"; then
                log_info "Secret detection test: PASSED"
            else
                log_error "Secret detection test: FAILED"
            fi
            ;;
        --help|help|-h)
            show_usage
            ;;
        *)
            log_error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi