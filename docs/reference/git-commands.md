# Git Commands Reference

## Purpose

This reference provides common Git command patterns for automated version control operations. It covers essential commands used in scripts and automation workflows for CI/CD pipelines and DevOps practices.

## When to use

- Writing automation scripts that interact with Git repositories
- Building CI/CD pipelines that require Git operations
- Performing bulk operations across repositories
- Creating Git-based deployment workflows
- Automating version control tasks

## Prerequisites

- Git installed (version 2.x or higher)
- Access to a Git repository (local or remote)
- Appropriate authentication credentials (for remote operations)

## Repository Operations

### Initialize Repository

```bash
# Initialize new repository
git init

# Initialize with specific directory
git init --bare /path/to/repo.git

# Clone repository
git clone https://github.com/user/repo.git
git clone git@github.com:user/repo.git
git clone --depth 1 https://github.com/user/repo.git
```

### Repository Information

```bash
# Get repository root
git rev-parse --show-toplevel

# Check if directory is repository
git rev-parse --is-inside-work-tree

# Get current branch
git rev-parse --abbrev-ref HEAD

# Get repository remote URL
git remote get-url origin
```

## Commit Operations

### Create Commits

```bash
# Stage all changes
git add -A

# Stage specific files
git add path/to/file1.txt path/to/file2.txt

# Stage with patterns
git add *.txt
git add .

# Commit with message
git commit -m "Commit message"

# Commit all tracked files
git commit -am "Message for tracked files only"

# Amend last commit
git commit --amend -m "Updated message"
git commit --amend --no-edit

# Commit with detailed message
git commit -m "Title" -m "Description"
```

### View Commits

```bash
# View commit history
git log
git log --oneline
git log --graph --oneline --all

# View specific commit
git show abc123
git show abc123:path/to/file

# View file history
git log -- path/to/file
git log -p -- path/to/file

# View who changed what
git blame path/to/file

# View diff between commits
git diff abc123..def456
git diff HEAD~3..HEAD
```

### Modify Commits

```bash
# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (unstage changes)
git reset HEAD~1

# Discard last commit
git reset --hard HEAD~1
```

## Branch Operations

### Manage Branches

```bash
# List branches
git branch
git branch -a
git branch -r

# Create branch
git branch feature-name

# Create and switch
git checkout -b feature-name
git switch -c feature-name

# Switch branch
git checkout branch-name
git switch branch-name

# Delete branch
git branch -d branch-name
git branch -D branch-name

# Rename branch
git branch -m old-name new-name
```

### Track Branches

```bash
# Set upstream
git branch -u origin/branch-name
git branch --set-upstream-to=origin/branch-name

# Get tracking branch
git rev-parse --abbrev-ref --symbolic-full-name @{u}
```

## Remote Operations

### Configure Remotes

```bash
# Add remote
git remote add origin https://github.com/user/repo.git
git remote add upstream https://github.com/user/repo.git

# List remotes
git remote -v

# Update remote URL
git remote set-url origin new-url

# Remove remote
git remote remove origin
```

### Sync with Remote

```bash
# Fetch all remotes
git fetch --all

# Fetch and prune
git fetch --prune

# Pull changes
git pull origin main
git pull --rebase origin main

# Push changes
git push origin main
git push -u origin branch-name

# Force push (use carefully)
git push --force origin branch-name

# Push tags
git push origin tag-name
git push --tags
```

## Stash Operations

```bash
# Stash changes
git stash
git stash push -m "Work in progress"

# List stashes
git stash list

# Apply stash
git stash apply
git stash apply stash@{0}

# Apply and remove
git stash pop

# Drop stash
git stash drop stash@{0}

# Clear all
git stash clear
```

## Tag Operations

```bash
# Create tag
git tag v1.0.0
git tag -a v1.0.0 -m "Release 1.0.0"

# List tags
git tag
git tag -l "v1.*"

# Push tag
git push origin v1.0.0

# Delete tag
git tag -d v1.0.0
git push origin --delete v1.0.0
```

## Working Directory Operations

### Status and Diff

