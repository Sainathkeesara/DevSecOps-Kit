#!/usr/bin/env bash
set -euo pipefail
readonly SCRIPT_VERSION="1.0.0"

DRY_RUN="${DRY_RUN:-false}"
VERBOSE="${VERBOSE:-false}"
FORCE="${FORCE:-false}"

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
        eval "$@"
    fi
}

check_git() {
    if ! command -v git &>/dev/null; then
        log_error "Git is not installed"
        return 1
    fi
    
    if ! git rev-parse --git-dir &>/dev/null; then
        log_error "Not a git repository"
        return 1
    fi
    
    log_info "Git environment: OK"
}

install_pre_commit_hook() {
    local hook_script hook_path
    
    hook_path=".git/hooks/pre-commit"
    
    if [[ -f "$hook_path" && "$FORCE" != "true" ]]; then
        log_warn "Pre-commit hook already exists. Use --force to overwrite."
        return 1
    fi
    
    cat << 'HOOK' > "$hook_path"
#!/usr/bin/env bash
set -euo pipefail

echo "Running pre-commit validation..."

if command -v shellcheck &>/dev/null; then
    for f in $(find . -name "*.sh" -type f); do
        shellcheck "$f" || exit 1
    done
fi

if command -v hadolint &>/dev/null; then
    for f in $(find . -name "Dockerfile" -type f); do
        hadolint "$f" || exit 1
    done
fi

echo "Pre-commit validation passed"
HOOK
    
    chmod +x "$hook_path"
    log_info "Pre-commit hook installed at $hook_path"
}

install_commit_msg_hook() {
    local hook_path
    
    hook_path=".git/hooks/commit-msg"
    
    cat << 'HOOK' > "$hook_path"
#!/usr/bin/env bash
set -euo pipefail

COMMIT_MSG_FILE="$1"
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

PATTERN="^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .{1,50}"

if ! echo "$COMMIT_MSG" | grep -qE "$PATTERN"; then
    echo "Invalid commit message format."
    echo "Expected: type(scope): message"
    echo "Types: feat, fix, docs, style, refactor, test, chore"
    exit 1
fi

echo "Commit message validated"
HOOK
    
    chmod +x "$hook_path"
    log_info "Commit-msg hook installed at $hook_path"
}

install_pre_push_hook() {
    local hook_path
    
    hook_path=".git/hooks/pre-push"
    
    cat << 'HOOK' > "$hook_path"
#!/usr/bin/env bash
set -euo pipefail

LOCAL_REF="$1"
LOCAL_SHA="$2"
REMOTE_REF="$3"
REMOTE_SHA="$4"

if [[ "$LOCAL_SHA" == "$REMOTE_SHA" ]]; then
    exit 0
fi

if [[ "$REMOTE_REF" == *"refs/heads/main" ]] || [[ "$REMOTE_REF" == *"refs/heads/master" ]]; then
    echo "Direct push to protected branch is not allowed"
    echo "Please use pull request workflow"
    exit 1
fi

echo "Pre-push validation passed"
HOOK
    
    chmod +x "$hook_path"
    log_info "Pre-push hook installed at $hook_path"
}

install_all_hooks() {
    check_git || return 1
    
    install_pre_commit_hook
    install_commit_msg_hook
    install_pre_push_hook
    
    log_info "All CI/CD hooks installed"
}

setup_git_aliases() {
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.st status
    git config --global alias.last 'log -1 HEAD'
    git config --global alias.unstage 'reset HEAD --'
    git config --global alias.graph 'log --graph --oneline --all'
    git config --global alias.undo 'reset --soft HEAD~1'
    
    log_info "Git aliases configured"
}

configure_git_settings() {
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global fetch.prune true
    git config --global core.autocrlf input
    
    log_info "Git settings configured"
}

show_usage() {
    cat << USAGE
Usage: $0 [COMMAND] [OPTIONS]

Git CI/CD hooks and automation setup for DevOps workflows.

Commands:
    install-hooks              Install all CI/CD hooks
    install-pre-commit         Install pre-commit hook
    install-commit-msg         Install commit-msg hook
    install-pre-push           Install pre-push hook
    aliases                    Configure git aliases
    config                     Configure git settings
    all                        Install hooks, aliases, and config

Options:
    --dry-run                  Show commands without executing
    --verbose                  Show debug information
    --force                    Force overwrite existing hooks
    --help                     Show this help

Examples:
    $0 install-hooks
    $0 aliases
    $0 all --force
USAGE
}

main() {
    local command="${1:-}"
    shift || true
    
    case "$command" in
        install-hooks|hooks)
            install_all_hooks
            ;;
        install-pre-commit)
            check_git && install_pre_commit_hook
            ;;
        install-commit-msg)
            check_git && install_commit_msg_hook
            ;;
        install-pre-push)
            check_git && install_pre_push_hook
            ;;
        aliases)
            setup_git_aliases
            ;;
        config)
            configure_git_settings
            ;;
        all)
            configure_git_settings
            setup_git_aliases
            install_all_hooks
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

main "$@"