---
last_verified: 2026-10-10
tool_version: n/a
---

# Trivy integration reference for container scanning

## Purpose

This reference maps the kit's Trivy container-scanning pieces into one flow: pick a scan entry point, shape the output for its consumer, gate the pipeline on the result, and publish the report where reviewers look. It does not re-teach SBOM generation, SARIF wiring, or multi-arch handling — those have their own docs — it shows which kit artifact covers each job and how the artifacts connect.

## When to use

- Scanning a single built image by hand: start with `trivy/snippets/scan-docker-image.sh`.
- Scanning one image with both human and machine output: use `trivy/scripts/container-vuln-scan.sh`.
- Gating a pipeline on severity thresholds with several report formats: use `trivy/scripts/image-vuln-pipeline.sh`.
- Scanning several target types (image, filesystem, repo) in one run: use `trivy/scripts/multi-target-scanner.sh`.
- Scanning every image in a Compose project: use `trivy/scripts/compose-multi-scan.sh`.
- Layering custom policy over scan results: use `trivy/scripts/custom-trivy-check-conftest.sh`.
- Running scans continuously inside a cluster: use `trivy/manifests/trivy-operator-deployment.yaml`.
- Uploading results to code scanning on a schedule: use `trivy/manifests/trivy-sarif-code-scanning.yaml`.

## Prerequisites

- Trivy installed and reachable on `PATH` (the Compose scanner fails fast with `Trivy is not installed` when it is absent).
- The target image available to the scanner (built or pulled before the scan step).
- `jq` available wherever a script parses JSON reports for threshold checks.
- The kit files listed above, read from this repo — all paths below are relative to the repo root.

## Steps

### 1. Pick the scan entry point

Match the job to the smallest artifact that does it:

| Job | Artifact | What it runs |
|---|---|---|
| First look at one image | `trivy/snippets/scan-docker-image.sh` | `trivy image` with a severity filter, table output, non-zero exit on findings |
| One image, two outputs | `trivy/scripts/container-vuln-scan.sh` | `trivy image` twice into an output dir: full table plus filtered JSON |
| Full gated pipeline | `trivy/scripts/image-vuln-pipeline.sh` | One pass producing SARIF, JSON, and a summary, compared against fail thresholds |
| Mixed targets | `trivy/scripts/multi-target-scanner.sh` | `image:`, `fs:`, and `repo:` targets, per-target SARIF plus JSON |
| Compose fleet | `trivy/scripts/compose-multi-scan.sh` | Image names extracted from `docker-compose.yml`, per-image reports plus a summary table |
| Custom policy overlay | `trivy/scripts/custom-trivy-check-conftest.sh` | Misconfiguration scan evaluated against a Rego policy directory |

Each script prints its own usage line when called with no arguments; follow that line rather than guessing flags.

### 2. Set severity and exit behaviour in one place

`trivy/configs/trivy-scan-config.yaml` is the shared scan configuration. Its keys, as shipped, are:

- `severity`: the levels reported (as shipped: CRITICAL, HIGH, MEDIUM).
- `scan.skip-db-update`: whether to skip the database refresh on repeat runs.
- `vulnerability.only-fixed` / `vulnerability.ignore-unfixed`: how findings without an available fix are treated.
- `format`: the default report rendering.
- `exit-code`: the process exit when findings remain after filtering.

Keep per-run overrides in the calling script and long-lived defaults in this file, so a threshold change is one diff in one file.

### 3. Shape the output for its consumer

- Human triage: table output, as written by `container-vuln-scan.sh` next to each JSON report.
- Programmatic gating: JSON output parsed with `jq`, as done by `image-vuln-pipeline.sh` and `ignore-rules-pipeline.sh`.
- Code scanning tabs: SARIF output uploaded by `trivy/manifests/trivy-sarif-code-scanning.yaml` and discussed in `trivy/docs/ci-pipeline-sarif-output.md`.
- Format and mode comparisons: `trivy/notebooks/trivy-scan-mode-comparison.ipynb` and `trivy/notebooks/trivy-sarif-output-processing.ipynb`.
- SBOM-shaped output: `trivy/docs/sbom-scanning-reference-guide.md`.
- Multi-architecture images: `trivy/docs/multi-arch-vulnerability-scanning.md`.
- Multi-platform CI wiring: `trivy/docs/ci-cd-pipeline-recipes.md`.

