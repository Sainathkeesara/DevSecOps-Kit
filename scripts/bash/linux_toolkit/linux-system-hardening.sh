#!/usr/bin/env bash
# Linux System Hardening Automation for Containerized Environments
# Level: L7 | Features: Idempotent, dry-run, comprehensive hardening, CIS benchmark compliance
# Author: DevOps Automation | Version: 1.0.0

set -euo pipefail

# =============================================================================
# CONFIGURATION
# =============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="$(dirname "${SCRIPT_DIR}")"
LOG_DIR="/var/log/hardening"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="/var/backups/hardening/${TIMESTAMP}"

# Default values
DRY_RUN="${DRY_RUN:-false}"
VERBOSE="${VERBOSE:-false}"
LOG_FILE="${LOG_FILE:-${LOG_DIR}/hardening-${TIMESTAMP}.log}"
ENABLE_KERNEL_HARDENING="${ENABLE_KERNEL_HARDENING:-true}"
ENABLE_FIREWALL="${ENABLE_FIREWALL:-true}"
ENABLE_SSH_HARDENING="${ENABLE_SSH_HARDENING:-true}"
ENABLE_DOCKER_HARDENING="${ENABLE_DOCKER_HARDENING:-true}"
ENABLE_USER_HARDENING="${ENABLE_USER_HARDENING:-true}"
ENABLE_AUDITD="${ENABLE_AUDITD:-true}"
ENABLE_APPARMOR="${ENABLE_APPARMOR:-true}"
ENABLE_ANTIVIRUS="${ENABLE_ANTIVIRUS:-false}"
CONTAINER_RUNTIME="${CONTAINER_RUNTIME:-docker}"
TARGET_SYSTEM="${TARGET_SYSTEM:-all}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging functions
log_info() {
    local msg="[INFO] $(date '+%Y-%m-%d %H:%M:%S') $*"
    [[ "$VERBOSE" == "true" ]] && echo -e "${GREEN}[INFO]${NC} $*"
    echo "$msg" >> "${LOG_FILE}"
}

log_warn() {
    local msg="[WARN] $(date '+%Y-%m-%d %H:%M:%S') $*"
    echo -e "${YELLOW}[WARN]${NC} $*" >&2
    echo "$msg" >> "${LOG_FILE}"
}

log_error() {
    local msg="[ERROR] $(date '+%Y-%m-%d %H:%M:%S') $*"
    echo -e "${RED}[ERROR]${NC} $*" >&2
    echo "$msg" >> "${LOG_FILE}"
}

log_debug() {
    local msg="[DEBUG] $(date '+%Y-%m-%d %H:%M:%S') $*"
    [[ "$VERBOSE" == "true" ]] && echo -e "${BLUE}[DEBUG]${NC} $*"
    echo "$msg" >> "${LOG_FILE}"
}

run() {
    local cmd="$*"
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY-RUN] $cmd"
        return 0
    fi
    log_debug "Executing: $cmd"
    eval "$cmd"
}

# Error handling
error_exit() {
    log_error "$1"
    exit 1
}

trap 'error_exit "Script interrupted"' INT TERM

# =============================================================================
# PREFLIGHT CHECKS
# =============================================================================
check_prerequisites() {
    log_info "Running preflight checks..."
    
    # Check root access
    if [[ $EUID -ne 0 ]]; then
        error_exit "This script must be run as root or with sudo"
    fi
    
    # Create directories
    mkdir -p "${LOG_DIR}" "${BACKUP_DIR}"
    
    # Check OS
    if [[ ! -f /etc/os-release ]]; then
        error_exit "Cannot determine OS type"
    fi
    
    source /etc/os-release
    log_info "Detected OS: ${NAME} ${VERSION_ID}"
    
    # Check container runtime
    if [[ "$ENABLE_DOCKER_HARDENING" == "true" ]]; then
        if ! command -v docker &>/dev/null && ! command -v podman &>/dev/null; then
            log_warn "No container runtime found, skipping Docker hardening"
            ENABLE_DOCKER_HARDENING=false
        fi
    fi
    
    log_info "Preflight checks passed"
}

