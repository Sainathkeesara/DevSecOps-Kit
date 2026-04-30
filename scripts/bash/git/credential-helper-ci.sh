#!/usr/bin/env bash
# Git Credential Helper CI/CD Configuration Script
# Level: L2 | Category: Git | Purpose: Configure credential helpers for CI/CD pipelines
# Supports: Linux, macOS, Windows (Git Bash), CI/CD platforms

set -euo pipefail

# Configuration
CRED_STORE_TYPE="${CRED_STORE_TYPE:-auto}"
GIT_USER="${GIT_USER:-}"
GIT_TOKEN="${GIT_TOKEN:-}"
HOSTS="${HOSTS:-github.com,gitlab.com,bitbucket.org}"
DRY_RUN="${DRY_RUN:-false}"
ACTION="${ACTION:-setup}"  # setup, test, remove
VERBOSE="${VERBOSE:-false}"
CI_PROVIDER="${CI_PROVIDER:-auto}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }
log_debug() { [[ "$VERBOSE" == "true" ]] && echo -e "${BLUE}[DEBUG]${NC} $*"; }

run_cmd() {
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY-RUN] $*"
    else
        eval "$@" 2>&1 || true
    fi
}

# Detect CI/CD provider
detect_ci_provider() {
    if [[ -n "$CI_PROVIDER" ]] && [[ "$CI_PROVIDER" != "auto" ]]; then
        echo "$CI_PROVIDER"
        return
    fi
    
    if [[ -n "${GITHUB_ACTIONS:-}" ]]; then
        echo "github-actions"
    elif [[ -n "${GITLAB_CI:-}" ]]; then
        echo "gitlab-ci"
    elif [[ -n "${JENKINS_HOME:-}" ]]; then
        echo "jenkins"
    elif [[ -n "${BITBUCKET_BUILD_NUMBER:-}" ]]; then
        echo "bitbucket"
    elif [[ -n "${CIRCLECI:-}" ]]; then
        echo "circleci"
    else
        echo "local"
    fi
}

# Detect available credential store
detect_credential_store() {
    if [[ "$CRED_STORE_TYPE" != "auto" ]]; then
        echo "$CRED_STORE_TYPE"
        return
    fi
    
    local os_type
    os_type=$(uname -s)
    
    case "$os_type" in
        Linux)
            if command -v secret-tool &>/dev/null; then
                echo "libsecret"
            elif [[ -n "${CREDENTIAL_STORE_FILE:-}" ]] || [[ -f ~/.git-credentials ]]; then
                echo "store"
            else
                echo "store"
            fi
            ;;
        Darwin)
            if command -v security &>/dev/null; then
                echo "osxkeychain"
            else
                echo "store"
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*)
            if command -v git-credential-manager-core &>/dev/null; then
                echo "manager-core"
            elif command -v git-credential-wincred &>/dev/null; then
                echo "wincred"
            else
                echo "store"
            fi
            ;;
        *)
            echo "store"
            ;;
    esac
}

# Setup credential helper for Linux (libsecret)
setup_libsecret() {
    log_info "Configuring libsecret credential helper..."
    
    if ! command -v secret-tool &>/dev/null; then
        log_error "secret-tool not found. Install libsecret-tools."
        return 1
    fi
    
    # Configure Git
    run_cmd git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret 2>/dev/null || \
           run_cmd git config --global credential.helper $(which git-credential-libsecret 2>/dev/null) || \
           run_cmd git config --global credential.helper store
    
    log_info "Git credential helper configured: $(git config --global credential.helper)"
}

# Setup credential helper for macOS
setup_macos() {
    log_info "Configuring macOS Keychain credential helper..."
    
    run_cmd git config --global credential.helper osxkeychain
    
    log_info "Git credential helper configured: $(git config --global credential.helper)"
}

# Setup credential helper for Windows
setup_windows() {
    log_info "Configuring Windows Credential Manager..."
    
    run_cmd git config --global credential.helper manager-core 2>/dev/null || \
           run_cmd git config --global credential.helper wincred
    
    log_info "Git credential helper configured: $(git config --global credential.helper)"
}

# Setup file-based credential store
setup_store() {
    log_info "Configuring file-based credential store..."
    
    run_cmd git config --global credential.helper store
    
    # Ensure credentials file exists with proper permissions
    local cred_file="${HOME}/.git-credentials"
    if [[ "$DRY_RUN" != "true" ]]; then
        touch "$cred_file" 2>/dev/null || true
        chmod 600 "$cred_file" 2>/dev/null || true
    fi
    
    log_info "Git credential helper configured: store"
    log_info "Credentials file: ${cred_file}"
}

