#!/usr/bin/env bash
# disk-usage.sh - Analyze disk usage with alerts

set -euo pipefail

THRESHOLD_WARNING="${THRESHOLD_WARNING:-80}"
THRESHOLD_CRITICAL="${THRESHOLD_CRITICAL:-90}"

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

check_all_disks() {
    df -hP | awk 'NR==1 {print; next} $5+0 > 80 {print}'
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ $# -ge 1 && "$1" == "--all" ]]; then
        check_all_disks
    elif [[ $# -ge 1 ]]; then
        check_disk_usage "$1"
    else
        check_disk_usage "/"
    fi
fi