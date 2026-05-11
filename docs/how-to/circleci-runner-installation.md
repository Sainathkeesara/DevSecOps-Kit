# CircleCI Self-Hosted Runner Installation and Configuration for CI/CD Pipelines

---

SQUIRREL:
  title: "CircleCI Self-Hosted Runner Installation and Configuration"
  category: "ci_cd"
  tags: ["circleci", "ci/cd", "runner", "self-hosted", "installation", "automation", "resource-class"]
  last_verified: "2026-05-11"
  version: "CircleCI Runner 3.0+"
---

## Purpose

This guide covers CircleCI self-hosted runner installation and configuration for executing CI/CD pipelines on your own infrastructure. CircleCI runners provide agent-based architecture supporting custom resource classes, labels, namespace management, and parallel job execution with isolation from CircleCI's cloud infrastructure.

## When to use

- Setting up self-hosted runners for CircleCI pipelines on private infrastructure
- Running builds in isolated environments with custom resource classes
- Scaling CI/CD capacity with multiple runner nodes
- Implementing parallel test execution across runner pools
- Managing runner assignments by labels and namespaces for workload segregation
- Migrating from CircleCI cloud executors to self-hosted runners

## Prerequisites

- Linux system (Ubuntu 18.04+, Debian 10+, RHEL 7+, CentOS 7+, Amazon Linux 2)
- Root or sudo privileges for installation
- CircleCI account with organization access
- Runner token from CircleCI UI (Settings → Organizations → Self-hosted runners)
- Network connectivity to circleci.com (TCP 443) and S3 for runner binary download
- 1GB+ disk space for binary and build workspace
- Docker installed if using Docker-based build environments (optional)

## Installation

### Quick Start Installation

```bash
# Basic installation with CircleCI runner token
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/ci_cd_toolkit/circleci/circleci-runner-install.sh | bash -s -- --token YOUR_RUNNER_TOKEN --resource-class namespace/linux

# Verify runner registration
sudo /opt/circleci/circleci-runner version
sudo systemctl status circleci-runner

# Check runner in CircleCI UI: Settings → Organizations → Self-hosted runners
```

### Automated Installation with Resource Class and Labels

```bash
# Install with custom resource class and labels
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/ci_cd_toolkit/circleci/circleci-runner-install.sh | bash -s -- \
  --token YOUR_TOKEN \
  --resource-class my-namespace/linux \
  --labels "linux,amd64,highmem" \
  --max-runs 2
```

### Dry-Run Preview

```bash
# Preview installation steps without executing
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/ci_cd_toolkit/circleci/circleci-runner-install.sh | bash -s -- \
  --dry-run \
  --token YOUR_TOKEN \
  --resource-class my-namespace/linux
```

### Using DevOps-Kit Local Script

```bash
# Clone DevOps-Kit repository
git clone https://github.com/opencode-ai/DevOps-Kit.git
cd DevOps-Kit

# Run installer from local copy
./scripts/bash/ci_cd_toolkit/circleci/circleci-runner-install.sh \
  --token YOUR_RUNNER_TOKEN \
  --resource-class my-namespace/linux \
  --labels "linux,x64"
```

### Manual Installation

#### Step 1: Generate Runner Token

```bash
# In CircleCI UI:
# 1. Navigate to Settings → Organizations
# 2. Select your organization
# 3. Go to Self-hosted runners
# 4. Click "Add Runner"
# 5. Copy the generated token for your namespace
```

#### Step 2: Download CircleCI Runner

```bash
# Download latest runner binary
VERSION="3.0.1"
ARCH=$(uname -m)
curl -sL "https://circleci-public.s3.amazonaws.com/runner/circleci-runner_${VERSION}_${ARCH}.tar.gz" -o /tmp/circleci-runner.tar.gz

# Extract
mkdir -p /opt/circleci
tar -xzf /tmp/circleci-runner.tar.gz -C /tmp
mv /tmp/circleci-runner /opt/circleci/circleci-runner
chmod +x /opt/circleci/circleci-runner
rm /tmp/circleci-runner.tar.gz

# Verify
/opt/circleci/circleci-runner version
```

#### Step 3: Create System User

```bash
# Create dedicated system user
sudo useradd --system --no-create-home --home-dir /nonexistent --shell /usr/sbin/nologin circleci
```

#### Step 4: Create Configuration

