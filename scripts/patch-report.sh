#!/usr/bin/env bash
# last_verified: 2026-07-10 · ansible 2.x · mailutils

# Patch management report generator
# Usage: ./patch-report.sh [--email <address>]
# Generates a dated report with server inventory, last patch status, and security update count

REPORT_DATE=$(date +%Y-%m-%d)
REPORT_FILE="/var/log/patch-report-${REPORT_DATE}.txt"
EMAIL="${1:-admin@example.com}"

{
  echo "Patch Management Report - $REPORT_DATE"
  echo "========================================"
  echo ""
  echo "Server Inventory:"
  ansible all --list-hosts
  echo ""
  echo "Last Patch Status:"
  ansible all -m setup -a "filter=ansible_date_time" | grep ansible_date_time
  echo ""
  echo "Security Updates Available:"
  ansible all -m shell -a "apt-get -s upgrade 2>/dev/null | grep -i security | wc -l"
} > "$REPORT_FILE"

echo "[+] Report written to $REPORT_FILE"
mail -s "Weekly Patch Report - $REPORT_DATE" "$EMAIL" < "$REPORT_FILE"
