# Git: GitHub Actions Runner Installation and Configuration Guide

## Purpose
This guide provides comprehensive instructions for installing, configuring, and managing GitHub Actions self-hosted runners across various environments including Linux, Windows, and Docker containers. Self-hosted runners allow you to run workflows on your own infrastructure with custom hardware, networking, and software configurations.

## When to Use
- Need specific hardware configurations not available in GitHub-hosted runners
- Require custom software installations or specific operating system versions
- Need to run workloads in private networks or behind corporate firewalls
- Require GPU, ARM, or other specialized hardware support
- Need to optimize costs for high-volume CI/CD workloads
- Require longer execution times than GitHub-hosted limits
- Need to comply with data residency or security requirements

## Prerequisites
- GitHub account with repository or organization-level runner permissions
- Target machine with supported OS (Linux, Windows, macOS)
- Administrative/sudo access on target machine
- Docker installed (for container-based runners)
- Network connectivity to GitHub services
- At least 1GB RAM (2GB+ recommended)
- 1 CPU core minimum (2+ recommended)
- 20GB free disk space minimum

## Steps

### 1. Repository-Level Runner Setup

#### Download the Runner Package
```bash
# Create runner directory
mkdir -p /opt/github-runner && cd /opt/github-runner

# Download runner (Linux x64)
curl -o actions-runner-linux-x64-2.317.0.tar.gz -L \
  https://github.com/actions/runner/releases/download/v2.317.0/actions-runner-linux-x64-2.317.0.tar.gz

# Extract

tar xzf ./actions-runner-linux-x64-2.317.0.tar.gz
```

#### Configure the Runner
```bash
# Run configuration (interactive)
./config.sh --url https://github.com/OWNER/REPO \
  --token YOUR_CONFIG_TOKEN \
  --name "my-runner-01" \
  --labels "linux,x64,production" \
  --unattended \
  --replace

# Get config token from repository settings:
# Settings -> Actions -> Runners -> New repository runner
```

#### Install and Start the Runner
```bash
# Install as systemd service
./svc.sh install
./svc.sh start

# Check service status
./svc.sh status

# View logs
journalctl -u actions.runner.OWNER-REPO.my-runner-01.service -n 50 -f
```

### 2. Docker-Based Runner Setup

```bash
# Create runner directory
mkdir -p /opt/docker-runner && cd /opt/docker-runner

# Create docker-compose.yml
cat > docker-compose.yml <<'EOF'
version: '3.8'
services:
  github-runner:
    image: ghcr.io/actions/runner:latest
    container_name: github-runner
    environment:
      - CONFIG_URL=https://github.com/OWNER/REPO
      - RUNNER_TOKEN=${RUNNER_TOKEN}
      - RUNNER_NAME=docker-runner-01
      - RUNNER_LABELS=docker,linux
      - RUNNER_WORKDIR=/home/runner/work
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - runner-data:/home/runner
    restart: always
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 4G

volumes:
  runner-data:
EOF

# Run the container
docker compose up -d
```

### 3. Organization-Level Runner Setup

```bash
# Download and configure for organization
./config.sh --url https://github.com/ORG-NAME \
  --token ORG_CONFIG_TOKEN \
  --name "org-runner-01" \
  --labels "linux,x64,org-shared" \
  --unattended

# Install as service
./svc.sh install
./svc.sh start
```

### 4. Ephemeral Runner with Auto-Removal

```bash
# Configure as ephemeral runner (removes after job)
./config.sh --url https://github.com/OWNER/REPO \
  --token YOUR_TOKEN \
  --name "ephemeral-runner" \
  --labels "linux,ephemeral" \
  --ephemeral \
  --unattended

# Run once and exit (useful for container-based runners)
./run.sh
```

### 5. Runner Labels and Capabilities

```bash
# Add custom labels during configuration
./config.sh --url https://github.com/OWNER/REPO \
  --token YOUR_TOKEN \
  --name "gpu-runner" \
  --labels "linux,gpu,nvidia,cuda" \
  --unattended

# In workflow, use labels:
# runs-on: [self-hosted, linux, gpu]
```

## Verify

### 1. Check Runner Status
```bash
# Systemd service
systemctl status actions.runner.OWNER-REPO.runner-name.service

# Runner CLI
cd /opt/github-runner
./run.sh  # Should connect to GitHub
```

### 2. Verify in GitHub UI
1. Navigate to: Repository Settings → Actions → Runners
2. Confirm runner appears in the list
3. Status should show "Online"
4. Check last active timestamp

### 3. Test Runner with Workflow
```yaml
name: Test Self-Hosted Runner
on: [workflow_dispatch]

jobs:
  test-runner:
    runs-on: [self-hosted, linux]
    steps:
      - uses: actions/checkout@v4
      - name: Verify runner environment
        run: |
          echo "Runner name: ${{ runner.name }}"
          echo "Runner OS: ${{ runner.os }}"
          echo "Runner architecture: ${{ runner.arch }}"
          uname -a
          hostname
```

## Rollback

### 1. Stop and Remove Runner
```bash
cd /opt/github-runner

# Stop service
./svc.sh stop
./svc.sh uninstall

# Remove from GitHub
./config.sh remove --token YOUR_REMOVE_TOKEN

# Clean up files
cd /
rm -rf /opt/github-runner

# Remove systemd service
rm -f /etc/systemd/system/actions.runner.OWNER-REPO.*.service
systemctl daemon-reload
```

### 2. Docker Runner Removal
```bash
cd /opt/docker-runner
docker compose down -v
rm -rf /opt/docker-runner
```

### 3. Remove Runner from GitHub UI
1. Go to Settings → Actions → Runners
2. Click the runner to delete
3. Click "Remove" button
4. Confirm deletion

## Common Errors

### Error: "Runner connection is broken"
**Solution:**
- Check network connectivity to GitHub
- Verify authentication token is valid
- Check firewall rules for outbound connections
- Ensure runner version is up to date

### Error: "Permission denied" during svc.sh install
**Solution:**
```bash
sudo chown -R $(whoami):$(whoami) /opt/github-runner
chmod +x ./svc.sh
```

### Error: "A runner already exists with the same name"
**Solution:**
```bash
./config.sh --replace  # Allow replacement
# Or use a unique runner name
```

### Error: "No runner found in the repository"
**Solution:**
- Verify runner is registered in correct repository
- Check GitHub permissions and runner scope
- Confirm workflow specifies correct labels

### Error: Ephemeral runners not removing after job
**Solution:**
- Ensure `--ephemeral` flag is set during config
- Check runner logs for errors
- Verify runner token has correct permissions

## References
- [GitHub Actions Self-Hosted Runners Documentation](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners)
- [Runner Software Releases](https://github.com/actions/runner/releases)
- [Runner Security Hardening](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions#hardening-for-self-hosted-runners)
- [Autoscaling Self-Hosted Runners](https://docs.github.com/en/actions/hosting-your-own-runners/autoscaling-with-self-hosted-runners)