### 4. Gate the build

Two gating styles ship in the kit:

- Threshold gating (`trivy/scripts/image-vuln-pipeline.sh`): severity counts from the JSON report are compared against configurable fail thresholds; exceeding them exits non-zero.
- Ignorefile gating (`trivy/scripts/ignore-rules-pipeline.sh`): an ignorefile suppresses acknowledged findings per target, and the upper-cased `FAIL_ON` severities decide the exit.

Run the scan step so the report files are written even when the gate fails — otherwise a failing gate deletes the evidence reviewers need. The SARIF doc in this repo calls out the same ordering hazard for uploads.

### 5. Run it on a schedule or in the cluster

- Scheduled CI scanning: `trivy/manifests/trivy-sarif-code-scanning.yaml` runs on push, pull request, and a weekly timer, with cache, severity, and target taken from environment.
- In-cluster continuous scanning: `trivy/manifests/trivy-operator-deployment.yaml` installs the operator controller and node collector; verify with `kubectl get vulnerabilityreports -A`.

## Verify

- The config file parses as YAML and every key edited exists in the shipped file.
- Each script's usage line runs: call with no arguments and confirm it prints usage instead of scanning.
- After a trial run, the output directory holds both the human-readable and machine-readable reports for the target.
- The gate exits non-zero on a deliberately vulnerable fixture image and zero once findings are acknowledged via the ignorefile.
- The SARIF upload step runs after the scan step regardless of gate outcome, so reports are never skipped on failure.
- In-cluster, `vulnerabilityreports` resources appear for running workloads after the operator manifest is applied.

## Rollback

- Config or threshold change: revert the single diff to `trivy/configs/trivy-scan-config.yaml` or the calling script in version control and re-run; prior reports in the output directory are untouched and remain comparable.
- Bad scheduled-workflow edit: restore the previous revision of `trivy/manifests/trivy-sarif-code-scanning.yaml`; the weekly timer re-establishes itself on the next run.
- Bad operator change: re-apply the previous revision of `trivy/manifests/trivy-operator-deployment.yaml`; collection resumes from the restored manifest with no per-image state to migrate.

## Common errors

| Symptom | Likely cause | Fix |
|---|---|---|
| `Trivy is not installed` | Scanner missing on the runner | Install Trivy on the runner image before the scan step |
| `No docker-compose.yml found` | Wrong project directory passed | Point the Compose scanner at the directory holding the Compose file |
| SARIF never uploaded | Gate exited before the upload step | Order scan, then upload, then gate — keep evidence on failure |
| Gate always passes | Severity filter compared in the wrong case or against the wrong field | Normalise case before comparing, as `ignore-rules-pipeline.sh` does with its `FAIL_ON` value |
| Gate always fails after acknowledging findings | Ignorefile path wrong or empty | Confirm the ignorefile exists at the given path and is passed for that target |
| Repeat runs are slow | Database re-downloaded every run | Cache the database directory between runs and skip the update on repeats |

## References

- `trivy/snippets/scan-docker-image.sh`
- `trivy/scripts/container-vuln-scan.sh`
- `trivy/scripts/image-vuln-pipeline.sh`
- `trivy/scripts/ignore-rules-pipeline.sh`
- `trivy/scripts/multi-target-scanner.sh`
- `trivy/scripts/compose-multi-scan.sh`
- `trivy/scripts/custom-trivy-check-conftest.sh`
- `trivy/configs/trivy-scan-config.yaml`
- `trivy/manifests/trivy-sarif-code-scanning.yaml`
- `trivy/manifests/trivy-operator-deployment.yaml`
- `trivy/docs/ci-cd-pipeline-recipes.md`
- `trivy/docs/ci-pipeline-sarif-output.md`
- `trivy/docs/sbom-scanning-reference-guide.md`
- `trivy/docs/multi-arch-vulnerability-scanning.md`
