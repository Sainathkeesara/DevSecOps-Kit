# Git Workflow Optimization for DevOps Pipelines

## Purpose

This guide covers Git workflow strategies optimized for DevOps and CI/CD pipelines. It provides patterns for managing branches, commits, and releases in automated environments where efficiency, traceability, and reliability are critical.

## When to use

- Setting up Git workflows for continuous integration
- Building automated deployment pipelines
- Managing multi-environment deployments (dev, staging, production)
- Implementing GitOps practices
- Optimizing repository operations in CI/CD

## Prerequisites

- Git installed (version 2.x or higher)
- Access to Git remote repository
- CI/CD platform (GitHub Actions, GitLab CI, Jenkins)
- Understanding of branching strategies

## Branching Strategies

### Feature Branch Workflow

```bash
# Create feature branch
git checkout -b feature/add-login
# Make changes
git add .
git commit -m "Add login functionality"
# Push to remote
git push -u origin feature/add-login
# Create PR/MR
```

### GitFlow Model

```bash
# Main branch (production)
main branch → tags for releases

# Develop branch (integration)
develop branch

# Feature branches
git checkout -b feature/new-feature develop
# ... work ...
git checkout develop
git merge --no-ff feature/new-feature
git push origin develop

# Release branches
git checkout -b release/1.0.0 develop
# ...final fixes...
git checkout main
git merge --no-ff release/1.0.0
git tag -a v1.0.0 -m "Release 1.0.0"
git push origin main --tags

# Hotfix branches
git checkout -b hotfix/fix-bug main
# ...fix...
git checkout main
git merge --no-ff hotfix/fix-bug
git tag -a v1.0.1 -m "Hotfix 1.0.1"
git checkout develop
git merge --no-ff hotfix/fix-bug
```

### Trunk-Based Development

```bash
# Short-lived branches (1-2 days max)
git checkout -b feature/quick-fix main
# ... small commit ...
git push origin feature/quick-fix

# Merge quickly after CI passes
git checkout main
git merge feature/quick-fix
```

## CI/CD Pipeline Patterns

### Basic Pipeline Integration

```bash
#!/bin/bash
# Pipeline script for CI

set -euo pipefail

BRANCH="${1:-main}"
REPO_URL="${2:-origin}"

# Checkout
git clone "$REPO_URL" repo
cd repo
git checkout "$BRANCH"

# Run tests
make test

# Build
make build

# Deploy (if on main)
if [[ "$BRANCH" == "main" ]]; then
    make deploy
fi
```

### Auto-Merge on Success

```bash
#!/bin/bash
# Auto-merge feature branch to main after tests pass

set -euo pipefail

FEATURE_BRANCH="${1}"
MAIN_BRANCH="${2:-main}"

# Ensure tests passed
if ! make test; then
    echo "Tests failed, not merging"
    exit 1
fi

# Get current commit
CURRENT_COMMIT=$(git rev-parse HEAD)

# Checkout main
git checkout "$MAIN_BRANCH"
git pull origin "$MAIN_BRANCH"

# Merge feature
git merge --no-ff "$FEATURE_BRANCH"

# Push
git push origin "$MAIN_BRANCH"

# Delete feature branch
git push origin --delete "$FEATURE_BRANCH"
git branch -d "$FEATURE_BRANCH"
```

### Semantic Versioning with Tags

```bash
#!/bin/bash
# Release workflow with semantic versioning

set -euo pipefail

VERSION="${1}"
VERSION_TYPE="${2:-patch}" # major, minor, patch

# Get current version
CURRENT_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")

# Calculate new version
case "$VERSION_TYPE" in
    major)
        NEW_VERSION="v$((VERSION + 1)).0.0"
        ;;
    minor)
        NEW_VERSION="v${VERSION%.*}.$((VERSION + 1)).0"
        ;;
    patch)
        NEW_VERSION="v${VERSION%.*}.$((VERSION + 1))"
        ;;
esac

# Create tag
git tag -a "$NEW_VERSION" -m "Release $NEW_VERSION"

# Push with tags
git push origin "$NEW_VERSION"
```

