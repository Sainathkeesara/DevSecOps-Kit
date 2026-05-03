#!/usr/bin/env bash
# service-health.sh - Check and restart system services

set -euo pipefail

SERVICE_NAME="${1:-}"
ACTION="${2:-status}"
MAX_RESTARTS="${MAX_RESTARTS:-3}"
RESTART_COOLDOWN="${RESTART_COOLDOWN:-30}"

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

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ -z "${SERVICE_NAME}" ]]; then
        echo "Usage: $0 <service> [status|restart]"
        exit 1
    fi
    
    case "${ACTION}" in
        status)
            get_service_status "${SERVICE_NAME}"
            ;;
        restart)
            restart_service "${SERVICE_NAME}"
            ;;
        *)
            echo "Usage: $0 <service> [status|restart]"
            exit 1
            ;;
    esac
fi