# Git: Security — Git repository access control and authentication hardening for CI/CD pipelines

## Purpose
This guide provides security best practices for hardening Git repository access control and authentication in CI/CD pipelines. It covers securing Git credentials, implementing least-privilege access, protecting against common vulnerabilities, and ensuring secure Git operations in automated workflows.

## When to Use
- Configuring CI/CD pipelines that interact with Git repositories
- Managing access to Git repositories for automated build and deployment systems
- Securing Git credentials in pipeline environments
- Implementing repository access controls for compliance requirements
- Protecting against credential leakage and unauthorized access in CI/CD

## Prerequisites
- Git installed (version 2.x or higher)
- Access to Git hosting provider (GitHub, GitLab, Bitbucket, etc.)
- Administrative access to CI/CD system (Jenkins, GitLab CI, GitHub Actions, etc.)
- Understanding of SSH keys and personal access tokens
- Pipeline YAML or configuration editing access

## Steps

### 1. Secure Credential Management

#### Use Personal Access Tokens (PAT) with Limited Scopes
```bash
# Generate PAT with minimal required permissions
# Example for GitHub: repo scope for private workflows
# Store securely in CI/CD secret management
```

#### Prefer SSH Keys Over Passwords
```bash
# Generate dedicated SSH key for CI/CD
ssh-keygen -t ed25519 -f /opt/ci-cd-git-key -N "" -C "ci-cd-pipeline"

# Add public key to Git hosting service as deploy key
# Configure CI/CD to use this key
```

#### Use CI/CD Secret Management
```yaml
# GitHub Actions example
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}  # Automatically managed token
          # OR use custom secret
          # token: ${{ secrets.CUSTOM_GIT_TOKEN }}

# GitLab CI example
variables:
  GIT_SSL_NO_VERIFY: "false"
  GIT_CHECKOUT: "true"
# Use CI_JOB_TOKEN or custom protected variables
```

### 2. Repository Access Control

#### Implement Least Privilege Principles
- Use repository-specific deploy keys instead of personal accounts
- Create machine users with minimal required permissions
- Grant access only to specific repositories needed
- Use read-only access when possible for clone operations

#### Branch Protection Rules
```bash
# GitHub API example to protect main branch
curl -X PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer <TOKEN>" \
  https://api.github.com/repos/OWNER/REPO/branches/main/protection \
  -d '{
    "required_status_checks": {
      "strict": true,
      "contexts": ["continuous-integration/build"]
    },
    "enforce_admins": true,
    "required_pull_request_reviews": {
      "required_approving_review_count": 1,
      "dismiss_stale_reviews": true
    },
    "restrictions": null
  }'
```

#### Repository Visibility and Forking Controls
- Disable forking for sensitive repositories
- Use private repositories for internal components
- Restrict visibility to organization members only
- Regularly audit repository collaborators and access levels

### 3. Secure Git Operations in Pipelines

#### Configure Git Securely
```bash
# Set secure Git configuration
git config --global http.sslVerify true
git config --global http.sslCAInfo /etc/ssl/certs/ca-certificates.crt
git config --global credential.helper store  # Use with secure storage
git config --global push.default simple
git config --global fetch.prune true
git config --global protocol.version 2
```

#### Use Secure Protocols
```bash
# Prefer SSH or HTTPS with token authentication
# Avoid git:// protocol (unencrypted)
# For HTTPS, ensure TLS 1.2+ is used

# Example SSH URL
git@github.com:organization/repo.git

# Example HTTPS with token (in CI/CD)
https://oauth2:ACCESS_TOKEN@github.com/organization/repo.git
```

#### Implement Commit Signing Verification
```bash
# Configure GPG key verification
git config --global commit.gpgsign true
git config --global gpg.program gpg

# In pipeline, verify commits
git verify-commit HEAD
# Or verify merge signatures
git verify-merges
```

#### Protect Against Repository Hijacking
```bash
# Enable push protection
git config --global receive.denyNonFastForwards true

# Use signed tags and verify them
git tag -s v1.0.0 -m "Release 1.0.0"
git verify-tag v1.0.0

# Implement repository integrity checks
git fsck --full --strict
```

### 4. CI/CD Specific Hardening

#### Isolate Git Operations
- Run Git operations in dedicated, minimal containers
- Use read-only filesystems where possible
- Limit network egress to only required Git hosting endpoints
- Implement filesystem Git safe directories

```bash
# Set safe directory for Git operations in pipeline
git config --global --add safe.directory /tmp/workspace
```

#### Audit and Monitor Git Access
- Enable audit logging for Git repository access
- Monitor for unusual access patterns or credential usage
- Set up alerts for failed authentication attempts
- Regularly review access logs and rotate credentials

#### Secure Webhook Configurations
```yaml
# GitHub webhook security
# 1. Use secret token for webhook validation
# 2. Validate payload signatures in receiver
# 3. Limit webhook permissions to required events
# 4. Use HTTPS for webhook delivery
```

