# Basic Git Commands and Repository Setup

## Purpose

This guide covers essential Git commands for daily use and repository setup tasks. It's designed for developers who understand version control concepts and need practical command reference for getting started with Git repositories.

## When to use

- Setting up a new Git repository for a project
- Cloning existing repositories from remote servers
- Basic day-to-day Git operations (add, commit, push, pull)
- Initial repository configuration (user info, branches)
- Working with remote repositories for the first time

## Prerequisites

### Software Requirements
- Git installed (`git --version` should return 2.x or higher)
- Terminal or command-line access
- SSH keys configured (for SSH-based remotes) OR HTTPS credentials

### Recommended Configuration
Before first use, configure your identity:
```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

## Initial Setup

### 1. Configure Git Identity

Set your name and email — these appear on every commit:

```bash
# Set global identity (applies to all repositories)
git config --global user.name "Jane Doe"
git config --global user.email "jane@company.com"

# Set per-repository identity (overrides global in specific repo)
git config user.name "Project Specific Name"
git config user.email "project@example.com"

# Verify configuration
git config --list
```

### 2. Choose Default Branch Name

Modern Git uses `main` as default; set it globally:

```bash
git config --global init.defaultBranch main
```

### 3. Configure Editor (Optional)

Set your preferred text editor for commit messages:

```bash
# Vim (default)
git config --global core.editor vim

# Nano
git config --global core.editor nano

# VS Code
git config --global core.editor "code --wait"

# Sublime Text
git config --global core.editor "subl --wait"
```

## Starting a Repository

### Initialize a New Repository

Create a new Git repository from scratch:

```bash
# Create project directory
mkdir my-project
cd my-project

# Initialize Git
git init
# Output: Initialized empty Git repository in /path/to/my-project/.git/

# Create initial file
echo "# My Project" > README.md

# Stage and commit
git add README.md
git commit -m "Initial commit"
```

### Clone an Existing Repository

Copy a repository from a remote server:

```bash
# Clone via HTTPS
git clone https://github.com/user/repo.git

# Clone via SSH
git clone git@github.com:user/repo.git

# Clone specific branch
git clone -b develop https://github.com/user/repo.git

# Clone shallow (only latest commit, saves space)
git clone --depth 1 https://github.com/user/repo.git

# Clone into specific directory
git clone https://github.com/user/repo.git my-folder-name
```

## Daily Operations

### Check Repository Status

See what's changed in your working directory:

```bash
# Standard status
git status
# Shows: staged, unstaged, and untracked files

# Short status (concise)
git status -s
# ?? = untracked, A = added, M = modified, D = deleted
```

### Stage Changes

Select which changes to include in the next commit:

```bash
# Stage specific file
git add README.md

# Stage multiple files
git add file1.txt file2.txt

# Stage all changes (use carefully)
git add .

# Stage all changes except deleted files
git add -u

# Stage interactive (choose hunks)
git add -p
```

### Commit Changes

Save a snapshot of staged changes:

```bash
# Commit with message
git commit -m "Add user authentication"

# Commit and stage all modified/deleted files (skip new untracked)
git commit -am "Fix typo in README"

# Commit with detailed message (opens editor)
git commit

# Amend last commit (changes message or adds forgotten files)
git commit --amend -m "Better commit message"

# Amend without changing message
git add forgot-file.txt
git commit --amend --no-edit
```

### View History

Review commit history:

```bash
# One-line summary
git log --oneline

# Graph view (shows branching)
git log --oneline --graph --all

# Detailed view with patches
git log -p

# Show recent N commits
git log -3

# Show changes for specific file
git log -- <file>

# Show who changed what and when
git blame <file>
```

### Undo Changes

Revert or reset changes:

```bash
# Discard unstaged changes in a file
git checkout -- <file>
# Git 2.23+
git restore <file>

# Unstage a file
git reset HEAD <file>
# Git 2.23+
git restore --staged <file>

# Undo last commit (keep changes unstaged)
git reset HEAD~1

# Undo last commit (keep changes staged)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1
# ⚠️  DANGER: permanently discards work
```

### Working with Branches

Create and manage branches:

```bash
# List branches (local)
git branch

# List all branches (local and remote)
git branch -a

# Create new branch
git branch feature-login

# Create and switch to branch
git checkout feature-login
# Git 2.23+
git switch feature-login

# Create and switch in one command
git checkout -b feature-login
# Git 2.23+
git switch -c feature-login

# Switch to existing branch
git checkout main
git switch main

# Rename branch
git branch -m old-name new-name

# Delete branch (merged)
git branch -d feature-login

# Force delete (unmerged changes lost)
git branch -D feature-login

# Compare branches
git diff main..feature-login
```

## Remote Operations

### Add a Remote

Link your local repository to a remote server:

```bash
# Add remote named 'origin'
git remote add origin https://github.com/user/repo.git

# View configured remotes
git remote -v
# Shows: fetch and push URLs

# Remove remote
git remote remove origin

# Rename remote
git remote rename origin upstream
```

### Fetch, Pull, Push

Synchronize with remote repository:

```bash
# Download changes (doesn't merge)
git fetch origin

# Download and merge changes
git pull origin main

# Pull with rebase (linear history)
git pull --rebase origin main

# Upload local commits to remote
git push origin main

# Push new branch to remote
git push -u origin feature-login
# -u sets upstream tracking

# Push all branches
git push --all origin

# Force push (overwrites remote — use cautiously)
git push --force origin feature-login
# ⚠️  Only use on private branches
```

### Tracking Branches

Local branches that track remote branches:

```bash
# Set upstream when pushing first time
git push -u origin feature-login

