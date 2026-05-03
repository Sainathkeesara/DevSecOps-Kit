#!/usr/bin/env bash
# process-monitor.sh - Monitor running processes

set -euo pipefail

list_processes() {
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
    local interval="${3:-60}"
    
    local end_time
    end_time=$(( $(date +%s) + duration ))
    
    while [[ $(date +%s) -lt "$end_time" ]]; do
        echo "=== $(date '+%Y-%m-%d %H:%M:%S') ==="
        ps aux | grep "${process_name}" | grep -v grep
        
        sleep "${interval}"
    done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-list}" in
        list)
            list_processes
            ;;
        watch)
            if [[ $# -lt 2 ]]; then
                echo "Usage: $0 watch <process_name> [duration] [interval]"
                exit 1
            fi
            watch_process "$2" "${3:-300}" "${4:-60}"
            ;;
        *)
            echo "Usage: $0 [list|watch]"
            exit 1
            ;;
    esac
fi