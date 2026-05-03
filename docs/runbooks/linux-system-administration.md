# Linux: System Administration Documentation and Runbook Automation

## Purpose
This guide provides comprehensive Linux system administration documentation for automating common sysadmin tasks including user management, service management, disk/filesystem management, network configuration, process monitoring, log management, backup/restore, performance monitoring, and security hardening. It delivers standardized runbooks with production-ready automation scripts following Linux best practices and enterprise standards.

## When to Use
- Automating routine Linux system administration tasks
- Onboarding new sysadmins with standardized procedures
- Implementing infrastructure-as-code for system management
- Creating audit-ready runbooks for compliance requirements
- Building self-service automation for DevOps teams
- Standardizing system administration across Linux distributions
- Implementing disaster recovery procedures
- Building monitoring and alerting for system health

## Prerequisites
- Target Linux systems: RHEL/CentOS 8+, Ubuntu 20.04+, Debian 10+
- Root/sudo access on target systems
- SSH key-based authentication configured
- Bash 4.0+ for script execution
- Python 3.8+ (optional, for advanced automation)
- Ansible 2.9+ (optional, for fleet management)
- Network connectivity for tool downloads
- Sufficient disk space for logs and backups (recommend 20GB+)

## Steps

### 1. User Management Runbook

#### 1.1 User Creation with Audit Trail
```bash
#!/usr/bin/env bash
# user-create.sh - Create system users with audit trail

set -euo pipefail

DRY_RUN="${DRY_RUN:-false}"
AUDIT_LOG="/var/log/sysadmin/user-management.log"

log_action() {
    local user="$1"
    local action="$2"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[${timestamp}] ${action}: ${user} (by: ${USER:-unknown}, PID: $$)" >> "${AUDIT_LOG}"
}

create_user() {
    local username="$1"
    local uid="${2:-}"
    local shell="${3:-/bin/bash}"
    local home_dir="${4:-/home}"
    
    if [[ -z "$username" ]]; then
        echo "Error: Username required"
        return 1
    fi
    
    if id "${username}" &>/dev/null; then
        echo "User ${username} already exists"
        return 0
    fi
    
    local useradd_opts="--create-home --shell ${shell}"
    if [[ -n "$uid" ]]; then
        useradd_opts="${useradd_opts} --uid ${uid}"
    fi
    
    if [[ "${DRY_RUN}" == "true" ]]; then
        echo "[DRY-RUN] Would execute: useradd ${useradd_opts} ${username}"
        log_action "${username}" "CREATE_DRY_RUN"
    else
        useradd ${useradd_opts} "${username}"
        log_action "${username}" "CREATE"
        echo "User ${username} created successfully"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    USAGE="Usage: $0 <username> [uid] [shell] [home] [--dry-run]"
    if [[ $# -lt 1 ]]; then
        echo "${USAGE}"
        exit 1
    fi
    
    args=("$@")
    for i in "${!args[@]}"; do
        if [[ "${args[$i]}" == "--dry-run" ]]; then
            DRY_RUN="true"
            unset 'args[i]'
        fi
    done
    
    username="${args[0]:-}"
    uid="${args[1]:-}"
    shell="${args[2]:-/bin/bash}"
    home="${args[3]:-/home}"
    
    create_user "${username}" "${uid}" "${shell}" "${home}"
fi
```

#### 1.2 User Modification and Group Management
```bash
#!/usr/bin/env bash
# user-modify.sh - Modify users and group membership

set -euo pipefail

modify_user() {
    local username="$1"
    local action="$2"
    local value="$3"
    
    case "${action}" in
        add_group)
            usermod -aG "${value}" "${username}"
            echo "Added ${username} to group ${value}"
            ;;
        remove_group)
            gpasswd -d "${username}" "${value}"
            echo "Removed ${username} from group ${value}"
            ;;
        lock)
            usermod -L "${username}"
            echo "Locked user ${username}"
            ;;
        unlock)
            usermod -U "${username}"
            echo "Unlocked user ${username}"
            ;;
        set_shell)
            usermod -s "${value}" "${username}"
            echo "Changed shell for ${username} to ${value}"
            ;;
        expire)
            usermod -e "${value}" "${username}"
            echo "Set expiration for ${username} to ${value}"
            ;;
        *)
            echo "Unknown action: ${action}"
            return 1
            ;;
    esac
}

#### 1.3 Password Policy Enforcement
```bash
#!/usr/bin/env bash
# password-policy.sh - Enforce password policies

