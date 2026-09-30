---
last_verified: 2026-09-30
tool_version: n/a
---

# ZAP scan configuration migration guide

## Purpose

This guide moves a ZAP setup from scattered legacy configuration — wrapper scripts with inline options, standalone context definitions, and one-off report commands — to a single version-controlled Automation Framework plan file. The plan declares scope, scan sequence, tuning, and reporting in one YAML document that ZAP reads at startup, so the same file drives local runs and CI runs. The companion reference for the plan layout itself is `zap-automation-plan-structure.md`; this guide covers only the migration path from the old shape to the new one.

## When to use

- Scan behaviour currently lives in two or more places (a CI job plus a local script plus a context file) and they have drifted apart
- Adding a new target URL or exclusion requires edits in several files and nobody is sure which one wins
- A team wants repeatable headless DAST runs where the full scan definition is reviewable in a pull request
- An existing setup built on the daemon-plus-API pattern in `zap-integration-patterns.md` needs to become declarative so it can be scheduled without maintaining polling scripts

## Prerequisites

- A working ZAP runtime (desktop, daemon, or container image — the plan format is the same regardless of launcher)
- Read access to the current scan configuration: CI job definitions, wrapper scripts, and any context or scope files
- A non-production target (staging or a deliberately vulnerable test app) to validate parity before switching CI over
- Familiarity with basic YAML syntax

## Steps

### 1. Inventory the current configuration

Collect every place scan behaviour is defined before changing anything:

1. List CI jobs that invoke ZAP and note what each one passes: target URL, scan depth or duration, and how the job decides pass or fail.
2. List wrapper scripts and note the same three things, plus any report-generation commands at the end.
3. List context or scope files and note include rules, exclude rules, and any authenticated areas.
4. Write the inventory down as a short table (location, target, scope rules, scan steps, report output). Anything missing from the table is something the migration could silently drop, so do this first.

### 2. Migrate scope into a context block

Legacy setups usually express scope as ad-hoc spider parameters or API query arguments spread across scripts. Consolidate each target into one named context under the plan's `env` key, following the context shape in `zap-automation-plan-structure.md`:

```yaml
env:
  contexts:
    - name: webapp
      urls:
        - "https://staging.example.com"
      includes:
        - "https://staging.example.com/.*"
      excludes:
        - "https://staging.example.com/static/.*"
        - "https://staging.example.com/logout"
```

Rules for this step:

- One context per application or per authenticated area, not one context per script. If two scripts scan the same app with slightly different excludes, reconcile them into a single exclude list now and record the decision in the pull request.
- Keep logout, static-asset, and third-party paths in `excludes`. Anything the spider must never touch belongs here, not in tribal knowledge.
- Every later job references the context by name. A typo in the name silently narrows or breaks the scan, so keep names short and reuse the same name across jobs.

### 3. Migrate the scan sequence into a jobs list

Legacy setups usually run spider, then optionally an active scan, then a report, as separate commands or API polling loops (the pattern in `zap-integration-patterns.md`). Translate that sequence into an ordered `jobs` list where each step names its context:

```yaml
jobs:
  - type: spider
    parameters:
      context: webapp
  - type: passiveScan-config
    parameters:
      scanOnlyInScope: true
  - type: report
    parameters:
      context: webapp
```

Rules for this step:

- Preserve the current scan depth policy. A setup that runs spider plus passive checks today (the fast CI smoke-test shape) becomes spider plus reporting jobs only — do not add an active-scan job as a side effect of migrating.
- A setup that runs active scans keeps an active-scan job in the same position it runs today (after spidering, before reporting). Active scanning sends attack payloads and is the slow step; keep whatever duration or strength limits the current setup applies.
- Place tuning jobs such as `passiveScan-config` before the jobs whose traffic they govern. Configuration declared after the spider has already run does not apply retroactively to that run.

### 4. Migrate tuning and thresholds

Legacy tuning usually hides in script variables or CI environment settings: alert caps, in-scope-only flags, and the pass-or-fail gate (for example, fail the build on High findings). Move each one explicitly:

1. Passive-scan tuning goes in the `passiveScan-config` job parameters (alert caps, scope restriction), as shown in `zap-automation-plan-structure.md`.
2. The CI pass-or-fail gate stays in the CI job, not in the plan — the plan defines what to scan and report, the pipeline decides what fails the build. Document the gate next to the plan file so reviewers see both halves.
3. Delete no threshold until its replacement is visible in either the plan or the pipeline definition. The inventory table from Step 1 is the checklist: every row must map to exactly one new location.

### 5. Migrate reporting

Legacy reporting is usually a final API call or CLI flag that writes one report file. Replace it with a `report` job at the end of the jobs list writing to the same path the pipeline already consumes, so downstream steps (artifact upload, finding triage) keep working unchanged. Confirm the report template and output directory match what the pipeline expects before deleting the old report command.

### 6. Cut CI over to the plan

1. Add a CI step that runs the plan file headless against the staging target. Keep the legacy scan step in place but non-gating during the transition.
2. Compare the two reports (see Verify below) until they agree on scope and findings for at least two consecutive runs.
3. Remove the legacy scan step and the polling scripts it depended on. Leave the plan file as the single source of scan behaviour.

### 7. Remove the legacy files

Delete the superseded wrapper scripts, duplicated context files, and polling loops. If anything in the old files is still referenced by other jobs, move those references first — a migration that leaves dead files behind recreates the drift it was meant to fix.

## Verify

1. Run the plan against the staging target and confirm the spider discovers the expected URL set with context filters applied.
2. Confirm excluded paths (logout, static assets, third-party hosts) do not appear in the report URLs.
3. Confirm the report lands at the path the pipeline consumes and downstream steps (upload, triage) run unchanged.
4. Diff the plan-driven report against the last legacy report for the same target: same scope, no new gaps, differences explainable by intended tuning changes only.
5. Confirm the CI gate still fails the build on the same finding severity it failed on before the migration.
6. Re-run to check stability — two consecutive runs should agree on scope and finding counts for an unchanged target.

## Rollback

Rollback is relevant here because the migration touches the security gate of the pipeline.

1. Keep the legacy scripts and CI steps in the repository (moved aside, not deleted) until the Verify checklist passes on at least two consecutive plan-driven runs.
2. To roll back, re-enable the legacy CI step as the gating step and remove the plan step. No plan-file change is needed since the legacy path does not read it.
3. If reports disagree during the transition, treat the legacy report as authoritative until the discrepancy is explained — never weaken the build gate to make the new report pass.
4. After the cutover is stable, delete the legacy files in a follow-up change so the repository holds exactly one scan definition.

## Common errors

- **Context name mismatch** — Jobs reference contexts by name, so a typo means a job silently runs out of scope or fails. Copy the name rather than retyping it, and keep a single context per application.
- **Exclude patterns too broad** — An over-broad exclude silently removes legitimate paths from the scan and the report looks clean for the wrong reason. Test patterns against the spider's discovered-URL list before finalising.
- **Tuning job placed after the traffic it should govern** — Passive-scan configuration must precede spider and active-scan jobs in the jobs list; placed after them, defaults apply to the whole run.
- **Plan file not visible inside the container** — When ZAP runs containerised, the plan path must be mounted or copied into the runtime. A missing mount fails the run before any scanning starts; verify the file resolves from inside the runtime, not just on the host.
- **Gate weakened during migration** — Moving the pass-or-fail threshold is not part of this migration. If the new report trips the gate, fix the scope or the application finding first; do not relax the gate to unblock the cutover.
- **Authenticated areas unscanned after migration** — Session seeding or login steps that lived in scripts must become explicit jobs or context session definitions in the plan. If the migrated report shows no authenticated URLs, the auth step was dropped in transit.

## References

- `zap-automation-plan-structure.md` — plan layout, contexts, request jobs, and passive-scan tuning used throughout this guide
- `zap-integration-patterns.md` — the daemon-plus-API pattern this guide migrates away from, and the scan-type comparison (baseline vs full) for choosing what the jobs list should contain
- `passive-vs-active-scanning-zap.md` — background on which scan steps belong in a fast CI run versus a deep pre-release run