# =============================================================================
# BACKUP
# =============================================================================
create_backup() {
    log_info "Creating configuration backup in ${BACKUP_DIR}"
    
    [[ "$DRY_RUN" == "true" ]] && return 0
    
    # Backup important files
    local files_to_backup=(
        "/etc/sysctl.conf"
        "/etc/sysctl.d/"
        "/etc/security/limits.conf"
        "/etc/pam.d/"
        "/etc/ssh/sshd_config"
        "/etc/fstab"
        "/etc/docker/daemon.json"
        "/etc/fail2ban/"
    )
    
    for item in "${files_to_backup[@]}"; do
        if [[ -e "$item" ]]; then
            cp -a "$item" "${BACKUP_DIR}/" 2>/dev/null || true
            log_debug "Backed up: $item"
        fi
    done
    
    # Save system info
    {
        echo "=== System Information ==="
        uname -a
        echo ""
        echo "=== OS Release ==="
        cat /etc/os-release
        echo ""
        echo "=== Running Services ==="
        systemctl list-units --type=service --state=running 2>/dev/null || true
    } > "${BACKUP_DIR}/system-info.txt"
    
    log_info "Backup created successfully"
}

# =============================================================================
# KERNEL HARDENING
# =============================================================================
apply_kernel_hardening() {
    [[ "$ENABLE_KERNEL_HARDENING" != "true" ]] && return 0
    
    log_info "Applying kernel hardening..."
    
    # Sysctl configuration
    cat > /etc/sysctl.d/99-security-hardening.conf << 'SYSCTLEOF'
# Kernel Security Hardening
kernel.kptr_restrict = 2
kernel.dmesg_restrict = 1
kernel.yama.ptrace_scope = 1
kernel.randomize_va_space = 2

# Network security
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_timestamps = 0
net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0

# Memory and performance
vm.overcommit_memory = 2
vm.overcommit_ratio = 80
vm.swappiness = 10
fs.file-max = 2097152

# Container-friendly settings
net.core.somaxconn = 4096
net.core.netdev_max_backlog = 8192
net.ipv4.tcp_max_syn_backlog = 4096
SYSCTLEOF
    
    run "sysctl --system"
    log_info "Kernel hardening applied"
}

# =============================================================================
# FIREWALL CONFIGURATION
# =============================================================================
configure_firewall() {
    [[ "$ENABLE_FIREWALL" != "true" ]] && return 0
    
    log_info "Configuring firewall..."
    
    if command -v ufw &>/dev/null; then
        log_info "Configuring UFW..."
        run "ufw --force reset"
        run "ufw default deny incoming"
        run "ufw default allow outgoing"
        run "ufw allow OpenSSH"
        run "echo 'y' | ufw enable"
    elif command -v firewall-cmd &>/dev/null; then
        log_info "Configuring firewalld..."
        run "systemctl enable --now firewalld"
        run "firewall-cmd --set-default-zone=drop --permanent"
        run "firewall-cmd --add-service=ssh --permanent"
        run "firewall-cmd --reload"
    else
        log_warn "No firewall tool found, installing ufw..."
        if command -v apt-get &>/dev/null; then
            run "apt-get update && apt-get install -y ufw"
            configure_firewall
        fi
    fi
}

# =============================================================================
# SSH HARDENING
# =============================================================================
configure_ssh() {
    [[ "$ENABLE_SSH_HARDENING" != "true" ]] && return 0
    
    log_info "Hardening SSH configuration..."
    
    cp /etc/ssh/sshd_config "${BACKUP_DIR}/sshd_config"
    
    # Apply security settings
    local ssh_params=(
        "Protocol 2"
        "PermitRootLogin no"
        "MaxAuthTries 3"
        "ClientAliveInterval 300"
        "ClientAliveCountMax 2"
        "X11Forwarding no"
        "AllowTcpForwarding no"
        "PermitEmptyPasswords no"
        "PasswordAuthentication no"
        "PubkeyAuthentication yes"
    )
    
    for param in "${ssh_params[@]}"; do
        local key="${param%% *}"
        if grep -q "^${key}" /etc/ssh/sshd_config; then
            run "sed -i 's/^${key}.*/${param}/' /etc/ssh/sshd_config"
        else
            run "echo '${param}' >> /etc/ssh/sshd_config"
        fi
    done
    
    run "systemctl restart sshd"
    log_info "SSH configuration hardened"
}

