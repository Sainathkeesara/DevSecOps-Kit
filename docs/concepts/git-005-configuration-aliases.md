# Git Configuration, Aliases, and Best Practices

## Purpose

This guide covers Git configuration options, custom aliases for productivity, and industry best practices for maintaining clean, collaborative Git workflows. It focuses on optimizing Git for individual and team use.

## When to use

- Setting up Git on a new machine
- Creating productivity-boosting aliases
- Establishing team Git standards and conventions
- Optimizing Git performance for large repositories
- Securing Git operations (SSH keys, GPG signing)
- Troubleshooting configuration issues

## Prerequisites

- Git installed and basic commands working
- Familiarity with Git commit/push/pull workflow
- Understanding of repository structure and branching

## Configuration Levels

Git configuration has three levels:

| Level | File Location | Scope |
|-------|--------------|-------|
| System-wide | `/etc/gitconfig` | All users on machine |
| Global (User) | `~/.gitconfig` | Current user, all repos |
| Local (Repository) | `<repo>/.git/config` | Specific repository only |

### Configuration Priority

Local overrides global, global overrides system. Use:
```bash
git config --list --show-origin
# Shows: file path and all key=value pairs
```

## User Identity

Set your name and email (appears in every commit):

```bash
# Global (recommended)
git config --global user.name "Jane Doe"
git config --global user.email "jane@company.com"

# Per-project (overrides global in that repo only)
git config user.name "Project Name"
git config user.email "project@company.com"

# Verify
git config user.name
git config user.email
```

**Best Practice:** Use your professional email. For open source, consider privacy.

## Preferred Editor

Set default editor for commit messages and interactive commands:

```bash
# VS Code (most popular)
git config --global core.editor "code --wait"

# Nano (simple, terminal-based)
git config --global core.editor nano

# Vim
git config --global core.editor vim

# Sublime Text
git config --global core.editor "subl --wait"

# IntelliJ IDEA
git config --global core.editor "idea --wait"
```

**Note:** `--wait` flag is critical — it makes editor block until file closed.

## Aliases

Create shortcuts for frequently used commands:

```bash
# Status shortcuts
git config --global alias.st status
git config --global alias.s "status -s"

# Commit shortcuts
git config --global alias.ci commit
git config --global alias.cim "commit -m"

# Branch shortcuts
git config --global alias.br branch
git config --global alias.ci commit

# Log with graph (visual branch history)
git config --global alias.lg "log --oneline --graph --all --decorate"

# Compact one-line graph
git config --global alias.l "log --oneline --graph --all"

# Log with author and date
git config --global alias.lg2 "log --graph --format='%C(auto)%h%d %s %C(cyan)%an, %C(bold blue)%ar' --abbrev-commit"

# Diff with compact stats
git config --global alias.d "diff --stat"

# Check uncommitted changes
git config --global alias.unstage "reset HEAD --"

# Remove deleted files from tracking
git config --global alias.clean "clean -fd"

# View last commit details
git config --global alias.last "log -1 HEAD"

# Undo last commit (keep changes)
git config --global alias.undo "reset --soft HEAD~1"

# Discard changes in working directory
git config --global alias.discard "checkout --"

# Show untracked files only
git config --global alias.untracked "ls-files --others --exclude-standard"

# Checkout new branch and switch
git config --global alias.cob "checkout -b"

# Merge with verbose output
git config --global alias.mergev "merge --no-ff -v"

# Fetch and prune (remove deleted remote branches)
git config --global alias.fp "fetch --prune"

# Push current branch to same-named remote
git config --global alias.p "push --set-upstream"

# List all aliases (quick reference)
git config --global alias.php "config --global -l | grep alias"
```

### Advanced Alias Examples

```bash
# Search commit messages
git config --global alias.sm "log --oneline --grep"

# Show file change stats for last N commits
git config --global alias.fstats "log --format='%H' -1 | xargs -I{} git diff-tree --stat {}"

# Find files by name in repository
git config --global alias.find "log --pretty=format: --name-only --diff-filter=A | sort -u | grep"

# Create release tag with annotation
git config --global alias.tag-release "tag -a v -m 'Release '"

# ShowContributors
git config --global alias.who "shortlog -sn"

# View branch tree with colors
git config --global alias.tree "log --all --graph --decorate --oneline --color=always"
```

### Shell Aliases in .gitconfig

For complex operations, use `!` prefix to run shell commands:

