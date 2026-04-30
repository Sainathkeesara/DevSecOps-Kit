# Git: Credential Helper Setup for CI/CD Pipelines

## Purpose
This guide provides comprehensive instructions for configuring Git credential helpers to securely manage authentication in CI/CD pipelines. Credential helpers eliminate the need to hardcode credentials in scripts or configuration files, instead storing and retrieving credentials from secure stores like libsecret, macOS Keychain, Windows Credential Manager, or custom scripts.

## When to Use
- Running Git operations in CI/CD pipelines (Jenkins, GitHub Actions, GitLab CI)
- Automating deployments that require Git repository access
- Managing multiple Git identities across different repositories
- Avoiding credential exposure in logs or process lists
- Implementing token rotation without pipeline changes
- Securing credentials for containerized build environments
- Managing SSH key passphrases in automated workflows

## Prerequisites
- Git 2.0+ installed on all CI/CD runners
- Access to credential store (libsecret, Keychain, or credential manager)
- Personal Access Token (PAT) or deploy key with appropriate permissions
- CI/CD platform account (GitHub Actions, Jenkins, GitLab CI, etc.)
- Repository or organization-level access to manage secrets
- For libsecret: `libsecret-tools` or `secret-tool` package installed
- For macOS: Keychain Access available
- For Windows: Git Credential Manager Core installed

## Steps

### 1. Configure Git Credential Helper (Global)

#### Linux (libsecret)
```bash
# Install libsecret if not available
# Ubuntu/Debian
sudo apt-get install -y libsecret-1-0 libsecret-1-dev
cd /usr/share/doc/git/contrib/credential/libsecret
sudo make
git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret

# RHEL/CentOS/Fedora
sudo dnf install -y libsecret libsecret-devel
cd /usr/share/doc/git/contrib/credential/libsecret
sudo make
git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
```

#### macOS (Keychain)
```bash
# Configure credential helper
git config --global credential.helper osxkeychain

# Verify stored credentials
security find-internet-password -ga github.com 2>&1 | grep "acct\|svce"
```

#### Windows (Credential Manager)
```bash
# Git Credential Manager Core (installed with Git for Windows)
git config --global credential.helper manager-core

# Or legacy credential helper
git config --global credential.helper wincred
```

### 2. Store Credentials in Credential Helper

```bash
# Method 1: Clone with authentication (prompts for store)
git clone https://github.com/username/repository.git
# Enter username and PAT when prompted
# Git will ask: "Username for 'https://github.com':"
# Then: "Password for 'https://username@github.com':"

# Method 2: Manual credential storage
echo "url=https://github.com" | git credential fill
echo "url=https://github.com" | git credential approve \
  username=YOUR_USERNAME \
  password=YOUR_PAT

# Method 3: Using credential store directly
git credential-store --file ~/.git-credentials store <<EOF
protocol=https
host=github.com
username=YOUR_USERNAME
password=YOUR_PAT
EOF
```

### 3. GitHub Actions Configuration

```yaml
name: Deploy with Git Credentials
on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
        with:
          # Use GitHub token for checkout
          token: ${{ secrets.GH_DEPLOY_TOKEN }}

      - name: Configure Git credentials
        run: |
          git config --global user.name "github-actions"
          git config --global user.email "github-actions@github.com"
          
          # Store PAT in credential helper
          echo "https://${GH_DEPLOY_USER}:${GH_DEPLOY_TOKEN}@github.com" | \
            git credential approve
        env:
          GH_DEPLOY_USER: ${{ secrets.GH_DEPLOY_USER }}
          GH_DEPLOY_TOKEN: ${{ secrets.GH_DEPLOY_TOKEN }}

      - name: Push changes
        run: |
          git checkout -b deploy-branch
          echo "Deploy file" > deploy.txt
          git add deploy.txt
          git commit -m "Deploy changes"
          git push origin deploy-branch
```

