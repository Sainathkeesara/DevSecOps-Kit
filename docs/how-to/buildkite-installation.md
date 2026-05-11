# Buildkite Installation and Agent Configuration for CI/CD Pipelines

---

SQUIRREL:
  title: "Buildkite Installation and Agent Configuration"
  category: "ci_cd"
  tags: ["buildkite", "ci/cd", "agent", "pipeline", "installation", "automation"]
  last_verified: "2026-05-11"
  version: "Buildkite Agent 3.58+"
---

## Purpose

This guide covers Buildkite agent installation and configuration for distributed CI/CD pipeline execution. Buildkite is a Kubernetes-backed CI/CD platform that runs builds on your own infrastructure with agent-based architecture supporting parallel job execution, custom tags, and queue management.

## When to use

- Setting up self-hosted CI/CD agents for Buildkite pipelines
- Scaling CI/CD capacity with multiple agent nodes
- Running builds in isolated containers with custom environments
- Implementing parallel test execution across multiple agents
- Managing agent pools by tags and queues for workload segregation
- Migrating from other CI/CD platforms to Buildkite

## Prerequisites

- Linux system (Ubuntu 18.04+, Debian 10+, RHEL 7+, CentOS 7+)
- Root or sudo privileges for installation
- Buildkite account with organization access
- Agent token from Buildkite UI (Agents → + Add new agent)
- Network connectivity to agent.buildkite.com (TCP 443)
- 1GB+ disk space for binary and build workspace
- Docker installed if using Docker-based build environments (optional)
- For Kubernetes: kubectl configured with cluster access (optional)

## Installation

### Quick Start Installation

```bash
# Basic installation with Buildkite agent token
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/ci_cd_toolkit/buildkite/buildkite-install.sh | bash -s -- --token YOUR_AGENT_TOKEN

# Verify agent registration
sudo buildkite-agent --version
sudo systemctl status buildkite-agent

# Check agent in Buildkite UI: Settings → Agents
```

### Automated Installation with Tags and Queue

```bash
# Install with custom tags and queue
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/ci_cd_toolkit/buildkite/buildkite-install.sh | bash -s -- \
  --token YOUR_TOKEN \
  --tags "linux,amd64,highmem,docker" \
  --queue high-priority \
  --max-runs 2
```

### Dry-Run Preview

```bash
# Preview installation steps without executing
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/ci_cd_toolkit/buildkite/buildkite-install.sh | bash -s -- \
  --dry-run \
  --token YOUR_TOKEN \
  --tags "linux"
```

### Using DevOps-Kit Local Script

```bash
# Clone DevOps-Kit repository
git clone https://github.com/opencode-ai/DevOps-Kit.git
cd DevOps-Kit

# Run installer from local copy
./scripts/bash/ci_cd_toolkit/buildkite/buildkite-install.sh \
  --token YOUR_AGENT_TOKEN \
  --tags "linux,x64" \
  --queue default
```

### Manual Installation

#### Step 1: Download Buildkite Agent

```bash
# Download latest stable version
VERSION="3.58.0"
curl -L "https://github.com/buildkite/agent/releases/download/v${VERSION}/buildkite-agent-linux-amd64.tar.gz" -o /tmp/buildkite-agent.tar.gz

# Extract and install
sudo tar -xzf /tmp/buildkite-agent.tar.gz -C /tmp
sudo cp /tmp/buildkite-agent /usr/local/bin/
sudo chmod +x /usr/local/bin/buildkite-agent
rm /tmp/buildkite-agent.tar.gz /tmp/buildkite-agent

# Verify installation
buildkite-agent --version
```

#### Step 2: Create System User

```bash
# Create dedicated system user for Buildkite agent
sudo useradd --system --no-create-home --home-dir /nonexistent --shell /usr/sbin/nologin buildkite-agent
```

#### Step 3: Create Configuration

```bash
# Create configuration directory
sudo mkdir -p /etc/buildkite-agent
sudo chown buildkite-agent:buildkite-agent /etc/buildkite-agent

# Create agent configuration
sudo tee /etc/buildkite-agent/agent.cfg > /dev/null <<'EOF'
--- # Buildkite Agent Configuration
tags: ["linux", "amd64"]
name: "$(hostname)"
queue: "default"
max-run-builds: 1
metrics: true
log-level: "info"
disconnect-after-job: false
spawn-method: "process"
hooks-path: "/etc/buildkite-agent/hooks"
agent-directory: "/var/lib/buildkite-agent"
temporary-directory: "/tmp/buildkite"
EOF

# Set ownership
sudo chown buildkite-agent:buildkite-agent /etc/buildkite-agent/agent.cfg
```

#### Step 4: Store Agent Token

