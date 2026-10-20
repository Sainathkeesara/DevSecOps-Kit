#!/usr/bin/env bash
# last_verified: 2026-10-20 - snyk n/a
# My first snyk test - install, auth, test, capture report

npm install -g snyk
snyk auth
snyk test --json > snyk-report.json
cat snyk-report.json