```bash
# Pull with info
git config --global alias.pull-info '!git pull "$@" && git status'

# Grep through ALL branches
git config --global alias.grep-all '!git grep "$@" $(git rev-list --all)'

# Count commits per author
git config --global alias.authors '!git shortlog -sn'

# Clean merged branches
git config --global alias.clean-merged '!git branch --merged | grep -v "\*" | grep -v "main" | xargs git branch -d'

# Generate changelog from last tag
git config --global alias.changelog '!git log --pretty=format:"- %s" $(git describe --tags --abbrev=0)..HEAD'
```

**View all aliases:**
```bash
git config --global -l | grep alias
# or use the alias itself
git php  # if you set alias.php above
```

## Diff and Merge Tools

Configure external merge tools for conflict resolution:

```bash
# Set default merge tool
git config --global merge.tool vimdiff

# Available tools: vimdiff, meld, kdiff3, p4merge, araxis, bc, vscode

# Configure VS Code as merge tool
git config --global merge.tool code
git config --global mergetool.code.cmd "code --wait $MERGED"

# Configure Meld
git config --global merge.tool meld
git config --global mergetool.meld.path /usr/bin/meld

# Use tool for all merges (no prompt)
git config --global mergetool.prompt false

# Launch tool for current conflicts
git mergetool
```

## Performance Tuning

For large repositories (1000+ files):

```bash
# Increase file descriptor limit (Linux/macOS)
git config --global core.preloadIndex true
git config --global core.untrackedCache true

# Faster push/pull (only if using recent Git)
git config --global pack.windowMemory 100m
git config --global pack.packSizeLimit 100m
git config --global pack.threads "1"  # CPU cores

# Reduce status time on large repos
git config --global status.showUntrackedFiles no
# Use 'git status -u' to show untracked when needed
```

## Safety Settings

Prevent common mistakes:

```bash
# Prevent pushing to main by default
git config --global push.default simple

# Require explicit branch name on push
git config --global push.default nothing

# Set default push behavior (main only)
git config --global push.followTags true

# Never push tags that haven't been explicitly pushed
git config --global remote.origin.prompt true

# Warn before committing large files (>10MB)
git config --global commit.gpgsign true  # optional GPG signing

# Enable rerere (reuse recorded resolution) for repeat conflicts
git config --global rerere.enabled true
```

## File Attributes

`.gitattributes` file controls Git behavior per-path:

```bash
# Set in repository root
echo "*.json linguist-language=JSON" >> .gitattributes
echo "*.min.js merge=ours" >> .gitattributes
echo "*.lock binary" >> .gitattributes
```

Common attributes:
- `binary` — no diff, no merge
- `text` — enforce LF line endings
- `text eol=crlf` — force CRLF on checkout
- `linguist-language=Python` — override language detection
- `merge=ours` — always keep our version during merge

## Line Ending Management

Handle cross-platform line ending differences:

```bash
# Auto-convert LF↔CRLF (recommended for Windows teams)
git config --global core.autocrlf true

# Mac/Linux teams: convert CRLF→LF only on commit
git config --global core.autocrlf input

# Disable conversion (Linux-only homogeneous environment)
git config --global core.autocrlf false

# Check current setting
git config --global core.autocrlf
```

**`.gitattributes` approach (force per-repo):**
```
# Set in repo root
* text=auto
*.sh text eol=lf
*.bat text eol=crlf
```

## GPG Signing (Optional)

Cryptographically sign commits for authenticity:

```bash
# Generate GPG key (if you don't have one)
gpg --full-generate-key

# List keys to find ID
gpg --list-secret-keys --keyid-format LONG

# Set signing key in Git
git config --global user.signingkey ABC123DEF456!

# Sign all commits automatically
git config --global commit.gpgsign true

# Sign individual commit
git commit -S -m "Secure commit"

# Verify signature
git verify-commit HEAD

# Sign tags
git tag -s v1.0.0 -m "Signed release"

# Configure GPG program (macOS)
git config --global gpg.program gpg2
```

**GitHub/GitLab: Add public GPG key to account settings for verification badges.**

## Hooks

Client-side hooks run automatically on Git events:

### Pre-commit Hook

Run checks before each commit:

```bash
# Create pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Run linter
npm run lint

# Run tests
npm test

# Fail if any command fails
if [ $? -ne 0 ]; then
  echo "Pre-commit checks failed"
  exit 1
fi
EOF

# Make executable
chmod +x .git/hooks/pre-commit
```

### Commit-msg Hook