```bash
# Create token file
echo "YOUR_AGENT_TOKEN" | sudo tee /etc/buildkite-agent/token
sudo chmod 600 /etc/buildkite-agent/token
sudo chown buildkite-agent:buildkite-agent /etc/buildkite-agent/token
```

#### Step 5: Create Systemd Service

```bash
# Create systemd service file
sudo tee /etc/systemd/system/buildkite-agent.service > /dev/null <<'EOF'
[Unit]
Description=Buildkite Agent
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=buildkite-agent
Group=buildkite-agent
Environment="BUILDKITE_AGENT_TOKEN=file:/etc/buildkite-agent/token"
ExecStart=/usr/local/bin/buildkite-agent start --config /etc/buildkite-agent/agent.cfg
ExecStop=/usr/local/bin/buildkite-agent stop
Restart=always
RestartSec=10
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start service
sudo systemctl daemon-reload
sudo systemctl enable buildkite-agent
sudo systemctl start buildkite-agent
```

#### Step 6: Verify Agent Registration

```bash
# Check service status
sudo systemctl status buildkite-agent

# View agent logs
sudo journalctl -u buildkite-agent -f

# Check agent version
buildkite-agent --version

# Verify agent appears in Buildkite UI → Settings → Agents
# Agent should show as "online" within 30-60 seconds
```

## Configuration

### Agent Tags

Tags allow Buildkite to route builds to appropriate agents:

```bash
# Install with tags
buildkite-install.sh --token TOKEN --tags "linux,amd64,docker,highmem"

# Edit configuration file directly
sudo tee /etc/buildkite-agent/agent.cfg > /dev/null <<'EOF'
tags: ["linux", "amd64", "docker", "gpu"]
EOF

sudo systemctl restart buildkite-agent
```

In your pipeline:

```yaml
steps:
  - label: ":docker: Build"
    agents:
      queue: "docker-builds"
      tags: ["docker", "linux"]
    command: "docker build -t myapp ."
```

### Queue Configuration

Queues provide workload segregation:

```bash
# Install agent for specific queue
buildkite-install.sh --token TOKEN --queue "high-priority"

# Change queue after installation
sudo sed -i 's/^queue:.*/queue: "high-priority"/' /etc/buildkite-agent/agent.cfg
sudo systemctl restart buildkite-agent
```

Pipeline selection:

```yaml
steps:
  - label: "Deploy"
    agents:
      queue: "deployments"
    command: "./deploy.sh"
```

### Concurrent Builds

Configure multiple parallel builds per agent:

```bash
# Install with 2 concurrent runs
buildkite-install.sh --token TOKEN --max-runs 2

# Or modify configuration
sudo tee /etc/buildkite-agent/agent.cfg > /dev/null <<'EOF'
max-run-builds: 4
EOF

sudo systemctl restart buildkite-agent
```

**Note**: Set `max-run-builds` based on available CPU cores and memory. For Docker-based builds, ensure adequate container capacity.

### Hooks Directory

Custom hooks execute scripts at build lifecycle events:

```bash
# Create hooks directory (created automatically)
sudo mkdir -p /etc/buildkite-agent/hooks

# Example: pre-build hook
sudo tee /etc/buildkite-agent/hooks/pre-checkout > /dev/null <<'HOOK'
#!/bin/bash
# Verify workspace is clean
if [ -n "$(git status --porcelain)" ]; then
  echo "Workspace has uncommitted changes"
  exit 1
fi
HOOK
sudo chmod +x /etc/buildkite-agent/hooks/pre-checkout
```

Available hooks:
- `pre-checkout` — before repository checkout
- `post-checkout` — after repository checkout
- `pre-command` — before each command step
- `post-command` — after each command step
- `pre-artifact` — before artifact upload
- `post-artifact` — after artifact upload

### Environment Variables

Set agent-wide environment variables:

```bash
# Edit systemd service to add environment variables
sudo tee /etc/systemd/system/buildkite-agent.service > /dev/null <<'EOF'
[Service]
...
Environment="DOCKER_HOST=unix:///var/run/docker.sock"
Environment="AWS_DEFAULT_REGION=us-west-2"
Environment="NODE_OPTIONS=--max-old-space-size=4096"
EOF

sudo systemctl daemon-reload
sudo systemctl restart buildkite-agent
```

## Agent Pools and Tagging Strategy

### Organizing Agents by Environment

```bash
# Production agents
buildkite-install.sh --token TOKEN --tags "prod,linux,highmem" --queue production

# Staging agents
buildkite-install.sh --token TOKEN --tags "staging,linux" --queue staging

# CI-only agents
buildkite-install.sh --token TOKEN --tags "ci,linux,fast" --queue ci
```

Pipeline configuration:

```yaml
steps:
  - label: "Integration Tests"
    agents:
      queue: "ci"
      tags: ["linux"]
    command: "make test-integration"

  - label: "Production Deploy"
    wait: ~
    agents:
      queue: "production"
    command: "./deploy-prod.sh"
```

### Docker-Based Builds

Install Docker and configure agent for container builds:

```bash
# Install Docker first
curl -fsSL https://get.docker.com | bash

# Add buildkite user to docker group
sudo usermod -aG docker buildkite-agent

# Install Buildkite agent with Docker tag
buildkite-install.sh \
  --token TOKEN \
  --tags "linux,docker,20.10" \
  --max-runs 2
```

Pipeline using Docker:

```yaml
steps:
  - label: ":docker: Build image"
    command: "docker build -t myapp:$BUILDKITE_BUILD_NUMBER ."
    artifact_paths: "image.tar"
  
  - label: ":test: Run tests"
    command: "docker run myapp:$BUILDKITE_BUILD_NUMBER npm test"
```

## Verification

### Check Agent Status

```bash
# Verify service is running
sudo systemctl status buildkite-agent

# Check agent version
buildkite-agent --version

# View agent summary
sudo buildkite-agent status

# Test agent connectivity to Buildkite API
sudo buildkite-agent meta-data get "test-key" || echo "Metadata fetch test: OK"
```

### Validate Build Execution

```bash
# Trigger a test build from Buildkite UI
# 1. Navigate to your pipeline
# 2. Click "New Build"
# 3. Select branch and trigger

# Monitor agent logs during build
sudo journalctl -u buildkite-agent -f

# Check build queue
sudo buildkite-agent queue

# List running jobs
sudo buildkite-agent running-jobs
```

### Monitor Agent Health

```bash
# Check buildkite-agent metrics endpoint
curl -s http://localhost:3000/metrics 2>/dev/null | grep buildkite

# View system resource usage
ps aux | grep buildkite-agent
sudo systemctl status buildkite-agent

# Check disk space for builds
df -h /var/lib/buildkite-agent
```

### Verify in Buildkite Dashboard

1. Navigate to **Settings → Agents** in Buildkite UI
2. Agent should appear with status "online"
3. Check agent tags and queue are correct
4. Trigger a test build and confirm agent picks it up
5. Monitor build progress in pipeline view

## Rollback

### Uninstall Agent

```bash
# Run uninstall script
/usr/local/bin/buildkite-agent stop
sudo systemctl disable buildkite-agent
sudo rm /etc/systemd/system/buildkite-agent.service
sudo systemctl daemon-reload
sudo rm -rf /etc/buildkite-agent
sudo rm /usr/local/bin/buildkite-agent
sudo userdel buildkite-agent

# Alternative: Use script uninstall mode
./scripts/bash/ci_cd_toolkit/buildkite/buildkite-install.sh --uninstall
```

### Downgrade Agent Version

```bash
# Stop service
sudo systemctl stop buildkite-agent

# Install specific older version manually
VERSION="3.57.0"
curl -L "https://github.com/buildkite/agent/releases/download/v${VERSION}/buildkite-agent-linux-amd64.tar.gz" | sudo tar -xz -C /usr/local/bin

# Ensure permissions
sudo chmod +x /usr/local/bin/buildkite-agent

# Restart
sudo systemctl start buildkite-agent

# Verify version
buildkite-agent --version
```

### Disable Agent Without Removing

```bash
# Stop service (agent appears offline in UI)
sudo systemctl stop buildkite-agent

# Disable permanently
sudo systemctl disable buildkite-agent

# Re-enable later
sudo systemctl enable buildkite-agent
sudo systemctl start buildkite-agent
```

### Remove from Buildkite UI

1. Navigate to **Settings → Agents**
2. Find agent in list
3. Click "Delete" or "Remove" to de-register
4. Agent will be removed from available pool immediately

## Common Errors

**Agent shows "offline" in UI**
- Check network connectivity: `curl -v https://agent.buildkite.com`
- Verify token is correct: `cat /etc/buildkite-agent/token`
- Review service logs: `sudo journalctl -u buildkite-agent -n 50`
- Ensure firewall allows outbound HTTPS (port 443)

**Agent token rejected**
- Regenerate token in Buildkite UI: Settings → Agents → + Add new agent
- Update token file: `echo "NEW_TOKEN" | sudo tee /etc/buildkite-agent/token`
- Restart service: `sudo systemctl restart buildkite-agent`

**"max-run-builds must be ≤ CPU count" warning**
- Reduce `max-run-builds` to match CPU cores
- Or increase `LimitNOFILE` in systemd service for file descriptor limits

**Builds not reaching agent**
- Check pipeline `agent` rules match agent tags/queue
- Verify agent tags include required pipeline tags
- Check queue assignment matches pipeline `queue` setting

