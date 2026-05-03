# Linux: System Hardening Automation for Containerized Environments

## Purpose
This guide provides a comprehensive, production-ready framework for automating Linux system hardening specifically tailored for containerized environments. It delivers standardized security configurations, automated compliance checks, and hardened runtime configurations following CIS benchmarks, NIST guidelines, and Docker security best practices. The solution includes automated remediation, continuous monitoring, and audit capabilities to maintain secure containerized infrastructure at scale.

## When to Use
- Securing Docker/Podman hosts before container deployment
- Implementing automated compliance for containerized workloads
- Hardening container runtimes and orchestration platforms
- Meeting regulatory requirements (CIS, NIST, PCI-DSS, SOC 2)
- Automating security baselines across container fleets
- Implementing least-privilege access controls for container hosts
- Securing container registries and image supply chains
- Building secure CI/CD pipeline stages for container images

## Prerequisites
- Target Linux systems: RHEL/CentOS 8+, Ubuntu 20.04+, or Debian 10+
- Container runtime: Docker 20.10+, Podman 4.0+, or containerd 1.6+
- Root/sudo access on target systems
- SSH key-based authentication configured
- Python 3.8+ for Ansible-based execution
- Ansible 2.9+ (optional, for fleet management)
- Network connectivity for security tool downloads
- 4GB+ RAM and 20GB+ disk space for full hardening suite

## Steps

### 1. Pre-Hardening Assessment

#### 1.1 System Inventory Collection
```bash
#!/usr/bin/env bash
# collect-system-info.sh - Collect baseline system information

set -euo pipefail

OUTPUT_DIR="/var/log/hardening-assessment"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

mkdir -p "${OUTPUT_DIR}"

collect_info() {
    echo "=== $1 ===" >> "${OUTPUT_DIR}/system-info-${TIMESTAMP}.txt"
    eval "$2" >> "${OUTPUT_DIR}/system-info-${TIMESTAMP}.txt" 2>&1
    echo "" >> "${OUTPUT_DIR}/system-info-${TIMESTAMP}.txt"
}

collect_info "OS Information" "cat /etc/os-release"
collect_info "Kernel Version" "uname -a"
collect_info "Installed Packages" "rpm -qa || dpkg -l"
collect_info "Running Services" "systemctl list-units --type=service --state=running"
collect_info "Network Configuration" "ip addr show"
collect_info "Firewall Rules" "iptables -L -n || nft list ruleset"
collect_info "Container Runtime" "docker version 2>/dev/null || podman version 2>/dev/null"
collect_info "User Accounts" "cut -d: -f1 /etc/passwd"
collect_info "Sudo Configuration" "cat /etc/sudoers"
collect_info "SSH Configuration" "cat /etc/ssh/sshd_config"

echo "System information collected in ${OUTPUT_DIR}"
```

#### 1.2 CIS Benchmark Assessment
```bash
#!/usr/bin/env bash
# cis-assessment.sh - Run CIS Docker Benchmark assessment

set -euo pipefail

CIS_VERSION="1.6.0"
ASSESSMENT_DIR="/var/log/cis-assessment"
mkdir -p "${ASSESSMENT_DIR}"

# Install Docker Bench for Security
if ! command -v docker-bench-security &>/dev/null; then
    git clone https://github.com/docker/docker-bench-security.git /tmp/docker-bench-security
    cp /tmp/docker-bench-security/docker-bench-security.sh /usr/local/bin/docker-bench-security
    chmod +x /usr/local/bin/docker-bench-security
fi

# Run assessment
docker-bench-security \
    --check 1,2,3,4,5 \
    --include-test-output \
    2>&1 | tee "${ASSESSMENT_DIR}/cis-docker-benchmark-${TIMESTAMP}.log"

# Parse results
FAILURES=$(grep -c "\[WARN\]" "${ASSESSMENT_DIR}/cis-docker-benchmark-${TIMESTAMP}.log" || true)
echo "CIS Assessment Complete: ${FAILURES} warnings found"
```

### 2. Kernel Hardening

