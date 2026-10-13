---
last_verified: 2026-10-13
tool_version: n/a
sources: []
---

# Trufflehog secrets database migration guide

## Purpose

Document how to migrate a TruffleHog secrets database — the detector catalog, verification cache, and findings store — between versions or storage backends so scans keep working after an upgrade or a backend move.

## When to use

Any time the installed TruffleHog version changes, the detector catalog is refreshed, the verification cache is cleared, or the findings store moves to a new backend. Read this before re-running scans so the new install behaves like the old one.

## Prerequisites

- TruffleHog installed and runnable (`trufflehog --help` confirms the version)
- The old database or cache directory is reachable
- A backup copy of the current store is available

## Steps

### 1. Record the current version and detector set

Run `trufflehog --version` and capture a baseline scan with `--json` so the pre-migration finding set is on disk:

```bash
trufflehog --version
trufflehog git file://./repo --json > baseline-before.json
```

### 2. Back up the database directory

The default cache directory is OS-specific; if a custom path was set with `--cache`, back that up instead. Copy it to a writable path before touching anything — the default cache dir may be on a read-only filesystem in containers.

### 3. Install the new version

TruffleHog does not auto-migrate the detector catalog. Re-run with `--no-update` to preserve the installed catalog, or let it refresh and re-baseline in the next step.

### 4. Clear or migrate the verification cache

Verification results are tied to detector version and endpoint state, so a stale cache can report verified findings that no longer verify. Delete the cache and re-run; re-verify against the baseline.

### 5. Re-run the baseline and diff

Re-run the baseline scan against the same target and diff the finding set. A changed detector set shows up as added or removed detector names; a changed cache shows up as verified status flips.

### 6. Promote only after the diff is understood

New detectors add coverage, removed detectors need a replacement or an ignore rule, and status flips need re-verification.

## Verify

- Run `trufflehog --version` before and after and confirm both versions.
- Re-run the baseline scan and confirm the finding count and detector-name set match the pre-migration baseline (within the expected diff).
- Confirm the verification cache path is empty or migrated and no stale verified findings remain.

## Rollback

Restore the backed-up database directory and re-run the baseline scan; the pre-migration finding set and cache state return. A scan does not resume after interruption — re-run the workflow instead.

## Common errors

- **Database directory is read-only** — back up to a writable path before migrating; the default cache dir may be on a read-only filesystem in containers.
- **Detector catalog changed silently** — always diff the detector name set, not just the finding count, after an upgrade.
- **Verification cache reports stale verified findings** — clear the cache before re-baselining; do not carry it across a version change.
- **New version drops a detector you relied on** — pin the version until a replacement detector or ignore rule is in place.

## References

- TruffleHog CLI reference — `trufflehog --help`
- Detector catalog — `github.com/trufflesecurity/trufflehog/tree/main/pkg/detectors`
- Configuration file schema — `github.com/trufflesecurity/trufflehog/tree/main/pkg/config`
- Scan mode comparison — `trufflehog/docs/comparing-scan-modes-git-filesystem-s3.md`
- Output format reference — `trufflehog/docs/trufflehog-output-formats-json-sarif-csv.md`
- CI/CD pipeline gate — `trufflehog/manifests/trufflehog-cicd-pipeline.yaml`