### 4. Jenkins Pipeline Configuration

```groovy
pipeline {
    agent any
    environment {
        GIT_CREDENTIALS = credentials('git-pat-credentials')
    }
    stages {
        stage('Deploy') {
            steps {
                script {
                    // Configure Git
git config --global user.email "jenkins@company.com"
                    
                    // Store credentials in helper
                    sh '''
                        echo "https://${env.GIT_CREDENTIALS_USR}:${env.GIT_CREDENTIALS_PSW}@github.com" | \
                        git credential approve
                    '''
                    
                    // Or use withCredentials
                    withCredentials([usernamePassword(
                        credentialsId: 'git-pat-credentials',
                        usernameVariable: 'GIT_USER',
                        passwordVariable: 'GIT_PASS'
                    )]) {
                        sh '''
                            git remote set-url origin \
                                https://${GIT_USER}:${GIT_PASS}@github.com/org/repo.git
                            git push origin main
                        '''
                    }
                }
            }
        }
    }
}
```

### 5. GitLab CI Configuration

```yaml
deploy:
  stage: deploy
  variables:
    GIT_SSL_NO_VERIFY: "false"
  before_script:
    - git config --global user.email "gitlab-ci@example.com"
    - git config --global user.name "GitLab CI"
    - echo "https://gitlab-ci-token:${CI_JOB_TOKEN}@${CI_SERVER_HOST}/" | git credential approve
  script:
    - git push https://gitlab-ci-token:${CI_JOB_TOKEN}@${CI_SERVER_HOST}/group/project.git HEAD:main
```

### 6. Custom Credential Helper Script

Create a secure credential helper for custom stores (Vault, AWS Secrets Manager, etc.):

```bash
#!/usr/bin/env bash
# /usr/local/bin/git-credential-vault
# Custom credential helper for HashiCorp Vault

VAULT_ADDR="${VAULT_ADDR:-https://vault.example.com}"
VAULT_ROLE="${VAULT_ROLE:-git-credentials}"

get_credential() {
    local host="$1"
    vault kv get -field=password "secret/git/${host}" 2>/dev/null
}

store_credential() {
    local host="$1"
    local username="$2"
    local password="$3"
    # Implement secure storage
    echo "Storing credentials for $host not implemented (read-only)"
}

erase_credential() {
    local host="$1"
    # Implement credential removal
    echo "Erasing credentials for $host not implemented"
}

while IFS= read -r line; do
    if [[ -z "$line" ]]; then
        break
    fi
    key="${line%%=*}"
    value="${line#*=}"
    case "$key" in
        host) host="$value" ;;
        username) username="$value" ;;
        password) password="$value" ;;
    esac
done

case "$1" in
    get)
        if password=$(get_credential "$host"); then
            echo "username=${username:-deploy}"
            echo "password=$password"
        fi
        ;;
    store)
        store_credential "$host" "$username" "$password"
        ;;
    erase)
        erase_credential "$host"
        ;;
esac
```

Make executable and configure:
```bash
chmod +x /usr/local/bin/git-credential-vault
git config --global credential.helper vault
```

### 7. Multiple Repository Credentials

```bash
# Store credentials for multiple hosts
echo "https://github.com" | git credential-approve \
  username=github-user \
  password=github-pat

echo "https://gitlab.com" | git credential-approve \
  username=gitlab-user \
  password=gitlab-token

echo "https://bitbucket.org" | git credential-approve \
  username=bitbucket-user \
  password=bitbucket-app-password

# View stored credentials (Linux with libsecret)
secret-tool lookup server github.com
secret-tool lookup server gitlab.com
```

### 8. SSH Key with Passphrase Helper

```bash
# Configure SSH key passphrase storage
# Install keychain or ssh-agent management

# Using keychain
sudo apt-get install -y keychain
echo 'eval $(keychain --eval --agents ssh id_rsa)' >> ~/.bashrc

# Or configure SSH agent for CI
# In CI/CD pipeline:
ssh-agent bash -c '
    ssh-add /path/to/private/key
    git clone git@github.com:user/repo.git
'
```

