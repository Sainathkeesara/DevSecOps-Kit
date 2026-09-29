---
last_verified: 2026-09-29
tool_version: n/a
---

# Semgrep Rules Migration Guide

## Purpose

This guide describes how to migrate an existing set of custom Semgrep rules from an ad-hoc layout into a consistent, reviewable structure. It covers inventorying current rules, normalizing rule shape, consolidating duplicated logic, and rolling the migrated set out through version control and CI.

## When to Use

Use this guide when custom rules have accumulated organically — single-pattern rules mixed with multi-pattern ones, inconsistent severity labels, overlapping rule IDs across directories — and reviews have become hard to reason about. It also applies when consolidating rules scattered across repositories into one owned rules directory.

## Prerequisites

- A checkout of the repository holding the current rules.
- Semgrep installed locally so migrated rules can be tested before commit.
- A sample codebase with known true-positive and true-negative examples for each migrated rule.
- The existing rule-writing reference in this kit (`semgrep-rule-writing-reference.md` in this directory) for pattern syntax details.

## Steps

### 1. Inventory the current rules

Collect every rule file into one list with its ID, language list, and what it detects. Record the file path next to each ID so duplicates and near-duplicates surface early.

```bash
grep -rh -- '- id:' --include='*.yaml' --include='*.yml' . | sort | uniq -c | sort -rn
```

Any ID appearing more than once is a migration candidate: either a genuine duplicate to delete or two rules that need distinct IDs.

### 2. Normalize the rule envelope

Bring every rule onto the same field set before changing matching logic: `id`, `patterns` (or a single `pattern`), `message`, `languages`, and `severity`. Prefer the `patterns` list form even for single-condition rules so later constraints slot in without restructuring:

```yaml
rules:
  - id: migrated-example-rule
    patterns:
      - pattern: $APP.run(debug=True)
    message: Debug mode is enabled on the application runner
    languages: [python]
    severity: WARNING
```

Keep rule IDs stable through the migration. Renaming IDs breaks historical finding tracking and suppresses comments that reference the old ID, so only rename when two rules genuinely collide.

### 3. Consolidate overlapping patterns

Where two rules match variants of the same construct (for example string formatting versus concatenation in the same sink), merge them into one rule with a `pattern-either` block rather than keeping parallel rules that drift apart:

```yaml
rules:
  - id: consolidated-sink-check
    patterns:
      - pattern-either:
          - pattern: $CURSOR.execute($QUERY + $VAR)
          - pattern: $CURSOR.execute($QUERY.format($VAR))
    message: Query built by string composition reaches the sink
    languages: [python]
    severity: ERROR
```

Delete the superseded rule files in the same commit so the old and new forms never coexist.

### 4. Standardize severity and messages

Map the inherited severities onto the three levels used across the ruleset (`INFO`, `WARNING`, `ERROR`) and rewrite messages as one sentence stating what was found, not how to fix it. Fix guidance belongs in the rule metadata or runbook, where it can be updated without touching matching logic.

### 5. Add test annotations and run the test pass

For each migrated rule, add a test file with `ruleid` lines for code that must match and `ok` lines for code that must not:

```python
# ok: migrated-example-rule
app.run(debug=False)

# ruleid: migrated-example-rule
app.run(debug=True)
```

Run the test pass over the rules directory and fix any rule that fails before committing:

```bash
semgrep --test --config rules/ tests/
```

### 6. Roll out through version control

Commit the migrated ruleset as one change against the previous layout, keeping the old directory untouched until the new one passes CI. Point the CI scan job at the new directory, confirm findings match the pre-migration baseline, then remove the legacy directory in a follow-up commit.

## Verify

1. Every rule ID in the inventory appears exactly once in the migrated directory.
2. The `--test` pass reports zero failures across all annotation files.
3. A scan of the sample codebase with the migrated ruleset produces the same finding set as the pre-migration baseline, minus intentionally removed duplicates.
4. The CI scan job references only the new rules directory.

## Rollback

If the migrated ruleset produces unexpected findings in CI, revert the job configuration to the legacy directory, which is retained until the migration is confirmed. Because rule IDs were kept stable, reverting the scan path restores the prior behavior with no annotation changes needed.

## Common Errors

### Renaming rule IDs during migration

New IDs invalidate existing triage history and suppression comments. Keep IDs stable and only introduce new ones for genuinely new rules.

### Migrating structure and logic in one edit

Changing the directory layout and the matching logic simultaneously makes regressions hard to attribute. Normalize structure first with identical matching behavior, verify, then tighten patterns.

### Skipping the baseline comparison

Without a pre-migration finding list there is no way to tell an intentional consolidation from an accidental detection loss. Capture the baseline scan output before switching CI to the new directory.

### Leaving both rulesets wired into CI

Scanning both the legacy and migrated directories doubles every finding. Exactly one directory should be referenced by the scan job at any time.

## References

- `semgrep-rule-writing-reference.md` — pattern and metavariable syntax used in the examples above.
- `comparing-rule-writing-approaches.md` — trade-offs between single-pattern and combinator styles when consolidating.
- `semgrep-ci-integration.md` — wiring the migrated rules directory into a CI scan job.