set -euo pipefail

MIN_LENGTH=12
MAX_DAYS=90
WARN_DAYS=7

enforce_password_policy() {
    local user="$1"
    
    if ! id "${user}" &>/dev/null; then
        echo "User ${user} does not exist"
        return 1
    fi
    
    chgmod=$(grep "^${user}:" /etc/shadow | cut -d: -f5)
    
    if [[ -n "$chgmod" ]]; then
        days_since_change=$(( $(date +%s) / 86400 - chgmod ))
        
        if [[ "$days_since_change" -gt $(( MAX_DAYS - WARN_DAYS )) ]]; then
            echo "WARNING: Password for ${user} will expire in $(( MAX_DAYS - days_since_change )) days"
        fi
        
        if [[ "$days_since_change" -gt "${MAX_DAYS}" ]]; then
            echo "ERROR: Password for ${user} has expired"
            return 1
        fi
    fi
}

echo "Password policy checks complete"
```

### 2. Service Management Runbook

#### 2.1 Service Health Check and Restart
```bash
#!/usr/bin/env bash
# service-health.sh - Check and restart system services

set -euo pipefail

SERVICE_NAME="${1:-}"
ACTION="${2:-status}"
MAX_RESTARTS=3
RESTART_COOLDOWN=30

get_service_status() {
    local service="$1"
    
    if command -v systemctl &>/dev/null; then
        systemctl is-active "${service}" 2>/dev/null
    elif command -v service &>/dev/null; then
        service "${service}" status &>/dev/null
    fi
}

restart_service() {
    local service="$1"
    local restart_count=0
    
    while [[ "$restart_count" -lt "${MAX_RESTARTS}" ]]; do
        echo "Attempting to restart ${service} (attempt $(( restart_count + 1 ))/${MAX_RESTARTS})"
        
        if command -v systemctl &>/dev/null; then
            systemctl restart "${service}"
        elif command -v service &>/dev/null; then
            service "${service}" restart
        fi
        
        sleep 5
        
        if get_service_status "${service}"; then
            echo "Service ${service} restarted successfully"
            return 0
        fi
        
        ((restart_count++))
        sleep "${RESTART_COOLDOWN}"
    done
    
    echo "ERROR: Failed to restart ${service} after ${MAX_RESTARTS} attempts"
    return 1
}

if [[ -n "${SERVICE_NAME}" ]]; then
    case "${ACTION}" in
        status)
            get_service_status "${SERVICE_NAME}"
            ;;
        restart)
            restart_service "${SERVICE_NAME}"
            ;;
        *)
            echo "Usage: $0 <service> [status|restart]"
            ;;
    esac
fi
```

#### 2.2 Service Dependency Analysis
```bash
#!/usr/bin/env bash
# service-deps.sh - Analyze service dependencies

set -euo pipefail

show_dependencies() {
    local service="$1"
    
    if command -v systemctl &>/dev/null; then
        echo "=== Units required by ${service} ==="
        systemctl list-dependencies "${service}" --reverse
        
        echo ""
        echo "=== Units that require ${service} ==="
        systemctl list-dependencies "${service}" --reverse --all
    fi
}
```

### 3. Disk and Filesystem Management Runbook

#### 3.1 Disk Usage Analysis
```bash
#!/usr/bin/env bash
# disk-usage.sh - Analyze disk usage with alerts

set -euo pipefail

THRESHOLD_WARNING=80
THRESHOLD_CRITICAL=90