## Verify

### 1. Test Credential Helper
```bash
# Check configured helper
git config --global --get credential.helper

# Test credential storage
echo "url=https://github.com" | git credential fill

# Should output stored credentials (or empty if none)
```

### 2. Verify CI/CD Pipeline
```yaml
- name: Test Git authentication
  run: |
    git ls-remote https://github.com/owner/private-repo.git
    # Should succeed without credential prompts
```

### 3. Check Stored Credentials
```bash
# Linux (libsecret)
secret-tool search --all server github.com

# macOS (Keychain)
security find-internet-password -ga github.com

# Windows
cmdkey /list | findstr github
```

## Rollback

### 1. Remove Stored Credentials
```bash
# Linux (libsecret)
secret-tool clear server github.com
secret-tool clear username YOUR_USERNAME

# macOS (Keychain)
security delete-internet-password -l github.com

# Windows
cmdkey /delete:github.com

# Or remove from git config
git config --global --unset credential.helper
git config --global --unset-all credential.helper
```

### 2. Revert to Manual Authentication
```bash
# Remove credential helper
git config --global --unset credential.helper

# Remove stored credentials file (if using store)
rm -f ~/.git-credentials

# Update CI/CD to use direct authentication
git remote set-url origin https://GIT_USER:GIT_PASS@github.com/owner/repo.git
```

### 3. Disable in CI/CD
```yaml
# Remove credential helper configuration from CI scripts
# Use direct URL with tokens instead:
- name: Push with token
  run: git push https://${GITHUB_TOKEN}@github.com/owner/repo.git
```

## Common Errors

### Error: "credential helper cannot be found"
**Cause:** Credential helper binary not installed or path incorrect.
```bash
# Solution: Install libsecret and compile helper
sudo apt-get install -y libsecret-1-0 libsecret-1-dev
cd /usr/share/doc/git/contrib/credential/libsecret
sudo make
```

### Error: "Permission denied" when storing credentials
**Cause:** File/directory permission issues or credential store locked.
```bash
# Solution: Fix permissions or unlock keychain
chmod 700 ~/.config/git/  # Linux
chmod 600 ~/.git-credentials

# macOS: Unlock keychain
security unlock-keychain ~/Library/Keychains/login.keychain
```

### Error: Authentication failed in CI/CD
**Cause:** Invalid token or insufficient permissions.
```bash
# Solution: Verify token permissions
# 1. Check token has correct scopes (repo, workflow, write:packages)
# 2. Ensure token not expired
# 3. Verify repository access for the token owner
# 4. Check CI/CD secret is correctly set
```

### Error: Credentials cached but not working
**Cause:** Credential store issue or network mismatch.
```bash
# Solution: Clear and re-store
printf "host=github.com\nprotocol=https\n" | git credential reject
printf "host=github.com\nprotocol=https\nusername=user\npassword=token\n" | git credential approve
```

### Error: libsecret: Cannot autolaunch D-Bus
**Cause:** No D-Bus session (common in CI/CD)
```bash
# Solution: Use custom credential helper or file-based store
git config --global credential.helper store

# Or start dbus (Linux CI)
eval $(dbus-launch --sh-syntax)
```

## References
- [Git Credential Storage Documentation](https://git-scm.com/docs/gitcredentials)
- [GitHub Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
- [Jenkins Credentials Binding Plugin](https://plugins.jenkins.io/credentials-binding/)
- [GitLab CI/CD Job Token](https://docs.gitlab.com/ee/ci/jobs/ci_job_token.html)
- [HashiCorp Vault Secrets Engine](https://www.vaultproject.io/docs/secrets/kv)
- [AWS Secrets Manager Git Integration](https://docs.aws.amazon.com/secretsmanager/latest/userguide/integrating_git.html)