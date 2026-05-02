# Git Workflow Optimization for DevOps Pipelines

## Purpose

This guide provides optimized Git workflows for DevOps pipelines, covering branching strategies, merge automation, pull request workflows, and release management patterns that improve team productivity and pipeline efficiency.

## When to use

- Implementing standardized Git workflows across teams
- Optimizing CI/CD pipeline performance through Git optimization
- Setting up branch protection and merge automation
- Configuring pull request workflows with automated checks
- Implementing trunk-based development or GitFlow patterns
- Managing release branches and hotfix workflows

## Prerequisites

- Git 2.30 or higher
- CI/CD platform (Jenkins, GitHub Actions, GitLab CI, Azure DevOps)
- Branch protection permissions
- Repository admin access for workflow configuration

## Branching Strategies

### Trunk-Based Development

```bash
#!/usr/bin/env bash
set -euo pipefail

setup_trunk_development() {
    local main_branch="${1:-main}"
    
    git checkout "$main_branch"
    git pull origin "$main_branch"
    
    git config branch "$main_branch" merge-options "--squash"
    
    echo "Trunk-based development configured"
    echo "All feature branches merge directly to $main_branch"
}

setup_trunk_development "$1"
```

### GitFlow Implementation

```bash
#!/usr/bin/env bash
set -euo pipefail

setup_gitflow() {
    local develop_branch="${1:-develop}"
    local main_branch="${2:-main}"
    
    git branch "$develop_branch" || git checkout -b "$develop_branch"
    
    git config branch.develop.merge-options "--no-ff"
    git config branch.main.merge-options "--no-ff"
    
    git flow init -d -b "$develop_branch" -r origin -p "" 2>/dev/null || true
    
    echo "GitFlow configured: develop=$develop_branch, main=$main_branch"
}

setup_gitflow "$1" "$2"
```

### Feature Branch Workflow

```bash
#!/usr/bin/env bash
set -euo pipefail

create_feature_branch() {
    local branch_name="${1}"
    local base_branch="${2:-main}"
    
    if [[ -z "$branch_name" ]]; then
        echo "Error: branch_name required"
        exit 1
    fi
    
    git fetch origin
    git checkout -b "feature/$branch_name" "origin/$base_branch"
    
    git config branch."feature/$branch_name" description "Feature: $branch_name"
    
    echo "Created feature branch: feature/$branch_name from $base_branch"
}

create_feature_branch "$1" "$2"
```

## Merge Strategy Optimization

### Squash Merge Automation

```bash
#!/usr/bin/env bash
set -euo pipefail

squash_merge() {
    local source_branch="${1}"
    local target_branch="${2:-main}"
    local commit_message="${3:-Auto-merged}"
    
    if [[ -z "$source_branch" ]]; then
        echo "Error: source_branch required"
        exit 1
    fi
    
    git checkout "$target_branch"
    git pull origin "$target_branch"
    
    if git merge --squash "origin/$source_branch"; then
        git commit -m "$commit_message"
        git push origin "$target_branch"
        git branch -d "$source_branch"
        git push origin --delete "$source_branch"
        echo "Squash merged $source_branch into $target_branch"
    else
        echo "Merge failed, aborting"
        git merge --abort
        exit 1
    fi
}

squash_merge "$1" "$2" "$3"
```

### Rebase Workflow for Clean History

```bash
#!/usr/bin/env bash
set -euo pipefail

rebase_on_target() {
    local target_branch="${1:-main}"
    
    local current_branch
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    
    git fetch origin
    
    if git rebase "origin/$target_branch"; then
        git push --force-with-lease origin "$current_branch"
        echo "Rebased $current_branch onto origin/$target_branch"
    else
        echo "Rebase failed, resolving conflicts required"
        git rebase --abort
        exit 1
    fi
}

rebase_on_target "$1"
```

## Pull Request Workflow Automation

### PR Creation with Checks

```bash
#!/usr/bin/env bash
set -euo pipefail

create_pull_request() {
    local source_branch="${1}"
    local target_branch="${2:-main}"
    local title="${3:-Feature branch}"
    local description="${4:-Automated PR}"
    
    local pr_body
    pr_body=$(cat << EOF
## Description
$description

## Changes
$(git diff --stat origin/"$target_branch"..origin/"$source_branch")

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Code review completed
EOF
)
    
    gh pr create --base "$target_branch" --head "$source_branch" \
        --title "$title" --body "$pr_body" 2>/dev/null || \
    git push origin "HEAD:refs/heads/$source_branch"
    
    echo "PR created: $source_branch -> $target_branch"
}

create_pull_request "$1" "$2" "$3" "$4"
```

### PR Review Automation

```bash
#!/usr/bin/env bash
set -euo pipefail

automate_pr_review() {
    local pr_url="${1}"
    
    local approvals=0
    
    if command -v gh &>/dev/null; then
        approvals=$(gh pr view "$pr_url" --json reviews -q '.reviews | length' 2>/dev/null || echo "0")
    fi
    
    if [[ "$approvals" -ge 1 ]]; then
        echo "PR approved with $approvals reviews"
        
        gh pr merge "$pr_url" --squash --delete-branch 2>/dev/null || \
            echo "Manual merge required"
    else
        echo "PR requires additional reviews"
        exit 1
    fi
}

automate_pr_review "$1"
```