check_disk_usage() {
    local mount_point="${1:-/}"
    
    local usage
    usage=$(df -P "${mount_point}" | awk 'NR==2 {print $5}' | tr -d '%')
    
    local device
    device=$(df -P "${mount_point}" | awk 'NR==2 {print $1}')
    
    if [[ "$usage" -ge "${THRESHOLD_CRITICAL}" ]]; then
        echo "CRITICAL: ${mount_point} (${device}) is ${usage}% full"
        return 2
    elif [[ "$usage" -ge "${THRESHOLD_WARNING}" ]]; then
        echo "WARNING: ${mount_point} (${device}) is ${usage}% full"
        return 1
    else
        echo "OK: ${mount_point} (${device}) is ${usage}% full"
        return 0
    fi
}

find_large_directories() {
    local path="${1:-.}"
    local limit="${2:-1G}"
    
    echo "=== Directories larger than ${limit} in ${path} ==="
    du -hScx "${path}" 2>/dev/null | sort -rh | head -20
}

analyze_inodes() {
    local mount_point="${1:-/}"
    
    local usage
    usage=$(df -Pi "${mount_point}" | awk 'NR==2 {print $5}' | tr -d '%')
    
    echo "Inode usage for ${mount_point}: ${usage}%"
    
    if [[ "$usage" -gt 90 ]]; then
        echo "WARNING: High inode usage detected"
    fi
}

#### 3.2 LVM Management
```bash
#!/usr/bin/env bash
# lvm-manage.sh - LVM volume management

set -euo pipefail

create_lvm_volume() {
    local vg_name="$1"
    local lv_name="$2"
    local size="$3"
    
    if ! vgs "${vg_name}" &>/dev/null; then
        echo "Volume group ${vg_name} does not exist"
        return 1
    fi
    
    lvcreate -L "${size}" -n "${lv_name}" "${vg_name}"
    mkfs.ext4 "/dev/${vg_name}/${lv_name}"
    
    echo "Logical volume /dev/${vg_name}/${lv_name} created"
}

extend_lvm_volume() {
    local vg_name="$1"
    local lv_name="$2"
    local size="$3"
    
    lvextend -L +"${size}" "/dev/${vg_name}/${lv_name}"
    resize2fs "/dev/${vg_name}/${lv_name}"
    
    echo "Logical volume extended"
}

#### 3.3 Filesystem Check and Repair
```bash
#!/usr/bin/env bash
# fsck-run.sh - Filesystem check and repair

set -euo pipefail

DRY_RUN="${DRY_RUN:-false}"

check_filesystem() {
    local device="$1"
    local force="${2:-false}"
    
    if mountpoint -q "$(mount | grep "${device}" | awk '{print $3}')"; then
        echo "ERROR: ${device} is mounted. Unmount first."
        return 1
    fi
    
    local opts="-fy"
    if [[ "${force}" == "true" ]]; then
        opts="-fay"
    fi
    
    if [[ "${DRY_RUN}" == "true" ]]; then
        echo "[DRY-RUN] Would execute: fsck ${opts} ${device}"
    else
        fsck ${opts} "${device}"
    fi
}
```

### 4. Network Configuration Runbook

#### 4.1 Network Interface Management
```bash
#!/usr/bin/env bash
# network-iface.sh - Manage network interfaces

set -euo pipefail

list_interfaces() {
    echo "=== Active Network Interfaces ==="
    ip link show up
    
    echo ""
    echo "=== IP Addresses ==="
    ip addr show
    
    echo ""
    echo "=== Routing Table ==="
    ip route show
}

configure_interface() {
    local iface="$1"
    local ip_cidr="$2"
    local gateway="$3"
    
    ip addr add "${ip_cidr}" dev "${iface}"
    ip link set "${iface}" up
    
    if [[ -n "${gateway}" ]]; then
        ip route add default via "${gateway}"
    fi
}

