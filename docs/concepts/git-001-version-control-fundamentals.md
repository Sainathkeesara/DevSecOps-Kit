# Introduction to Version Control Fundamentals

## Purpose

This document introduces the fundamental concepts of version control, explaining why it's essential for software development and DevOps practices. It provides the foundational knowledge needed before diving into specific tools like Git.

## When to use

- New developers learning version control for the first time
- Teams transitioning from manual file sharing to version control
- Understanding the core problems version control solves
- Before starting any Git-specific training or documentation

## Prerequisites

- Basic understanding of software development workflows
- Familiarity with file systems and directories
- No prior version control experience required

## What is Version Control?

Version control is a system that records changes to files over time so you can recall specific versions later. It enables multiple people to work on the same project without overwriting each other's work.

### Core Benefits

**1. Track History**
- Every change is recorded with who made it and when
- View complete project history at any point
- Compare changes between versions
- Revert to previous states when needed

**2. Collaboration**
- Multiple developers work simultaneously on the same codebase
- Changes are merged intelligently
- Conflicts are identified and resolvable
- No more emailing "final_final_v3.zip" files

**3. Branching and Experimentation**
- Create isolated branches to try new features
- Test ideas without breaking stable code
- Merge successful experiments back to main
- Discard failed experiments cleanly

**4. Backup and Recovery**
- Full history stored locally and/or remotely
- Recover from accidental deletions or corruption
- Multiple team members have complete copies

## Key Concepts

### Repository (Repo)

A collection of files and their version history. A Git repository contains:
- All project files
- Complete history of every change
- Branch information
- Configuration data

### Commit

A snapshot of the entire repository at a point in time. Each commit includes:
- Unique identifier (hash)
- Author information
- Timestamp
- Commit message describing changes
- Pointer to parent commit(s)

### Working Directory

The directory on your local machine where you edit files. This is where you make changes before committing them.

### Staging Area (Index)

A holding area for changes you want to include in the next commit. You selectively add files to the staging area.

```
Working Directory → [git add] → Staging Area → [git commit] → Repository
```

### Branch

A movable pointer to a commit. Branches allow you to work on different versions of the project simultaneously.

- `main`/`master` — primary production-ready branch
- `develop` — integration branch for features
- `feature/*` — individual feature development
- `release/*` — release preparation
- `hotfix/*` — emergency fixes

### Remote

A version of the repository hosted on a server (GitHub, GitLab, Bitbucket). Remotes enable collaboration by providing a central point for team members to share changes.

### Merge

Combining changes from different branches. Git attempts to merge automatically; conflicts require manual resolution.

### Conflict

When two or more people modify the same lines in a file, Git cannot automatically merge the changes. Conflicts must be resolved manually.

## Centralized vs Distributed VCS

### Centralized (SVN, CVS)

```
┌─────────────┐
│   Server    │ ← Single source of truth
│  (Central)  │
└──────┬──────┘
       │
       ├── Developer A
       ├── Developer B
       └── Developer C
```

- Single central repository
- Everyone commits to and updates from the server
- Requires network connection for most operations
- Server downtime stops all work

### Distributed (Git, Mercurial)

```
    ┌─────────────┐
    │   Server    │ ← Shared remote
    │  (Remote)   │
    └──────┬──────┘
           │
    ┌──────┴──────┐
    │             │
┌───▼───┐    ┌───▼───┐
│Clone A│    │Clone B│ ← Each has full history
└───────┘    └───────┘
```

- Every developer has a complete copy of the repository
- Offline work is fully possible
- Faster operations (local)
- Multiple remotes possible

## Basic Workflow

1. **Initialize or clone a repository**
   ```bash
   git init  # or git clone <url>
   ```

2. **Make changes** — edit files in your working directory

3. **Stage changes** — move changes to staging area
   ```bash
   git add <file>
   ```

4. **Commit changes** — save a snapshot to repository
   ```bash
   git commit -m "Meaningful message"
   ```

5. **Share changes** — push to remote repository
   ```bash
   git push origin main
   ```

6. **Get updates** — pull changes from others
   ```bash
   git pull origin main
   ```

## Verify

```bash
# Check if Git is installed
git --version
# Expected: git version 2.x.x

# Verify repository status
git status
# Shows: staged, unstaged, and untracked files

# View commit history
git log --oneline
# Shows list of commits with hashes

# Check branches
git branch
# Shows current branch with * marker

# View configuration
git config --list
# Shows all Git configuration
```

## Rollback

### Discard unstaged changes
```bash
git checkout -- <file>
# or Git 2.23+
git restore <file>
```

### Unstage changes
```bash
git reset HEAD <file>
# or
git restore --staged <file>
```

### Amend last commit (minor change)
```bash
# Make additional changes
git add <file>
git commit --amend
# Use with caution: rewrites history
```

## Common Errors

### "Not a git repository"
```
fatal: not a git repository
```
**Cause:** Not inside a Git repository directory
**Solution:** Navigate to a Git repository or run `git init`

### "Nothing to commit, working tree clean"
```
nothing added to commit but untracked files present
```
**Cause:** No staged changes to commit
**Solution:** Use `git add` to stage files first

### Merge conflicts
```
CONFLICT (content): Merge conflict in <file>
```
**Cause:** Same lines modified in different branches
**Solution:**
1. Open affected files
2. Resolve `<<<<<<<`, `=======`, `>>>>>>>` markers
3. `git add <file>`
4. `git commit`

## References

- Pro Git Book: https://git-scm.com/book/en/v2
- Git Documentation: https://git-scm.com/docs
- Version Control with Git: https://www.atlassian.com/git
- GitHub Guides: https://guides.github.com
- Git Cheat Sheet: https://education.github.com/git-cheat-sheet-education.pdf
