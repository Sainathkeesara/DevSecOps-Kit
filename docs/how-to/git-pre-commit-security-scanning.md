# Git Hook Automation: Pre-commit Security Scanning and Validation

## Purpose

Automate security scanning and validation at the pre-commit phase to catch vulnerabilities, secrets, and code quality issues before they enter the repository.

## When to Use

- Enforce security policies in CI/CD pipelines
- Prevent secrets and credentials from being committed
- Detect vulnerabilities in dependencies before deployment
- Maintain code quality standards across the team

## Prerequisites

- Git installed (version 2.34+ recommended)
- Required tools based on scanning type:
  - **Secrets detection**: `trufflehog` or `git-secrets`
  - **Vulnerability scanning**: `trivy`, `npm audit`, `pip-audit`
  - **Code quality**: `shellcheck`, `pylint`, `eslint`
  - **Terraform**: `tflint`, `tfsec`
- Local Git hooks directory initialized

## Steps

### 1. Initialize Local Git Hooks Directory

```bash
mkdir -p .git/hooks
```

### 2. Create Pre-commit Hook Script

Create the hook file in `.git/hooks/pre-commit`:

```bash
#!/bin/bash
# Pre-commit security scanning hook
# Location: .git/hooks/pre-commit

set -euo pipefail

# Configuration
SCAN_SECRETS="${SCAN_SECRETS:-true}"
SCAN_VULNS="${SCAN_VULNS:-true}"
SCAN_QUALITY="${SCAN_QUALITY:-true}"
DRY_RUN="${DRY_RUN:-false}"
VERBOSE="${VERBOSE:-false}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()   { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }
log_debug() { [[ "$VERBOSE" == "true" ]] && echo -e "${BLUE}[DEBUG]${NC} $*"; }

# Exit with failure
fail_hook() {
    log_error "Pre-commit hook failed: $*"
    exit 1
}

# Check for secrets in staged files
scan_secrets() {
    log_info "Scanning for secrets..."
    
    local secrets_found=0
    
    # Check for trufflehog
    if command -v trufflehog &>/dev/null; then
        local changed_files
        changed_files=$(git diff --cached --name-only --diff-filter=ACM)
        
        for file in $changed_files; do
            if [[ -f "$file" ]]; then
                if truffehog filesystem "$file" 2>/dev/null | grep -q "Found secrets"; then
                    log_error "Secrets detected in $file"
                    secrets_found=1
                fi
            fi
        done
    fi
    
    # Check for git-secrets
    if command -v git-secrets &>/dev/null; then
        if git secrets --lock --install &>/dev/null 2>&1; then
            if git secrets --scan --cached 2>/dev/null; then
                secrets_found=1
            fi
        fi
    fi
    
    # Fallback: common secret patterns
    local patterns=(
        "AKIA[0-9A-Z]{16}"          # AWS Access Key
        "ghp_[a-zA-Z0-9]{36}"        # GitHub Personal Token
        "gho_[a-zA-Z0-9]{36}"        # GitHub OAuth Token
        "xox[baprs]-([a-zA-Z0-9]{10,48})" # Slack Token
        "sk-[a-zA-Z0-9]{48}"        # OpenAI API Key
    )
    
    local staged_files
    staged_files=$(git diff --cached --name-only --diff-filter=ACM)
    
    for pattern in "${patterns[@]}"; do
        for file in $staged_files; do
            if [[ -f "$file" ]] && grep -E "$pattern" "$file" &>/dev/null; then
                log_error "Potential secret found in $file (pattern: $pattern)"
                secrets_found=1
            fi
        done
    done
    
    if [[ $secrets_found -eq 1 ]]; then
        fail_hook "Secrets detected in staged files"
    fi
    
    log_info "Secrets scan passed"
}

# Scan for vulnerabilities
scan_vulnerabilities() {
    log_info "Scanning for vulnerabilities..."
    
    local vuls_found=0
    
    # Detect project type and run appropriate scanner
    
    # Node.js/JavaScript
    if [[ -f "package.json" ]] && command -v npm &>/dev/null; then
        if npm audit --json &>/dev/null 2>&1; then
            local vulns
            vulns=$(npm audit --json 2>/dev/null | jq -r '.metadata.vulnerability_count // 0')
            if [[ "$vulns" -gt 0 ]]; then
                log_error "Found $vulns npm vulnerabilities"
                vuls_found=1
            fi
        fi
    fi
    
    # Python
    if [[ -f "requirements.txt" || -f "Pipfile" ]] && command -v pip-audit &>/dev/null; then
        if ! pip-audit &>/dev/null 2>&1; then
            log_error "Python vulnerabilities detected"
            vuls_found=1
        fi
    fi
    
    # Terraform
    if [[ -f "*.tf" ]] && command -v tfsec &>/dev/null; then
        if ! tfsec . --exit-code 1 &>/dev/null 2>&1; then
            log_error "Terraform security issues detected"
            vuls_found=1
        fi
    fi
    
    # Docker
    if [[ -f "Dockerfile" ]] && command -v hadolint &>/dev/null; then
        if ! hadolint Dockerfile &>/dev/null 2>&1; then
            log_error "Dockerfile issues detected"
            vuls_found=1
        fi
    fi
    
    # Trivy for general vulnerabilities
    if command -v trivy &>/dev/null; then
        local changed_files
        changed_files=$(git diff --cached --name-only --diff-filter=ACM)
        
        for file in $changed_files; do
            if [[ -f "$file" && "$file" == *.dockerfile* ]]; then
                if trivy fs --scanners vuln "$file" &>/dev/null 2>&1; then
                    log_error "Vulnerabilities in $file"
                    vuls_found=1
                fi
            fi
        done
    fi
    
    if [[ $vuls_found -eq 1 ]]; then
        fail_hook "Vulnerabilities detected"
    fi
    
    log_info "Vulnerability scan passed"
}

# Scan code quality
scan_quality() {
    log_info "Scanning code quality..."
    
    local quality_issues=0
    
    # Shell scripts
    if command -v shellcheck &>/dev/null; then
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
    
    # Python (if pylint available)
    if command -v pylint &>/dev/null; then
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
        fail_hook "Code quality issues detected"
    fi
    
    log_info "Code quality scan passed"
}

# Main execution
main() {
    log_info "Starting pre-commit security scanning..."
    
    [[ "$DRY_RUN" == "true" ]] && log_warn "Dry-run mode: no blocking"
    
    if [[ "$SCAN_SECRETS" == "true" ]]; then
        scan_secrets
    fi
    
    if [[ "$SCAN_VULNS" == "true" ]]; then
        scan_vulnerabilities
    fi
    
    if [[ "$SCAN_QUALITY" == "true" ]]; then
        scan_quality
    fi
    
    log_info "All pre-commit checks passed"
}

main "$@"
```