#### 4.2 Firewall Management
```bash
#!/usr/bin/env bash
# firewall-manage.sh - Manage firewall rules

set -euo pipefail

manage_firewall() {
    local action="$1"
    local port="$2"
    local protocol="${3:-tcp}"
    local zone="${4:-public}"
    
    if command -v firewall-cmd &>/dev/null; then
        case "${action}" in
            allow)
                firewall-cmd --zone="${zone}" --add-port="${port}/${protocol}" --permanent
                firewall-cmd --zone="${zone}" --add-port="${port}/${protocol}"
                ;;
            deny)
                firewall-cmd --zone="${zone}" --remove-port="${port}/${protocol}" --permanent
                ;;
            reload)
                firewall-cmd --reload
                ;;
        esac
    elif command -v ufw &>/dev/null; then
        case "${action}" in
            allow)
                ufw allow "${port}"/"${protocol}"
                ;;
            deny)
                ufw deny "${port}"/"${protocol}"
                ;;
        esac
    elif command -v iptables &>/dev/null; then
        case "${action}" in
            allow)
                iptables -A INPUT -p "${protocol}" --dport "${port}" -j ACCEPT
                ;;
            deny)
                iptables -A INPUT -p "${protocol}" --dport "${port}" -j DROP
                ;;
        esac
    fi
    
    echo "Firewall action '${action}' for port ${port}/${protocol} completed"
}
```

### 5. Process and Resource Management Runbook

#### 5.1 Process Monitoring
```bash
#!/usr/bin/env bash
# process-monitor.sh - Monitor running processes

set -euo pipefail

MONITOR_INTERVAL=60
CPU_THRESHOLD=80
MEM_THRESHOLD=80

monitor_processes() {
    echo "=== Top CPU Consumers ==="
    ps aux --sort=-%cpu | head -11
    
    echo ""
    echo "=== Top Memory Consumers ==="
    ps aux --sort=-%mem | head -11
    
    echo ""
    echo "=== Zombie Processes ==="
    ps aux | awk '$8 ~ /Z/ {print}'
    
    echo ""
    echo "=== Process Count by User ==="
    ps aux | awk 'NR>1 {print $1}' | sort | uniq -c | sort -rn
}

watch_process() {
    local process_name="$1"
    local duration="${2:-300}"
    
    local end_time
    end_time=$(( $(date +%s) + duration ))
    
    while [[ $(date +%s) -lt "$end_time" ]]; do
        echo "=== $(date '+%Y-%m-%d %H:%M:%S') ==="
        ps aux | grep "${process_name}" | grep -v grep
        
        sleep "${MONITOR_INTERVAL}"
    done
}

#### 5.2 Resource Limits Configuration
```bash
#!/usr/bin/env bash
# resource-limits.sh - Configure system resource limits

set -euo pipefail

configure_limits() {
    local user="$1"
    local limit_type="$2"
    local soft_limit="$3"
    local hard_limit="${4:-$3}"
    
    if [[ -n "$user" ]]; then
        sed -i "/^${user}/d" /etc/security/limits.conf
        echo "${user} ${limit_type} ${soft_limit} ${hard_limit}" >> /etc/security/limits.conf
    else
        echo "* ${limit_type} ${soft_limit} ${hard_limit}" >> /etc/security/limits.conf
    fi
    
    echo "Limits configured: ${user} ${limit_type} ${soft_limit} ${hard_limit}"
}

```

### 6. Log Management Runbook

#### 6.1 Log Rotation Configuration
```bash
#!/usr/bin/env bash
# log-rotate-config.sh - Configure log rotation

set -euo pipefail

configure_logrotate() {
    local log_file="$1"
    local max_size="${2:-100M}"
    local max_count="${3:-14}"
    local compress="${4:-true}"
    
    cat > /etc/logrotate.d/custom-"$(basename "${log_file}")" <<EOF
${log_file} {
    daily
    size ${max_size}
    rotate ${max_count}
    missingok
    notifempty
    compress
    delaycompress
    create 0640 root adm
    sharedscripts
    postrotate
        systemctl reload rsyslog > /dev/null 2>&1 || true
    endscript
}
EOF
    
    logrotate -d /etc/logrotate.d/custom-"$(basename "${log_file}")" 2>&1 | head -20
}
```

#### 6.2 Centralized Logging with journald
```bash
#!/usr/bin/env bash
# journald-config.sh - Configure systemd journald

set -euo pipefail

