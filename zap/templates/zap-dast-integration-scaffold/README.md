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

The docs also suggest that for large targets with many URLs you may want to
split the scan across multiple plan files — this scaffold ships two plans
(quick and full) that you can adapt separately.

## Structure

```
zap-dast-integration-scaffold/
├── README.md
├── Makefile
├── .gitignore
├── .github/workflows/
│   └── zap-dast.yml              # GitHub Actions workflow
├── plans/
│   ├── quick-scan.yaml           # Spider + passive scan (fast)
│   └── full-scan.yaml            # Spider + AJAX + active scan (thorough)
└── scripts/
    └── run-zap-dast.sh           # Local scan script (same workflow as CI)
```

## Prerequisites

- Docker (for running ZAP in a container)
- curl, jq (for the local script)
- A target web application (staging or ephemeral environment)
- A GitHub repository (for CI integration)

## Steps

### 1. Copy the scaffold

```bash
cp -r zap-dast-integration-scaffold /your/repo/security/zap-dast
```

### 2. Configure targets

Edit `plans/quick-scan.yaml` and set `{{TARGET_URL}}` to your app's base URL.
If the app requires authentication, uncomment and fill in the `authentication`
block in the plan files.

### 3. Run a local scan

```bash
make quick-scan
```

This starts ZAP in a Docker container, runs the quick scan plan (spider +
passive), and writes reports to `reports/`.

### 4. Enable CI

Push the scaffold to your repo. The workflow at `.github/workflows/zap-dast.yml`
runs on every pull request and push to the default branch, producing a JSON
report as a build artifact.

### 5. Promote to full scan

Once the quick scan passes reliably, switch to:

```bash
make full-scan
```

The full plan adds AJAX spider and active scanning — expect it to take 5-10x
longer but catch more vulnerabilities.

## Verify

- Run `make quick-scan` against a known-clean staging environment — the exit
  code should be 0 and a JSON report appears in `reports/`.
- Deploy a deliberately vulnerable test page (e.g. one with a reflected XSS
  parameter) and re-run — the scan should flag it and the exit code should be
  non-zero.
- Open a PR against your repo and confirm the CI workflow runs and produces a
  report artifact.

## Maintenance

The `.github/dependabot.yml` file configures Dependabot to keep the ZAP Docker
image up to date. Review and merge Dependabot PRs in your repository to receive
security fixes and base image updates automatically.

## Common errors

- **ZAP container exits immediately**: usually a missing target URL or invalid
  plan syntax. Run `docker logs zap-dast-worker` to check.
- **No URLs discovered**: the spider may not be able to reach the target.
  Verify the target is accessible from the Docker host and not behind a VPN
  or firewall.
- **Plan parsing errors**: YAML indentation is significant in Automation
  Framework plans. Use `yamllint plans/*.yaml` to validate.