## Automation Scripts

### Detect Changes Since Last Release

```bash
#!/bin/bash
# Find changes since last release tag

set -euo pipefail

LAST_TAG=$(git describe --tags --abbrev=0)

echo "Changes since $LAST_TAG:"
git log --oneline "$LAST_TAG..HEAD"

echo ""
echo "Changed files:"
git diff --name-only "$LAST_TAG..HEAD"
```

### Generate Changelog

```bash
#!/bin/bash
# Auto-generate changelog

set -euo pipefail

LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "HEAD~10")
CURRENT_TAG=$(git describe --tags --abbrev=0)

cat << EOF > CHANGELOG.md
# Changelog

## [$CURRENT_TAG](https://github.com/user/repo/compare/$LAST_TAG...$CURRENT_TAG)

### Added
$(git log --format="* %s (%h)" "$LAST_TAG..HEAD" --grep="Add" 2>/dev/null || echo "")

### Fixed
$(git log --format="* %s (%h)" "$LAST_TAG..HEAD" --grep="Fix" 2>/dev/null || echo "")

### Changed
$(git log --format="* %s (%h)" "$LAST_TAG..HEAD" --grep="Update" 2>/dev/null || echo "")
EOF
```

### Pre-commit Checks

```bash
#!/bin/bash
# Pre-commit validation

set -euo pipefail

# Check branch name
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if ! [[ "$BRANCH" =~ ^(feature|bugfix|hotfix|release)/ ]]; then
    echo "Warning: Branch name should follow convention"
fi

# No secrets in code
if git diff --staged | grep -iE "(password|secret|token|api_key)" 2>/dev/null; then
    echo "Error: Potential secrets found"
    exit 1
fi

# Tests pass
make test || exit 1

echo "Pre-commit checks passed"
```

## Best Practices

### Commit Messages

```bash
# Good commit message format
git commit -m "Add user authentication flow

- Implement login/logout functionality
- Add session management
- Include remember me option

Closes #123"

# Conventional commits
git commit -m "feat: add user authentication"
git commit -m "fix: resolve login redirect issue"
git commit -m "docs: update API documentation"
git commit -m "refactor: simplify user service"
```

### Push Operations

```bash
# Safe push patterns
git push origin main           # Push to main branch
git push -u origin feature # Set upstream
git push --force-with-lease feature  # Safe force push

# Push tags
git push --tags           # All tags
git push origin v1.0.0   # Specific tag
```

### Merge Strategies

```bash
# No-fast-forward merge (preserves history)
git merge --no-ff feature-branch

# Squash merge (clean history)
git merge --squash feature-branch
git commit -m "Add feature X"

# Rebase for linear history
git rebase main
git push --force-with-lease
```

## Verify

```bash
# Check branch status
git branch -vv

# Verify merge status
git log --graph --oneline --all

# Check CI status
git status

# Verify tags
git tag -l "v*"
```

## Rollback

### Revert a Merge

```bash
# Revert merge commit
git revert -m 1 abc123

# Force push previous state
git push --force-with-lease origin main
```

### Reset to Tag

```bash
# Soft reset (keep changes)
git reset --soft v1.0.0

# Hard reset (discard)
git reset --hard v1.0.0

# Push force
git push --force-with-lease origin main
```

## Common Errors

### "refusing to merge unrelated histories"

```bash
git pull origin main --allow-unrelated-histories
```

### "Updates were rejected"

```bash
git pull --rebase origin main
git push origin main
```

## References

- Git Flow: https://nvie.com/posts/a-successful-git-branching-model/
- Conventional Commits: https://www.conventionalcommits.org/
- GitHub Actions: https://docs.github.com/en/actions