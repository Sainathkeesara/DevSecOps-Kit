#!/usr/bin/env bash
# last_verified: 2026-10-13 · gitleaks n/a
#
# What I learned auditing git secrets with gitleaks.
# Following the quickstart, here's what worked and where it broke.
#
# Steps I actually ran:
#   1. Ran `gitleaks detect` against a copy of a repo (history scan).
#   2. Re-ran it pointed at the working tree for untracked files.
#   3. Opened the JSON report and checked each finding by hand.
# Got stuck on: detect exits non-zero when it finds something, so my
#   first version looked like it "failed" even though the scan worked.
# What I'd try next: a small allowlist for my own test strings.

# I keep the target and report path as args because I rerun this
# against different checkouts -- doing it with $1/$2 here because the
# docs example hardcodes "." and I kept overwriting my last report.
TARGET="${1:-.}"
REPORT="${2:-gitleaks-audit.json}"

# First pass: full history scan, report goes to the JSON file.
# I use --report-path because terminal output scrolls past me.
gitleaks detect --source "$TARGET" --report-path "$REPORT"
SCAN_STATUS=$?

# A non-zero exit here means "leaks found", not "command broke",
# which confused me until I read the terminal message twice.
if [ $SCAN_STATUS -eq 0 ]; then
  echo "no leaks reported in $TARGET"
else
  echo "possible secrets listed in $REPORT -- review each hit by hand"
fi
