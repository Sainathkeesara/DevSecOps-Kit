#!/usr/bin/env bash
# user-create.sh - Create system users with audit trail

set -euo pipefail

DRY_RUN="${DRY_RUN:-false}"
AUDIT_LOG="${AUDIT_LOG:-/var/log/sysadmin/user-management.log}"

mkdir -p "$(dirname "${AUDIT_LOG}")"

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
    if [[ $# -lt 1 ]]; then
        echo "Usage: $0 <username> [uid] [shell] [home] [--dry-run]"
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