#### 2.1 Sysctl Security Parameters
```bash
#!/usr/bin/env bash
# kernel-hardening.sh - Apply kernel security hardening

set -euo pipefail

SYSCTL_CONF="/etc/sysctl.d/99-security-hardening.conf"

cat > "${SYSCTL_CONF}" << 'EOF'
# Kernel Security Hardening Parameters

# Prevent kernel pointer leaks
kernel.kptr_restrict = 2
kernel.dmesg_restrict = 1

# Restrict ptrace to parent only
kernel.yama.ptrace_scope = 1

# Enable ASLR
kernel.randomize_va_space = 2

# SYN cookies protection
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_timestamps = 0

# IP forwarding (disable unless required)
net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0

# Ignore ICMP broadcasts
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1

# Log martians
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1

# Reverse path filtering
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Disable source packet routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0

# Enable ExecShield
kernel.exec-shield = 1
kernel.randomize_va_space = 2

# Restrict core dumps
fs.suid_dumpable = 0

# Increase file descriptor limits
fs.file-max = 2097152
fs.nr_open = 2097152

# Network tuning
net.core.somaxconn = 4096
net.core.netdev_max_backlog = 8192
net.ipv4.tcp_max_syn_backlog = 4096
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_keepalive_time = 1800
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.tcp_keepalive_probes = 5

# Memory overcommit
vm.overcommit_memory = 2
vm.overcommit_ratio = 80

# Swappiness
vm.swappiness = 10

# Shared memory
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
EOF

# Apply parameters
sysctl --system

echo "Kernel hardening parameters applied"
```

#### 2.2 Kernel Module Hardening
```bash
#!/usr/bin/env bash
# module-hardening.sh - Disable unnecessary kernel modules

set -euo pipefail

MODULES_TO_DISABLE=(
    "cramfs"
    "freevxfs"
    "jffs2"
    "hfs"
    "hfsplus"
    "squashfs"
    "udf"
    "usb-storage"
    "vfat"  # Remove if USB storage required
)

for module in "${MODULES_TO_DISABLE[@]}"; do
    echo "Installing ${module} module to disable..."
    
    # Create modprobe configuration
    echo "install ${module} /bin/true" > "/etc/modprobe.d/${module}.conf"
    
    # Try to unload if loaded
    if lsmod | grep -q "^${module}"; then
        modprobe -r "${module}" 2>/dev/null || true
        echo "Module ${module} unloaded"
    fi
done

# Load security modules
modprobe apparmor 2>/dev/null || true
modprobe audit 2>/dev/null || true

# Update initramfs
if command -v dracut &>/dev/null; then
    dracut -f
elif command -v update-initramfs &>/dev/null; then
    update-initramfs -u
fi

echo "Kernel module hardening complete"
```

### 3. Filesystem Hardening

#### 3.1 Partition Hardening with /etc/fstab
```bash
#!/usr/bin/env bash
# fstab-hardening.sh - Apply filesystem mount options

set -euo pipefail

# Backup original fstab
cp /etc/fstab /etc/fstab.backup.$(date +%Y%m%d)

# Function to add mount options
add_mount_option() {
    local partition="$1"
    local mount_point="$2"
    local fs_type="$3"
    local options="$4"
    
    # Check if mount point already exists
    if grep -q "${mount_point}" /etc/fstab; then
        echo "Mount point ${mount_point} already exists, skipping"
        return 0
    fi
    
    echo "${partition} ${mount_point} ${fs_type} ${options} 0 0" >> /etc/fstab
    echo "Added: ${mount_point} with options: ${options}"
}

# Add security-enhanced mount points
cat >> /etc/fstab << 'EOF'

# Security Enhanced Mount Points
tmpfs /tmp tmpfs defaults,noexec,nosuid,nodev,noatime,nodiratime,size=2G 0 0
tmpfs /dev/shm tmpfs defaults,noexec,nosuid,nodev,noatime,nodiratime,size=1G 0 0
tmpfs /var/tmp tmpfs defaults,noexec,nosuid,nodev,noatime,nodiratime,size=512M 0 0
tmpfs /var/log/audit tmpfs defaults,noexec,nosuid,nodev,noatime,nodiratime,size=512M 0 0
tmpfs /var/log tmpfs defaults,noexec,nosuid,nodev,noatime,nodiratime,size=1G 0 0

# /boot with nodev
UUID=$(blkid -s UUID -o value /dev/sda1) 2>/dev/null || true
if [ -n "$UUID" ]; then
    echo "UUID=${UUID} /boot ext4 defaults,nodev 0 2" >> /etc/fstab
fi
EOF

echo "Filesystem hardening configuration added to /etc/fstab"
echo "Note: Reboot required for changes to take effect"
```

#### 3.2 Immutable Files and Directories
```bash
#!/usr/bin/env bash
# immutable-files.sh - Set immutable attributes on critical files

set -euo pipefail

# Files that should be immutable
IMMUTABLE_FILES=(
    "/etc/passwd"
    "/etc/shadow"
    "/etc/group"
    "/etc/gshadow"
    "/etc/ssh/ssh_host_rsa_key"
    "/etc/ssh/ssh_host_rsa_key.pub"
    "/etc/ssh/ssh_host_ecdsa_key"
    "/etc/ssh/ssh_host_ecdsa_key.pub"
    "/etc/ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_ed25519_key.pub"
    "/etc/security/limits.conf"
    "/etc/sysctl.conf"
    "/etc/hosts"
    "/etc/hostname"
)

set_immutable() {
    local file="$1"
    if [ -f "${file}" ]; then
        chattr +i "${file}" 2>/dev/null && \
            echo "Set immutable: ${file}" || \
            echo "Warning: Could not set immutable on ${file}"
    else
        echo "Warning: File not found: ${file}"
    fi
}

for file in "${IMMUTABLE_FILES[@]}"; do
    set_immutable "${file}"
done

# Remove immutable (for testing/management)
# chattr -i /etc/passwd

echo "Immutable file attributes configured"
echo "To modify files, use: chattr -i <file>"
```

