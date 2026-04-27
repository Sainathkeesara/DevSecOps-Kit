#!/usr/bin/env bash
# File: scripts/bash/linux/linux-dns-monitor.sh
# Description: Monitor DNS health and alert on issues

set -euo pipefail

ALERT_LOG="/var/log/dns-health.log"
CHECK_INTERVAL="60"  # seconds

log_alert() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ALERT: $1" | tee -a "$ALERT_LOG"
}

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $1"
}

check_coredns() {
    if ! systemctl is-active --quiet coredns; then
        log_alert "CoreDNS is not running!"
        return 1
    fi
    return 0
}

check_resolution() {
    local test_domains=("google.com" "github.com" "app.internal.local")
    
    for domain in "${test_domains[@]}"; do
        if ! dig @127.0.0.1 "$domain" +short > /dev/null 2>&1; then
            log_alert "DNS resolution failed for: $domain"
            return 1
        fi
    done
    
    return 0
}

check_response_time() {
    local domain="google.com"
    local response_time
    
    response_time=$(dig @127.0.0.1 "$domain" +stats 2>/dev/null | grep "Query time:" | awk '{print $4}')
    
    if [[ -n "$response_time" ]] && [[ "$response_time" -gt 1000 ]]; then
        log_warn "High DNS response time: ${response_time}ms"
    fi
}

main() {
    log_info "Starting DNS health monitoring (interval: ${CHECK_INTERVAL}s)"
    
    while true; do
        if ! check_coredns; then
            # Try to restart CoreDNS
            log_info "Attempting to restart CoreDNS..."
            systemctl restart coredns
            sleep 5
            if ! check_coredns; then
                log_alert "CoreDNS restart failed! Manual intervention required."
            else
                log_info "CoreDNS restarted successfully"
            fi
        fi
        
        if ! check_resolution; then
            log_warn "DNS resolution issues detected"
        fi
        
        check_response_time
        
        sleep "$CHECK_INTERVAL"
    done
}

# Run once if not in daemon mode
if [[ "${1:-}" == "--once" ]]; then
    check_coredns
    check_resolution
    check_response_time
else
    main
fi