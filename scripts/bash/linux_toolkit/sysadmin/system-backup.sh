#!/usr/bin/env bash
# system-backup.sh - Automated system backup

set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-/backup}"
DATE_STAMP=$(date +%Y%m%d-%H%M%S)
RETENTION_DAYS="${RETENTION_DAYS:-30}"
DRY_RUN="${DRY_RUN:-false}"

backup_system() {
    local backup_name="system-${DATE_STAMP}"
    local backup_path="${BACKUP_DIR}/${backup_name}"
    
    if [[ "${DRY_RUN}" == "true" ]]; then
        echo "[DRY-RUN] Would create backup at ${backup_path}"
        return 0
    fi
    
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
    find "${BACKUP_DIR}" -maxdepth 1 -type d -mtime +"${RETENTION_DAYS}" -exec rm -rf {} \; 2>/dev/null || true
    
    echo "Backup complete: ${backup_path}"
    du -sh "${backup_path}"
}

restore_system() {
    local backup_path="$1"
    local component="${2:-all}"
    
    if [[ ! -d "${backup_path}" ]]; then
        echo "ERROR: Backup path ${backup_path} does not exist"
        return 1
    fi
    
    if [[ "${DRY_RUN}" == "true" ]]; then
        echo "[DRY-RUN] Would restore ${component} from ${backup_path}"
        return 0
    fi
    
    echo "Verifying backup integrity"
    cd "${backup_path}"
    sha256sum -c checksums.txt || {
        echo "ERROR: Checksum verification failed"
        return 1
    }
    
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

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ $# -lt 1 ]]; then
        echo "Usage: $0 backup|restore [options]"
        echo "  backup: Create system backup"
        echo "  restore <path> [component]: Restore from backup (component: etc|home|all)"
        echo ""
        echo "Environment:"
        echo "  BACKUP_DIR=/backup        Backup directory (default: /backup)"
        echo "  RETENTION_DAYS=30       Days to keep backups"
        echo "  DRY_RUN=true           Dry run mode"
        exit 1
    fi
    
    case "$1" in
        backup)
            shift
            backup_system "$@"
            ;;
        restore)
            shift
            restore_system "$@"
            ;;
    esac
fi