### 4. Container Runtime Hardening

#### 4.1 Docker Daemon Configuration
```bash
#!/usr/bin/env bash
# docker-daemon-hardening.sh - Configure Docker daemon security

set -euo pipefail

DOCKER_CONF="/etc/docker/daemon.json"

# Backup existing configuration
if [ -f "${DOCKER_CONF}" ]; then
    cp "${DOCKER_CONF}" "${DOCKER_CONF}.backup.$(date +%Y%m%d)"
fi

# Create hardened configuration
cat > "${DOCKER_CONF}" << 'EOF'
{
  "authorization-plugins": [],
  "data-root": "/var/lib/docker",
  "dns": ["8.8.8.8", "8.8.4.4"],
  "exec-opts": ["native.cgroupdriver=systemd"],
  "exec-root": "/var/run/docker",
  "experimental": false,
  "features": {
    "buildkit": true
  },
  "group": "docker",
  "icc": false,
  "insecure-registries": [],
  "ip": "0.0.0.0",
  "iptables": true,
  "live-restore": true,
  "log-driver": "json-file",
  "log-level": "info",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "mtu": 1500,
  "raw-logs": false,
  "registry-mirrors": [],
  "seccomp-profile": "builtin",
  "selinux-enabled": true,
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ],
  "swarm": {
    "default-addr-pool": [
      {
        "base": "10.0.0.0/8",
        "size": 24
      }
    ]
  },
  "tls": true,
  "tlsverify": true,
  "userland-proxy": false,
  "userns-remap": "default"
}
EOF

# Create required directories
mkdir -p /etc/docker/certs.d
chmod 700 /etc/docker/certs.d

# Restart Docker to apply changes
systemctl daemon-reload
systemctl restart docker

# Verify configuration
docker info 2>&1 | grep -E "(Security|Logging|Storage|Cgroup)"

echo "Docker daemon hardening complete"
```

#### 4.2 Docker Content Trust
```bash
#!/usr/bin/env bash
# docker-content-trust.sh - Enable Docker Content Trust

set -euo pipefail

# Enable Docker Content Trust
export DOCKER_CONTENT_TRUST=1
export DOCKER_CONTENT_TRUST_SERVER=https://notary.docker.io

echo "Docker Content Trust enabled"
echo "DOCKER_CONTENT_TRUST=1"
echo "DOCKER_CONTENT_TRUST_SERVER=https://notary.docker.io"

# Add to /etc/environment for persistence
if ! grep -q "DOCKER_CONTENT_TRUST" /etc/environment 2>/dev/null; then
    echo 'DOCKER_CONTENT_TRUST=1' >> /etc/environment
    echo 'DOCKER_CONTENT_TRUST_SERVER=https://notary.docker.io' >> /etc/environment
    echo "Content trust settings added to /etc/environment"
fi

# For systemd services, add to docker.service.d override
mkdir -p /etc/systemd/system/docker.service.d
cat > /etc/systemd/system/docker.service.d/override.conf << 'EOF'
[Service]
Environment="DOCKER_CONTENT_TRUST=1"
Environment="DOCKER_CONTENT_TRUST_SERVER=https://notary.docker.io"
EOF

systemctl daemon-reload
systemctl restart docker

echo "Docker Content Trust configuration complete"
```

#### 4.3 Rootless Docker Configuration
```bash
#!/usr/bin/env bash
# rootless-docker.sh - Configure rootless Docker mode

set -euo pipefail

# Install rootless Docker prerequisites
if command -v apt-get &>/dev/null; then
    apt-get update
    apt-get install -y uidmap
elif command -v yum &>/dev/null; then
    yum install -y shadow-utils
fi

# Configure rootless Docker
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock

# Install rootless Docker
curl -fsSL https://get.docker.com/rootless | sh

# Add to shell profile
cat >> ~/.bashrc << 'EOF'
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock
export PATH=/home/$(whoami)/bin:$PATH
EOF

echo "Rootless Docker configuration complete"
echo "Please restart your shell or run: source ~/.bashrc"
```

