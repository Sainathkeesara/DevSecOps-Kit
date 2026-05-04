# Docker AuthZ Plugin Security Hardening for Privileged Containers

## Purpose

This guide provides steps to harden Docker environments by implementing authorization (AuthZ) plugin security policies that prevent and monitor privileged container operations, mitigating container escape risks and host system compromise.

## When to use

- When running untrusted workloads in containers
- During security audits of Docker hosts
- Before deploying containers in production environments
- When implementing container security policies
- If your environment requires zero-trust container behavior

## Prerequisites

- Bash 4.0 or higher
- Docker Engine 20.10+
- Root/sudo access for Docker configuration
- Basic understanding of Docker security model
- Access to docker daemon configuration

## Affected Versions

- Docker Engine all versions when using privileged containers
- Docker Engine with misconfigured authorization
- Any Docker installation without proper AuthZ policies

## Steps

### Step 1: Identify Docker security posture

```bash
# Check Docker version
docker version --format '{{.Server.Version}}'

# Check for running privileged containers
docker ps -a --format '{{.Names}}' | xargs -I {} docker inspect {} --format '{{.Name}}:{{.HostConfig.PrivilegedMode}}'

# Check docker daemon configuration
cat /etc/docker/daemon.json 2>/dev/null || echo "No daemon.json found"

# Check running Docker processes
ps aux | grep dockerd
```

### Step 2: Identify existing authorization plugins

```bash
# Check if authorization plugin is enabled
docker info --format '{{.Plugins.Authorization}}' 2>/dev/null || echo "No authorization plugin"

# List all plugins
docker info --format '{{.Plugins}}' 2>/dev/null

# Check daemon.json for authorization plugin setting
grep -r "authorization-plugin" /etc/docker/ 2>/dev/null || echo "No AuthZ plugins"
```

### Step 3: Run security check

Use the hardening script to detect security gaps:

```bash
# Run the check script
./scripts/bash/docker_toolkit/security/docker-authz-plugin-hardening.sh --check

# Dry-run mode
./scripts/bash/docker_toolkit/security/docker-authz-plugin-hardening.sh --dry-run

# JSON output for automation
./scripts/bash/docker_toolkit/security/docker-authz-plugin-hardening.sh --json-output
```

### Step 4: Apply hardening

#### Prevent privileged containers by default

Add to `/etc/docker/daemon.json`:

```json
{
  "authorization-plugins": [],
  "icc": false,
  "iptables": true,
  "userland-proxy": false,
  "no-new-privileges": true,
  "live-restore": true,
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "default-ulimits": {
    "nofile": {
      "Name": "nofile",
      "Hard": 64000,
      "Soft": 64000
    }
  },
  "default-memory-limit": "512m",
  "default-memory-swap-limit": "1g"
}
```

#### Install and configure AuthZ plugin if needed

```bash
# Example: Install docker authorizes plugin
docker plugin install docker/docker-authz-plugin:latest --grant-all-permissions

# Update daemon.json
# Add "authorization-plugins": ["docker/docker-authz-plugin:latest"]
```

### Step 5: Implement runtime security

```bash
# Block privileged containers at runtime
docker run --privileged alpine:latest docker ps || echo "Privileged container blocked"

# Use --security-opt instead
docker run --security-opt no-new-privileges:true alpine:latest docker ps

# Use seccomp profile
docker run --security-opt seccomp=/path/to/profile.json alpine:latest
```

### Step 6: Monitor privileged containers

```bash
# Enable Docker event monitoring
docker events --filter 'event=container_start' | while read event; do
    container=$(echo $event | jq -r '.container')
    privileged=$(docker inspect $container --format '{{.HostConfig.PrivilegedMode}}')
    if [ "$privileged" = "true" ]; then
        echo "ALERT: Privileged container started: $container"
    fi
done
```

## Verify

Post-hardening validation checklist:

1. **No Privileged Containers Running**
   ```bash
   docker ps -a --format '{{.Names}}' | xargs -I {} docker inspect {} --format '{{.Name}}:{{.HostConfig.PrivilegedMode}}' | grep true
   # Expected: no output
   ```

2. **Daemon Configuration Verified**
   ```bash
   cat /etc/docker/daemon.json
   # Verify default deny for privileged mode
   ```

3. **Run Hardening Script Verification**
   ```bash
   ./scripts/bash/docker_toolkit/security/docker-authz-plugin-hardening.sh --check
   ```

Expected result: Exit code 0, no security gaps detected.

## Rollback

If issues arise after hardening:

```bash
# Revert daemon.json to defaults
sudo cp /etc/docker/daemon.json.bak /etc/docker/daemon.json

# Restart Docker
sudo systemctl restart docker
```

## Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `docker: command not found` | Docker not in PATH | Use full path `/usr/bin/docker` or install Docker |
| `Cannot connect to Docker daemon` | Docker not running | Start Docker: `sudo systemctl start docker` |
| `Permission denied` | User not in docker group | Add user: `sudo usermod -aG docker $USER` |
| `authorization-plugins: plugin not found` | Plugin not installed | Remove from daemon.json or install plugin |

## References

- [Docker Security Documentation](https://docs.docker.com/engine/security/)
- [Docker Authorization Plugins](https://docs.docker.com/engine/extend/plugins_authorization/)
- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)