```bash
# Create config directory
sudo mkdir -p /etc/circleci
sudo chown circleci:circleci /etc/circleci

# Create runner configuration
sudo tee /etc/circleci/runner-config.json > /dev/null <<'EOF'
{
  "api": {
    "auth_token": "YOUR_RUNNER_TOKEN"
  },
  "runner": {
    "name": "my-runner-01",
    "resource_class": "namespace/linux",
    "max_runups": 1,
    "working_directory": "/var/lib/circleci-runner",
    "labels": ["linux", "amd64"]
  }
}
EOF

sudo chown circleci:circleci /etc/circleci/runner-config.json
sudo chmod 600 /etc/circleci/runner-config.json
```

#### Step 5: Create Working Directory

```bash
# Create and set permissions
sudo mkdir -p /var/lib/circleci-runner
sudo chown circleci:circleci /var/lib/circleci-runner
```

#### Step 6: Create Systemd Service

```bash
# Create systemd service
sudo tee /etc/systemd/system/circleci-runner.service > /dev/null <<'EOF'
[Unit]
Description=CircleCI Runner
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=circleci
Group=circleci
ExecStart=/opt/circleci/circleci-runner start --config /etc/circleci/runner-config.json
Restart=always
RestartSec=10
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

# Reload and start
sudo systemctl daemon-reload
sudo systemctl enable circleci-runner
sudo systemctl start circleci-runner
```

#### Step 7: Verify Runner Registration

```bash
# Check service status
sudo systemctl status circleci-runner

# View runner logs
sudo journalctl -u circleci-runner -f

# Verify runner version
/opt/circleci/circleci-runner version

# Verify in CircleCI UI → Settings → Organizations → Self-hosted runners
# Runner should appear within 30-60 seconds
```

## Configuration

### Resource Class

Resource classes define the runner's capabilities and are used in pipeline configuration:

```bash
# Install with resource class
circleci-runner-install.sh --token TOKEN --resource-class "my-namespace/linux-xl"

# Format: namespace/name or namespace/resource-class
# The namespace must match your CircleCI organization
```

In your `.circleci/config.yml`:

```yaml
jobs:
  build:
    machine:
      resource_class: my-namespace/linux-xl
    steps:
      - checkout
      - run: make build
```

### Runner Name

Names uniquely identify each runner:

```bash
# Set custom name
circleci-runner-install.sh --token TOKEN --name "runner-prod-01"

# Default: hostname-timestamp
```

### Labels

Labels enable flexible runner selection in pipelines:

```bash
# Install with labels
circleci-runner-install.sh --token TOKEN --resource-class my-namespace/linux \
  --labels "linux,amd64,docker,highmem"

# Multiple labels as comma-separated list
```

Pipeline usage:

```yaml
jobs:
  test:
    machine:
      image: ubuntu-2004:current
    steps:
      - checkout
      - run: make test

  deploy:
    machine:
      image: ubuntu-2004:current
    resource_class: my-namespace/linux
    steps:
      - checkout
      - run: make deploy
```

Targeted runner selection with labels:

```yaml
executors:
  linux:
    machine:
      image: ubuntu-2004:current

jobs:
  docker-build:
    executor: linux
    steps:
      - setup_remote_docker:
          docker_layer_caching: true
      - run: docker build -t myapp .

workflows:
  build-and-deploy:
    jobs:
      - docker-build:
          labels:
            - docker
            - linux
```

### Max Concurrent Runs

Configure parallel job execution:

```bash
# Install with 2 concurrent runs
circleci-runner-install.sh --token TOKEN --resource-class my-namespace/linux --max-runs 2

# Adjust in config
sudo tee /etc/circleci/runner-config.json > /dev/null <<'EOF'
{
  "runner": {
    "max_runups": 4
  }
}
EOF
sudo systemctl restart circleci-runner
```

**Note**: Set `max_runups` based on available CPU cores and memory. Each concurrent job requires separate resource allocation.

### Working Directory

Custom workspace location:

```bash
# Custom work directory
circleci-runner-install.sh --token TOKEN --work-dir /data/circleci-runner
```

## Runner Pools and Namespace Strategy

### Organizing Runners by Environment

```bash
# Production runners
circleci-runner-install.sh \
  --token TOKEN \
  --resource-class prod/linux \
  --labels "prod,linux,highmem" \
  --max-runs 2

# Staging runners
circleci-runner-install.sh \
  --token TOKEN \
  --resource-class staging/linux \
  --labels "staging,linux" \
  --max-runs 1

# CI runners
circleci-runner-install.sh \
  --token TOKEN \
  --resource-class ci/linux-fast \
  --labels "ci,linux,fast" \
  --max-runs 4
```

Pipeline configuration:

```yaml
workflows:
  test-and-deploy:
    jobs:
      - test:
          resource_class: ci/linux-fast

      - deploy-staging:
          resource_class: staging/linux
          requires: [test]

      - deploy-prod:
          resource_class: prod/linux
          requires: [deploy-staging]
```

### Docker-Based Builds

Install Docker and configure for container builds:

```bash
# Install Docker first
curl -fsSL https://get.docker.com | bash

# Add circleci user to docker group
sudo usermod -aG docker circleci

# Install runner with Docker labels
circleci-runner-install.sh \
  --token TOKEN \
  --resource-class my-namespace/docker \
  --labels "linux,docker,20.10" \
  --max-runs 2
```

Pipeline with Docker:

```yaml
jobs:
  build:
    machine:
      image: ubuntu-2004:202104-01
    resource_class: my-namespace/docker
    steps:
      - checkout
      - setup_remote_docker:
          docker_layer_caching: true
      - run: docker build -t myapp:$CIRCLE_BUILD_NUM .
```

## Verification

### Check Runner Status

```bash
# Verify service is running
sudo systemctl status circleci-runner

# Check runner version
/opt/circleci/circleci-runner version

# View runner logs
sudo journalctl -u circleci-runner -f

# Test runner connectivity
curl -s https://circleci.com/api/v2/runner/namespaces 2>/dev/null | head -20
```

### Validate Job Execution

```bash
# Trigger a test job from CircleCI UI
# 1. Navigate to your project
# 2. Click "Trigger Pipeline"
# 3. Select branch and trigger

# Monitor runner logs during job execution
sudo journalctl -u circleci-runner -f | grep -E "(job|execution|run)"

# Check working directory for job artifacts
ls -la /var/lib/circleci-runner/
```

### Monitor Runner Health

```bash
# Check system resource usage
ps aux | grep circleci-runner
top -p $(pgrep -f circleci-runner)

# Check disk space for builds
df -h /var/lib/circleci-runner

# View service status
sudo systemctl status circleci-runner
journalctl -u circleci-runner --no-pager -n 50
```

### Verify in CircleCI Dashboard

1. Navigate to **Settings → Organizations → Self-hosted runners** in CircleCI UI
2. Runner should appear with status "online"
3. Check resource class and labels are correct
4. Trigger a test pipeline and confirm runner picks up the job
5. Monitor job execution in pipeline view

## Rollback

### Uninstall Runner

```bash
# Run uninstall script
sudo systemctl stop circleci-runner
sudo systemctl disable circleci-runner
sudo rm /etc/systemd/system/circleci-runner.service
sudo systemctl daemon-reload
sudo rm -rf /etc/circleci
sudo rm -rf /opt/circleci
sudo rm -rf /var/lib/circleci-runner
sudo userdel circleci

# Alternative: Use script uninstall mode
./scripts/bash/ci_cd_toolkit/circleci/circleci-runner-install.sh --uninstall
```

### Downgrade Runner Version

```bash
# Stop service
sudo systemctl stop circleci-runner

# Download specific older version
VERSION="2.2.0"
curl -sL "https://circleci-public.s3.amazonaws.com/runner/circleci-runner_${VERSION}_$(uname -m).tar.gz" | sudo tar -xz -C /opt/circleci

# Ensure permissions
sudo chmod +x /opt/circleci/circleci-runner

# Restart
sudo systemctl start circleci-runner

# Verify version
/opt/circleci/circleci-runner version
```

### Disable Runner Without Removing

```bash
# Stop service (runner appears offline in UI)
sudo systemctl stop circleci-runner

# Disable permanently
sudo systemctl disable circleci-runner

# Re-enable later
sudo systemctl enable circleci-runner
sudo systemctl start circleci-runner
```

### Remove from CircleCI UI

1. Navigate to **Settings → Organizations → Self-hosted runners**
2. Find runner in list
3. Click "Remove" to de-register
4. Runner will be removed from available pool immediately

## Common Errors

**Runner shows "offline" in UI**
- Check network connectivity: `curl -v https://circleci.com`
- Verify token is correct: `cat /etc/circleci/runner-config.json | jq .api.auth_token`
- Review service logs: `sudo journalctl -u circleci-runner -n 50`
- Ensure firewall allows outbound HTTPS (port 443)

**Runner token rejected**
- Regenerate token in CircleCI UI: Settings → Organizations → Self-hosted runners → Add Runner
- Update token in config: `sudo nano /etc/circleci/runner-config.json`
- Restart service: `sudo systemctl restart circleci-runner`

