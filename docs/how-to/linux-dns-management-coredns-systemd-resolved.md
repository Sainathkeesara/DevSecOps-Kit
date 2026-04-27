# Linux DNS Management with CoreDNS and systemd-resolved

## Purpose

This project provides comprehensive guidance on setting up and managing DNS resolution on Linux systems using CoreDNS as a local DNS server and systemd-resolved as the system-level resolver. Proper DNS management is essential for reliable network communication, service discovery, and efficient name resolution in both single-host and multi-host environments.

## When to Use

- When you need a local caching DNS server for improved resolution performance
- When managing DNS for containerized applications (Docker, Kubernetes)
- When setting up development environments requiring custom domain resolution
- When implementing split-horizon DNS (internal vs external resolution)
- When troubleshooting DNS-related network issues
- When building service discovery mechanisms for microservices

## Prerequisites

- Linux server (Ubuntu 20.04+, RHEL 8+, Debian 11+)
- Root or sudo access
- Basic understanding of DNS concepts (A records, CNAME, forwarders, etc.)
- Network connectivity for package installation
- At least 512MB RAM recommended for CoreDNS
- Port 53 available (TCP and UDP)

## Steps

### Step 1: Install CoreDNS

CoreDNS is a flexible, extensible DNS server written in Go. Install it using the official binary release:

```bash
# Download the latest CoreDNS release
COREDNS_VERSION="1.11.1"
wget https://github.com/coredns/coredns/releases/download/v${COREDNS_VERSION}/coredns_${COREDNS_VERSION}_linux_amd64.tgz

# Extract the binary
tar -xzf coredns_${COREDNS_VERSION}_linux_amd64.tgz

# Install CoreDNS
sudo mv coredns /usr/local/bin/
sudo chown root:root /usr/local/bin/coredns
sudo chmod 755 /usr/local/bin/coredns

# Verify installation
coredns -version
# Expected output: CoreDNS-1.11.1
```

### Step 2: Configure CoreDNS

Create a CoreDNS configuration file that handles local resolution and forwards external queries:

```bash
# Create CoreDNS configuration directory
sudo mkdir -p /etc/coredns

# Create the Corefile (CoreDNS configuration)
cat | sudo tee /etc/coredns/Corefile << 'EOF'
.:53 {
    # Enable caching for 30 seconds
    cache 30
    
    # Enable logging
    log
    
    # Enable metrics on port 9153
    prometheus :9153
    
    # Health check endpoint
    health :8080
    
    # Handle local zone for internal services
    hosts {
        127.0.0.1 localhost
        ::1       localhost ip6-localhost ip6-loopback
        10.0.1.100 internal.local
        10.0.1.101 app.internal.local
        fallthrough
    }
    
    # Forward external queries to upstream DNS servers
    forward . 8.8.8.8 8.8.4.4 1.1.1.1
    
    # Enable automatic HTTPS (DoH) for upstream queries
    # tls 1.1.1.1 8.8.8.8
    
    # Reload configuration on SIGHUP
    reload
    
    # Enable errors logging
    errors
}

# Internal domain zone
internal.local:53 {
    errors
    log
    file /etc/coredns/internal.db internal.local
}
EOF

# Create internal zone file
sudo mkdir -p /etc/coredns
cat | sudo tee /etc/coredns/internal.db << 'EOF'
$ORIGIN internal.local.
$TTL 1D
@   IN  SOA ns1.internal.local. admin.internal.local. (
        2024010101  ; serial
        8H      ; refresh
        2H       ; retry
        4W       ; expire
        1D       ; minimum TTL
)
    IN  NS  ns1.internal.local.
    IN  A   10.0.1.100

ns1 IN  A   10.0.1.100
app IN  A   10.0.1.101
db  IN  A   10.0.1.102
www IN  CNAME app.internal.local.
EOF

# Test CoreDNS configuration
coredns -conf /etc/coredns/Corefile -check
```

### Step 3: Create CoreDNS Systemd Service

Create a systemd service to manage CoreDNS as a system service:

