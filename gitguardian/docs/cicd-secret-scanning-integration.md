---
last_verified: 2026-10-03
tool_version: n/a
sources: []
---

# GitGuardian CI/CD secret scanning integration

## Purpose

This document describes how to integrate GitGuardian's `ggshield` CLI into CI/CD pipelines so that secret scanning runs automatically on every push and pull request. It covers both pre-merge (PR-level) scanning and scheduled full-repo scanning, and how scan findings connect to the kit's incident response pipeline.

## When to use this approach

Use this pattern when:

- Secrets must be blocked before they reach a protected branch
- The CI/CD platform is GitHub Actions, GitLab CI, or a similar pipeline runner
- Both per-commit (diff-scoped) and batch (full-repo) scanning strategies are needed
- Scan results should feed into an incident tracking or alerting system

## Prerequisites

- `ggshield` available in the CI runner — installed via pip, a container image, or the system package manager
- A GitGuardian API token with scanning permissions (e.g. `GITGUARDIAN_API_KEY` / `GITGUARDIAN_API_SECRET`)
- Access to modify the repository's CI/CD workflow definitions
- A `.ggshield.yaml` at the repository root (see `gitguardian/configs/.ggshield.yaml` for the base template)

## Steps

### 1. Install ggshield in the CI runner

Add a pre-step to the pipeline job that installs the CLI:

```bash
pip install ggshield
```

Alternatively, use a container image that already bundles `ggshield` so the install step is avoided entirely.

### 2. Configure ggshield for the repository

Place a `.ggshield.yaml` at the repository root. The configuration supports per-directory overrides and ignore rules. The base template lives at `gitguardian/configs/.ggshield.yaml`; for multi-team monorepos, see `gitguardian/configs/monorepo-allowlists.yaml` for the allowlist pattern.

### 3. Scan PR diffs before merge

In the CI workflow, run a scan scoped to the pull request diff:

```bash
ggshield secret scan ci
```

This command reads the CI environment context and scans only the commit range introduced by the pull request. When a secret is detected, the scan exits non-zero and the pipeline fails, preventing the merge.

### 4. Schedule full-repo scans

Configure a scheduled job (daily or weekly) that scans the entire repository:

```bash
ggshield secret scan path . --recursive --json
```

The JSON output can be post-processed to route findings to the correct teams by directory prefix. See `gitguardian/docs/monorepo-ci-per-team-exclusions.md` for the team-routing pattern.

### 5. Route findings to incident response

Pipe the scan output into the incident response pipeline:

```bash
./gitguardian/scripts/gg-incident-response-pipeline.sh
```

That script normalizes the JSON output, applies severity-based gating (`FAIL_ON` threshold), and optionally forwards findings to a webhook for alerting.

### 6. Enforce merge gates

Register the PR-level scan as a required status check in the branch protection rules so that pull requests containing secrets cannot be merged until findings are resolved.

## Verify

1. **PR scan blocks a test secret:** Add a file containing a plausible dummy secret value, open a pull request, and confirm the CI job fails with a finding.
2. **Scheduled scan produces output:** Run the full-repo scan manually and confirm it exits 0 with no findings, or reports the expected findings.
3. **Webhook routing works:** If using the incident response pipeline, confirm a test finding produces a non-empty JSON payload forwarded to the configured alert channel.
4. **Config isolation:** Confirm per-directory `.ggshield.yaml` overrides suppress expected noise (e.g. test fixtures) without masking real secrets.
5. **Required status check:** Confirm the branch protection rule lists the secret-scanning job as required, and that a PR cannot be merged while the check is failing.

## Common errors

- **Token scope too broad:** Using a GitGuardian account-level token instead of a scoped API token. The scan succeeds but findings are attributed to the wrong account, making triage harder.
- **Config not picked up:** Scanning from a subdirectory without passing `--config-path` means the root `.ggshield.yaml` is ignored, so custom ignore rules and allowlists do not apply.
- **Scheduled scan noise:** Without `secret.ignored_paths` entries in the config, generated files and vendored dependencies produce false positives. Reference `gitguardian/configs/.ggshield.yaml` for baseline exclusions.
- **CI environment not detected:** `ggshield secret scan ci` relies on CI-specific environment variables. Running it outside a CI context (e.g. locally without `CI=true`) falls back to scanning the full diff, not the PR range.
- **Merge gate bypassed:** If the secret-scanning job is not marked as required in branch protection, contributors can override the failure and merge anyway.

## References

- GitGuardian monorepo CI exclusion patterns: `gitguardian/docs/monorepo-ci-per-team-exclusions.md`
- Incident response pipeline script: `gitguardian/scripts/gg-incident-response-pipeline.sh`
- Base ggshield configuration: `gitguardian/configs/.ggshield.yaml`
- Monorepo allowlists config: `gitguardian/configs/monorepo-allowlists.yaml`
- Pre-commit hook integration: `gitguardian/scripts/pre-commit-hook-ggshield.sh`
