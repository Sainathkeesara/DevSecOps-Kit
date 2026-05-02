# Git Automation for CI/CD Integration

## Purpose

This guide provides automation scripts and workflows for integrating Git operations into CI/CD pipelines. It covers automated versioning, commit workflows, and deployment triggers used in DevOps automation.

## When to use

- Building Git-based CI/CD pipelines
- Automating version increments on merge
- Creating pre-build and post-build Git hooks
- Implementing Git-based deployment triggers
- Setting up automated changelog generation

## Prerequisites

- Git 2.x or higher
- CI/CD platform (Jenkins, GitHub Actions, GitLab CI, etc.)
- Repository with appropriate permissions

## Automated Versioning

### Semantic Version Bump Script

```bash
#!/usr/bin/env bash
set -euo pipefail

bump_version() {
    local type="${1:-patch}"
    local current version major minor patch
    
    current=$(git describe --tags --abbrev=0 2>/dev/null | sed 's/^v//' || echo "0.0.0")
    IFS='.' read -r major minor patch <<< "$current"
    
    case "$type" in
        major) major=$((major + 1)); minor=0; patch=0 ;;
        minor) minor=$((minor + 1)); patch=0 ;;
        patch) patch=$((patch + 1)) ;;
    esac
    
    echo "v${major}.${minor}.${patch}"
}

create_release() {
    local version version_file
    
    version=$(bump_version "$1")
    version_file="VERSION"
    
    echo "$version" > "$version_file"
    git add "$version_file"
    git commit -m "Release $version"
    git tag -a "$version" -m "Release $version"
    git push origin main --tags
}

create_release "$1"
```

### GitHub Actions Version Bump

```yaml
name: Version Bump
on:
  push:
    branches: [main]

jobs:
  bump:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Bump version
        run: |
          git config user.name "CI Bot"
          git config user.email "ci@example.com"
          ./scripts/bump-version.sh patch
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Pipeline Workflows

### Pre-Build Validation

```bash
#!/usr/bin/env bash
set -euo pipefail

pre_build_check() {
    local branch current_branch
    
    branch="${1:-main}"
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    
    if [[ "$current_branch" != "$branch" ]]; then
        echo "Error: Must be on $branch branch"
        exit 1
    fi
    
    if ! git diff-index --quiet HEAD --; then
        echo "Error: Uncommitted changes"
        exit 1
    fi
    
    git fetch origin
    local behind
    behind=$(git rev-list HEAD..origin/$branch --count)
    
    if [[ "$behind" -gt 0 ]]; then
        echo "Error: Branch is $behind commits behind"
        exit 1
    fi
    
    echo "Pre-build check passed"
}

pre_build_check "$1"
```

### Post-Build Deployment Trigger

```bash
#!/usr/bin/env bash
set -euo pipefail

trigger_deployment() {
    local environment="${1:-staging}"
    local commit_sha webhook_url
    
    commit_sha=$(git rev-parse HEAD)
    webhook_url="https://deploy.example.com/hook"
    
    curl -X POST "$webhook_url" \
        -H "Content-Type: application/json" \
        -d "{\"commit\":\"$commit_sha\",\"env\":\"$environment\"}"
    
    echo "Deployment triggered for $environment"
}

trigger_deployment "$1"
```

## Commit Message Automation

### Conventional Commits Generator

```bash
#!/usr/bin/env bash
set -euo pipefail

generate_commit() {
    local type="${1}"
    local scope="${2:-}"
    local message="${3}"
    
    local commit_msg
    if [[ -n "$scope" ]]; then
        commit_msg="${type}(${scope}): ${message}"
    else
        commit_msg="${type}: ${message}"
    fi
    
    git add -A
    git commit -m "$commit_msg"
    
    echo "Created commit: $commit_msg"
}

generate_commit "$1" "$2" "$3"
```

### Auto-Changelog from Commits

```bash
#!/usr/bin/env bash
set -euo pipefail

generate_changelog() {
    local from_tag="${1}"
    local to_tag="${2:-HEAD}"
    
    cat << EOF
# Changelog

## What's Changed

$(git log --format="- %s (%h)" "$from_tag..$to_tag")

## New Contributors

$(git log --format="%an" "$from_tag..$to_tag" | sort -u)
EOF
}

generate_changelog "$1" "$2"
```

## Branch Protection Automation

### Enforce Protected Branch Rules

```bash
#!/usr/bin/env bash
set -euo pipefail

enforce_branch_protection() {
    local branch="${1:-main}"
    local repo="${2:-}"
    
    git branch --protect "$branch" 2>/dev/null || \
    git config branch.$branch.protect true
    
    git push origin --mirror
    
    echo "Branch $branch protected"
}

enforce_branch_protection "$1" "$2"
```

## Git Hooks for CI/CD

### Pre-commit Hook

```bash
#!/usr/bin/env bash
set -euo pipefail

PRE_COMMIT_HOOK=$(cat << 'HOOK'
#!/usr/bin/env bash
set -euo pipefail

echo "Running pre-commit checks..."

if command -v hadolint &>/dev/null; then
    hadolint Dockerfile
fi

if command -v shellcheck &>/dev/null; then
    find . -name "*.sh" -exec shellcheck {} \;
fi

echo "Pre-commit checks passed"
HOOK
)

mkdir -p .git/hooks
echo "$PRE_COMMIT_HOOK" > .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

## Verify

```bash
#!/usr/bin/env bash

echo "Verifying Git automation setup..."

command -v git >/dev/null && echo "Git: OK"

git --version

if [[ -f .git/hooks/pre-commit ]]; then
    echo "Pre-commit hook: OK"
fi

echo "Setup verification complete"
```

## Rollback

```bash
#!/usr/bin/env bash
set -euo pipefail

rollback_release() {
    local last_tag
    
    last_tag=$(git describe --tags --abbrev=0)
    git reset --hard "$last_tag"
    git push --force origin main
    
    echo "Rolled back to $last_tag"
}

rollback_release
```

## Common Errors

### Push Rejected

```
error: failed to push some refs to 'origin'
```

**Solution:**
```bash
git pull --rebase origin main
git push origin main
```

### Merge Conflicts

```
error: Merge conflict in file
```

**Solution:**
```bash
git status
git add resolved-files
git commit -m "Resolve conflicts"
```

### Token Authentication Failed

```
fatal: Authentication failed
```

**Solution:**
```bash
git remote set-url origin https://TOKEN@github.com/user/repo.git
```

## References

- GitHub Actions Documentation
- GitLab CI/CD Pipeline Configuration
- Conventional Commits Specification