### 3. Make Hook Executable

```bash
chmod +x .git/hooks/pre-commit
```

### 4. Install Hook asGit Hook (Recommended)

Instead of editing `.git/hooks`, use the top-level `.git/hooks` directory in repository:

```bash
# Install for current repository
git config core.hooksPath .git/hooks

# Or globally
git config --global core.hooksPath ~/.git/hooks
```

### 5. Create Installer Script (Optional)

```bash
#!/usr/bin/env bash
# Install pre-commit hooks for project
# Level: L2 | Category: Git | Purpose: Pre-commit security scanning

set -euo pipefail

DRY_RUN="${DRY_RUN:-false}"

HOOKS_DIR=".git/hooks"
HOOK_SCRIPT="$HOOKS_DIR/pre-commit"

mkdir -p "$HOOKS_DIR"

# Download or create pre-commit hook
if [[ ! -f "$HOOK_SCRIPT" ]]; then
    echo "Installing pre-commit hook..."
    # ... hook content from above ...
fi

chmod +x "$HOOK_SCRIPT"

# Configure Git to use local hooks
git config core.hooksPath "$HOOKS_DIR"

echo "Pre-commit hook installed successfully"
```

## Verify

1. **Test the hook**: Create a file with a fake secret (e.g., `AWS_SECRET=AKIAIOSFODNN7EXAMPLE`) and verify the hook blocks the commit:

   ```bash
   # Create test file with secret
   echo "AWS_SECRET=AKIAIOSFODNN7EXAMPLE" > test_secret.txt
   
   # Try to stage and commit
   git add test_secret.txt
   git commit -m "Test commit"
   # Expected: Commit should be blocked
   ```

2. **Verify hook runs**: Set verbose mode:

   ```bash
   VERBOSE=true git commit -m "Test"
   ```

3. **Skip hook when needed** (emergency use only):

   ```bash
   git commit --no-verify -m "Emergency commit"
   ```

## Rollback

To disable the pre-commit hook:

```bash
# Remove hook
rm .git/hooks/pre-commit

# Or disable temporarily
git commit --no-verify -m "Commit without hook"
```

## Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `hook not executable` | Missing execute permission | `chmod +x .git/hooks/pre-commit` |
| `command not found` | Scanner not installed | Install required tool or disable that check |
| `false positive on secrets` | Pattern too broad | Adjust patterns in hook for your project |
| `slow scan on large repos` | Scanning too many files | Limit to staged files only |

## References

- [Git Hooks Documentation](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)
- [TruffleHog](https://trufflesecurity.com/trufflehog)
- [Trivy](https://aquasecurity.github.io/trivy/)
- [ShellCheck](https://www.shellcheck.net/)
- [Git Secrets](https://github.com/awslabs/git-secrets)