configure_journald() {
    local max_use="${1:-2G}"
    local max_file_size="${2:-200M}"
    local max_retention="${3:-7}"
    
    cat > /etc/systemd/journald.conf.d/custom.conf <<EOF
[Journal]
SystemMaxUse=${max_use}
SystemMaxFileSize=${max_file_size}
MaxRetentionSec=${max_retention}day
Storage=persistent
Compress=yes
Seal=yes
EOF
    
    systemctl restart systemd-journald
    echo "journald configured with max_use=${max_use}, max_file_size=${max_file_size}"
}
```

### 7. Backup and Restore Runbook

#### 7.1 System Backup Automation
```bash
#!/usr/bin/env bash
# system-backup.sh - Automated system backup

set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-/backup}"
DATE_STAMP=$(date +%Y%m%d-%H%M%S)
RETENTION_DAYS="${RETENTION_DAYS:-30}"

backup_system() {
    local backup_name="system-${DATE_STAMP}"
    local backup_path="${BACKUP_DIR}/${backup_name}"
    
    mkdir -p "${backup_path}"
    
    echo "Starting system backup to ${backup_path}"
    
    echo "Backing up /etc"
    tar -czpf "${backup_path}/etc.tar.gz" /etc
    
    echo "Backing up /var/spool"
    tar -czpf "${backup_path}/spool.tar.gz" /var/spool 2>/dev/null || true
    
    echo "Backing up /home"
    tar -czpf "${backup_path}/home.tar.gz" /home 2>/dev/null || true
    
    echo "Backing up installed packages"
    if command -v rpm &>/dev/null; then
        rpm -qa > "${backup_path}/packages.txt"
    elif command -v dpkg &>/dev/null; then
        dpkg --get-selections > "${backup_path}/packages.txt"
    fi
    
    echo "Creating backup manifest"
    cat > "${backup_path}/MANIFEST" <<EOF
Backup Date: ${DATE_STAMP}
Hostname: $(hostname)
OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2)
Kernel: $(uname -r)
EOF
    
    echo "Computing checksums"
    find "${backup_path}" -type f -exec sha256sum {} \; > "${backup_path}/checksums.txt"
    
    echo "Cleaning old backups"
    find "${BACKUP_DIR}" -maxdepth 1 -type d -mtime +"${RETENTION_DAYS}" -exec rm -rf {} \;
    
    echo "Backup complete: ${backup_path}"
    du -sh "${backup_path}"
}

#### 7.2 System Restore
```bash
#!/usr/bin/env bash
# system-restore.sh - System restore from backup

set -euo pipefail

DRY_RUN="${DRY_RUN:-false}"

restore_system() {
    local backup_path="$1"
    local component="${2:-all}"
    
    if [[ ! -d "${backup_path}" ]]; then
        echo "ERROR: Backup path ${backup_path} does not exist"
        return 1
    fi
    
    echo "Verifying backup integrity"
    cd "${backup_path}"
    sha256sum -c checksums.txt || {
        echo "ERROR: Checksum verification failed"
        return 1
    }
    
    if [[ "${DRY_RUN}" == "true" ]]; then
        echo "[DRY-RUN] Would restore ${component} from ${backup_path}"
        return 0
    fi
    
    case "${component}" in
        etc)
            tar -xzpf "${backup_path}/etc.tar.gz" -C /
            ;;
        home)
            tar -xzpf "${backup_path}/home.tar.gz" -C /
            ;;
        all)
            tar -xzpf "${backup_path}/etc.tar.gz" -C /
            tar -xzpf "${backup_path}/home.tar.gz" -C /
            ;;
    esac
    
    echo "Restore complete for ${component}"
}

```

### 8. Performance Monitoring Runbook

