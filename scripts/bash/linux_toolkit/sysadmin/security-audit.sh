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
    echo "Checking open ports..."
    ss -tunlp 2>/dev/null || netstat -tunlp 2>/dev/null
    
    echo ""
    echo "Checking running services..."
    systemctl list-units --type=service --state=running 2>/dev/null | head -20 || true
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_security_audit
fi