**Permission denied errors**
- Check buildkite-agent user permissions: `id buildkite-agent`
- For Docker builds: `sudo usermod -aG docker buildkite-agent`
- For workspace access: ensure `/var/lib/buildkite-agent` owned by agent user

**High memory usage**
- Reduce `max-run-builds` to limit concurrent builds
- Increase system swap space: `sudo swapon --show`
- Monitor with `htop` or `ps aux --sort=-%mem | grep buildkite`

**Service fails to start**
- Validate configuration: `buildkite-agent validate --config /etc/buildkite-agent/agent.cfg`
- Check token file format: no extra quotes or whitespace
- Test binary manually: `sudo -u buildkite-agent /usr/local/bin/buildkite-agent start --config /etc/buildkite-agent/agent.cfg`

**Agent keeps disconnecting**
- Check system clock synchronization: `timedatectl status`
- Ensure NTP is running: `sudo timedatectl set-ntp true`
- Review network stability; unstable connections cause frequent reconnects

**Build job stuck in "running" state**
- Check actual running jobs: `sudo buildkite-agent running-jobs`
- Kill zombie job: `sudo buildkite-agent stop`
- Verify job completion in Buildkite UI, may require manual cleanup

## Troubleshooting

### Agent Not Appearing in UI

```bash
# 1. Check service is running
sudo systemctl status buildkite-agent

# 2. Verify token
sudo cat /etc/buildkite-agent/token

# 3. Test API connectivity
curl -v https://agent.buildkite.com/v1/agent-info

# 4. Check logs
sudo journalctl -u buildkite-agent --since "5 minutes ago"

# 5. Validate config
sudo buildkite-agent validate --config /etc/buildkite-agent/agent.cfg

# 6. Restart with verbose logging
sudo sed -i 's/^log-level:.*/log-level: "debug"/' /etc/buildkite-agent/agent.cfg
sudo systemctl restart buildkite-agent
sudo journalctl -u buildkite-agent -f
```

### Build Fails with "No agents available"

```bash
# 1. Verify agent tags match pipeline requirements
sudo cat /etc/buildkite-agent/agent.cfg | grep tags

# 2. Check pipeline agent configuration
# In Buildkite UI, check pipeline settings → Agents → Tags

# 3. Add missing tags
sudo tee /etc/buildkite-agent/agent.cfg > /dev/null <<'EOF'
tags: ["linux", "amd64", "docker"]
EOF
sudo systemctl restart buildkite-agent

# 4. Verify queue assignment
sudo grep queue /etc/buildkite-agent/agent.cfg
```

### High Build Queue Times

```bash
# Increase concurrent builds
sudo sed -i 's/^max-run-builds:.*/max-run-builds: 4/' /etc/buildkite-agent/agent.cfg
sudo systemctl restart buildkite-agent

# Check resource utilization
htop
df -h

# Consider adding more agents instead of increasing max-run-builds
```

### Clean Build Workspace

```bash
# Clean agent workspace
sudo systemctl stop buildkite-agent
sudo rm -rf /var/lib/buildkite-agent/*
sudo systemctl start buildkite-agent

# Or use buildkite-agent cleanup
sudo buildkite-agent cleanup --force
```

### Reset Agent Configuration

```bash
# Stop agent
sudo systemctl stop buildkite-agent

# Backup and recreate config
sudo cp /etc/buildkite-agent/agent.cfg /etc/buildkite-agent/agent.cfg.bak
sudo rm /etc/buildkite-agent/agent.cfg

# Re-run installation with desired parameters
# OR manually create fresh config

sudo systemctl start buildkite-agent
```

## Security Considerations

- Store agent token in `/etc/buildkite-agent/token` with `600` permissions
- Limit `max-run-builds` to prevent resource exhaustion
- Use separate agents for untrusted repositories (different queues)
- Enable audit logging via Buildkite organization settings
- Rotate agent tokens periodically from Buildkite UI
- Restrict agent user capabilities; avoid running as root
- Monitor agent metrics for unusual job patterns
- Use Docker-based builds to isolate job execution

## References

- [Buildkite Agent Documentation](https://buildkite.com/docs/agent)
- [Buildkite Agent Configuration](https://buildkite.com/docs/agent/configuration)
- [Buildkite Pipelines YAML Reference](https://buildkite.com/docs/pipelines/configuration)
- [Buildkite Tags and Queues](https://buildkite.com/docs/pipelines/queues)
- [Buildkite Hooks](https://buildkite.com/docs/agent/hooks)
- [Buildkite Metadata](https://buildkite.com/docs/agent/metadata)
- DevOps-Kit CI/CD Toolkit: `docs/how-to/ci_cd_toolkit.md`