**"max_runups exceeds CPU count" warning**
- Reduce `max_runups` in configuration to match CPU cores
- Or increase `LimitNOFILE` in systemd service for file descriptor limits

**Jobs not reaching runner**
- Check pipeline `resource_class` matches runner configuration
- Verify labels include required pipeline labels
- Check resource class namespace matches your CircleCI organization

**Permission denied errors**
- Check circleci user permissions: `id circleci`
- For Docker builds: `sudo usermod -aG docker circleci`
- For workspace access: ensure `/var/lib/circleci-runner` owned by circleci user

**High memory usage**
- Reduce `max_runups` to limit concurrent jobs
- Increase system swap space: `sudo swapon --show`
- Monitor with `htop` or `ps aux --sort=-%mem | grep circleci`

**Service fails to start**
- Validate JSON config: `jq . /etc/circleci/runner-config.json`
- Check token file format: no extra quotes or whitespace
- Test binary manually: `sudo -u circleci /opt/circleci/circleci-runner start --config /etc/circleci/runner-config.json`

**Runner keeps disconnecting**
- Check system clock synchronization: `timedatectl status`
- Ensure NTP is running: `sudo timedatectl set-ntp true`
- Review network stability; unstable connections cause frequent reconnects

**Job stuck in "Queued" state**
- Check if runner is online in CircleCI UI
- Verify resource class matches job configuration
- Check CircleCI API rate limits

## Troubleshooting

### Runner Not Appearing in UI

```bash
# 1. Check service is running
sudo systemctl status circleci-runner

# 2. Verify config
cat /etc/circleci/runner-config.json | jq .

# 3. Test API connectivity
curl -s https://circleci.com/api/v2/runner/namespaces -H "Circle-Token: $TOKEN"

# 4. Check logs
sudo journalctl -u circleci-runner --since "5 minutes ago"

# 5. Validate config JSON
jq . /etc/circleci/runner-config.json

# 6. Restart with debug logging
sudo systemctl restart circleci-runner
sudo journalctl -u circleci-runner -f
```

### Jobs Fail with "No runners available"

```bash
# 1. Verify resource class matches runner config
grep resource_class /etc/circleci/runner-config.json

# 2. Check CircleCI pipeline config
# In .circleci/config.yml, ensure resource_class matches

# 3. Verify namespace is correct
# Namespace must match your CircleCI organization

# 4. Check labels match
cat /etc/circleci/runner-config.json | jq .runner.labels

# 5. Check CircleCI UI for runner status
# Settings → Organizations → Self-hosted runners
```

### High Job Queue Times

```bash
# Increase concurrent jobs
sudo tee /etc/circleci/runner-config.json > /dev/null <<'EOF'
{
  "runner": {
    "max_runups": 4
  }
}
EOF
sudo systemctl restart circleci-runner

# Check resource utilization
htop
df -h

# Consider adding more runners instead of increasing max_runups
```

### Clean Runner Workspace

```bash
# Clean runner working directory
sudo systemctl stop circleci-runner
sudo rm -rf /var/lib/circleci-runner/*
sudo systemctl start circleci-runner

# Check disk space
df -h /var/lib/circleci-runner
```

### Reset Runner Configuration

```bash
# Stop runner
sudo systemctl stop circleci-runner

# Backup and recreate config
sudo cp /etc/circleci/runner-config.json /etc/circleci/runner-config.json.bak

# Re-run installation with desired parameters
# OR manually create fresh config

sudo systemctl start circleci-runner
```

## Security Considerations

- Store runner token securely; it provides access to your CircleCI organization
- Set `auth_token` file permissions to `600`
- Limit `max_runups` to prevent resource exhaustion
- Use separate runners for untrusted repositories (different resource classes)
- Enable audit logging via CircleCI organization settings
- Rotate runner tokens periodically from CircleCI UI
- Restrict runner user capabilities; avoid running as root
- Monitor runner metrics for unusual job patterns
- Use Docker-based builds to isolate job execution
- Implement network segmentation for runner nodes

## References

- [CircleCI Self-Hosted Runners](https://circleci.com/docs/runner-overview/)
- [CircleCI Runner Configuration](https://circleci.com/docs/runner-config-reference/)
- [CircleCI Resource Classes](https://circleci.com/docs/resource-class-overview/)
- [CircleCI Installation Guide](https://circleci.com/docs/runner-installation/)
- [CircleCI API](https://circleci.com/docs/api/v2/)
- DevOps-Kit CI/CD Toolkit: `docs/how-to/ci_cd_toolkit.md`