# Store credentials for a host
store_credentials() {
    local host="$1"
    local user="${2:-$GIT_USER}"
    local token="${3:-$GIT_TOKEN}"
    
    if [[ -z "$user" ]] || [[ -z "$token" ]]; then
        log_warn "No credentials provided for $host. Skipping."
        return 0
    fi
    
    log_info "Storing credentials for host: $host"
    
    local store_method
    store_method=$(git config --global credential.helper)
    
    # URL encode the token (handle special characters)
    local encoded_token
    encoded_token=$(printf '%s' "$token" | jq -sRr @uri 2>/dev/null || echo "$token")
    
    case "$store_method" in
        *libsecret*|osxkeychain|manager-core|wincred)
            # Use git credential helper directly
            run_cmd printf "protocol=https\nhost=%s\nusername=%s\npassword=%s\n" \
                "$host" "$user" "$encoded_token" | git credential approve
            ;;
        store|*)
            # Store directly in file
            local cred_file="${HOME}/.git-credentials"
            local cred_line="https://${user}:${encoded_token}@${host}"
            
            # Remove existing entry for this host
            if [[ -f "$cred_file" ]]; then
                run_cmd sed -i "/${host}/d" "$cred_file" 2>/dev/null || \
                    run_cmd sed -i '' "/${host}/d" "$cred_file" 2>/dev/null || true
            fi
            
            # Add new entry
            run_cmd echo "$cred_line" >> "$cred_file"
            ;;
    esac
    
    log_debug "Credentials stored for $host (user: $user)"
}

# Configure CI-specific credentials
setup_ci_credentials() {
    local provider
    provider=$(detect_ci_provider)
    
    log_info "Configuring credentials for CI provider: $provider"
    
    case "$provider" in
        github-actions)
            # GitHub Actions: token is automatically available
            if [[ -n "${GITHUB_TOKEN:-}" ]]; then
                log_info "GitHub Actions detected. GITHUB_TOKEN is available."
                run_cmd git config --global user.name "github-actions[bot]"
                run_cmd git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"
                
                # For same-repo operations, GITHUB_TOKEN is auto-injected
                # For cross-repo, use stored credentials
                if [[ -n "${GIT_TOKEN:-}" ]]; then
                    for host in $(echo "$HOSTS" | tr ',' ' '); do
                        store_credentials "$host"
                    done
                fi
            fi
            ;;
        gitlab-ci)
            log_info "GitLab CI detected. CI_JOB_TOKEN is available."
            run_cmd git config --global user.email "gitlab-ci@example.com"
            run_cmd git config --global user.name "GitLab CI"
            
            # GitLab auto-configures credentials with CI_JOB_TOKEN
            if [[ -n "${CI_SERVER_HOST:-}" ]]; then
                run_cmd git config --global credential.helper 'cache --timeout=3600'
            fi
            ;;
        jenkins)
            log_info "Jenkins detected."
            run_cmd git config --global user.email "jenkins@${NODE_NAME:-localhost}"
            run_cmd git config --global user.name "Jenkins"
            
            if [[ -n "${GIT_TOKEN:-}" ]]; then
                for host in $(echo "$HOSTS" | tr ',' ' '); do
                    store_credentials "$host"
                done
            fi
            ;;
        bitbucket)
            log_info "Bitbucket Pipelines detected."
            run_cmd git config --global user.email "pipelines@bitbucket.org"
            run_cmd git config --global user.name "Bitbucket Pipelines"
            ;;
        *)
            log_info "Unknown or local environment."
            run_cmd git config --global user.email "${GIT_USER_EMAIL:-ci@example.com}"
            run_cmd git config --global user.name "${GIT_USER_NAME:-CI/CD}"
            ;;
    esac
}

# Test credential helper
test_credentials() {
    local test_host="${1:-github.com}"
    
    log_info "Testing credential helper for host: $test_host"
    
    # Test configuration
    local helper
    helper=$(git config --global credential.helper || echo "(not set)")
    log_info "Configured helper: $helper"
    
    # Test credential fill
    log_info "Testing credential retrieval..."
    if printf "url=https://%s\n" "$test_host" | git credential fill 2>&1 | grep -q 'username\|password'; then
        log_info "Credential helper is working!"
        if [[ "$VERBOSE" == "true" ]]; then
            printf "url=https://%s\n" "$test_host" | git credential fill
        fi
        return 0
    else
        log_warn "No credentials found for $test_host (this may be expected)"
        return 1
    fi
}

# Remove credentials
remove_credentials() {
    local host="$1"
    
    log_info "Removing credentials for host: $host"
    
    local store_method
    store_method=$(git config --global credential.helper)
    
    case "$store_method" in
        *libsecret*)
            run_cmd secret-tool clear protocol https
            run_cmd secret-tool clear host "$host"
            ;;
        osxkeychain)
            run_cmd security delete-internet-password -s "$host" 2>/dev/null || true
            ;;
        manager-core|wincred)
            log_error "Manual removal required for Windows credential manager"
            log_error "Run: cmdkey /delete:$host"
            ;;
        store|*)
            local cred_file="${HOME}/.git-credentials"
            if [[ -f "$cred_file" ]]; then
                run_cmd sed -i "/${host}/d" "$cred_file" 2>/dev/null || \
                    run_cmd sed -i '' "/${host}/d" "$cred_file" 2>/dev/null || true
            fi
            ;;
    esac
    
    log_info "Credentials removed for $host"
}

