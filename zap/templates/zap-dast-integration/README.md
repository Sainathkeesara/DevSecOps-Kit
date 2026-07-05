---
last_verified: 2026-07-05
tool_version: stable
sources: []
---

# ZAP DAST Integration Scaffold

A project scaffold for running OWASP ZAP Dynamic Application Security Testing
via the Automation Framework in GitHub Actions. Drop this into any web project
to get CI-integrated DAST scanning with minimal setup.

## Purpose

Teams shipping web applications need automated security testing in CI, but
standing up a ZAP pipeline from scratch means learning the Automation Framework
plan syntax, wiring up Docker, writing a workflow, and figuring out how to gate
on findings. This scaffold packages all of that into a single copy-paste
template so you can get a baseline DAST scan running in minutes.

## When to use

- Your application has a web interface or API that can be reached from CI
- You want to catch common web vulnerabilities (XSS, SQLi, missing headers)
- You prefer the ZAP Automation Framework over manual scripting
- You already use GitHub Actions and want native SARIF upload

## Prerequisites

- Docker (for running ZAP in a container)
- A target URL to scan (staging environment, ephemeral preview URL, etc.)
- GitHub repository with Actions enabled

## Structure

```
zap-dast-integration/
├── .github/
│   └── workflows/
│       └── zap-dast.yml      # GitHub Actions CI workflow
├── plans/
│   ├── quick-scan.yaml       # Spider + passive scan (fast)
│   └── full-scan.yaml        # Spider + AJAX + active scan (thorough)
├── scripts/
│   └── run-zap-dast.sh       # Local scan script
├── README.md
└── zap-automation-plan.yaml  # Default plan at repo root
```

## Steps

### 1. Copy the scaffold

```bash
cp -r zap-dast-integration /your/repo/security/zap-dast
```

### 2. Configure targets

Edit `plans/quick-scan.yaml` and set `{{TARGET_URL}}` to your app's base URL.
If scanning an authenticated area, add the authentication block to the context.

### 3. Run a local scan

```bash
chmod +x scripts/run-zap-dast.sh
./scripts/run-zap-dast.sh https://staging.example.com ./reports plans/quick-scan.yaml
```

### 4. Enable CI

Push the scaffold to your repo. The workflow at `.github/workflows/zap-dast.yml`
runs on every pull request and push to the default branch.

Set `TARGET_URL` in **Settings > Variables and secrets > Actions > Variables**,
or provide it as a workflow dispatch input when running manually.

## Verify

- Run `./scripts/run-zap-dast.sh` against a known-clean staging environment — the exit
  code should be 0 and a JSON report appears in `reports/`.
- Deploy a deliberately vulnerable test page (e.g. one with a reflected XSS
  parameter) and re-run — the scan should flag it and the exit code should be
  non-zero.
- Open a PR and confirm the CI workflow runs and uploads a SARIF report to
  GitHub Code Scanning.

## Common errors

- **ZAP container exits immediately**: usually a missing target URL or invalid
  plan syntax. Run `docker logs zap-dast-worker` to check.
- **No URLs discovered**: the spider may not be able to reach the target.
  Verify the target is accessible from the Docker host and not behind a VPN
  or firewall.
- **Plan parsing errors**: YAML indentation is significant in Automation
  Framework plans. Use `yamllint plans/*.yaml` to validate.