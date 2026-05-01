#!/usr/bin/env bash
# Git Automation Scripts for CI/CD Integration
# Level: L6 | Category: Git | Purpose: Automation scripts for CI/CD Git operations
# Supports: Linux, macOS, Windows (Git Bash)

set -euo pipefail

DRY_RUN="${DRY_RUN:-false}"
VERBOSE="${VERBOSE:-false}"
AUTO_PUSH="${AUTO_PUSH:-false}"
AUTO_TAG="${AUTO_TAG:-false}"

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

git_auto_commit() {
    local message="${1:-Auto-commit}"
    local branch="${2:-}"
    
    if [[ -n "$branch" ]]; then
        run_cmd git checkout "$branch"
    fi
    
    if [[ -n $(git status --porcelain) ]]; then
        run_cmd git add -A
        run_cmd git commit -m "$message"
        log_info "Committed: $message"
        
        if [[ "$AUTO_PUSH" == "true" ]]; then
            local current_branch
            current_branch=$(git rev-parse --abbrev-ref HEAD)
            run_cmd git push origin "$current_branch"
        fi
    else
        log_warn "No changes to commit"
    fi
}

git_auto_tag() {
    local version="${1}"
    local message="${2:-Release $version}"
    
    if [[ -z "$version" ]]; then
        log_error "Version required for tag"
        return 1
    fi
    
    run_cmd git tag -a "$version" -m "$message"
    log_info "Created tag: $version"
    
    if [[ "$AUTO_PUSH" == "true" ]]; then
        run_cmd git push origin "$version"
    fi
}

git_semver_bump() {
    local type="${1:-patch}"
    
    local current
    current=$(git describe --tags --abbrev=0 2>/dev/null | sed 's/^v//' || echo "0.0.0")
    
    local major minor patch
    IFS='.' read -r major minor patch <<< "$current"
    
    case "$type" in
        major) major=$((major + 1)); patch=0; minor=0 ;;
        minor) minor=$((minor + 1)); patch=0 ;;
        patch) patch=$((patch + 1)) ;;
    esac
    
    echo "v${major}.${minor}.${patch}"
}

git_clone_or_update() {
    local repo_url="${1}"
    local target_dir="${2:-.}"
    local branch="${3:-main}"
    
    if [[ -d "$target_dir/.git" ]]; then
        log_info "Updating existing repository..."
        run_cmd git -C "$target_dir" checkout "$branch"
        run_cmd git -C "$target_dir" pull origin "$branch"
    else
        log_info "Cloning repository..."
        run_cmd git clone -b "$branch" "$repo_url" "$target_dir"
    fi
}

git_changes_since() {
    local ref="${1:-HEAD~1}"
    
    run_cmd git diff --name-only "$ref..HEAD"
    echo ""
    run_cmd git log --oneline "$ref..HEAD"
}

git_changelog_generate() {
    local from_tag="${1}"
    local to_tag="${2:-HEAD}"
    
    cat << CHANGELOG_EOF
# Changelog

## Changes from $from_tag to $to_tag

### Commits
$(git log --format="* %s (%h)" "$from_tag..$to_tag")

### Files Changed
$(git diff --stat "$from_tag..$to_tag")
CHANGELOG_EOF
}

git_pipeline_build() {
    local branch="${1:-main}"
    
    log_info "Building pipeline for branch: $branch"
    
    run_cmd git fetch --all
    
    if ! run_cmd git checkout "$branch"; then
        log_error "Failed to checkout branch: $branch"
        return 1
    fi
    
    run_cmd git merge origin/main
    
    log_info "Running tests..."
    if command -v make &>/dev/null; then
        run_cmd make test
    else
        log_warn "make not found, skipping tests"
    fi
    
    log_info "Build complete"
}

git_merge_on_success() {
    local source_branch="${1}"
    local target_branch="${2:-main}"
    
    log_info "Merging $source_branch into $target_branch"
    
    run_cmd git fetch origin "$source_branch"
    run_cmd git checkout "$target_branch"
    run_cmd git merge --no-ff "$source_branch"
    
    run_cmd git push origin "$target_branch"
    
    log_info "Merge complete"
}

git_feature_branch() {
    local branch_name="${1}"
    local base_branch="${2:-main}"
    
    if [[ -z "$branch_name" ]]; then
        log_error "Branch name required"
        return 1
    fi
    
    run_cmd git checkout -b "$branch_name" "$base_branch"
    log_info "Created branch: $branch_name from $base_branch"
}

show_usage() {
    cat << USAGE
Usage: $0 [COMMAND] [OPTIONS]

Git automation scripts for CI/CD integration.

Commands:
    auto-commit <message> [branch]     Auto-commit changes
    auto-tag <version> [message]       Create and optionally push tag
    semver-bump <type>              Bump semver (major|minor|patch)
    clone <url> [dir] [branch]      Clone or update repository
    changes [ref]                  Show changes since ref
    changelog <from> [to]           Generate changelog
    pipeline-build [branch]            Build pipeline
    merge <source> [target]          Merge branch on success
    feature-branch <name> [base]      Create feature branch

Options:
    --dry-run           Show commands without executing
    --verbose           Show debug information
    --auto-push         Auto-push after commit/tag
    --help              Show this help

Examples:
    # Auto-commit with message
    $0 auto-commit "Update version" main

    # Create release tag
    $0 auto-tag v1.0.0 "Release 1.0.0"

    # Bump patch version
    VERSION=$($0 semver-bump patch)
    $0 auto-tag $VERSION

    # Build pipeline
    $0 pipeline-build main

    # Feature branch workflow
    $0 feature-branch feature/add-login
    # ... make changes ...
    $0 auto-commit "Add login" feature/add-login
    $0 merge feature/add-login develop
USAGE
}

main() {
    local command="${1:-}"
    shift || true
    
    case "$command" in
        auto-commit)
            git_auto_commit "$@"
            ;;
        auto-tag)
            git_auto_tag "$@"
            ;;
        semver-bump)
            git_semver_bump "$@"
            ;;
        clone)
            git_clone_or_update "$@"
            ;;
        changes)
            git_changes_since "$@"
            ;;
        changelog)
            git_changelog_generate "$@"
            ;;
        pipeline-build)
            git_pipeline_build "$@"
            ;;
        merge)
            git_merge_on_success "$@"
            ;;
        feature-branch)
            git_feature_branch "$@"
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