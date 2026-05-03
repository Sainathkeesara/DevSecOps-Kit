# Linux: Container Orchestration Automation with Systemd and Cgroups

## Purpose
This guide provides a comprehensive framework for automating container orchestration on Linux using systemd and cgroups. It covers systemd service management, cgroup resource constraints, container lifecycle management, and integration patterns for production environments.

## When to Use
- Managing containerized workloads with systemd as the init system
- Implementing resource constraints using cgroups (CPU, memory, I/O, PID limits)
- Building automated container orchestration for DevOps pipelines
- Deploying container services with systemd integration
- Implementing resource monitoring and quota enforcement
- Creating self-healing container infrastructure with systemd watchdogs

## Prerequisites
- Linux systems running RHEL 8+, Ubuntu 20.04+, Debian 10+, or Fedora 35+
- Container runtime: Docker 20.10+, Podman 4.0+, or containerd 1.6+
- systemd 247+ for advanced features (Slice, Scope, Manager APIs)
- cgroup v2 (unified hierarchy) recommended for modern features
- Root/sudo access on target systems
- SSH key-based authentication for remote management
- Basic understanding of systemd units and cgroup hierarchies
- Optional: Ansible 2.9+ for fleet management

## Steps

### 1. Understanding Systemd Container Integration

Systemd provides native container management through several unit types:

| Unit Type | Purpose | Use Case |
|-----------|---------|----------|
| Service | Long-running containers | Application containers |
| Scope | Transient container groups | Batch jobs, temporary workloads |
| Slice | Resource isolation groups | QoS tiering |
| Socket | Activation on demand | On-demand service startup |

### 2. Cgroup Resource Configuration

Create cgroup-based resource limits for containers:

**CPU Limits:**
```bash
# CPU shares (relative weight, default 1024)
CGROUP_CPU_SHARES=1024
# CPU quota (microseconds per period)
CGROUP_CPU_QUOTA=50000
# CPU period (microseconds, default 100000)
CGROUP_CPU_PERIOD=100000

# Example: 50% of one CPU
# quota=50000, period=100000 = 0.5 CPU
```

**Memory Limits:**
```bash
# Memory limit (bytes)
CGROUP_MEMORY_LIMIT=1073741824  # 1GB
# Memory+swap limit
CGROUP_MEMORY_SWAP_LIMIT=2147483648  # 2GB
# Memory soft limit (for oomd)
CGROUP_MEMORY_SOFT_LIMIT=536870912  # 512MB
```

**I/O Limits:**
```bash
# Read IOPS limit
CGROUP_IO_READ_BPS=10485760  # 10MB/s
# Write IOPS limit
CGROUP_IO_WRITE_BPS=10485760
# Device weight (block weight 100-10000)
CGROUP_IO_WEIGHT=100
```

**PID Limits:**
```bash
# Maximum processes/threads
CGROUP_PIDS_MAX=100
```

### 3. Systemd Service Unit for Containers

Create `container-app.service`:

```ini
[Unit]
Description=My Container Application
After=network.target docker.service
Requires=docker.service
Wants=network-online.target

[Service]
Type=oneshot
RemainAfterExit=yes

# Pull and run container
ExecStartPre=/usr/bin/docker pull nginx:latest
ExecStart=/usr/bin/docker run \
    --name myapp \
    --cgroup-parent /system.slice/myapp.slice \
    --memory=1g \
    --cpus=0.5 \
    --oom-kill-disable \
    --restart=on-failure:5 \
    --restart-sec=10 \
    -p 8080:80 \
    -v /opt/myapp/config:/etc/nginx:ro \
    -v /opt/myapp/logs:/var/log/nginx \
    --log-driver=journald \
    --log-opt tag="{{.Name}}/{{.ID}}" \
    nginx:latest

ExecStop=/usr/bin/docker stop myapp
ExecStopPost=/usr/bin/docker rm -f myapp

# Resource limits via systemd (alternative to docker flags)
MemoryMax=1073741824
CPUQuota=50%
MemorySwapMax=1073741824
TasksMax=50

# Security hardening
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/opt/myapp

[Install]
WantedBy=multi-user.target
```

### 4. Cgroup Slice Configuration

Create resource isolation slices for different workload types:

`/etc/systemd/system/low-priority.slice`:
```ini
[Unit]
Description=Low Priority Workload Slice
Before=slices.target

[Slice]
CPUWeight=100
MemoryLow=536870912
MemoryMax=2147483648
IOWeight=100
TasksMax=100
```

`/etc/systemd/system/high-priority.slice`:
```ini
[Unit]
Description=High Priority Workload Slice
Before=slices.target

[Slice]
CPUWeight=800
MemoryLow=2147483648
MemoryMax=8589934592
IOWeight=800
TasksMax=500
```