#### 8.1 System Performance Analysis
```bash
#!/usr/bin/env bash
# perf-analyze.sh - Analyze system performance

set -euo pipefail

analyze_performance() {
    echo "=== CPU Load ==="
    uptime
    cat /proc/loadavg
    
    echo ""
    echo "=== Memory Usage ==="
    free -h
    
    echo ""
    echo "=== Disk I/O ==="
    iostat -x 1 1 2>/dev/null || cat /proc/diskstats | head -10
    
    echo ""
    echo "=== Network Statistics ==="
    netstat -s 2>/dev/null || ss -s
    
    echo ""
    echo "=== Top Processes by Resource ==="
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -15
}

collect_metrics() {
    local output_file="$1"
    
    echo "=== Performance Metrics ===" > "${output_file}"
    echo "Timestamp: $(date)" >> "${output_file}"
    echo "" >> "${output_file}"
    
    echo "=== CPU ===" >> "${output_file}"
    head -1 /proc/loadavg >> "${output_file}"
    mpstat 1 1 2>/dev/null >> "${output_file}" || true
    
    echo "=== Memory ===" >> "${output_file}"
    free >> "${output_file}"
    
    echo "=== Disk ===" >> "${output_file}"
    df -h >> "${output_file}"
    
    echo "Metrics saved to ${output_file}"
}
```

### 9. Security Hardening Runbook

#### 9.1 Security Audit
```bash
#!/usr/bin/env bash
# security-audit.sh - Security audit checks

set -euo pipefail

run_security_audit() {
    echo "=== Security Audit ==="
    
    echo "Checking for world-writable files..."
    find / -perm -0002 -type f 2>/dev/null | head -20
    
    echo ""
    echo "Checking for orphaned files..."
    find / -nouser -o -nogroup 2>/dev/null | head -20
    
    echo ""
    echo "Checking for UID 0 users besides root..."
    awk -F: '($3 == "0") {print $1}' /etc/passwd
    
    echo ""
    echo "Checking for default passwords..."
    grep -E "^(root|admin):" /etc/shadow 2>/dev/null || true
    
    echo ""
    echo "Checking open ports..."
    ss -tunlp 2>/dev/null || netstat -tunlp 2>/dev/null
    
    echo ""
    echo "Checking running services..."
    systemctl list-units --type=service --state=running | head -20
}

#### 9.2 SSH Hardening
```bash
#!/usr/bin/env bash
# ssh-harden.sh - SSH security hardening

set -euo pipefail

harden_ssh() {
    local sshd_config="/etc/ssh/sshd_config"
    
    cp "${sshd_config}" "${sshd_config}.bak"
    
    sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' "${sshd_config}"
    sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' "${sshd_config}"
    sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' "${sshd_config}"
    sed -i 's/^#*MaxAuthTries.*/MaxAuthTries 3/' "${sshd_config}"
    sed -i 's/^#*ClientAliveInterval.*/ClientAliveInterval 300/' "${sshd_config}"
    sed -i 's/^#*ClientAliveCountMax.*/ClientAliveCountMax 2/' "${sshd_config}"
    
    if ! grep "^AllowUsers" "${sshd_config}" &>/dev/null; then
        echo "AllowUsers" >> "${sshd_config}"
    fi
    
    sshd -t && {
        systemctl reload sshd
        echo "SSH hardened successfully"
    } || {
        echo "ERROR: SSH configuration test failed"
        mv "${sshd_config}.bak" "${sshd_config}"
        return 1
    }
}
```

### 10. Automation Execution Framework

#### 10.1 Master Runbook Script
```bash
#!/usr/bin/env bash
# sysadmin-runbook.sh - Master system administration runbook

set -euo pipefail

usage() {
    cat <<EOF
Usage: $0 <command> [options]

Commands:
    user-create <username> [uid] [shell]    Create system user
    user-modify <user> <action> <value>   Modify user (add_group|remove_group|lock|unlock)
    service-status <service>              Check service status
    service-restart <service>             Restart service
    disk-usage [mount]                    Check disk usage
    lvm-create <vg> <lv> <size>           Create LVM volume
    network-list                          List network interfaces
    firewall <action> <port> [protocol]  Manage firewall
    process-list                          List processes
    backup [path]                        Create system backup
    restore <path> [component]           Restore from backup
    security-audit                        Run security audit
    ssh-harden                           Harden SSH
    all                                  Run all checks

Options:
    --dry-run    Dry run mode
    --help       Show this help

EOF
}

