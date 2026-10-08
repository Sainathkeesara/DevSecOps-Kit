---
last_verified: 2026-10-08
tool_version: n/a
sources: []
---

# Snyk security policy migration patterns

Moving security policy configuration — ignore rules, severity thresholds, patch rules, and exclusion paths — from one form or environment to another without weakening the gate or losing accepted-risk suppressions.

## Purpose

A Snyk security policy is not a single file. It is a stack of decisions spread across a declarative policy file (ignore and patch rules keyed by finding identifier), a project configuration (severity gate, exclusion paths, and a pointer to the policy file), a per-language threshold config, and the CI workflow that executes the scan and interprets its exit status. As a repository grows from a single project to a multi-service monorepo, or as teams move from shared CI gates back to local triage, that stack must move with it — consolidate, split, promote, or reformat — while keeping the same pass-or-fail posture on the far side.

This doc covers the patterns the kit uses to migrate Snyk security policy between these forms. Each migration moves one layer at a time, introduces the new policy alongside the old one so the gate can be compared before the switch, and keeps the previous file in version control so rollback is a revert, not a rewrite from memory.

The worked references throughout are the kit's own policy files: the ignore/patch policy at `../configs/snyk-dependency-patch-ignore.yaml`, the per-project configuration template at `../configs/snyk-project-configuration-template.yaml`, the per-language threshold config at `../templates/snyk-multilang-scan-scaffold/policies/severity-policy.json`, the CI workflow at `../manifests/snyk-github-actions-cicd-workflow.yaml`, the scan pipeline script at `../scripts/snyk-vuln-scan-pipeline.sh`, and the CI integration pattern in `integrating-snyk-with-cicd-security-scanning.md`.

## When to use

- The repository grew from a single project to a multi-service monorepo, and the existing policy file no longer expresses per-service tolerance (different services need different ignore rules or severity thresholds).
- Teams want to move from ad-hoc CLI scan configuration to version-controlled, auditable policy files.
- Security policy must promote across environments (development → staging → production) with different severity gates at each stage.
- The policy file format or finding identifier scheme changed, and existing ignore rules need to be reconciled.
- Projects are consolidating across Snyk organizations, and policy must follow.
- A migration was already applied and the open question is how to prove the gate did not change, not how to apply it.

## Prerequisites

- The policy inventory: the ignore/patch policy file, the project configuration template, the per-language threshold file, and the CI workflow that consumes them — all listed in References.
- The scan pipeline script (`../scripts/snyk-vuln-scan-pipeline.sh`) running locally, so pass and fail behavior can be reproduced before and after migration.
- A recorded baseline: the count and severities of findings from the current policy, captured from a scan on the default branch.
- Version control of the policy files, so rollback is a file revert rather than a rewrite from memory.

## Steps

### 1. Inventory the policy layers separately

A Snyk security policy spans four independent layers. Migrating them all at once makes it impossible to attribute a gate change to the layer that caused it.

| Layer | Where it lives in the kit | What migrates |
|---|---|---|
| Ignore and patch rules | `../configs/snyk-dependency-patch-ignore.yaml` — the `ignore:` and `patch:` sections | Accepted-risk suppressions and remediation patches |
| Severity threshold | `../configs/snyk-project-configuration-template.yaml` — `severity_gate.fail_on`; per-language thresholds in `../templates/snyk-multilang-scan-scaffold/policies/severity-policy.json` | Which finding severities fail the build vs. record for monitoring |
| Exclusion paths | `../configs/snyk-project-configuration-template.yaml` — the `exclusions:` list | Which directories and files the scan skips |
| CI execution | `../manifests/snyk-github-actions-cicd-workflow.yaml` — the test (gating) job vs. the monitor (recording) job | Where and when the gate runs |

The layers migrate independently. A single "reconfigure everything" change that touches all four at once is the anti-pattern: if the finding count moves, there is no way to tell which layer moved it.

### 2. Decide which layers change and which stay fixed

Not every migration touches every layer. Moving from per-project policies to a monorepo-wide policy changes the ignore/patch file and the configuration template's `policy_file` pointer, but leaves the CI execution layer unchanged. Promoting thresholds across environments changes `severity_gate.fail_on` and the per-language config, but leaves ignore rules untouched. Identify the single layer that must change, and leave the others at their current values so the comparison in step 4 has one variable.

### 3. Introduce the new policy alongside the old, in recording mode

The kit's CI integration doc (`integrating-snyk-with-cicd-security-scanning.md`) describes the gating vs. recording split: the test job fails the PR check, the monitor job records a snapshot. A migration reuses this split. Add the new policy file or configuration alongside the old one, point a copy of the scan at the new policy, and let it run in recording mode — it collects findings without failing the gate. The old policy keeps enforcing while the new one measures; neither is edited in place.

For a threshold migration, this means running the scan with the new `fail_on` value and capturing the finding count, but not wiring it into the PR gate until step 5. For an ignore-rule migration, this means placing the new policy file next to the old one and running a scan that applies the new ignores, then comparing the finding count against the baseline.

### 4. Diff the scan output, not the file