Enable slices:
```bash
systemctl start low-priority.slice
systemctl start high-priority.slice
```

### 5. Container Scope Units

For dynamic container management using scopes:

`container-batch.scope`:
```ini
[Unit]
Description=Batch Job Container Scope
After=network.target

[Scope]
TasksMax=100
MemoryMax=4G
CPUQuota=200%
TimeoutStartSec=300
TimeoutStopSec=60

[Install]
WantedBy=multi-user.target
```

Manage containers in scope:
```bash
systemd-run --scope --slice=batch \
    /usr/bin/docker run --rm -it \
    --cgroup-parent=/system.slice/batch.slice \
    busybox:latest sh
```

### 6. Automated Deployment Script

Create `deploy-container-stack.sh`:

```bash
#!/usr/bin/env bash
# Container Orchestration Deployment with Systemd and Cgroups
# Level: L7 | Features: Idempotent, dry-run, resource enforcement, rollback

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${CONFIG_FILE:-/etc/container-orchestrator/config.yml}"
DRY_RUN="${DRY_RUN:-false}"
VERBOSE="${VERBOSE:-false}"
LOG_FILE="/var/log/container-orchestrator.log"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*"; }
log_debug() { [[ "$VERBOSE" == "true" ]] && echo -e "${BLUE}[DEBUG]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*"; }

run() {
    local cmd="$*"
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY-RUN] $cmd"
    else
        log_debug "Executing: $cmd"
        eval "$cmd"
    fi
}

check_dependencies() {
    log_info "Checking dependencies..."
    
    for cmd in docker systemctl grep awk; do
        if ! command -v "$cmd" &>/dev/null; then
            log_error "$cmd not found"
            return 1
        fi
    done
    
    if ! systemctl is-active --quiet docker; then
        log_error "Docker service not running"
        return 1
    fi
    
    log_info "All dependencies satisfied"
}

create_cgroup_slice() {
    local slice_name="$1"
    local cpu_weight="$2"
    local memory_max="$3"
    local tasks_max="${4:-100}"
    
    log_info "Creating cgroup slice: $slice_name"
    
    local slice_file="/etc/systemd/system/${slice_name}.slice"
    
    if [[ -f "$slice_file" ]]; then
        log_warn "Slice $slice_name already exists"
        return 0
    fi
    
    run "cat > $slice_file <<EOF
[Unit]
Description=${slice_name} Slice
Before=slices.target

[Slice]
CPUWeight=$cpu_weight
MemoryMax=$memory_max
TasksMax=$tasks_max
EOF"
    
    run "systemctl daemon-reload"
    run "systemctl start ${slice_name}.slice" || true
    
    log_info "Slice $slice_name created successfully"
}

deploy_container_service() {
    local service_name="$1"
    local image="$2"
    local container_name="$3"
    local slice="${4:-}"
    local memory_limit="${5:-}"
    local cpu_limit="${6:-}"
    local ports="${7:-}"
    local volumes="${8:-}"
    local restart_policy="${9:-on-failure:5}"
    
    log_info "Deploying container service: $service_name"
    
    local service_file="/etc/systemd/system/${service_name}.service"
    local docker_run_args="--name $container_name --restart=$restart_policy --log-driver=journald"
    
    if [[ -n "$slice" ]]; then
        docker_run_args="$docker_run_args --cgroup-parent=/system.slice/${slice}.slice"
    fi
    
    if [[ -n "$memory_limit" ]]; then
        docker_run_args="$docker_run_args --memory=$memory_limit"
    fi
    
    if [[ -n "$cpu_limit" ]]; then
        docker_run_args="$docker_run_args --cpus=$cpu_limit"
    fi
    
    if [[ -n "$ports" ]]; then
        docker_run_args="$docker_run_args -p $ports"
    fi
    
    if [[ -n "$volumes" ]]; then
        docker_run_args="$docker_run_args -v $volumes"
    fi
    
    local ports_array=""
    if [[ -n "$ports" ]]; then
        ports_array=$(echo "$ports" | tr ',' '\n' | while read p; do echo -n "-p $p "; done)
    fi
    
    run "cat > $service_file <<EOF
[Unit]
Description=${service_name} Container Service
After=network.target docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes

ExecStartPre=-/usr/bin/docker rm -f $container_name 2>/dev/null || true
ExecStart=/usr/bin/docker run $docker_run_args $image
ExecStop=/usr/bin/docker stop $container_name
ExecStopPost=/usr/bin/docker rm -f $container_name

[Install]
WantedBy=multi-user.target
EOF"
    
    run "systemctl daemon-reload"
    run "systemctl enable ${service_name}.service"
    run "systemctl start ${service_name}.service"
    
    log_info "Service $service_name deployed successfully"
}

verify_deployment() {
    local service_name="$1"
    
    log_info "Verifying deployment: $service_name"
    
    if systemctl is-active --quiet "${service_name}.service"; then
        log_info "Service $service_name is running"
        
        local container_name
        container_name=$(systemctl show "${service_name}.service" -p ExecStart --value | grep -oP '(?<=--name\s)\S+')
        
        if docker ps --format '{{.Names}}' | grep -q "$container_name"; then
            log_info "Container $container_name is running"
            return 0
        fi
    fi
    
    log_error "Verification failed for $service_name"
    return 1
}

rollback_service() {
    local service_name="$1"
    
    log_warn "Rolling back service: $service_name"
    
    run "systemctl stop ${service_name}.service"
    run "systemctl disable ${service_name}.service"
    run "rm -f /etc/systemd/system/${service_name}.service"
    run "systemctl daemon-reload"
    
    log_info "Service $service_name rolled back"
}

main() {
    log_info "Starting container orchestration deployment..."
    
    check_dependencies || exit 1
    
    create_cgroup_slice "high-priority" 800 4G 200
    create_cgroup_slice "low-priority" 100 2G 50
    
    deploy_container_service "webapp" "nginx:latest" "webapp-container" "high-priority" "1g" "0.5" "8080:80" "/opt/webapp:/usr/share/nginx/html:ro" "on-failure:3"
    deploy_container_service "api" "redis:alpine" "redis-cache" "high-priority" "512m" "0.25" "6379:6379" "" "no"
    
    for svc in webapp api; do
        verify_deployment "$svc" || {
            log_error "Verification failed for $svc, rolling back"
            rollback_service "$svc"
            exit 1
        }
    done
    
    log_info "Container orchestration deployment complete!"
}

main "$@"
```

