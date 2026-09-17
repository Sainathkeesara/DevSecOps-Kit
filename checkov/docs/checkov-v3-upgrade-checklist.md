---
last_verified: 2026-09-17
tool_version: "n/a"
sources: []
---

# Checkov major-version upgrade checklist

> A rollout checklist for moving a Checkov installation to a newer major release while keeping scan results and policy gates understandable.

## Purpose

This checklist separates the operational work of a major-version upgrade from the version-specific change catalog. It helps a team inventory every scanner invocation, preserve a comparable test run, make a small upgrade change, and verify that the gate still behaves as intended.

The checklist intentionally does not state which options, APIs, authentication fields, or output behaviors changed. Those details vary by release and must be taken from the migration notes for the exact version being installed. This file is an execution checklist; the version-specific migration guide remains the place to record those differences.

## When to use

- A repository uses Checkov as part of a review or delivery gate and is changing the installed major release.
- The scan is invoked from more than one place, such as local tooling, scheduled jobs, or repository automation.
- Custom checks, report consumers, or wrapper code may depend on behavior from the previous release.
- A team needs a repeatable way to compare results before accepting the upgrade.

## Prerequisites

- Access to every repository or workspace where the scanner is invoked.
- A representative set of infrastructure fixtures with both expected findings and expected clean results.
- A way to install a selected release consistently in the local environment and in the review environment.
- Permission to create a trial change and retain the previous installation reference for comparison.
- The migration notes published for the selected release, available before editing scan configuration.

## Steps

### 1. Inventory the current setup

List each invocation and record where it runs, how the scanner is installed, which inputs it scans, and which result the caller consumes. Include local commands, scheduled jobs, repository automation, pre-commit tooling, and wrapper programs. Note whether the installation reference is pinned or allowed to move.

Do not change anything during this pass. The inventory is the map used to decide which surfaces need a trial run.

### 2. Capture a baseline

Run the current installation against the representative fixtures and retain the complete result set. Record the exit behavior, the number and identity of reported checks, and the reports consumed by downstream tooling. Keep the fixture contents and scan inputs unchanged for the comparison run.

A baseline is useful only when it is reproducible. Store it somewhere the person reviewing the upgrade can retrieve it without rerunning unrelated work.

### 3. Read the release migration notes

Before editing configuration, read the migration notes for the selected release and mark every item that affects the inventory. Translate each relevant item into a concrete check for this repository. If a note does not affect the current setup, record that it was reviewed rather than silently assuming it is irrelevant.

Do not copy a generic migration claim into this checklist. Keep release-specific details in the version-specific guide or in the change record for the selected release.

### 4. Make one trial change

Create a trial change that updates the installation reference and only the configuration required by the reviewed migration notes. Keep policy edits, ignore-list changes, fixture changes, and unrelated refactoring out of the same change. A narrow change makes a failing run easier to attribute.

If custom checks or result parsers are involved, update them in small, reviewable steps. Preserve the previous version reference in the change history so the team can return to a known state while investigating.

### 5. Run the same comparison

Run the upgraded installation against the unchanged fixtures. Compare the new result set with the baseline, including checks that disappear as well as checks that appear. For every difference, link the explanation to a reviewed migration note, an intentional policy change, or a corrected fixture.

Treat an unexplained disappearance as a failed verification. A gate that reports fewer findings is not necessarily safer; the team must know whether a check stopped running or whether the input genuinely changed.

### 6. Check the consumers

Verify every program that reads the scanner result. Confirm that it can parse the retained report, that required fields are still present, and that its gate decision matches the intended policy. Also verify that custom checks load and that their expected identities are represented in the result.

If authentication or remote attribution is part of the setup, test it with the selected release using the repository's approved credentials and configuration. Do not place credentials or secrets in the trial change or its reports.

### 7. Review and release gradually

Have a second reviewer inspect the installation change, the migration-note mapping, the baseline comparison, and the consumer checks. Merge only after the differences are explained and the known-bad and known-good fixtures produce the intended outcomes.

Watch the first scheduled and manual runs after release. Keep the baseline and the previous installation reference available until those runs are understood.

## Verify

1. Every invocation from the inventory has a corresponding trial result.
2. The upgraded run completes against the unchanged fixtures without an unexplained startup failure.
3. The before-and-after result comparison accounts for every added, removed, or changed finding.
4. Custom checks load and the expected check identities remain visible.
5. Report consumers parse the retained output and enforce the intended gate decision.
6. Authentication and remote attribution, when used, are verified without storing credentials in the repository.
7. The trial change contains no unrelated policy, fixture, or refactoring edits.
8. The previous installation reference and baseline remain available for investigation.

## Rollback

If the upgraded run cannot be explained or the gate behaves incorrectly, restore the previous installation reference and the matching configuration changes. Re-run the unchanged fixtures to confirm that the prior baseline behavior returns. Keep the failed comparison and review notes so the next attempt starts from the observed failure rather than from an incomplete memory of it.

Rollback is a temporary recovery step, not a substitute for resolving the version-specific change. Open a fresh trial change after the cause is understood.

## Common errors

| Symptom | Likely area to inspect | Response |
|---|---|---|
| The upgraded run fails before scanning | Installation reference or invocation configuration | Compare the trial change with the baseline and consult the selected release's migration notes |
| Custom checks do not load | Custom-check loading or compatibility | Test one check at a time and map the failure to the relevant migration note |
| The result count changes without an explanation | Scan inputs, check registration, or report parsing | Re-run the unchanged fixtures and compare check identities, not only totals |
| A report consumer rejects the output | Report format or field handling | Validate the retained report against the consumer's expected contract |
| The gate passes a known-bad fixture | Gate configuration or missing checks | Restore the previous reference, investigate the difference, and repeat verification |
| The upgrade works locally but not in the review environment | Installation consistency or environment-specific configuration | Compare installation references and environment inputs before changing policy |

## References

Use the migration notes published for the exact Checkov release selected for the trial. Keep version-specific flags, API changes, authentication requirements, and output differences in that release-specific guide rather than in this operational checklist.
