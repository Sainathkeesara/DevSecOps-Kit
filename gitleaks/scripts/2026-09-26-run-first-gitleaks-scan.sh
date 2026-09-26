#!/usr/bin/env bash
#
# last_verified: 2026-09-26 · gitleaks n/a
#
# My first gitleaks scan. Points gitleaks at a sample repo and writes the
# findings to a JSON report I can inspect afterwards.

gitleaks detect --source "${1:-.}" --report-path gitleaks-report.json