# Show usage
show_usage() {
    cat << USAGE
Usage: $0 [OPTIONS]

Configure Git credential helpers for CI/CD pipelines.

Options:
    --type TYPE          Credential store type (auto, libsecret, store, osxkeychain, manager-core)
    --user USERNAME      Git username
    --token TOKEN        Git personal access token or password
    --hosts HOSTS        Comma-separated list of Git hosts (default: github.com,gitlab.com,bitbucket.org)
    --action ACTION      Action to perform: setup, test, remove, ci-setup (default: setup)
    --ci-provider PROVIDER CI provider (auto, github-actions, gitlab-ci, jenkins, local)
    --dry-run            Show what would be done without changes
    --verbose            Show debug information
    --help               Show this help

Examples:
    # Setup with GitHub PAT
    $0 --user myuser --token ghp_xxx --action setup

    # Setup for multiple hosts
    $0 --token ghp_xxx --hosts github.com,gitlab.com --action setup

    # Auto-configure for CI environment
    CI_PROVIDER=github-actions GIT_TOKEN=\${GITHUB_TOKEN} $0 --action ci-setup

    # Test credential helper
    $0 --action test --hosts github.com

    # Remove stored credentials
    $0 --action remove --hosts github.com

Environment Variables:
    CRED_STORE_TYPE    Credential store type override
    GIT_USER           Default Git username
    GIT_TOKEN          Default Git token/password
    DRY_RUN            Set to 'true' for dry-run mode
    CI_PROVIDER        Override CI provider detection

Supported Credential Stores:
    libsecret       Linux (D-Bus/secret-tool)
    store           File-based (~/.git-credentials)
    osxkeychain     macOS Keychain
    manager-core    Windows Credential Manager Core
    wincred         Windows Credential Manager (legacy)
USAGE
}

# Main
while [[ $# -gt 0 ]]; do
    case $1 in
        --type) CRED_STORE_TYPE="$2"; shift 2 ;;
        --user) GIT_USER="$2"; shift 2 ;;
        --token) GIT_TOKEN="$2"; shift 2 ;;
        --hosts) HOSTS="$2"; shift 2 ;;
        --action) ACTION="$2"; shift 2 ;;
        --ci-provider) CI_PROVIDER="$2"; shift 2 ;;
        --dry-run) DRY_RUN="true"; shift ;;
        --verbose) VERBOSE="true"; shift ;;
        --help) show_usage; exit 0 ;;
        *) log_error "Unknown option: $1"; show_usage; exit 1 ;;
    esac
done

if [[ "$DRY_RUN" == "true" ]]; then
    log_warn "DRY-RUN MODE - No changes will be made"
fi

case "$ACTION" in
    setup)
        log_info "Setting up Git credential helper..."
        
        STORE_TYPE=$(detect_credential_store)
        log_info "Detected credential store: $STORE_TYPE"
        
        case "$STORE_TYPE" in
            libsecret) setup_libsecret ;;
            osxkeychain) setup_macos ;;
            manager-core|wincred) setup_windows ;;
            store|*) setup_store ;;
        esac
        
        # Store credentials if provided
        if [[ -n "$GIT_TOKEN" ]] && [[ -n "$GIT_USER" ]]; then
            IFS=',' read -ra HOST_ARRAY <<< "$HOSTS"
            for host in "${HOST_ARRAY[@]}"; do
                store_credentials "$host" "$GIT_USER" "$GIT_TOKEN"
            done
        fi
        
        log_info "Setup complete!"
        log_info "Credential helper: $(git config --global credential.helper)"
        ;;
    ci-setup)
        setup_ci_credentials
        
        if [[ -n "$GIT_TOKEN" ]] && [[ -n "$GIT_USER" ]]; then
            IFS=',' read -ra HOST_ARRAY <<< "$HOSTS"
            for host in "${HOST_ARRAY[@]}"; do
                store_credentials "$host" "$GIT_USER" "$GIT_TOKEN"
            done
        fi
        
        log_info "CI setup complete!"
        ;;
    test)
        test_credentials
        ;;
    remove)
        IFS=',' read -ra HOST_ARRAY <<< "$HOSTS"
        for host in "${HOST_ARRAY[@]}"; do
            remove_credentials "$host"
        done
        ;;
    *)
        log_error "Unknown action: $ACTION"
        show_usage
        exit 1
        ;;
esac

log_info "Done!"
