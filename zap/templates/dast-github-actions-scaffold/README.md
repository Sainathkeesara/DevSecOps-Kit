# OWASP ZAP DAST Integration Scaffold

## Purpose

A project scaffold for running OWASP ZAP Dynamic Application Security Testing in CI
via GitHub Actions and the Automation Framework. The template packages the workflow,
Automation Framework plans, and a local runner script into a single copy-paste
structure so teams can integrate baseline DAST scanning without wiring the pipeline
from scratch.

## When to use

Use this scaffold when you want DAST scans on every pull request and the ability to
promote to scheduled full scans. It fits web applications where the CI runner can
reach the target environment. It assumes familiarity with GitHub Actions and CI
artifacts.

## Prerequisites

- A GitHub repository with Actions enabled
- A target web application reachable from GitHub Actions runners
- Docker available for local execution (optional in CI if using a containerized runner)

## Structure

```
dast-github-actions-scaffold/
├── README.md
├── Makefile
├── .gitignore
├── .github/
│   └── workflows/
│       └── dast-scan.yml
├── plans/
│   ├── quick-scan.yaml
│   └── full-scan.yaml
└── scripts/
    └── run-dast-scan.sh
```

## Steps

### 1. Copy the scaffold

Place the `dast-github-actions-scaffold` directory at the repository root so
GitHub Actions picks up the workflow file automatically.

### 2. Configure the scan target

Edit `plans/quick-scan.yaml` and `plans/full-scan.yaml`. Replace the
`{{TARGET_URL}}` placeholder with your application's base URL. If the
application requires authentication, add the relevant authentication block to
the plan context.

### 3. Run a local scan

```bash
make quick-scan
```

This runs the quick plan and writes a JSON report to `reports/`.

### 4. Enable CI

Commit and push the scaffold. The workflow at
`.github/workflows/dast-scan.yml` triggers on pull requests and pushes to the
default branch, producing a report artifact. Adjust the `TARGET_URL` repository
variable or secret to match your environment.

### 5. Promote to full scans

After the quick scan passes reliably, switch to:

```bash
make full-scan
```

The full plan runs a longer spider and active scan, which detect additional
vulnerability classes at the cost of longer runtime.

## Verify

- Run `make quick-scan` against a staging environment. Exit code should be `0`
  when no issues are found, and a JSON report appears in `reports/`.
- Open a pull request and confirm the GitHub Actions workflow executes and
  uploads a report artifact.
- Change the alert threshold in `plans/full-scan.yaml` and re-run. The exit
  code should reflect the configured failure level.
