# Git: Credential Helper Setup for CI/CD Pipelines

## Purpose

This guide provides configuration for Git credential helpers in CI/CD pipeline environments. It enables automated authentication to Git repositories without interactive login, supporting GitHub Actions, GitLab CI, Jenkins, and other CI platforms.

## When to Use

- Setting up automated build and deployment pipelines
- Configuring CI/CD runners for Git operations
- Enabling git fetch/pull in containerized environments
- Configuring authentication for cross-repository access
- Setting up deployment keys and tokens

## Prerequisites

- Git 2.0 or later installed
- CI/CD platform access (GitHub, GitLab, etc.)
- Personal Access Token (PAT) or deploy key
- Required for CI: appropriate environment variables set

## Steps

### 1. Setup Basic Credential Helper

```bash
# Configure credential helper based on OS
git config --global credential.helper store

# OR for Linux with libsecret
git config --global credential.helper libsecret

# OR for macOS
git config --global credential.helper osxkeychain

# OR for Windows
git config --global credential.helper manager-core
```

### 2. Configure for GitHub Actions

```bash
# Set tokens in secrets (not hardcoded)
# GITHUB_TOKEN is auto-injected

# Configure git identity
git config --global user.name "github-actions[bot]"
git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"
```

### 3. Configure for GitLab CI

```bash
# CI_JOB_TOKEN is auto-injected
# Configure git
git config --global user.email "gitlab-ci@example.com"
git config --global user.name "GitLab CI"

# Set credential helper
git config --global credential.helper 'cache --timeout=3600'
```

### 4. Configure for Jenkins

```bash
# Set environment variables in Jenkins credentials
export GIT_USER="jenkins-deploy"
export GIT_TOKEN="${JENKINS_GIT_TOKEN}"

# Configure git identity
git config --global user.email "jenkins@${NODE_NAME:-localhost}"
git config --global user.name "Jenkins"
```

### 5. Store Credentials

```bash
# Using personal access token
git config --global credential.username "$GIT_USER"

# OR using the credential helper script
echo "protocol=https
host=github.com
username=${GIT_USER}
password=${GIT_TOKEN}" | git credential approve
```

## Verify

```bash
# Test configuration
git config --global credential.helper

# Test authentication
git ls-remote https://github.com/owner/repo.git

# Check git identity
git config --global user.name
git config --global user.email
```

## Rollback

```bash
# Remove credential configuration
git config --global --unset credential.helper
git config --global --unset credential.username

# Clear stored credentials
rm -f ~/.git-credentials
```

## Common Errors

### Error: Authentication failed

**Cause:** Invalid token or credentials.
```bash
# Verify token is set
echo $GIT_TOKEN

# Re-configure credentials
git config --global credential.helper store
```

### Error: Permission denied

**Cause:** Token lacks required scopes.
```bash
# Ensure token has repo scope
# For GitHub: repo, read:org
# For GitLab: api, read_repository
```

### Error: Credential helper not found

**Cause:** Required tool not installed.
```bash
# Install libsecret (Ubuntu/Debian)
apt install libsecret-1-0

# Install libsecret-tools
apt install libsecret-tools
```

## References

- [Git Credential Storage](https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitLab CI/CD Documentation](https://docs.gitlab.com/ci/)