#### Dependency Scanning for Git Sources
```bash
# Example: Scan submodules for vulnerabilities
git submodule foreach 'git pull && npm audit || true'

# Or use tools like:
# - Trivy for scanning Git repositories
# - GitHub Dependabot for automated security updates
```

## Verify

### 1. Credential Security
```bash
# Check that no credentials are stored in plain text
grep -r "password\|token\|key" /path/to/pipeline/configs --exclude-dir=.git

# Verify SSH agent forwarding is disabled
ssh -G | grep forwardagent

# Check Git credential helper
git config --global --get credential.helper
```

### 2. Repository Access
```bash
# Test deploy key access (should be read-only if configured as such)
ssh -T git@github.com  # Should show successful authentication but no shell access

# Verify repository permissions
# Attempt to push to a read-only deploy key (should fail)
git push origin main  # Should be rejected with proper permissions

# Check branch protection via API
curl -H "Authorization: token $TOKEN" \
  https://api.github.com/repos/OWNER/REPO/branches/main/protection
```

### 3. Pipeline Security
```bash
# Verify Git configuration in pipeline environment
git config --list --show-origin | grep -E "(ssl|credential|protocol)"

# Check for unsafe Git settings
git config --global --get-all url."https://insteadOf".git

# Validate that Git operations use intended authentication
GIT_TRACE=1 git ls-remote origin 2>&1 | grep -E "(Authorization|authenticate)"
```

### 4. Commit Verification
```bash
# Check if commits are signed
git log --show-signature -1

# Verify tag signatures
git tag -v v1.0.0

# Ensure push rules prevent force pushes to protected branches
git push --force-with-lease origin main  # Should be rejected if protected
```

## Rollback

### 1. Reverting Credential Changes
```bash
# Rotate compromised token
# 1. Generate new token with same scopes
# 2. Update CI/CD secrets
# 3. Delete old token from Git hosting service
# 4. Update pipeline configuration

# Remove unauthorized SSH key
# 1. Delete public key from Git hosting service
# 2. Remove from authorized_keys if used
# 3. Generate new key pair and update pipeline
```

### 2. Restoring Repository Access
```bash
# Re-enable fork access if accidentally disabled
# GitHub: Settings -> Repository -> Forking -> Allow forking

# Restore branch protection if modified incorrectly
# Reapply protection rules via UI or API

# Revert unsafe Git config changes
git config --global --unset http.sslVerify
git config --global --unset credential.helper
```

### 3. Pipeline Recovery
```bash
# Clear compromised Git credentials from runner
# GitHub Actions: Delete and recreate self-hosted runner
# GitLab CI: Clear build container cache and restart runner

# Audit pipeline execution history for unauthorized access
# Review job logs for suspicious Git operations
```

## Common Errors

### Error: "Authentication failed" despite valid credentials
**Cause:** Incorrect credential storage or expired token
**Solution:**
```bash
# For HTTPS tokens
git credential reject
# Then re-enter token properly stored

# Check token expiration and scopes
# Regenerate token with appropriate permissions
```

### Error: "Permission denied (publickey)" with SSH key
**Cause:** Key not loaded, wrong key, or missing from SSH agent
**Solution:**
```bash
# Verify key is loaded
ssh-add -l

# Add key to agent
ssh-add /path/to/private/key

# Test connection
ssh -T git@github.com

# Ensure public key is correctly added to Git hosting service
```

### Error: "remote: Invalid username or password" with token
**Cause:** Token missing required scopes or incorrectly formatted
**Solution:**
```bash
# Verify token has required scopes (repo, workflow, etc.)
# Ensure token is used as password, not username
# Format: https://oauth2:TOKEN@github.com/user/repo.git
```

### Error: "Repository not found" despite correct URL
**Cause:** Insufficient repository access or visibility restrictions
**Solution:**
```bash
# Verify repository exists and is accessible
curl -H "Authorization: token $TOKEN" \
  https://api.github.com/repos/OWNER/REPO

# Check repository visibility and access permissions
# Ensure token/repository owner match
```

### Error: "GPG error: No data" when verifying commit
**Cause:** Missing or incorrect GPG key configuration
**Solution:**
```bash
# Import GPG key into keyring
gpg --import < public_key.asc

# Trust the key
gpg --edit-key KEYID
# Then set trust to ultimate

# Configure Git to use correct GPG program
git config --global gpg.program gpg
```

## References
- [GitHub Security Best Practices](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure)
- [GitLab Security Documentation](https://docs.gitlab.com/ee/topics/security/)
- [Bitbucket Security Guidelines](https://support.atlassian.com/bitbucket-cloud/docs/git-secure-repositories/)
- [CIS Git Benchmark](https://www.cisecurity.org/controls/git)
- [NIST SP 800-113: Guide to SSL VPNs](https://csrc.nist.gov/publications/detail/sp/800-113/final)
- [OWASP CI/CD Security Project](https://owasp.org/www-project-cicd-security/)
- [Git SCM Book - Git on the Server](https://git-scm.com/book/en/v2/Git-on-the-Server-The-Protocols)
- [SLSA Framework for Supply Chain Security](https://slsa.dev/)