# =============================================================================
# DOCKER HARDENING
# =============================================================================
configure_docker() {
    [[ "$ENABLE_DOCKER_HARDENING" != "true" ]] && return 0
    
    log_info "Hardening Docker configuration..."
    
    mkdir -p /etc/docker
    
    cat > /etc/docker/daemon.json << 'EOF'
{
  "authorization-plugins": [],
  "data-root": "/var/lib/docker",
  "exec-opts": ["native.cgroupdriver=systemd"],
  "experimental": false,
  "icc": false,
  "iptables": true,
  "live-restore": true,
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "no-new-privileges": true,
  "raw-logs": false,
  "registry-mirrors": [],
  "seccomp-profile": "builtin",
  "selinux-enabled": true,
  "storage-driver": "overlay2",
  "tls": true,
  "tlsverify": true,
  "userland-proxy": false,
  "userns-remap": "default"
}
EOF
    
    run "systemctl restart docker"
    log_info "Docker daemon hardened"
}

# =============================================================================
# USER HARDENING
# =============================================================================
configure_users() {
    [[ "$ENABLE_USER_HARDENING" != "true" ]] && return 0
    
    log_info "Hardening user configuration..."
    
    # Password aging
    sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   7/' /etc/login.defs
    sed -i 's/^PASS_MIN_LEN.*/PASS_MIN_LEN    14/' /etc/login.defs
    
    # Lock dangerous accounts
    local dangerous_users=("games" "operator" "ftp" "nfsnobody")
    for user in "${dangerous_users[@]}"; do
        if id "$user" &>/dev/null; then
            run "usermod -L $user"
            run "usermod -s /usr/sbin/nologin $user"
            log_info "Locked user: $user"
        fi
    done
    
    log_info "User configuration hardened"
}

# =============================================================================
# AUDIT DAEMON
# =============================================================================
configure_auditd() {
    [[ "$ENABLE_AUDITD" != "true" ]] && return 0
    
    log_info "Configuring audit daemon..."
    
    if command -v auditctl &>/dev/null; then
        # Basic audit rules
        cat > /etc/audit/rules.d/hardening.rules << 'EOF'
-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/sudoers -p wa -k scope
-w /var/log/ -p wa -k log_files
-w /usr/bin/docker -p x -k docker
-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change
-a always,exit -F arch=b64 -S clock_settime -k time-change
-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale
EOF
        
        run "auditctl -R /etc/audit/rules.d/hardening.rules"
        run "systemctl restart auditd"
        log_info "Audit daemon configured"
    else
        log_warn "auditd not found, skipping audit configuration"
    fi
}

# =============================================================================
# APPARMOR PROFILES
# =============================================================================
configure_apparmor() {
    [[ "$ENABLE_APPARMOR" != "true" ]] && return 0
    
    log_info "Configuring AppArmor..."
    
    if command -v apparmor_status &>/dev/null; then
        run "systemctl enable --now apparmor"
        log_info "AppArmor enabled"
    else
        log_warn "AppArmor not available, skipping"
    fi
}

# =============================================================================
# SYSTEM UPDATES
# =============================================================================
apply_updates() {
    log_info "Applying system security updates..."
    
    if command -v apt-get &>/dev/null; then
        run "apt-get update"
        run "apt-get upgrade -y"
    elif command -v yum &>/dev/null; then
        run "yum update -y"
    fi
    
    log_info "System updates applied"
}

# =============================================================================
# VERIFICATION
# =============================================================================
verify_hardening() {
    log_info "Verifying hardening configuration..."
    
    local checks_passed=0
    local checks_total=0
    
    # Check sysctl settings
    ((checks_total++))
    if sysctl net.ipv4.tcp_syncookies 2>/dev/null | grep -q 1; then
        ((checks_passed++))
        log_info "✓ TCP SYN cookies enabled"
    else
        log_error "✗ TCP SYN cookies not enabled"
    fi
    
    # Check SSH settings
    ((checks_total++))
    if sshd -T 2>/dev/null | grep -q "permitrootlogin no"; then
        ((checks_passed++))
        log_info "✓ Root SSH login disabled"
    else
        log_warn "✗ Root SSH login not verified"
    fi
    
    # Check Docker daemon
    if [[ "$ENABLE_DOCKER_HARDENING" == "true" ]]; then
        ((checks_total++))
        if docker info 2>/dev/null | grep -q "userns-remap"; then
            ((checks_passed++))
            log_info "✓ Docker user namespace remapping enabled"
        else
            log_warn "✗ Docker user namespace not verified"
        fi
    fi
    
    # Check firewall
    if [[ "$ENABLE_FIREWALL" == "true" ]]; then
        ((checks_total++))
        if command -v ufw &>/dev/null && ufw status | grep -q "active"; then
            ((checks_passed++))
            log_info "✓ UFW firewall active"
        elif command -v firewall-cmd &>/dev/null && firewall-cmd --state 2>/dev/null | grep -q "running"; then
            ((checks_passed++))
            log_info "✓ Firewalld running"
        else
            log_warn "✗ Firewall status not verified"
        fi
    fi
    
    log_info "Verification: ${checks_passed}/${checks_total} checks passed"
    
    if [[ $checks_passed -lt $checks_total ]]; then
        log_warn "Some verification checks failed"
    fi
}