The migration signal is the finding set, not whether the new policy file loaded without error. Compare the finding count and severities from the scan using the new policy against the recorded baseline from step 0 of the same workload on the default branch. A non-empty diff is a behavior change — investigate before promoting.

Key comparison points:

- Total finding count (should be equal or lower, never higher without explanation).
- Finding severities (no severity should jump from passing to failing without investigation).
- Ignored findings (the new policy should not silently un-ignore anything the old one suppressed).
- Excluded paths (the new exclusions should not expose previously-skipped directories).

### 5. Promote by switching enforcement, then retire the old layer

Once the new policy's finding set matches the baseline for a full scan cycle, promote it to the active position: update the configuration template's `policy_file` pointer, set the `severity_gate.fail_on` to the new value, or swap the CI workflow to use the new file. Only then remove the old policy file or configuration.

The first scan after promotion is the evidence: if it produces the same gate decision as the pre-migration baseline, the migration is complete.

### 6. Roll back by reverting the file

Rollback is a revert of the configuration file in version control, not a rewrite from memory. Because step 3 kept the old policy alongside the new one until step 5 completed, the previous state is one `git checkout` away. The CI execution layer (described in `integrating-snyk-with-cicd-security-scanning.md`) provides the same dryrun-then-deny ladder that makes this safe: re-apply the old configuration, confirm the baseline finding count returns, and re-promote once the issue is diagnosed.

## Verify

After the migration completes, check:

1. The finding count and severity distribution from the new policy match the pre-migration baseline for the same workload.
2. No finding that was suppressed (ignored or excluded) under the old policy is exposed as a gate failure under the new one, unless explicitly intended.
3. The configuration template (`../configs/snyk-project-configuration-template.yaml`) points to the correct policy file path, and that path exists.
4. The CI workflow (`../manifests/snyk-github-actions-cicd-workflow.yaml`) test job fails on the same finding severities the old configuration did, and the monitor job records the same snapshot cadence.
5. A deliberately introduced ignore rule in the new policy file actually suppresses the intended finding — confirming the policy file is being loaded and applied, not silently ignored.

## Common errors

- **Migrating ignore rules without reconciling finding identifiers.** Vulnerability identifiers can change when Snyk re-keys or removes a finding. An ignore rule keyed to an old identifier silently stops matching, and the previously-suppressed finding surfaces as a new failure. Audit the ignore section against the current scan output before cutting over.
- **Changing the threshold and the ignore rules in one step.** If the gate fails after migration, there is no way to tell whether the new severity threshold exposed findings that the old ignores had suppressed, or whether the threshold itself changed the gate. Migrate one layer at a time.
- **Editing the old policy file in place instead of introducing a new one.** In-place edits destroy the comparison baseline. The old file should stay byte-for-byte unchanged until the new policy proves itself and the switch is deliberate.
- **Losing the policy-file pointer during a monorepo split.** When splitting one policy into per-service files, each service's configuration template must point to its own policy file. A service that forgets to update its `policy_file.path` silently inherits the wrong ignores.
- **Promoting before one full scan cycle.** The first scan after promotion may be catching up on newly-discovered findings unrelated to the policy change. Wait for a full cycle under the new policy before declaring the migration complete.

## References

- [`../configs/snyk-dependency-patch-ignore.yaml`](../configs/snyk-dependency-patch-ignore.yaml) — the ignore/patch policy file: accepted-risk suppressions and remediation patches keyed by finding identifier.
- [`../configs/snyk-project-configuration-template.yaml`](../configs/snyk-project-configuration-template.yaml) — the per-project configuration template: severity gate, exclusion paths, and the policy-file pointer that ties policy to pipeline.
- [`../configs/snyk-ci-github-actions.yaml`](../configs/snyk-ci-github-actions.yaml) — CI-side Snyk configuration consumed by the workflow.
- [`../templates/snyk-multilang-scan-scaffold/policies/severity-policy.json`](../templates/snyk-multilang-scan-scaffold/policies/severity-policy.json) — per-language severity thresholds.
- [`../manifests/snyk-github-actions-cicd-workflow.yaml`](../manifests/snyk-github-actions-cicd-workflow.yaml) — the CI/CD workflow with separate test (gating) and monitor (recording) jobs.
- [`../scripts/snyk-vuln-scan-pipeline.sh`](../scripts/snyk-vuln-scan-pipeline.sh) — the local scan pipeline: threshold gating, JSON output, and severity-count aggregation.
- [`integrating-snyk-with-cicd-security-scanning.md`](integrating-snyk-with-cicd-security-scanning.md) — the gating vs. recording split that makes non-blocking policy introduction possible.
- [`multi-project-ci-pipeline.md`](multi-project-ci-pipeline.md) — per-service project naming and matrix scanning for monorepos.
- [`vulnerability-prioritization-reachability-fix-prs-license-compliance.md`](vulnerability-prioritization-reachability-fix-prs-license-compliance.md) — triage and prioritization of findings the scan produces.
- [`../notes/0000-primer-snyk.md`](../notes/0000-primer-snyk.md) — first-contact Snyk concepts.