```bash
# Check status
git status
git status -s

# Show diff
git diff
git diff --staged
git diff path/to/file

# Count changes
git diff --stat
```

### File Operations

```bash
# Checkout file
git checkout -- path/to/file
git restore path/to/file

# Restore staged file
git restore --staged path/to/file

# Remove file
git rm path/to/file

# Remove from tracking
git rm --cached path/to/file
```

## Automation Patterns

### Conditional Execution

```bash
#!/usr/bin/env bash
# Run only if there are changes
if [[ -n $(git status --porcelain) ]]; then
    git add -A
    git commit -m "Auto-commit changes"
    git push origin main
fi
```

### Get Current State

```bash
#!/usr/bin/env bash
# Get various states
BRANCH=$(git rev-parse --abbrev-ref HEAD)
COMMIT=$(git rev-parse HEAD)
TAG=$(git describe --tags --abbrev=0)
VERSION=$(git describe --tags)
REPO=$(git rev-parse --show-toplevel)
```

### Check for Changes

```bash
#!/usr/bin/env bash
# Check if repo has changes
if git diff-index --quiet HEAD --; then
    echo "No changes"
else
    echo "Has changes"
fi
```

### Auto-commit with Token

```bash
#!/usr/bin/env bash
# Use with GitHub token
export GITHUB_TOKEN="ghp_xxx"

git remote set-url origin https://${GITHUB_TOKEN}@github.com/user/repo.git
git push origin main
```

## Verify

```bash
# Verify Git installed
git --version

# Verify repository
git status

# Verify remote
git remote -v

# Verify branches
git branch -a

# Test remote connection
git ls-remote origin
```

## Common Errors

### "detected dubious ownership"

```
error: detected dubious ownership in repository
```

**Solution:**
```bash
# Add to safe directory
git config --global --add safe.directory /path/to/repo
# Or
git config --global --add safe.directory '*'
```

### "Authentication failed"

```
fatal: Authentication failed
```

**Solution:**
```bash
# Use token-based auth
git remote set-url origin https://TOKEN@github.com/user/repo.git

# Or configure credential helper
git config credential.helper store
```

### "refusing to merge unrelated histories"

```
fatal: refusing to merge unrelated histories
```

**Solution:**
```bash
git pull origin main --allow-unrelated-histories
```

## Rollback

### 1. Repository State Rollback

#### Reset to Previous Commit
```bash
# Soft reset (keep changes staged)
git reset --soft HEAD~1

# Mixed reset (default - keep changes unstaged)
git reset HEAD~1
git reset --mixed HEAD~1

# Hard reset (discard changes)
git reset --hard HEAD~1

# Reset to specific commit
git reset --hard <commit-hash>
```

#### Revert Commit (Create New Commit That Undoes Changes)
```bash
# Revert last commit
git revert HEAD

# Revert specific commit
git revert <commit-hash>

# Revert multiple commits
git revert <commit-hash>..HEAD
```

#### Restore Deleted Files
```bash
# Restore file to last committed version
git checkout HEAD -- path/to/file
git restore path/to/file

# Restore file from specific commit
git checkout <commit-hash> -- path/to/file
```

### 2. Remote Repository Rollback

#### Revert Push to Remote
```bash
# Force push previous state (use with caution)
git push origin +HEAD~1:main

# Revert merge commit
git revert -m 1 <merge-commit-hash>
git push origin main
```

#### Recover Deleted Branch
```bash
# Find deleted branch commit
git reflog
# Or
git fsck --lost-found

# Recover branch
git checkout -b recovered-branch <commit-hash>
```

### 3. Stash Recovery

#### Recover Dropped Stash
```bash
# Find dropped stash in reflog
git fsck --no-reflogs | awk '/dangling commit/ {print $3}'

# Apply dropped stash
git stash apply <dropped-stash-hash>
```

## References

- Git Documentation: https://git-scm.com/docs
- Pro Git Book: https://git-scm.com/book/en/v2
- Git Cheat Sheet: https://education.github.com/git-cheat-sheet-education.pdf