#### 4.4 Container Image Security
```bash
#!/usr/bin/env bash
# container-image-security.sh - Container image security scanning

set -euo pipefail

# Install Trivy for vulnerability scanning
install_trivy() {
    if ! command -v trivy &>/dev/null; then
        echo "Installing Trivy..."
        curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | \
            sh -s -- -b /usr/local/bin
    fi
}

# Scan Docker image
scan_image() {
    local image="$1"
    local severity="${2:-HIGH,CRITICAL}"
    
    echo "Scanning image: ${image}"
    trivy image \
        --severity "${severity}" \
        --vuln-type os,library \
        --exit-code 1 \
        "${image}" 2>&1 || {
        echo "Vulnerabilities found in ${image}"
        return 1
    }
    echo "No critical vulnerabilities found in ${image}"
}

# Generate SBOM (Software Bill of Materials)
generate_sbom() {
    local image="$1"
    local output="${2:-sbom.spdx.json}"
    
    echo "Generating SBOM for: ${image}"
    trivy image \
        --format spdx-json \
        --output "${output}" \
        "${image}"
    
    echo "SBOM saved to: ${output}"
}

# Check image signatures
verify_signature() {
    local image="$1"
    
    echo "Verifying signature for: ${image}"
    
    # Using Cosign for signature verification
    if command -v cosign &>/dev/null; then
        cosign verify \
            --key cosign.pub \
            "${image}" 2>&1 || {
            echo "Signature verification failed for ${image}"
            return 1
        }
        echo "Signature verified for ${image}"
    else
        echo "Cosign not installed, skipping signature verification"
    fi
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_trivy
    
    # Scan all local images
    if command -v docker &>/dev/null; then
        for image in $(docker images --format '{{.Repository}}:{{.Tag}}' | grep -v '<none>'); do
            scan_image "${image}" || true
        done
    fi
fi
```

### 5. Access Control and Authentication

#### 5.1 SSH Hardening
```bash
#!/usr/bin/env bash
# ssh-hardening.sh - Configure SSH daemon security

set -euo pipefail

SSH_CONFIG="/etc/ssh/sshd_config"
SSH_BACKUP="${SSH_CONFIG}.backup.$(date +%Y%m%d)"

# Backup original SSH config
cp "${SSH_CONFIG}" "${SSH_BACKUP}"

# SSH Hardening Parameters
declare -A SSH_PARAMS=(
    ["Protocol"]="2"
    ["PermitRootLogin"]="no"
    ["MaxAuthTries"]="3"
    ["MaxSessions"]="2"
    ["ClientAliveInterval"]="300"
    ["ClientAliveCountMax"]="2"
    ["LoginGraceTime"]="60"
    ["X11Forwarding"]="no"
    ["PermitTunnel"]="no"
    ["AllowAgentForwarding"]="no"
    ["AllowTcpForwarding"]="no"
    ["GatewayPorts"]="no"
    ["PermitEmptyPasswords"]="no"
    ["PasswordAuthentication"]="no"
    ["PubkeyAuthentication"]="yes"
    ["IgnoreRhosts"]="yes"
    ["HostbasedAuthentication"]="no"
    ["Port"]="22"
    ["Banner"]="/etc/issue.net"
    ["UsePAM"]="yes"
    ["KexAlgorithms"]="curve25519-sha256,email,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512"
    ["Ciphers"]="email,email,email,aes256-ctr,aes192-ctr,aes128-ctr"
    ["MACs"]="email,email,email"
)

# Apply SSH parameters
for key in "${!SSH_PARAMS[@]}"; do
    value="${SSH_PARAMS[$key]}"
    
    if grep -q "^${key}" "${SSH_CONFIG}"; then
        sed -i "s/^${key}.*/${key} ${value}/" "${SSH_CONFIG}"
    else
        echo "${key} ${value}" >> "${SSH_CONFIG}"
    fi
done

# Remove dangerous options
sed -i '/^#.*Banner/d' "${SSH_CONFIG}"
sed -i '/^#.*PermitRootLogin/d' "${SSH_CONFIG}"

# Create login banner
cat > /etc/issue.net << 'EOF'
#############################################################
#                                                           #
#  WARNING: Unauthorized access to this system is prohibited #
#  and will be prosecuted to the fullest extent of the law.  #
#                                                           #
#  All activities are logged and monitored.                  #
#                                                           #
#############################################################
EOF

# Restart SSH service
systemctl restart sshd

# Verify configuration
echo "SSH Hardening Applied:"
echo "======================"
grep -E "^(Protocol|PermitRootLogin|PasswordAuthentication|PubkeyAuthentication)" "${SSH_CONFIG}"

echo ""
echo "SSH configuration backed up to: ${SSH_BACKUP}"
echo "SSH hardening complete"
```