if [[ $# -lt 1 ]]; then
    usage
    exit 1
fi

COMMAND="$1"
shift

case "${COMMAND}" in
    user-create)
        . "$(dirname "$0")/user-create.sh"
        create_user "$@"
        ;;
    user-modify)
        . "$(dirname "$0")/user-modify.sh"
        modify_user "$@"
        ;;
    service-status)
        . "$(dirname "$0")/service-health.sh"
        get_service_status "$1"
        ;;
    service-restart)
        . "$(dirname "$0")/service-health.sh"
        restart_service "$1"
        ;;
    disk-usage)
        . "$(dirname "$0")/disk-usage.sh"
        check_disk_usage "${1:-/}"
        ;;
    network-list)
        . "$(dirname "$0")/network-iface.sh"
        list_interfaces
        ;;
    firewall)
        . "$(dirname "$0")/firewall-manage.sh"
        manage_firewall "$@"
        ;;
    process-list)
        . "$(dirname "$0")/process-monitor.sh"
        monitor_processes
        ;;
    backup)
        . "$(dirname "$0")/system-backup.sh"
        backup_system
        ;;
    restore)
        . "$(dirname "$0")/system-restore.sh"
        restore_system "$@"
        ;;
    security-audit)
        . "$(dirname "$0")/security-audit.sh"
        run_security_audit
        ;;
    ssh-harden)
        . "$(dirname "$0")/ssh-harden.sh"
        harden_ssh
        ;;
    all)
        . "$(dirname "$0")/disk-usage.sh"
        . "$(dirname "$0")/process-monitor.sh"
        . "$(dirname "$0")/security-audit.sh"
        
        echo "=== System Health Check ==="
        check_disk_usage "/"
        monitor_processes
        run_security_audit
        ;;
    --help|help)
        usage
        ;;
    *)
        echo "Unknown command: ${COMMAND}"
        usage
        exit 1
        ;;
esac
```

## Verify

After implementation, verify the runbooks work correctly:

```bash
#!/usr/bin/env bash
# Verify runbook execution

set -euo pipefail

BACKUP_DIR="/tmp/test-backup"

echo "Testing user create (dry-run)..."
DRY_RUN=true bash user-create.sh testuser123

echo "Testing disk usage check..."
bash disk-usage.sh /

echo "Testing process list..."
bash process-monitor.sh | head -20

echo "Testing network list..."
bash network-iface.sh | head -30

echo "Testing backup (dry-run)..."
BACKUP_DIR="${BACKUP_DIR}" DRY_RUN=true bash system-backup.sh
rm -rf "${BACKUP_DIR}"

echo "All tests passed"
```

## Rollback

To rollback changes:

```bash
#!/usr/bin/env bash
# Rollback procedures

rollback_user() {
    local username="$1"
    userdel -r "${username}" 2>/dev/null || true
}

rollback_service() {
    local service="$1"
    systemctl revert "${service}" 2>/dev/null || true
}

rollback_firewall() {
    local port="$1"
    firewall-cmd --zone=public --remove-port="${port}" --permanent 2>/dev/null || true
}

rollback_lvm() {
    local vg_name="$1"
    local lv_name="$2"
    lvremove -f "/dev/${vg_name}/${lv_name}" 2>/dev/null || true
}

rollback_etc() {
    local backup_file="$1"
    tar -xzf "${backup_file}" -C / 2>/dev/null || true
}
```

## Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| Permission denied | Not running as root | Use sudo |
| User already exists | Duplicate username | Check with `id username` |
| Service not found | Wrong service name | Use `systemctl list-units` |
| Disk space low | No space for backup | Free up space or change backup path |
| Network interface down | Interface not enabled | Use `ip link set up` |
| Firewall blocking | Wrong zone | Check zone with `firewall-cmd --list-all` |
| LVM no space | VG exhausted | Extend VG or create new VG |
| SSH connection refused | Service not running | Start sshd |

## References
- Linux Man Pages: useradd(8), usermod(8), systemctl(1), fsck(8), lvcreate(8), iptables(8)
- Red Hat Enterprise Linux Documentation
- Ubuntu Server Guide
- CIS Benchmarks for Linux
- NIST SP 800-53 Security Controls