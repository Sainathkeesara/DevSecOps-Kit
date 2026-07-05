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

For targets with many URLs or branching scan logic, you can extend the plan
files under `plans/` without touching the root `zap-automation-plan.yaml`.

## Structure

```
zap-dast-integration-scaffold/
├── README.md
├── Makefile
├── .gitignore
├── zap-automation-plan.yaml       ← primary Automation Framework entrypoint
├── .github/workflows/
│   └── zap-dast.yml              # GitHub Actions workflow
├── plans/
│   ├── quick-scan.yaml           # Spider + passive scan (fast)
│   └── full-scan.yaml            # Spider + AJAX + active scan (thorough)
└── scripts/
    └── run-zap-dast.sh           # Local scan runner (uses any plan file)
```

## Prerequisites

- Docker (for running ZAP in a container)
- A target web application (staging or ephemeral environment)
- A GitHub repository (for CI integration)

## Steps

### 1. Copy the scaffold

```bash
cp -r zap-dast-integration-scaffold /your/repo/security/zap-dast
```

### 2. Configure targets

Edit `zap-automation-plan.yaml` and replace `{{TARGET_URL}}` and
`{{REPORT_DIR}}` with your app's base URL and desired output directory.
If the app requires authentication, add an `authentication` block to the
context in the plan file.

### 3. Run a local scan

```bash
make plan-scan
```

This starts ZAP in a Docker container, runs the automation plan (spider +
AJAX spider + passive scan + active scan + report), and writes reports to
`reports/`.

For a faster first pass, use `make quick-scan` or `make full-scan` against
the plan files in `plans/`.

### 4. Enable CI

Push the scaffold to your repo. The workflow at `.github/workflows/zap-dast.yml`
runs on every pull request and push to the default branch, producing a JSON
report as a build artifact.

Set `ZAP_TARGET_URL` in **Settings > Variables and secrets > Actions >
Variables**, or the workflow falls back to `http://localhost:8080`.

## Verify

- Run `make plan-scan` against a known-clean staging environment — the exit
  code should be 0 and a JSON report appears in `reports/`.
- Deploy a deliberately vulnerable test page (e.g. one with a reflected XSS
  parameter) and re-run — the scan should flag it and the exit code should be
  non-zero.
- Open a PR against your repo and confirm the CI workflow runs and produces a
  report artifact.

## Common errors

- **ZAP container exits immediately**: usually a missing target URL or invalid
  plan syntax. Run `docker logs zap-dast-worker` to check.
- **No URLs discovered**: the spider may not be able to reach the target.
  Verify the target is accessible from the Docker host and not behind a VPN
  or firewall.
- **Plan parsing errors**: YAML indentation is significant in Automation
  Framework plans. Use `yamllint zap-automation-plan.yaml plans/*.yaml` to
  validate.
