---
last_verified: 2026-10-11
tool_version: n/a
sources: []
---

# Trivy database migration guide

## Purpose

This guide moves the kit's Trivy scanning setup from one vulnerability-database arrangement to another without breaking scan gates or losing coverage history. A database migration here means any change to where the vulnerability data lives or how it reaches the scanner: a new database location, a changed cache directory layout, or a shift from per-run downloads to a shared or pre-populated cache. It does not re-teach routine database refreshes or scan configuration — those are covered by `../configs/trivy-scan-config.yaml` and `trivy-integration-reference-container-scanning.md` — it covers the controlled move from the old arrangement to the new one.

## When to use

- The database location pinned in the kit no longer matches what the scanner expects, and scans fail or silently fall back to stale data.
- The cache directory layout changes (for example a runner image moves the cache home), so previously warm caches stop being reused.
- Consolidating several one-off database downloads into one shared or pre-populated cache to shorten CI runs.
- Do not use this guide for a routine refresh of an unchanged database location; that is a normal scan run, not a migration.

## Prerequisites

- An inventory of every kit artifact that touches the database or its cache (see Step 1). All paths below are relative to the repo root.
- A recent scan report produced against the current database, kept as the comparison baseline.
- Write access to a scratch location for the new database or cache, separate from the live one.
- A single low-risk scan target to use as the canary before rolling the change out.

## Steps

### 1. Inventory every database touchpoint

Collect the full list before changing anything. In this kit the touchpoints are:

| Artifact | What it pins |
|---|---|
| `../configs/trivy-scan-config.yaml` | `scan.skip-db-update`: whether a run refreshes the database or reuses the cache |
| `../configs/.trivy.yaml` | Same `skip-db-update` key in the alternate config file |
| `../manifests/trivy-sarif-code-scanning.yaml` | `TRIVY_CACHE_DIR` (`/tmp/.trivy-cache`), cache restore steps, and `--cache-dir` on each scan invocation |
| `../manifests/trivy-operator-deployment.yaml` | `trivy.env` pins both the database repository and `TRIVY_CACHE_DIR` (`/home/scanner/.cache/trivy`) |
| `../templates/trivy-k8s-workload-scanning/trivy-config.yaml` | `cache-dir` for workload scans |
| `../docs/ci-cd-pipeline-recipes.md` | Per-platform cache locations and cache-key table |
| `../docs/sbom-scanning-reference-guide.md` | `TRIVY_CACHE_DIR` usage in SBOM scan workflows |
| `../notes/scanning-performance-optimization.md` | Cache refresh, pruning, and offline-mode behaviour |

If any file outside this list sets a cache directory or database location, add it to the inventory now; a migration that misses one writer leaves two databases diverging silently.

### 2. Record the baseline

Run one representative scan per target type against the current database and store the reports outside the normal output directory. Note the finding count per severity and the database age the scanner reports. This baseline is the standard the migrated setup is judged against in Step 4 — without it, a coverage regression after the move is undetectable.

### 3. Prepare the new location alongside the old one

Set up the new database or cache directory in a fresh location; do not reuse or overwrite the live one yet. Populate it with a full download or a copy of a pre-populated bundle, then confirm the directory is readable by the same user or service account that runs scans. Keep the old location untouched so every existing pipeline keeps working during the migration window.

### 4. Point one canary at the new location

Change exactly one scan entry point — one script invocation or one workflow job — to use the new location, and re-run the baseline target. Compare the new report against the baseline from Step 2:

- Finding counts per severity match, or every difference is explainable by database freshness rather than by missing data.
- The scanner reports the database age from the new location, proving it read the new data and not a leftover cache.
- Gates that consume the report (threshold checks in `../scripts/image-vuln-pipeline.sh`, ignorefile handling in `../scripts/ignore-rules-pipeline.sh`) produce the same pass or fail verdict as before.

If any check fails, the migration is not ready to roll out; diagnose using the Common errors table below while all other pipelines still use the old location.

### 5. Roll out touchpoint by touchpoint

Update the remaining inventory entries one diff at a time, in this order: local scripts and configs first, then scheduled workflows, then in-cluster manifests and templates last. Re-run the affected scan after each diff and confirm the report lands where reviewers expect before moving to the next entry. Keep each change to a single file so any regression bisects to exactly one diff.

### 6. Retire the old location

Once every touchpoint reads from the new location and at least one full schedule cycle (nightly or weekly scans, plus operator-driven collection) has completed cleanly, back up the old database directory once, then remove it and prune any cache keys that referenced it. Update the per-platform cache table in `../docs/ci-cd-pipeline-recipes.md` if a location documented there changed.

## Verify

- Every file in the Step 1 inventory points at the new location; no stale path remains.
- A fresh scan of the baseline target reproduces the baseline finding counts.
- The scanner-reported database age is current, confirming reads come from the new location.
- Threshold and ignorefile gates return the same verdicts as the pre-migration baseline.
- One full scheduled cycle completes with reports uploaded and no cache-miss warnings.
- The old location is backed up once and then removed, with no pipeline still referencing it.

## Rollback

- Single script or config change: revert the one diff in version control and re-run; reports already produced are untouched and remain comparable.
- Bad scheduled-workflow edit: restore the previous revision of `../manifests/trivy-sarif-code-scanning.yaml`; the timer re-establishes itself on the next run.
- Bad operator or template change: re-apply the previous revision of the manifest; collection resumes from the restored file.
- Data-level rollback: point the cache directory variable back at the retained backup of the old location and re-run the canary comparison before rolling forward again.
- What is not a rollback lever: re-running a scan does not reconstruct a deleted database — the backup copy from Step 6 is the only way back once the old location is removed, so do not delete it until the Verify list is fully clean.

## Common errors

| Symptom | Likely cause | Fix |
|---|---|---|
| Scans slow down after the move | New location not actually cached; every run re-downloads | Confirm the cache directory persists between runs and `skip-db-update` behaviour matches the old setup |
| Finding counts differ from baseline | Old and new databases at different freshness, or two locations in use at once | Check the scanner-reported database age on both reports; confirm no touchpoint still points at the old location |
| Gate verdict flips with no code change | Threshold or ignorefile evaluated against a report from a different database | Re-run baseline and migrated scans back to back, then compare verdicts on the paired reports |
| Offline or restricted runner fails | New location unreachable without network and no pre-populated cache present | Pre-populate the cache as described in `../notes/scanning-performance-optimization.md` before switching the runner |
| Permission denied on the cache directory | New path owned by a different user than the scan step | Create the directory with the scan user or service account, matching the ownership pattern of the old location |
| Operator keeps reporting old results | In-cluster manifest still pins the previous database or cache path | Update `trivy.env` in `../manifests/trivy-operator-deployment.yaml` and wait one collection interval before judging |

## References

- `../configs/trivy-scan-config.yaml`
- `../configs/.trivy.yaml`
- `../manifests/trivy-sarif-code-scanning.yaml`
- `../manifests/trivy-operator-deployment.yaml`
- `../templates/trivy-k8s-workload-scanning/trivy-config.yaml`
- `../scripts/image-vuln-pipeline.sh`
- `../scripts/ignore-rules-pipeline.sh`
- `../docs/trivy-integration-reference-container-scanning.md`
- `../docs/ci-cd-pipeline-recipes.md`
- `../docs/ci-pipeline-sarif-output.md`
- `../docs/sbom-scanning-reference-guide.md`
- `../notes/scanning-performance-optimization.md`
