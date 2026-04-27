#!/usr/bin/env bash
# File: scripts/bash/linux/linux-dns-coredns.sh
# Description: Utility script for managing CoreDNS DNS entries
# Usage: ./linux-dns-coredns.sh [add|remove|list] [domain] [ip]

set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
COREDNS_ZONE_FILE="/etc/coredns/internal.db"
SERIAL_FILE="/etc/coredns/serial"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root"
        exit 1
    fi
}

# Get current serial number
get_serial() {
    if [[ -f "$SERIAL_FILE" ]]; then
        cat "$SERIAL_FILE"
    else
        date +%Y%m%d01
    fi
}

# Increment serial number
increment_serial() {
    local current_serial
    current_serial=$(get_serial)
    local today
    today=$(date +%Y%m%d)
    local serial_date
    serial_date=${current_serial:0:8}
    local serial_seq
    serial_seq=${current_serial:8:2}
    
    if [[ "$serial_date" == "$today" ]]; then
        serial_seq=$((10#$serial_seq + 1))
        printf "%s%02d" "$today" "$serial_seq"
    else
        echo "${today}01"
    fi
}

# Update serial in zone file
update_serial() {
    local new_serial
    new_serial=$(increment_serial)
    echo "$new_serial" > "$SERIAL_FILE"
    
    # Update the zone file
    sed -i "s/^@\s*IN\s*SOA.*(\s*[0-9]\{10\}\s*)/@   IN  SOA ns1.internal.local. admin.internal.local. (\n        $new_serial/" "$COREDNS_ZONE_FILE" || true
    
    log_info "Serial updated to: $new_serial"
}

# Add DNS entry
add_entry() {
    local domain="$1"
    local ip="$2"
    
    if grep -q "^${domain}\s" "$COREDNS_ZONE_FILE"; then
        log_error "Entry '$domain' already exists"
        exit 1
    fi
    
    # Add the entry before the closing parenthesis
    sed -i "/^)/i ${domain}   IN  A   ${ip}" "$COREDNS_ZONE_FILE" || true
    
    update_serial
    
    log_info "Added entry: ${domain} -> ${ip}"
    reload_coredns
}

# Remove DNS entry
remove_entry() {
    local domain="$1"
    
    if ! grep -q "^${domain}\s" "$COREDNS_ZONE_FILE"; then
        log_error "Entry '$domain' not found"
        exit 1
    fi
    
    sed -i "/^${domain}\s/d" "$COREDNS_ZONE_FILE" || true
    
    update_serial
    
    log_info "Removed entry: ${domain}"
    reload_coredns
}

# List all entries
list_entries() {
    echo "Current DNS entries in internal.local:"
    echo "----------------------------------------"
    grep -E "^([a-z0-9-]+)\s+IN\s+A\s+" "$COREDNS_ZONE_FILE" 2>/dev/null | while read -r line; do
        echo "  $line"
    done
}

# Reload CoreDNS
reload_coredns() {
    if systemctl is-active --quiet coredns; then
        systemctl reload coredns 2>/dev/null || systemctl restart coredns
        log_info "CoreDNS reloaded"
    else
        log_warn "CoreDNS is not running"
    fi
}

# Show usage
show_usage() {
    cat << EOF
Usage: $SCRIPT_NAME [add|remove|list] [domain] [ip]

Commands:
    add <domain> <ip>     Add a DNS A record
    remove <domain>       Remove a DNS A record
    list                  List all DNS A records
    help                  Show this help message

Examples:
    $SCRIPT_NAME add webserver.internal.local 10.0.1.105
    $SCRIPT_NAME remove oldserver.internal.local
    $SCRIPT_NAME list

Files:
    Zone file: $COREDNS_ZONE_FILE
    Serial file: $SERIAL_FILE
EOF
}

# Main function
main() {
    local command="${1:-help}"
    
    case "$command" in
        add)
            check_root
            if [[ -z "${2:-}" ]] || [[ -z "${3:-}" ]]; then
                log_error "Domain and IP are required"
                show_usage
                exit 1
            fi
            add_entry "$2" "$3"
            ;;
        remove)
            check_root
            if [[ -z "${2:-}" ]]; then
                log_error "Domain is required"
                show_usage
                exit 1
            fi
            remove_entry "$2"
            ;;
        list)
            list_entries
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            log_error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

main "$@"