# Set upstream for existing branch
git branch -u origin/feature-login

# View tracking info
git branch -vv
# Shows: [origin/main] for tracked branches

# Push current branch to same-named remote
git push
# (requires upstream set)

# Pull from tracked remote
git pull
# (uses upstream automatically)
```

### Sync Full Repository

```bash
# Fetch all remotes
git fetch --all

# Prune deleted remote branches
git fetch --prune

# Pull with rebase for clean history
git pull --rebase origin main

# Push all branches
git push --all

# Push tags
git push --tags
```

## Stashing

Temporarily save uncommitted changes:

```bash
# Save current working directory changes
git stash

# Save with descriptive message
git stash push -m "WIP: experimental feature"

# List stash entries
git stash list
# stash@{0}: WIP on main: abc123...

# Apply stash (keeps it in stash list)
git stash apply

# Apply specific stash
git stash apply stash@{2}

# Apply and remove from stash
git stash pop

# Drop specific stash
git stash drop stash@{0}

# Clear all stashes
git stash clear
```

## Tags

Mark specific points in history (releases, milestones):

```bash
# Create lightweight tag
git tag v1.0.0

# Create annotated tag (with message, author, date)
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push tags to remote
git push origin v1.0.0
git push origin --tags  # all tags

# List tags
git tag
git tag -l "v1.*"  # pattern

# Show tag details
git show v1.0.0

# Delete tag (locally)
git tag -d v1.0.0

# Delete tag (remote)
git push origin --delete v1.0.0
```

## Verify

```bash
# Verify installation
git --version
# Expected: git version 2.x.x

# Verify repository integrity
git status
# Should show: "On branch main" or similar

# Verify remotes
git remote -v
# Should show fetch/push URLs

# Verify branches
git branch -a
# Should list local and remote branches

# Test connection to remote
git ls-remote
# Lists remote refs without local clone

# Check last commit
git log -1
# Shows author, date, message

# Verify no conflicts
git status
# Should NOT show "unmerged paths"

# Test push access
git push --dry-run origin main
# Shows what would be pushed (no actual push)
```

## Rollback

### Reset to Previous State

Move branch pointer backward:

```bash
# Soft reset (keep changes staged)
git reset --soft HEAD~1

# Mixed reset (keep changes unstaged) — default
git reset HEAD~1

# Hard reset (discard all changes)
git reset --hard HEAD~1
# ⚠️  LOSES WORK — cannot be undone
```

### Revert a Commit

Create new commit that undoes previous changes (safe for shared history):

```bash
# Revert specific commit
git revert abc123def

# Revert range of commits
git revert HEAD~3..HEAD

# Revert merge commit (specify parent)
git revert -m 1 abc123  # use -m 1 or -m 2
```

### Restore Deleted Files

```bash
# Restore file from HEAD
git restore --staged deleted-file.txt
git restore deleted-file.txt

# Restore from specific commit
git checkout abc123 -- path/to/file
```

### Recovery After Bad Reset

```bash
# Find lost commits
git reflog
# Shows: all HEAD movements

# Recover from reflog
git reset --hard abc123  # hash from reflog
```

## Common Errors

### "fatal: not a git repository"

**Problem:** Directory is not a Git repository.

**Solution:**
```bash
# Initialize new repo
git init

# Or navigate to existing repo
cd path/to/existing/repo
```

### "fatal: repository not found"

**Problem:** Remote URL is incorrect or access denied.

**Solution:**
```bash
# Verify remote URL
git remote -v

# Update incorrect URL
git remote set-url origin https://github.com/user/repo.git

# Check repository exists on server
# Visit GitHub/GitLab in browser
```

### "error: src refspec main does not match any"

**Problem:** Branch doesn't exist locally yet (no commits on it).

**Solution:**
```bash
# Commit first
git add .
git commit -m "Initial commit"

# Then push
git push -u origin main
```

### "fatal: refusing to merge unrelated histories"

**Problem:** Repositories have unrelated commit histories.

**Solution:**
```bash
# Only use if you understand the risk
git pull origin main --allow-unrelated-histories
```

### "fatal: Authentication failed"

**Problem:** Credentials incorrect or expired.

**Solution:**
```bash
# For HTTPS: update credentials
git config --global credential.helper cache

# For SSH: verify SSH key
ssh -T git@github.com

# Regenerate/readd SSH key if needed
```

### "error: Your local changes would be overwritten by merge"

**Problem:** Uncommitted changes conflict with incoming changes.

**Solution:**
```bash
# Option 1: Stash changes, pull, then unstash
git stash
git pull origin main
git stash pop

# Option 2: Commit changes first
git add .
git commit -m "WIP"

git pull origin main
```

### "fatal: ambiguous argument 'HEAD~1'"

**Problem:** No commits yet or malformed reference.

**Solution:**
```bash
# Make initial commit first
git add .
git commit -m "Initial commit"

# Then use reset/reflog
```

### Merge Conflicts

When automatic merge fails:

```bash
# 1. Identify conflicted files
git status
# Shows: "both modified: <file>"

# 2. Open files and resolve <<<<<<< markers
# Choose either HEAD (local) or incoming changes
# or create a hybrid solution

# 3. Mark as resolved
git add <file>

# 4. Complete merge
git commit
# Uses default merge message
```

## References

- Git Documentation: https://git-scm.com/docs
- Git Commands Reference: https://git-scm.com/docs/git
- Pro Git Book: https://git-scm.com/book/en/v2
- Git Quick Reference: https://github.com/arslanbilal/git-cheat-sheet
- Git Interactive Tutorial: https://learngitbranching.org
- Git Basics (Atlassian): https://www.atlassian.com/git/tutorials
