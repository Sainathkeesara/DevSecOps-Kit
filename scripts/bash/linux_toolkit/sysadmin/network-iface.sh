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
    
    ip addr add "${ip_cidr}" dev "${iface}" 2>/dev/null || true
    ip link set "${iface}" up
    
    if [[ -n "${gateway}" ]]; then
        ip route add default via "${gateway}"
    fi
}

show_connections() {
    echo "=== Established Connections ==="
    ss -tun state established
    
    echo ""
    echo "=== Listening Ports ==="
    ss -tunlp | grep LISTEN
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-list}" in
        list)
            list_interfaces
            ;;
        connections)
            show_connections
            ;;
        configure)
            if [[ $# -lt 3 ]]; then
                echo "Usage: $0 configure <interface> <ip/cidr> [gateway]"
                exit 1
            fi
            configure_interface "$2" "$3" "$4"
            ;;
    esac
fi