### 7. Cgroup Resource Monitoring

Monitor cgroup resource usage:

```bash
#!/usr/bin/env bash
# Cgroup Resource Monitoring Script

set -euo pipefail

MONITOR_INTERVAL="${MONITOR_INTERVAL:-5}"
SLICE_NAME="${SLICE_NAME:-}"

log_resources() {
    local slice="$1"
    
    echo "=== $slice Resource Usage ==="
    
    if [[ -f "/sys/fs/cgroup/system.slice/${slice}.slice/cpu.pressure" ]]; then
        echo "CPU Pressure:"
        cat "/sys/fs/cgroup/system.slice/${slice}.slice/cpu.pressure"
    fi
    
    if [[ -f "/sys/fs/cgroup/system.slice/${slice}.slice/memory.pressure" ]]; then
        echo -e "\nMemory Pressure:"
        cat "/sys/fs/cgroup/system.slice/${slice}.slice/memory.pressure"
    fi
    
    if [[ -f "/sys/fs/cgroup/system.slice/${slice}.slice/memory.current" ]]; then
        echo -e "\nMemory Usage:"
        cat "/sys/fs/cgroup/system.slice/${slice}.slice/memory.current"
    fi
    
    if [[ -f "/sys/fs/cgroup/system.slice/${slice}.slice/pids.current" ]]; then
        echo -e "\nPID Usage:"
        cat "/sys/fs/cgroup/system.slice/${slice}.slice/pids.current"
    fi
}

while true; do
    if [[ -n "$SLICE_NAME" ]]; then
        log_resources "$SLICE_NAME"
    else
        for slice in /sys/fs/cgroup/system.slice/*.slice; do
            [[ -d "$slice" ]] || continue
            basename "$slice" | sed 's/.slice$//' | xargs -I{} log_resources {}
        done
    fi
    sleep "$MONITOR_INTERVAL"
done
```

### 8. Integration with Container Runtimes

**Docker Integration:**
```bash
# Use systemd cgroup driver for Kubernetes compatibility
docker info | grep "Cgroup Driver"

# Configure in /etc/docker/daemon.json
{
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "journald",
    "storage-driver": "overlay2"
}
```

**Podman Integration:**
```bash
# Podman uses systemd cgroups by default
podman info | grep "cgroup"

# Generate systemd units
podman generate systemd --name mycontainer > /etc/systemd/system/mycontainer.service

# Run with cgroup constraints
podman run \
    --cgroups=enabled \
    --memory=1g \
    --cpus=0.5 \
    --device-read-bps=/dev/sda:10mb \
    nginx
```

### 9. Health Checks and Auto-Restart

Systemd watchdog integration for container health:

