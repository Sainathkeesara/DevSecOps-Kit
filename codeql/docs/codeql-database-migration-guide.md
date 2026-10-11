---
last_verified: 2026-10-08
tool_version: n/a
---

# CodeQL database migration guide

## Purpose

A CodeQL database is a build-time snapshot of one repository revision: the
source files plus the extracted relational facts that queries run against.
This guide covers how to move an existing CodeQL setup from one database
arrangement to another without losing scan coverage — changing the language
set, changing the build mode, relocating where the database lives in CI, or
re-creating a database that has gone stale — using only the workflow and
manifest shapes already present in this kit.

## When to use

- The repository adds a second language and the single-language database no
  longer covers it.
- The build mode changes: the workflow currently relies on autobuild and the
  project now needs explicit build steps (or the reverse).
- The database directory moves (new runner layout, new cache path, or a
  shared pipeline template that expects a fixed location).
- A stored database keeps producing empty or outdated results and needs to
  be discarded and re-created from a clean checkout.
- A custom query pack is introduced alongside the default suite (see
  `../docs/wired-custom-queries-into-ci.md`) and the database must serve
  both.

## Prerequisites

- A working baseline: `../configs/first-codeql-analysis.yml` (minimal
  init → autobuild → analyze flow) runs green on the current revision.
- The multi-language manifest `../manifests/multi-language-codeql-analysis.yaml`
  is available as the reference for the target state when adding languages.
- Write access to the workflow file being migrated and a branch where the
  migrated workflow can run at least twice before the old one is removed.

## Steps

### 1. Inventory the current database arrangement

Record three things before changing anything: which languages the init step
requests, whether the build step is autobuild or manual, and where the
database directory is created. The minimal config in this kit requests one
language with autobuild:

```yaml
- name: Initialize CodeQL
  uses: github/codeql-action/init@v3
  with:
    languages: python
```

Keep this file untouched on the default branch until the migrated workflow
has passed on a side branch.

### 2. Add or remove a language

Create the new database per language rather than reusing the old
single-language database. Point the migrated workflow at the language matrix
used by `codeql/manifests/multi-language-codeql-analysis.yaml`, then delete
the old database directory so the next run cannot silently fall back to it.
Run one analysis per language and confirm each produces its own result set
before merging — a migration where one language's results disappear looks
identical to a clean scan unless each language is checked individually.

### 3. Move between autobuild and manual build steps

When leaving autobuild, replace the autobuild step with the project's real
build commands issued between the init and analyze steps, keeping the init
and analyze steps otherwise identical. When moving toward autobuild (for a
newly added interpreted language, for example), do the reverse: drop the
manual build block and restore the autobuild step from
`codeql/configs/first-codeql-analysis.yml`. In both directions, re-create the
database from scratch after the switch — a database extracted under one build
mode does not reliably serve the other.

### 4. Relocate the database directory

If the pipeline template expects the database at a fixed path, create it
there on the migrated branch and remove the old path in the same change, so
no job can read a leftover database from the previous location. Verify the
relocation by checking that a run on a clean runner (no cache) still finds
the database — a run that only passes because of a cached copy at the old
path will fail the first time the cache expires.

### 5. Re-create a stale database

When results look outdated (new code never flagged, removed code still
flagged), discard the database directory entirely and re-run init plus build
on a fresh checkout rather than reusing the stored copy. Confirm the fresh
database reflects the current revision by introducing a known finding from
the custom-query doc's verify procedure and checking that it appears.

### 6. Keep custom packs working across the migration

If the setup uses a local query pack (`codeql-custom/` with `qlpack.yml`,
per `codeql/docs/wired-custom-queries-into-ci.md`), carry the `packs`
pointer into the migrated init step unchanged. After migration, confirm the
result set still contains rows from both the default suite and the custom
pack before deleting the old workflow.

## Verify

- The migrated workflow runs green twice on the side branch: once on a warm
  runner and once on a clean runner with no cache.
- Each requested language produces a non-empty result set; no language's
  results vanish relative to the pre-migration run.
- A deliberately introduced finding matching a custom query is flagged after
  migration, and a clean revision passes.
- No job reads from the old database path — searching the workflow files for
  the old path returns nothing.
- The default-branch workflow is only replaced after all of the above hold.

## Rollback

- Keep the pre-migration workflow file on the default branch until the
  migrated one has passed twice; rollback is restoring that file.
- If the migrated run drops a language's results, restore the old
  single-language workflow and re-create its database from a clean checkout
  rather than trying to repair the migrated database in place.
- If a relocated database path breaks clean-runner runs, revert the path
  change first and re-run before investigating anything else — a wrong path
  masks every other symptom.
- What is not a rollback lever: re-running analysis against the old stored
  database does not undo a bad migration; the old database reflects the old
  revision and the old layout, so it cannot validate the new one.

## Common errors

- Reusing a database across build modes. Symptoms: empty results or build
  errors during extraction. Fix: delete the database and re-create it under
  the new build mode.
- Migrating the workflow but leaving the old database directory in place.
  The job picks up the stale copy and the migration looks successful until
  the cache expires. Fix: remove the old directory in the same change.
- Adding a language to the init step without checking its result set.
  The run is green but the new language was never actually analyzed. Fix:
  verify per-language results as described in Step 2.
- Dropping the `packs` pointer when copying the init step to the new
  workflow. Default queries still run, so the run looks fine, but custom
  findings silently disappear. Fix: diff the init step against the custom
  query doc before merging.

## References

- `codeql/configs/first-codeql-analysis.yml` — minimal init/autobuild/analyze baseline
- `codeql/manifests/multi-language-codeql-analysis.yaml` — target shape for multi-language setups
- `codeql/manifests/codeql-multi-language-scan.yaml` — second multi-language reference
- `codeql/docs/wired-custom-queries-into-ci.md` — custom pack layout and verify procedure
- `codeql/docs/query-writing-patterns-dataflow-javascript-typescript.md` — query patterns the migrated database must still serve
