---
last_verified: 2026-11-02
tool_version: n/a
sources:
  - https://github.com/kubernetes-sigs/kind/releases
---

# First win: find a secret and a vulnerable package

This lesson closes the Foundations stage: you take the sample app you set up last time and scan it with two tools — Gitleaks for secrets and Trivy for vulnerable packages — then read one finding from each. The goal is the first real "win": something concrete you can point at and fix.

## What you'll learn

- Run Gitleaks and Trivy against the sample app
- Read one finding from each and explain what it means

## Before you start

- [Set up the lab and the sample app](07-lab-setup.md) — you need the sample app cloned and running in the lab
- [YAML, JSON, jq and regex for security tooling](06-yaml-json-jq-regex.md) — you'll use `jq` to read the Gitleaks JSON report
- Docker must be installed and working. Confirm with `docker --version`.
- `trivy` installed. Confirm with `trivy --version`.
- `gitleaks` installed. Confirm with `gitleaks version`.

## Walkthrough

1. Scan the sample app's repository for secrets with Gitleaks.

   From the sample app directory, run a directory scan:

   ```bash
   cd ~/devsecops-lab/sample-app
   gitleaks dir . --report-format json --report-path /tmp/gitleaks-report.json
   ```

   You should see Gitleaks print a summary line like `Leaks found: 1` (or more) and write the JSON report to `/tmp/gitleaks-report.json`.

2. Read the secret finding.

   Open the report and inspect the first leak:

   ```bash
   jq '.[0] | {file, startLine, ruleID, match}' /tmp/gitleaks-report.json
   ```

   You should see a JSON object naming the file (for example a `.env` or compose file), the line number, the rule ID (such as `generic-api-key`), and the matched secret value (redacted in real life — never commit it).

   What it means: a credential is stored in source code. Anyone with read access to the repo can use it; rotating it and moving it to a secret store is the fix.

3. Scan the sample app's image/filesystem for vulnerable packages with Trivy.

   Run Trivy against the application directory:

   ```bash
   cd ~/devsecops-lab/sample-app
   trivy fs . --severity HIGH,CRITICAL
   ```

   You should see Trivy download its vulnerability database on the first run, then print a table of findings with columns like Library, Vulnerability ID, Severity, Installed Version, and Fixed Version.

4. Read one vulnerable-package finding.

   Pick the first row and note its Vulnerability ID (a CVE), the package name, the installed version, and the fixed version. Example interpretation: package `urllib3` at `1.26.5` is affected by `CVE-...` (HIGH); upgrading to the fixed version closes it.

   What it means: a dependency you ship contains a known, publicly disclosed flaw. The fix is usually to bump the dependency (and re-test), not to rewrite your code.

## Exercise

On your own, run both scans against the sample app and write down, for one finding from each tool: the file or package it points at, the rule/CVE ID, the severity, and the single most important next action you would take. Do not fix anything yet — just triage.

## Check your work

`gitleaks dir .` reports at least one leak and writes a JSON report you can parse with `jq`; `trivy fs . --severity HIGH,CRITICAL` prints a table with at least one row showing Library, Vulnerability, Severity, Installed Version, and Fixed Version. If either scan is clean, re-check that you are scanning the sample app (not an empty directory) and that the tools' databases downloaded successfully.

## Common mistakes

- Scanning the wrong directory and getting zero findings — confirm your working directory contains the sample app files.
- Treating a Gitleaks match as a false positive without checking: verify whether the value is a real credential before dismissing it.
- Reading only the severity and ignoring the Fixed Version column — the fixed version is what tells you whether an upgrade is available.

## Next

[Containers and orchestration — concepts](../../docs/concepts/containers-orchestration/0000-primer-containers-orchestration.md)