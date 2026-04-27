#!/usr/bin/env bash
# File: scripts/bash/linux/linux-dns-test.sh
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
if curl -s http://127.0.0.1:9153/metrics 2>/dev/null | grep -q "coredns_dns_request_count_total"; then
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