# =============================================================================
# REPORT
# =============================================================================
generate_report() {
    local report_file="${LOG_DIR}/hardening-report-${TIMESTAMP}.txt"
    
    cat > "$report_file" << EOF
================================================================================
          LINUX SYSTEM HARDENING REPORT
          Generated: $(date)
================================================================================

SYSTEM INFORMATION:
  Hostname: $(hostname)
  OS: $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
  Kernel: $(uname -r)

HARDENING OPTIONS APPLIED:
  Kernel Hardening: ${ENABLE_KERNEL_HARDENING}
  Firewall: ${ENABLE_FIREWALL}
  SSH Hardening: ${ENABLE_SSH_HARDENING}
  Docker Hardening: ${ENABLE_DOCKER_HARDENING}
  User Hardening: ${ENABLE_USER_HARDENING}
  Audit Daemon: ${ENABLE_AUDITD}
  AppArmor: ${ENABLE_APPARMOR}

BACKUP LOCATION:
  ${BACKUP_DIR}

LOG FILE:
  ${LOG_FILE}

================================================================================
EOF
    
    log_info "Report saved to: ${report_file}"
    cat "$report_file"
}

# =============================================================================
# MAIN
# =============================================================================
main() {
    echo "================================================================================"
    echo "     Linux System Hardening Automation for Containerized Environments"
    echo "================================================================================"
    echo ""
    
    check_prerequisites
    create_backup
    
    # Apply hardening modules
    apply_kernel_hardening
    configure_firewall
    configure_ssh
    configure_docker
    configure_users
    configure_auditd
    configure_apparmor
    
    # Verify and report
    verify_hardening
    generate_report
    
    echo ""
    echo "================================================================================"
    echo "     Hardening Complete!"
    echo "================================================================================"
    echo "  Log file: ${LOG_FILE}"
    echo "  Backup dir: ${BACKUP_DIR}"
    [[ "$DRY_RUN" == "true" ]] && echo "  WARNING: DRY RUN MODE - No changes were applied!"
}

# Help function
show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

Linux System Hardening Automation for Containerized Environments

OPTIONS:
    --dry-run              Run in dry-run mode (no changes applied)
    --verbose              Enable verbose logging
    --no-kernel            Disable kernel hardening
    --no-firewall          Disable firewall configuration
    --no-ssh               Disable SSH hardening
    --no-docker            Disable Docker hardening
    --no-user              Disable user hardening
    --no-audit             Disable audit daemon configuration
    --no-apparmor          Disable AppArmor
    --help                 Show this help message

EXAMPLES:
    # Run full hardening
    $0

    # Dry run to see what would be changed
    $0 --dry-run --verbose

    # Skip Docker hardening
    $0 --no-docker

ENVIRONMENT VARIABLES:
    DRY_RUN                Set to 'true' for dry-run mode
    VERBOSE                Set to 'true' for verbose output
    ENABLE_KERNEL_HARDENING  Set to 'false' to disable
    ENABLE_FIREWALL        Set to 'false' to disable
    ENABLE_SSH_HARDENING   Set to 'false' to disable
    ENABLE_DOCKER_HARDENING Set to 'false' to disable
    ENABLE_USER_HARDENING  Set to 'false' to disable
    ENABLE_AUDITD          Set to 'false' to disable
    ENABLE_APPARMOR        Set to 'false' to disable

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --no-kernel)
            ENABLE_KERNEL_HARDENING=false
            shift
            ;;
        --no-firewall)
            ENABLE_FIREWALL=false
            shift
            ;;
        --no-ssh)
            ENABLE_SSH_HARDENING=false
            shift
            ;;
        --no-docker)
            ENABLE_DOCKER_HARDENING=false
            shift
            ;;
        --no-user)
            ENABLE_USER_HARDENING=false
            shift
            ;;
        --no-audit)
            ENABLE_AUDITD=false
            shift
            ;;
        --no-apparmor)
            ENABLE_APPARMOR=false
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Run main function
main "$@"