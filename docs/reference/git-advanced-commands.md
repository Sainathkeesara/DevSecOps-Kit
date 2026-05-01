# Git Advanced Command Patterns

## Purpose

This reference covers advanced Git command patterns for automation, scripting, and complex version control scenarios in DevOps environments.

## When to use

- Writing advanced Git automation scripts
- Handling complex merge scenarios
- Performing bulk repository operations
- Implementing Git-based deployment workflows

## Advanced Status Commands

### Detailed Status with Options

```bash
git status --porcelain
git status --porcelain=v1
git status --porcelain=v2
git status --short
git status --branch
```

### Branch Status Comparison

```bash
git status -sb
git branch -vv
git branch -vva
```

## Automation-Ready Commands

### Check for Uncommitted Changes

```bash
if git diff-index --quiet HEAD --; then
    echo "Clean"
else
    echo "Dirty"
fi
```

### Get Change Summary

```bash
git diff --stat
git diff --shortstat
git diff --numstat
```

### List Modified Files Only

```bash
git diff --name-only
git diff --name-status
git diff --diff-filter=M
```

## Advanced Log Patterns

### Pretty Log Formats

```bash
git log --pretty=format:"%h - %an, %ar : %s"
git log --pretty=format:"%C(auto)%h %s %C(dim white)(%aN)"
git log --oneline --graph --all --decorate
```

### Filter by Date

```bash
git log --after="2024-01-01"
git log --before="2024-12-31"
git log --since="2 weeks ago"
```

### Filter by Author

```bash
git log --author="username"
git log --author="username@example.com"
```

### Range Queries

```bash
git log main..feature
git log ^main feature
git log feature --not main
```

## Submodule Operations

### Manage Submodules

```bash
git submodule add https://github.com/user/repo.git path/to/submodule
git submodule update --init --recursive
git submodule sync
git submodule deinit -f path/to/submodule
```

## Worktree Commands

### Multiple Working Directories

```bash
git worktree add ../branch-worktree feature-branch
git worktree list
git worktree prune
git worktree remove ../branch-worktree
```

## Bisect for Automation

### Automated Bug Finding

```bash
git bisect start
git bisect bad
git bisect good v1.0.0
git bisect run ./test-script.sh
```

## Filter Branch for Cleanup

### Remove Sensitive Data

```bash
git filter-branch --force --tree-filter \
    'rm -f passwords.txt' HEAD
git update-ref -d refs/original/refs/heads/master
```

## Advanced Rebase

### Interactive Rebase Script

```bash
git rebase -i HEAD~5
git rebase --onto newbase oldbase feature
git rebase -X theirs main feature
```

## Git Attributes

### Line Ending Handling

```bash
echo "* text=auto" > .gitattributes
echo "*.sh text eol=lf" >> .gitattributes
echo "*.bat text eol=crlf" >> .gitattributes
```

## Bisect Automation

### Finding Breaking Changes

```bash
#!/usr/bin/env bash
git bisect start HEAD v1.0.0
git bisect run make test
```

## Verify

```bash
git --version
git config --list
git status
```

## Common Errors

### Detached HEAD

```
You are in 'detached HEAD' state
```

**Solution:**
```bash
git checkout main
git checkout -b new-branch
```

### Large File Warnings

```
warning: LF will be replaced by CRLF
```

**Solution:**
```bash
git config core.autocrlf true
git config core.autocrlf input
```

## References

- Git Internals: https://git-scm.com/book/en/v2
- Advanced Git: https://git-scm.com/book/en/v2/Git-Internals