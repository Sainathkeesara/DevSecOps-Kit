---
last_verified: 2026-10-06
tool_version: n/a
---

# Integrating Snyk with CI/CD security scanning

## Purpose

This reference describes how to place Snyk scans inside a CI/CD pipeline so that every change is checked at the right stage: fast feedback on pull requests, a recorded snapshot on merge to the default branch, and recurring monitoring for newly disclosed issues in already-merged code. It defines which scan result blocks a merge and which result only records information for later triage.

## When to use

Use this pattern when a repository already builds and tests on every pull request and needs a security gate that fits the existing stages without adding a separate manual review step. It applies to single-project and multi-project layouts; for per-service project naming in monorepos, combine it with the per-service approach in `multi-project-ci-pipeline.md`.

Do not use this pattern as a replacement for continuous monitoring configuration or for prioritising the findings themselves — those are covered by `vulnerability-prioritization-reachability-fix-prs-license-compliance.md`.

## Prerequisites

- A Snyk account with an API token stored as a CI secret (for example `SNYK_TOKEN`). The pipeline reads it from the secret store at run time; the token never appears in committed files.
- The Snyk CLI available in the CI job, either pre-installed on the runner image or installed by the workflow before the scan step.
- A pipeline with at least two trigger types: pull-request runs for gating and default-branch runs for recording snapshots.
- The existing pipeline workflow in `snyk-github-actions-cicd-workflow.yaml` and the local scan helper in `snyk-vuln-scan-pipeline.sh` available as starting points.

## Steps

### 1. Assign each scan a pipeline stage

Run a blocking scan on pull requests and a recording scan on the default branch. The pull-request job runs `snyk test` and fails the check when findings exceed the agreed threshold. The default-branch job runs `snyk monitor` after a successful merge so the dashboard holds a snapshot of exactly what was released. A scheduled run of `snyk monitor` on the default branch covers newly disclosed issues in code that has not changed.

A minimal stage table:

| Trigger | Scan | Outcome on findings |
|---|---|---|
| Pull request | `snyk test` | Fail the check when above threshold |
| Push to default branch | `snyk monitor` | Record snapshot; fail only on execution error |
| Scheduled (e.g. weekly) | `snyk monitor` | Record snapshot; notify, do not block |

### 2. Define the gating threshold before wiring the job

Agree the fail threshold with the owning team before the first gated run: which severity level fails the pull-request check, and whether only fixable (upgradable) findings fail it. Encode the threshold as an explicit job input or environment value so a threshold change is a visible pipeline edit, not a silent CLI tweak. Start strict on new code and keep the scheduled monitor as the backstop for pre-existing findings.

### 3. Wire the pull-request gate

Add a job to the pull-request workflow that checks out the merge commit, authenticates with the stored token, and runs `snyk test` with the agreed threshold. Keep the job read-only: it needs repository contents and permission to report a check result, not write access to code. The job fails when the scan exit status indicates findings above threshold; it also fails when the scan itself errors (authentication failure, missing manifest), so infrastructure breakage is never mistaken for a clean result.

### 4. Wire the default-branch snapshot

Add a second job that runs only on pushes to the default branch (and on the schedule) and executes `snyk monitor`. This job records the result under a stable project name so successive snapshots form one history per project. On failure of the scan execution itself, the job fails and notifies; on findings alone, it records and passes, because triage happens against the dashboard, not by reverting the merge.

### 5. Route scan output to a durable location

Persist the scan report as a pipeline artifact on every run, including passing runs, so a later question about what a given merge introduced can be answered from the run record rather than re-running the scan. Name the artifact with the run identifier and the project or service name so multi-project runs stay distinguishable. Link the artifact from the pull-request check summary when the platform supports it.

### 6. Define the failure handoff

A failing gate must tell the author what to do next without requiring Snyk expertise: which finding severities caused the failure, where the full report artifact is, and who owns the exception path. Document the exception path explicitly — a time-boxed ignore with an owner and an expiry, reviewed on a fixed cadence — and forbid broad suppressions that silence whole categories. Route confirmed exploitable findings to the team rotation; route tooling failures (authentication, network, missing lockfile) to the pipeline owners.

## Verify

1. Open a pull request that introduces a dependency with a known finding above the threshold and confirm the Snyk job fails while other jobs behave normally.
2. Merge a clean change and confirm the default-branch job records a new snapshot under the expected project name.
3. Trigger the scheduled run manually (or wait for the next schedule) and confirm it records without opening or closing pull requests.
4. Break the scan deliberately in a test branch (for example, remove the token) and confirm the job fails with an execution error rather than reporting a clean scan.
5. Download the report artifact from a completed run and confirm it names the run and project unambiguously.

## Common errors

1. **Gating on the monitor job.** The default-branch snapshot job is configured to fail on findings, so every merge with a pre-existing finding blocks the pipeline retroactively. Fix: only the pull-request `snyk test` job gates; monitor jobs record.
2. **Silent pass on tooling failure.** The scan step swallows a non-zero exit from authentication or setup, so a broken scan reports success. Fix: check the scan's exit status separately from the findings threshold and fail the job on execution errors.
3. **Threshold hidden in the command line.** The severity threshold lives only inside a long shell line, so nobody can tell what the gate enforces without reading job logs. Fix: promote the threshold to a named job input or environment value documented in the workflow header.
4. **Snapshot project name drifts.** The monitor job derives the project name from a branch-specific value, so each branch creates a new dashboard project and history fragments. Fix: pin the project name to the repository and service path, independent of branch.
5. **Whole-category suppression as triage.** An ignore rule silences an entire severity or dependency to unblock a release, hiding later findings of the same kind. Fix: scope ignores to the specific finding with an owner and expiry, and review open ignores on the same cadence as the scheduled scan.

## References

- `../manifests/snyk-github-actions-cicd-workflow.yaml` — pipeline workflow with separate test and monitor jobs, the starting point for the stage layout above.
- `../scripts/snyk-vuln-scan-pipeline.sh` — local scan helper (test, monitor, threshold exit) for reproducing a gated result outside CI.
- `../docs/multi-project-ci-pipeline.md` — per-service project naming for monorepos; combine with this doc when one pipeline scans several services.
- `../docs/vulnerability-prioritization-reachability-fix-prs-license-compliance.md` — triage and prioritisation of the findings this pipeline surfaces.
- `../configs/snyk-ci-github-actions.yaml` — CI-oriented Snyk configuration referenced by the pipeline jobs.