Enforce commit message format:

```bash
cat > .git/hooks/commit-msg << 'EOF'
#!/bin/bash
# Enforce Conventional Commits
MSG=$(cat $1)
if ! echo "$MSG" | grep -qE "^(feat|fix|docs|style|refactor|test|chore)\(.+\): .{10,}"; then
  echo "ERROR: Commit message doesn't follow convention"
  echo "Format: type(scope): description"
  echo "Example: feat(auth): add OAuth2 support"
  exit 1
fi
EOF
chmod +x .git/hooks/commit-msg
```

### Prepare-commit-msg Hook

Auto-insert issue tracker reference:

```bash
cat > .git/hooks/prepare-commit-msg << 'EOF'
#!/bin/bash
# Prepend issue ID from branch name
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ $BRANCH =~ ^(feature|bugfix|hotfix)/([A-Z]+-[0-9]+) ]]; then
  ISSUE="${BASH_REMATCH[2]}"
  sed -i "1s/^/[${ISSUE}] /" "$1"
fi
EOF
chmod +x .git/hooks/prepare-commit-msg
```

**Note:** Hooks are not versioned by default. Track them manually or use:
- `husky` (Node.js projects)
- `lefthook` (multi-language)
- `pre-commit` framework (Python-based)

## Best Practices

### 1. Atomic Commits

Each commit should be a single logical change:

✅ **Good:**
```
commit 1: Fix login validation bug
commit 2: Add password reset endpoint
commit 3: Update API documentation
```

❌ **Bad:**
```
commit 1: Fix login, add reset, update docs, change colors
```

### 2. Meaningful Commit Messages

Follow Conventional Commits format:

```
<type>(<scope>): <short description>

<body> (optional)

<footer> (optional)
```

**Structure:**
- **Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
- **Scope**: module or component affected
- **Description**: imperative, present tense, no period

**Examples:**
```
feat(auth): add OAuth2 login flow

- Implement OAuth2 authorization code flow
- Add token refresh mechanism
- Update user profile endpoint

Closes #123
```

```
fix(api): correct pagination offset calculation

The offset was incorrectly calculated as page * limit
instead of (page - 1) * limit, causing first page to skip items.

Closes #456
```

### 3. Branch Naming Conventions

Use descriptive, consistent names:

```bash
# Feature branches
feature/user-profile-editor
feature/jenkins-pipeline-automation

# Bug fixes
bugfix/login-cookie-expiry
bugfix/header-overlap-mobile

# Hotfixes (production emergencies)
hotfix/security-patch-cve-2025-1234
hotfix/payment-gateway-timeout

# Releases
release/v2.1.0
release/2025.04

# Documentation
docs/api-endpoint-updates
```

### 4. Rebasing vs Merging

**Interactive rebase for local cleanup:**
```bash
# Squash multiple WIP commits
git rebase -i HEAD~5

# Choose: squash, fixup, reword, drop
# Creates clean, linear history
```

**Merge for shared branches:**
```bash
# Use merge on main/develop branches
# Never rebase public/shared history
```

**Rule of thumb:**
- ✅ `git rebase -i` on **private** branches
- ❌ Never `git rebase` on **public/shared** branches
- ✅ `git merge --no-ff` for feature merges to preserve history

### 5. .gitignore Essentials

Never commit:
- Secrets and credentials (`.env`, `*.pem`, `id_rsa`)
- Dependencies (`node_modules/`, `vendor/`, `target/`)
- Build artifacts (`*.o`, `dist/`, `build/`)
- IDE files (`.vscode/`, `.idea/`, `*.swp`)
- OS files (`.DS_Store`, `Thumbs.db`)
- Logs (`*.log`, `logs/`)
- Temporary files (`*.tmp`, `*.bak`)

**Template:**
```
# Dependencies
node_modules/
vendor/
target/

# Environment
.env
.env.local
.env.*.local

# Secrets
*.pem
*.key
*.crt
id_rsa
id_ed25519

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Build
dist/
build/
*.o
*.class

# Cache
.cache/
.tmp/
```

### 6. Commit Often, Push Regularly

- Commit small, focused changes frequently
- Push to remote at least daily
- Pull before you push (avoid conflicts)
- Use `git push --set-upstream` on first push of branch

### 7. Review Before Committing

```bash
# Check staged changes
git diff --staged

# Check all changes (staged + unstaged)
git diff

# Verify file list
git status
```

### 8. Write Descriptive Branch Names

