---
last_verified: 2026-08-19
tool_version: n/a
sources: []
---

# GitGuardian multi-repo scanning scaffold

A project scaffold for running GitGuardian `ggshield` secret scans across multiple
repositories with a centralized allowlist, configurable detector rules, and CI
integration.

## Purpose

Organizations managing more than a handful of repositories need a consistent way to
run secret scans without duplicating configuration in every repo. This scaffold puts
the shared settings — allowlists, ignored paths, and ignored detectors — in one
centralized place and provides a runner script that can target a list of repositories.

The goal is not to replace per-repo CI gates, but to add an org-wide safety net that
catches secrets that slip past local hooks or forgotten PR scans.

## When to use

- You have 3+ repositories that all need the same secret-scanning baseline.
- Teams want a single allowlist instead of maintaining copies in every repo.
- You need both a local runner (for ad-hoc org audits) and a scheduled CI workflow.
- You already use `ggshield` and want to scale coverage without scaling config drift.

## Prerequisites

- `ggshield` installed and authenticated with a GitGuardian API token.
- `git` CLI with SSH keys or a personal access token that can clone target repos.
- `jq` for JSON post-processing in the runner scripts.
- A GitHub organization or account with repositories to scan.

## Structure

```
gitguardian-multi-repo-scanning-scaffold/
├── README.md
├── Makefile
├── .gitignore
├── repos.txt                     # One repository URL per line
├── ggshield.yaml                 # Root ggshield config
├── .ggshield/
│   └── allowlist.yaml            # Centralized allowlist
├── scripts/
│   ├── scan-multi-repo.sh        # Clone + scan each repo
│   └── aggregate-report.sh       # Merge per-repo JSON into summary
└── .github/workflows/
    └── org-secret-scan.yml       # Scheduled org-wide scan
```

## Steps

### 1. List the target repositories

Edit `repos.txt` and add every repository URL you want to scan:

```
https://github.com/org/service-a
https://github.com/org/service-b
https://github.com/org/service-c
```

The runner reads this file line by line. If a URL is unreachable, the script logs
the failure and continues to the next repo rather than aborting the whole batch.

### 2. Configure the centralized allowlist

Edit `.ggshield/allowlist.yaml` with false positives that apply across all scanned
repos. Each entry needs a `path`, `line`, and `reason` so the allowlist stays
auditable:

```yaml
allowlist:
  - path: "docs/examples/aws-config.example"
    line: 12
    reason: "Example credential in documentation"
  - path: "test/fixtures/stripe-seed.json"
    line: 3
    reason: "Test fixture with Stripe test key"
```

### 3. Tune the root config

`ggshield.yaml` sets the baseline for every scan. The runner passes this file to
`ggshield` with `--config-path` so the same config is used regardless of which repo
is being scanned:

```yaml
version: "2"
ignore-known-paths:
  - "node_modules/"
  - "vendor/"
  - "dist/"
ignored-detectors:
  - "generic_api_key"
ignored-paths:
  - "*.generated.go"
  - "*.min.js"
```

### 4. Run a local audit

```bash
make scan
```

This clones each repository into a temp directory, runs `ggshield secret scan path .`
against the working tree, and writes a timestamped JSON report to `reports/`.

If `GG_TOKEN` is set, authenticated scans run against the GitGuardian dashboard.
Without it, the scan still works locally but findings are not posted.

### 5. Schedule the CI workflow

Push the scaffold to a "meta" repository in your organization. The workflow at
`.github/workflows/org-secret-scan.yml` runs on a cron schedule and on-demand via
`workflow_dispatch`. It reads `repos.txt`, executes the runner, and uploads the
aggregated report as a workflow artifact.

## Verify

- Add a test repository containing a known-looking secret (e.g. `sk_test_xxx`) outside
  any ignored path. Run `make scan` and confirm the report lists it with the correct
  file and line number.
- Add the same test secret to the allowlist in `.ggshield/allowlist.yaml`. Re-run and
  confirm it is excluded from the aggregated report.
- Open the meta repo in GitHub and confirm the scheduled workflow produces an artifact
  with the expected JSON structure.
- Verify that a repository listed in `repos.txt` with a bad URL logs a warning and
  continues scanning the remaining repos.

## Common errors

- **ggshield auth missing:** `ggshield` returns exit 2 when `GITGUARDIAN_API_KEY` is
  not set. The runner checks for this and exits with a clear message rather than
  silently skipping findings.
- **Allowlist entry not matched:** The `path` must match the relative path inside the
  cloned repo, not the full filesystem path. Common mistake is including a leading `/`
  or the temp directory name.
- **JSON shape mismatch across ggshield versions:** Older ggshield versions emit a raw
  array from `--json`; newer versions wrap it in a `secrets_scan` object. The
  `aggregate-report.sh` script normalizes both shapes before merging.
- **Rate limits on org scans:** Cloning 50+ repos in one workflow can hit GitHub API
  rate limits. The runner sleeps between clones and respects `X-RateLimit-Remaining`
  headers when present.