```bash
# Create systemd service file
sudo cat > /etc/systemd/system/coredns.service << 'EOF'
[Unit]
Description=CoreDNS DNS server
Documentation=https://coredns.io
After=network.target
Wants=network-online.target

[Service]
Type=simple
User=coredns
Group=coredns
ExecStart=/usr/local/bin/coredns -conf /etc/coredns/Corefile
ExecReload=/bin/kill -SIGUSR1 $MAINPID
Restart=on-failure
RestartSec=5
LimitNOFILE=1048576
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/var/log/coredns /tmp

[Install]
WantedBy=multi-user.target
EOF

# Create coredns user and group
sudo useradd -r -s /bin/false -d /etc/coredns coredns
sudo chown -R coredns:coredns /etc/coredns
sudo mkdir -p /var/log/coredns
sudo chown coredns:coredns /var/log/coredns

# Create /tmp/coredns for runtime files
sudo mkdir -p /tmp/coredns
sudo chown coredns:coredns /tmp/coredns

# Reload systemd and enable CoreDNS
sudo systemctl daemon-reload
sudo systemctl enable coredns
sudo systemctl start coredns

# Verify CoreDNS is running
sudo systemctl status coredns
```

### Step 4: Configure systemd-resolved

systemd-resolved is the local DNS resolver that integrates with the Linux system. Configure it to use CoreDNS:

```bash
# Check if systemd-resolved is running
systemctl status systemd-resolved

# If not enabled, start it
sudo systemctl enable systemd-resolved
sudo systemctl start systemd-resolved

# Check current DNS configuration
resolvectl status

# Configure systemd-resolved to use CoreDNS
# Edit /etc/systemd/resolved.conf
sudo tee /etc/systemd/resolved.conf << 'EOF'
[Resolve]
DNS=127.0.0.1
Domains=~internal.local
DNSSEC=allow-downgrade
DNSOverTLS=opportunistic
Cache=yes
DNSStubListener=yes
ReadEtcHosts=yes
EOF

# If /etc/resolv.conf is a symlink to systemd-resolved, it's already configured
# Otherwise, update it
if [ -L /etc/resolv.conf ]; then
    echo "/etc/resolv.conf is managed by systemd-resolved"
else
    echo "nameserver 127.0.0.1" | sudo tee /etc/resolv.conf
    echo "search internal.local" | sudo tee -a /etc/resolv.conf
fi

# Restart systemd-resolved to apply changes
sudo systemctl restart systemd-resolved

# Verify DNS resolution is using CoreDNS
resolvectl query google.com
resolvectl query app.internal.local
```

### Step 5: Configure NetworkManager Integration

If using NetworkManager, ensure it integrates with systemd-resolved:

```bash
# Check NetworkManager DNS configuration
sudo nmcli general status

# Configure NetworkManager to use systemd-resolved
sudo tee /etc/NetworkManager/conf.d/dns.conf << 'EOF'
[main]
dns=systemd-resolved
rc-manager=unmanaged
EOF

# Restart NetworkManager
sudo systemctl restart NetworkManager

# Verify DNS configuration
resolvectl status | grep 'DNS Servers'
```

### Step 6: Test DNS Resolution

Verify that DNS resolution is working correctly:

```bash
# Test external DNS resolution
dig @127.0.0.1 google.com +short
nslookup google.com 127.0.0.1

# Test internal domain resolution
dig @127.0.0.1 app.internal.local +short
# Should return: 10.0.1.101

# Test CNAME resolution
dig @127.0.0.1 www.internal.local +short
# Should return: app.internal.local. and 10.0.1.101

# Use systemd-resolved for queries
resolvectl query app.internal.local
resolvectl query google.com

# Test DNS caching
time dig @127.0.0.1 google.com +short
time dig @127.0.0.1 google.com +short
# Second query should be faster due to caching

# Check CoreDNS logs for query activity
sudo journalctl -u coredns -f --no-pager | head -20
```

### Step 7: Create DNS Management Scripts

Create utility scripts for managing DNS entries:

```bash
#!/usr/bin/env bash
# File: scripts/bash/linux/dns-management-coredns.sh
# Description: Utility script for managing CoreDNS DNS entries
# Usage: ./dns-management-coredns.sh [add|remove|list] [domain] [ip]

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
    sed -i "s/^@\s*IN\s*SOA.*(\s*[0-9]\{10\}\s*)/@   IN  SOA ns1.internal.local. admin.internal.local. (\n        $new_serial/" "$COREDNS_ZONE_FILE"
    
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
    sed -i "/^)/i ${domain}   IN  A   ${ip}" "$COREDNS_ZONE_FILE"
    
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
    
    sed -i "/^${domain}\s/d" "$COREDNS_ZONE_FILE"
    
    update_serial
    
    log_info "Removed entry: ${domain}"
    reload_coredns
}

# List all entries
list_entries() {
    echo "Current DNS entries in internal.local:"
    echo "----------------------------------------"
    grep -E "^([a-z0-9-]+)\s+IN\s+A\s+" "$COREDNS_ZONE_FILE" | while read -r line; do
        echo "  $line"
    done
}

# Reload CoreDNS
reload_coredns() {
    if systemctl is-active --quiet coredns; then
        systemctl reload coredns
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
```