## Pipeline Integration

### Git Push Triggers

```bash
#!/usr/bin/env bash
set -euo pipefail

configure_push_triggers() {
    local branch_pattern="${1:-*}"
    local ci_config="${2:-.github/workflows/ci.yml}"
    
    if [[ -f "$ci_config" ]]; then
        cat >> "$ci_config" << EOF

on:
  push:
    branches:
      - $branch_pattern
EOF
        echo "Push triggers configured for $branch_pattern"
    else
        echo "CI config not found: $ci_config"
        exit 1
    fi
}

configure_push_triggers "$1" "$2"
```

### Commit Status Checks

```bash
#!/usr/bin/env bash
set -euo pipefail

check_commit_status() {
    local commit_sha="${1}"
    local context="${2:-ci/pipeline}"
    
    local status
    status=$(git log --format="%S" -1 "$commit_sha")
    
    if [[ "$status" == "clean" ]]; then
        echo "Commit $commit_sha is clean"
        return 0
    else
        echo "Commit $commit_sha has unresolved status"
        return 1
    fi
}

check_commit_status "$1" "$2"
```

## Release Workflow Optimization

### Release Branch Management

```bash
#!/usr/bin/env bash
set -euo pipefail

create_release_branch() {
    local version="${1}"
    local base_branch="${2:-main}"
    
    if [[ -z "$version" ]]; then
        echo "Error: version required (e.g., v1.2.3)"
        exit 1
    fi
    
    local release_branch="release/$version"
    
    git fetch origin
    git checkout -b "$release_branch" "origin/$base_branch"
    
    git tag -a "$version" -m "Release $version"
    
    echo "Release branch created: $release_branch"
    echo "Tag created: $version"
}

create_release_branch "$1" "$2"
```

### Hotfix Workflow

```bash
#!/usr/bin/env bash
set -euo pipefail

create_hotfix() {
    local fix_description="${1}"
    local version="${2:-hotfix}"
    
    local hotfix_branch="hotfix/$(date +%Y%m%d-%H%M%S)"
    
    git checkout main
    git pull origin main
    
    git checkout -b "$hotfix_branch"
    
    echo "Hotfix branch created: $hotfix_branch"
    echo "Apply your fixes, then run: git flow hotfix finish $hotfix_branch"
}

create_hotfix "$1" "$2"
```

## Branch Protection Configuration

```bash
#!/usr/bin/env bash
set -euo pipefail

configure_branch_protection() {
    local branch="${1:-main}"
    local require_reviews="${2:-1}"
    require_approvals="${3:-true}"
    
    if command -v gh &>/dev/null; then
        gh api "repos/{owner}/{repo}/branches/$branch/protection" \
            -X PUT -f required_status_checks='{"strict":true,"contexts":["ci/pipeline"]}' \
            -f required_pull_request_reviews='{"required_reviewers":[],"dismiss_stale_reviews":true}' \
            -f enforce_admins=false 2>/dev/null || true
    fi
    
    git config branch."$branch".protect true
    git config branch."$branch".require_reviews "$require_reviews"
    
    echo "Branch protection configured for $branch"
}

configure_branch_protection "$1" "$2" "$3"
```

## Verify

```bash
#!/usr/bin/env bash

echo "Verifying Git workflow optimization..."

command -v git >/dev/null && echo "Git: OK"

git --version

if git config --get branch.main.protect &>/dev/null; then
    echo "Branch protection: configured"
fi

if [[ -d ".git" ]]; then
    echo "Git repository: OK"
    git branch -a | head -5
fi

echo "Workflow verification complete"
```

## Rollback

```bash
#!/usr/bin/env bash
set -euo pipefail

rollback_workflow() {
    local target_branch="${1:-main}"
    
    git checkout "$target_branch"
    git pull origin "$target_branch"
    
    local unmerged
    unmerged=$(git branch --no-merged | grep -v "$target_branch" || true)
    
    if [[ -n "$unmerged" ]]; then
        echo "Warning: unmerged branches exist:"
        echo "$unmerged"
    fi
    
    echo "Rolled back to $target_branch state"
}

rollback_workflow "$1"
```

## Common Errors

### Merge Conflict During Rebase

```
error: could not apply abc1234... commit message
```

**Solution:**
```bash
git status
git add resolved-files
git rebase --continue
```

### Branch Already Exists

```
error: fatal: A branch named 'feature/xyz' already exists
```

**Solution:**
```bash
git branch -D feature/xyz
git checkout -b feature/xyz
```

### Push Rejected (Protected Branch)

```
error: denied by filter protection
```

**Solution:**
```bash
# Create PR instead of direct push
git push origin HEAD:refs/heads/feature/xyz
# Then merge via PR
```

### Large File Rejected

```
error: large file detected
```

**Solution:**
```bash
git lfs install
git lfs track "*.zip"
git add .gitattributes
git add large-file.zip
git commit -m "Add large file with LFS"
```

## References

- [GitFlow Documentation](https://github.com/nvie/gitflow)
- [Trunk-Based Development](https://trunkbaseddevelopment.com/)
- [GitHub Branch Protection](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-branch-protection-rules)
- [Conventional Commits](https://www.conventionalcommits.org/)