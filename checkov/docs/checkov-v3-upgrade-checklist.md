---
last_verified: 2026-09-17
tool_version: "n/a"
---

# Checkov major-version upgrade checklist: 2.x to 3.x rollout without breaking the gate

## Purpose

This checklist turns a Checkov major-version upgrade into a repeatable rollout. It covers how to inventory every place that invokes the scanner, stage the upgrade off the default branch, compare findings before and after, and roll back fast if the gate breaks. For the catalog of what actually changed between major versions, see the companion [migration guide](checkov-v3-migration-guide.md).

## When to use

- You are planning to move a pipeline from the 2.x line to the 3.x line and want the upgrade to land as a routine change, not an incident.
- The scan step is load-bearing: it gates merges, releases, or environment promotion, so a broken upgrade blocks delivery.
- You maintain custom checks or wrappers around the scanner and need to confirm they still load and report after the upgrade.

## Prerequisites

- A checkout of every repository whose CI invokes the scanner, with permission to open a trial branch.
- A list of scan entry points: CI workflow steps, pre-commit hooks, wrapper scripts, and scheduled jobs. Grep for the scanner name across workflow definitions and hook configs before starting.
- A representative test corpus: at least one infrastructure directory with known findings (both passing and failing checks) that you can scan repeatedly.
- Permission to pin and unpin the scanner version in your install step (package pin, image tag, or pre-commit revision).

## Steps

### 1. Inventory every invocation

Search all workflow files, hook configs, and wrapper scripts for scanner invocations. Record the install method (package manager, container image, pre-commit hook), the pinned version if any, the target directories, and which output the pipeline consumes (exit code, report file, or both). Unpinned installs are the most common source of surprise upgrades; pin them before proceeding.

### 2. Read the breaking-change catalog first

Read the companion [migration guide](checkov-v3-migration-guide.md) end to end and mark every item that touches your inventory from step 1: removed flags, changed custom-check APIs, and authentication or reporting differences. If none of the catalog items touch your setup, the upgrade is likely a pin bump plus a verification run. If several do, budget time per item.

### 3. Stage the upgrade on a trial branch

Create a branch whose only change is the scanner version pin (or install reference) moving to the 3.x line. Do not combine the upgrade with policy changes, new ignore rules, or refactoring in the same branch; a green run should mean the upgrade is safe, and a red run should point at exactly one cause.

### 4. Update custom checks and wrappers against the new API

If you load custom checks from an external directory, review each one against the API changes in the migration catalog and update the signatures and imports on the trial branch. Do the same for wrapper scripts that parse scanner output: confirm the output formats and exit-code behavior your wrapper depends on are unchanged, or adjust the parsing first.

### 5. Run a before/after comparison on the same corpus

On the base branch, run the scanner against your test corpus and save the full finding list. On the trial branch, run the upgraded scanner against the identical corpus and diff the two finding lists. Every difference should trace to a catalogued breaking change or an intentional fix; an unexplained new pass (a check that silently stopped running) is a failed upgrade, not a clean one.

### 6. Fix the CI invocation, not just the scanner

Update the trial branch's CI steps for anything the new major version expects: replaced flags, required identifiers for authenticated runs, and report-format options. Keep each edit minimal and keep the old working invocation in the branch history so the diff reviews cleanly.

### 7. Merge and watch the first runs

Merge the trial branch during a window when someone can watch the first few pipeline runs. Confirm the gate still fails closed on genuinely misconfigured code (a gate that passes everything after an upgrade is worse than one that fails loudly). Keep the previous version pin noted in the merge description so anyone can revert without research.

## Verify

1. The trial branch scans the test corpus with no startup errors and no silently skipped checks.
2. The before/after finding diff is fully explained by catalogued changes.
3. Custom checks all load; the count of executed custom rule IDs matches the pre-upgrade count.
4. The CI gate still blocks a known-bad fixture and still passes a known-good one.
5. No workflow file, hook config, or wrapper script still references a removed option.

## Rollback

If the upgrade breaks the gate and the fix is not obvious within one investigation cycle, revert the version pin to the previous line and revert the invocation edits with it. Rollback is a version-pin revert plus the matching flag and API-signature reverts; treat it as temporary and re-attempt the upgrade on a fresh trial branch rather than letting the pin drift. Record what broke so the next attempt starts from the failure, not from zero.

## Common errors

| Symptom | Likely cause | Fix |
|---|---|---|
| Scan step errors immediately at startup after the upgrade | The pipeline passes an option the new major version removed | Look up the removed option in the [migration guide](checkov-v3-migration-guide.md) and switch to its replacement |
| Custom checks fail to import or report zero findings | Custom-check code targets the old API | Update the check against the API-change section of the [migration guide](checkov-v3-migration-guide.md) |
| Authenticated runs no longer attribute results | The new version requires an identifier the old invocation omitted | Add the required identifier per the [migration guide](checkov-v3-migration-guide.md) |
| Gate passes code it used to fail | A check silently stopped executing rather than genuinely passing | Compare executed rule IDs before and after; restore or re-register the missing check |
| Upgrade works locally but fails in CI | CI installs an unpinned scanner while local is pinned | Pin the CI install to the same version verified locally |

## References

- Companion catalog of version-to-version changes: [migration guide](checkov-v3-migration-guide.md).