```ini
[Service]
WatchdogSec=30s
Restart=on-failure
RestartSec=10

# Health check via exec
ExecStartPre=/usr/bin/docker pull healthcheck/image:tag

# Script to check container health
ExecStart=/bin/bash -c '\
    while ! docker inspect --format="{{.State.Health.Status}}" myapp | grep -q "healthy"; do\
        sleep 5;\
    done;\
    docker start myapp'
```

### 10. Container Networking with Systemd

Bind container ports to specific interfaces:

```bash
# Create systemd network-socket activation unit
cat > /etc/systemd/system/container-ports.socket <<EOF
[Unit]
Description=Container Port Activation Socket
PartOf=container-app.service

[Socket]
ListenStream=8080
BindIPv6Only=both
Accept=false

[Install]
WantedBy=sockets.target
EOF

# Container starts on socket activation
systemctl enable container-ports.socket
```

## Verify

### 1. Check Service Status
```bash
systemctl status container-app.service
journalctl -u container-app.service -f
```

### 2. Verify Cgroup Configuration
```bash
# List cgroup hierarchy
systemd-cgls

# Check slice resources
systemctl show high-priority.slice

# View cgroup settings
cat /sys/fs/cgroup/system.slice/high-priority.slice/cpu.max
cat /sys/fs/cgroup/system.slice/high-priority.slice/memory.max
```

### 3. Monitor Container Resources
```bash
# Docker stats
docker stats --no-stream

# cAdvisor for metrics
docker run --cadvisor -v /:/rootfs:ro -p 8080:8080

# systemd-cgtop
systemd-cgtop
```

### 4. Verify Resource Limits
```bash
# Check applied limits
docker inspect container_name | grep -A 20 "HostConfig"

# View process cgroup
cat /proc/<pid>/cgroup
```

### 5. Test Failure Recovery
```bash
# Kill container process
docker kill <container_id>

# Check auto-restart
systemctl status container-app.service
docker ps | grep container_name
```

## Rollback

### 1. Stop and Disable Service
```bash
systemctl stop container-app.service
systemctl disable container-app.service
rm /etc/systemd/system/container-app.service
systemctl daemon-reload
```

### 2. Remove Containers
```bash
docker stop container-app
docker rm container-app
```

### 3. Clean Up Cgroup Slices
```bash
systemctl stop high-priority.slice
systemctl disable high-priority.slice
rm /etc/systemd/system/high-priority.slice
systemctl daemon-reload
```

### 4. Restore Previous Configuration
```bash
# If using Git
git checkout HEAD~1 -- /etc/systemd/system/container-app.service
systemctl daemon-reload
systemctl start container-app.service
```

## Common Errors

### Error: "Failed to start container-app.service: Unit docker.service not found"
**Cause:** Docker daemon not running.
```bash
# Start Docker
systemctl enable --now docker
systemctl status docker
```

### Error: "OCI runtime create failed:... cgroup mountpoint does not exist"
**Cause:** Cgroup not mounted or cgroup v1/v2 mismatch.
```bash
# Check cgroup version
mount | grep cgroup

# For cgroup v2
# Ensure /sys/fs/cgroup is mounted as cgroup2

# For cgroup v1
# Ensure proper cgroup hierarchy is available
```

### Error: "Memory limit exceeded" in container
**Cause:** Container hit memory limit.
```bash
# Increase limit
systemctl set-property container-app.service MemoryMax=2G

# Or update docker run args
docker update --memory=2g container_name
```

### Error: "CPU quota exceeded"
**Cause:** Container using more CPU than allocated.
```bash
# Increase CPU quota
systemctl set-property container-app.service CPUQuota=100%

# Or update docker
docker update --cpus=1 container_name
```

### Error: "Failed to allocate memory" in systemd
**Cause:** cgroup memory limit too low.
```bash
# Check current limits
systemctl show high-priority.slice | grep Memory

# Adjust slice limits
systemctl set-property high-priority.slice MemoryMax=8G
```

### Error: "Process already in cgroup" when creating slice
**Cause:** Slice already exists or processes still attached.
```bash
# Kill all processes in slice
echo 1 > /sys/fs/cgroup/system.slice/low-priority.slice/cgroup.kill

# Then recreate
system daemon-reload
```

## References
- [systemd.resource-control](https://www.freedesktop.org/software/systemd/man/systemd.resource-control.html)
- [Docker Runtime Options](https://docs.docker.com/engine/reference/run/)
- [cgroup v2 kernel documentation](https://www.kernel.org/doc/Documentation/cgroup-v2.txt)
- [Systemd Slice Units](https://www.freedesktop.org/software/systemd/man/systemd.slice.html)
- [Container Security Guide](https://docs.docker.com/engine/security/)