```
# Good
feature/user-authentication
bugfix/payment-webhook-timeout
hotfix/cve-2025-1234-sql-injection

# Bad
fix-bug
new-feature
update
```

### 9. Keep Main Branch Deployable

- `main`/`master` should always be production-ready
- Use pull requests for all changes
- Require code review before merging
- Run CI/CD on every PR
- Never commit directly to main (protected branch)

### 10. Clean Up Branches

After feature merges, delete branches:

```bash
# Delete local branch
git branch -d feature-done

# Delete remote branch
git push origin --delete feature-done

# Clean up all merged branches
git branch --merged | grep -v "\*" | grep -v "main" | xargs git branch -d

# Prune remote-tracking branches
git fetch --prune
```

## Verify

```bash
# Check all config
git config --global --list

# Verify aliases work
git s  # should run status -s
git lg  # should show graph log

# Check identity
git config user.name
git config user.email

# Verify merge tool
git config merge.tool

# Check line ending config
git config --global core.autocrlf

# Verify GPG signing (if configured)
git config --global commit.gpgsign
gpg --list-secret-keys --keyid-format LONG

# Test alias
git last  # shows last commit

# Validate repository health
git status
git fsck  # check object integrity
```

## Rollback

### Remove an Alias

```bash
# Delete specific alias
git config --global --unset alias.st

# Delete multiple
git config --global --unset-all alias.myalias
```

### Reset Configuration

```bash
# Remove specific key
git config --global --unset user.name

# Edit config file directly
vim ~/.gitconfig

# Reset merge tool
git config --global --unset merge.tool
```

### Recover from Misconfiguration

```bash
# View all config with file origins
git config --list --show-origin

# Check system config
git config --system --list

# Check local repo config
git config --local --list

# Restore default
git config --global --replace-all core.editor vim
```

## Common Errors

### "fatal: bad alias — st"

**Cause:** Alias not defined or typo in alias name.

**Solution:**
```bash
# Check defined aliases
git config --global -l | grep alias

# Define missing alias
git config --global alias.st status

# Fix typo in .gitconfig manually
vim ~/.gitconfig
```

### "error: cannot run code: No such file or directory"

**Cause:** Editor configured but not installed.

**Solution:**
```bash
# Change to installed editor
git config --global core.editor vim

# Or install configured editor
# For VS Code: download from code.visualstudio.com
```

### "warning: core.autocrlf is set to 'true' on a case-insensitive filesystem"

**Cause:** Git warns about potential issues with autocrlf on Windows/macOS.

**Solution:**
```bash
# Usually safe to ignore if Windows development
# Or use .gitattributes for fine-grained control
echo "* text=auto" >> .gitattributes
```

### "fatal: unable to auto-detect email address"

**Cause:** User.email not configured.

**Solution:**
```bash
git config --global user.email "you@example.com"
```

### GPG Errors: "gpg: signing failed: No secret key"

**Cause:** Signing key not available or wrong key ID.

**Solution:**
```bash
# List available secret keys
gpg --list-secret-keys --keyid-format LONG

# Update Git config with correct key
git config --global user.signingkey <correct-key-id>

# Ensure GPG agent is running (macOS)
gpgconf --launch gpg-agent
```

### Hook Scripts Not Running

**Cause:** Hooks not executable or wrong filename.

**Solution:**
```bash
# Make hook executable
chmod +x .git/hooks/pre-commit

# Verify hook filename (no extension)
ls -la .git/hooks/pre-commit

# Check shebang line (first line: #!/bin/bash)
head -1 .git/hooks/pre-commit
```

### Alias with Arguments Not Working

**Problem:** Aliases don't pass arguments correctly.

**Solution:** Use `$*` in shell-style alias:
```bash
# Wrong (args ignored)
git config --global alias.unstage 'reset HEAD'

# Correct
git config --global alias.unstage 'reset HEAD --'

# With shell function for complex logic
git config --global alias.new '!f() { git checkout -b "$1" && git push -u origin "$1"; }; f'
```

## References

- Git Configuration Docs: https://git-scm.com/docs/git-config
- Git Aliases Guide: https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases
- Pro Git (Config): https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration
- Conventional Commits: https://www.conventionalcommits.org
- Git Hooks Documentation: https://git-scm.com/docs/githooks
- Atlassian Git Workflows: https://www.atlassian.com/git/tutorials/comparing-workflows
- GitHub Git Cheatsheet: https://education.github.com/git-cheat-sheet-education.pdf
