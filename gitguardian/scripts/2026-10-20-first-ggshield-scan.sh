#!/usr/bin/env bash
# last_verified: 2026-10-20 - gitguardian n/a
# My first ggshield scan - install, auth, scan, capture report

pip install ggshield
ggshield auth login
ggshield scan path . --json > ggshield-report.json
cat ggshield-report.json