Make the script executable:

```bash
chmod +x scripts/bash/linux/dns-management-coredns.sh
```

### Step 8: Create systemd-resolved Configuration Override

Create an override to ensure systemd-resolved uses CoreDNS:

```bash
# Create override directory
sudo mkdir -p /etc/systemd/system/systemd-resolved.service.d

# Create override configuration
sudo tee /etc/systemd/system/systemd-resolved.service.d/override.conf << 'EOF'
[Service]
Environment=SYSTEMD_RESOLVED_LISTENERS=127.0.0.1:53
EOF

# Reload systemd
sudo systemctl daemon-reload
```

### Step 9: Configure nsswitch.conf

Ensure nsswitch is configured to use systemd-resolved:

```bash
# Check current configuration
grep hosts /etc/nsswitch.conf

# Ensure it includes resolve (for systemd-resolved)
if ! grep -q "resolve" /etc/nsswitch.conf; then
    sudo sed -i 's/^hosts:.*/hosts:          files resolve dns myhostname/' /etc/nsswitch.conf
fi
```

### Step 10: Verification and Testing

Create a comprehensive test script:

```bash
#!/usr/bin/env bash
# File: scripts/bash/linux/test-dns-setup.sh
# Description: Test DNS setup

set -euo pipefail

echo "=== DNS Setup Verification ==="
echo ""

echo "1. Check CoreDNS is running:"
if systemctl is-active --quiet coredns; then
    echo "   ✓ CoreDNS is running"
else
    echo "   ✗ CoreDNS is NOT running"
    exit 1
fi

echo ""
echo "2. Check systemd-resolved is running:"
if systemctl is-active --quiet systemd-resolved; then
    echo "   ✓ systemd-resolved is running"
else
    echo "   ✗ systemd-resolved is NOT running"
    exit 1
fi

echo ""
echo "3. Test external DNS resolution:"
if result=$(dig @127.0.0.1 google.com +short 2>/dev/null | head -1); then
    if [[ -n "$result" ]]; then
        echo "   ✓ External resolution works: google.com -> $result"
    else
        echo "   ✗ External resolution failed"
        exit 1
    fi
else
    echo "   ✗ dig command failed"
    exit 1
fi

echo ""
echo "4. Test internal domain resolution:"
if result=$(dig @127.0.0.1 app.internal.local +short 2>/dev/null); then
    if [[ "$result" == "10.0.1.101" ]]; then
        echo "   ✓ Internal resolution works: app.internal.local -> $result"
    else
        echo "   ✗ Unexpected result: $result"
        exit 1
    fi
else
    echo "   ✗ Internal resolution failed"
    exit 1
fi

echo ""
echo "5. Check DNS caching:"
# First query
time1=$( { time dig @127.0.0.1 google.com +short > /dev/null; } 2>&1 | grep real | awk '{print $2}')
# Second query (should be cached)
time2=$( { time dig @127.0.0.1 google.com +short > /dev/null; } 2>&1 | grep real | awk '{print $2}')
echo "   First query:  $time1"
echo "   Second query: $time2 (should be faster)"

echo ""
echo "6. Check CoreDNS metrics:"
if curl -s http://127.0.0.1:9153/metrics | grep -q "coredns_dns_request_count_total"; then
    echo "   ✓ Metrics endpoint is accessible"
else
    echo "   ✗ Metrics endpoint is not accessible"
fi

echo ""
echo "7. Check CoreDNS logs:"
if journalctl -u coredns --no-pager -n 5 2>/dev/null | grep -q "CoreDNS"; then
    echo "   ✓ CoreDNS logs are available"
    journalctl -u coredns --no-pager -n 3 2>/dev/null
else
    echo "   ✗ No CoreDNS logs found"
fi

echo ""
echo "=== All checks passed! ==="
```

Make the test script executable:

```bash
chmod +x scripts/bash/linux/test-dns-setup.sh
```

### Step 11: DNS Monitoring and Alerting

Create a monitoring script:

```bash
#!/usr/bin/env bash
# File: scripts/bash/linux/monitor-dns-health.sh
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
```

Make the monitoring script executable:

```bash
chmod +x scripts/bash/linux/monitor-dns-health.sh
```

### Step 12: Documentation Reference

Document common DNS troubleshooting commands:

```bash
# Check DNS configuration
resolvectl status
cat /etc/resolv.conf

# Test DNS resolution
dig @127.0.0.1 example.com
nslookup example.com 127.0.0.1
host example.com 127.0.0.1

# Trace DNS resolution path
dig @127.0.0.1 example.com +trace

# Check DNS cache statistics
dig @127.0.0.1 example.com +stats

# View CoreDNS logs
journalctl -u coredns -f

# Test internal domain resolution
dig @127.0.0.1 internal.local ANY

# Flush DNS cache (systemd-resolved)
resolvectl flush-caches

# Check systemd-resolved statistics
resolvectl statistics

# Monitor DNS queries in real-time
journalctl -u coredns -f | grep "query"
```

## Verify

### Verification Steps

1. **Verify CoreDNS installation:**
   ```bash
   coredns -version
   # Expected: CoreDNS-1.11.1 or similar
   ```

2. **Verify CoreDNS is running:**
   ```bash
   systemctl status coredns
   # Expected: active (running)
   ```

3. **Test external DNS resolution:**
   ```bash
   dig @127.0.0.1 google.com +short
   # Expected: Returns an IP address
   ```

4. **Test internal domain resolution:**
   ```bash
   dig @127.0.0.1 app.internal.local +short
   # Expected: 10.0.1.101
   ```

5. **Verify systemd-resolved configuration:**
   ```bash
   resolvectl status | grep "DNS Servers"
   # Expected: 127.0.0.1
   ```

6. **Test DNS caching:**
   ```bash
   time dig @127.0.0.1 google.com +short
   time dig @127.0.0.1 google.com +short
   # Expected: Second query is faster
   ```

7. **Verify DNS management script:**
   ```bash
   ./scripts/bash/linux/dns-management-coredns.sh list
   # Expected: Shows current DNS entries
   ```

8. **Run comprehensive test:**
   ```bash
   ./scripts/bash/linux/test-dns-setup.sh
   # Expected: All checks pass
   ```

## Rollback

To remove CoreDNS and systemd-resolved configuration:

```bash
# Stop and disable services
sudo systemctl stop coredns
sudo systemctl disable coredns
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved

# Remove CoreDNS binary
sudo rm /usr/local/bin/coredns

# Remove configuration files
sudo rm -rf /etc/coredns
sudo rm -f /etc/systemd/system/coredns.service

# Restore original resolv.conf
sudo rm -f /etc/resolv.conf
sudo ln -s /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# Restore systemd-resolved configuration
sudo rm -f /etc/systemd/resolved.conf
sudo rm -f /etc/systemd/system/systemd-resolved.service.d/override.conf

# Reload systemd
sudo systemctl daemon-reload

# Restart systemd-resolved with default configuration
sudo systemctl enable systemd-resolved
sudo systemctl start systemd-resolved

# Remove management scripts
sudo rm -f /usr/local/bin/dns-management-coredns.sh
sudo rm -f /var/log/dns-health.log
sudo rm -f /var/log/coredns

# Remove log files
sudo rm -rf /var/log/coredns

# Verify removal
coredns -version 2>&1 | grep -q "not found" && echo "CoreDNS removed successfully"
```

## Common Errors

| Error | Solution |
|-------|----------|
| `coredns: permission denied` | Run with sudo or ensure user has proper permissions |
| `bind: address already in use` | Port 53 is in use; stop conflicting DNS services |
| `connection refused` | CoreDNS is not running; start with `systemctl start coredns` |
| `SERVFAIL` | Check CoreDNS logs; verify upstream DNS servers are reachable |
| `NXDOMAIN` | Domain does not exist; check zone file configuration |
| `systemd-resolved not responding` | Restart with `systemctl restart systemd-resolved` |
| `DNS resolution slow` | Check upstream DNS servers; verify network connectivity |
| `cache not working` | Verify cache directive in Corefile; check memory limits |
| `metrics not accessible` | Verify port 9153 is not blocked; check firewall rules |
| `zone file parse error` | Validate zone file syntax; check SOA record formatting |

## References

- [CoreDNS Official Documentation](https://coredns.io/)
- [CoreDNS GitHub Repository](https://github.com/coredns/coredns)
- [systemd-resolved Documentation](https://www.freedesktop.org/software/systemd/man/systemd-resolved.service.html)
- [DNS Best Practices - RFC 8499](https://tools.ietf.org/html/rfc8499)
- [BIND Zone File Format](https://bind9.readthedocs.io/en/latest/reference.html#zone-file)
- [systemd-resolved and DNS](https://systemd.io/DNS/)