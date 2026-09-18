---
last_verified: 2026-09-18
tool_version: n/a
---

# CodeQL custom query pack scaffold with CI integration harness

## Purpose

This scaffold provides a minimal, reusable layout for keeping project-specific
CodeQL queries in the same repository as the code they scan, plus a CI
workflow and a local test script that exercise the pack the same way. Copy
the directory into a repository, add queries under `queries/`, list them in
the suite file, and point the workflow at the pack directory.

## When to use

Use this scaffold when the default CodeQL query suites do not cover
project-specific patterns (internal credential formats, bespoke helper
functions, team-specific risky calls) and those patterns need to be checked
on every pull request. For one-off exploration of a single query file,
running the query locally against a test database is simpler than adopting
the full pack layout.

## Prerequisites

- A repository with at least one supported language checked in under `src/`
  or the repository root.
- The CodeQL CLI available on the machine used for local runs.
- A CI runner with permission to check out the repository and upload
  analysis results.

## Steps

### 1. Copy the scaffold into the repository

```bash
cp -r custom-query-pack-ci-harness <repo>/codeql-custom
```

The layout inside `codeql-custom` is:

```text
codeql-custom/
├── README.md
├── qlpack.yml
├── queries/
│   └── hardcoded-credential-check.ql
├── suites/
│   └── custom-suite.qls
├── fixtures/
│   └── basic/
│       ├── known-bad.py
│       └── known-good.py
├── scripts/
│   └── test-pack.sh
└── .github/
    └── workflows/
        └── codeql-custom-queries.yml
```

### 2. Declare the pack

`qlpack.yml` gives the pack a name and declares which language libraries it
needs. Keep one pack directory per language group so dependency lists stay
short.

```yaml
name: custom-queries
version: 0.0.1
dependencies:
  codeql/python-all: "*"
```

### 3. Add queries under `queries/`

Each query file carries its own metadata block (`@name`, `@description`,
`@kind`, `@problem.severity`, `@id`, `@tags`). The bundled example,
`queries/hardcoded-credential-check.ql`, flags string literals assigned to
secret-like variable names. Add further queries as new files in the same
directory, one pattern per file.

### 4. Register queries in the suite

`suites/custom-suite.qls` lists the queries the harness runs. Reference each
query by its path relative to the pack root:

```text
+ queries/hardcoded-credential-check.ql
```

Add one line per query. Queries not listed in the suite are stored but not
executed by the CI or local harness.

### 5. Wire the pack into CI

`.github/workflows/codeql-custom-queries.yml` checks out the repository,
initializes analysis with the local pack directory, builds, and analyzes.
The key part is the `packs` input pointing at the directory that holds
`qlpack.yml`:

```yaml
- name: Initialize CodeQL
  uses: github/codeql-action/init@v3
  with:
    languages: python
    packs: ./codeql-custom
```

Pushing the scaffold as-is gives a passing baseline; adding a file that
matches a custom query makes the corresponding check report a finding.

### 6. Test the pack locally before pushing

```bash
chmod +x codeql-custom/scripts/test-pack.sh
./codeql-custom/scripts/test-pack.sh
```

The script creates a database for the sample source, runs the suite file
against it, and writes the findings to a results directory. Use it to
confirm a new query fires on a known-bad fixture and stays quiet on a
known-good one before opening a pull request.

## Verify

- The local script exits zero and the results directory contains one entry
  per query listed in the suite file.
- A pull request that introduces a hardcoded secret matching the example
  query reports a finding on the changed lines.
- A pull request with no matching pattern reports no custom-query findings
  and the workflow completes successfully.
- The suite file and the `queries/` directory agree: every `+ queries/...`
  line names a file that exists, and every query file intended for CI has a
  line in the suite.

## Common errors

- **Pack directory not found in CI.** The `packs` input is relative to the
  checkout root. When the scaffold is copied to a subdirectory, update the
  path in the workflow to match the new location.
- **Query runs locally but not in CI.** The query file exists but has no
  entry in `suites/custom-suite.qls`. Add the `+ queries/<name>.ql` line.
- **Suite references a missing file.** A suite line names a query that was
  renamed or deleted. Either restore the file or remove the line; the
  local test script reports which path is unresolved.
- **Empty results on a fixture that should match.** The fixture does not
  use a variable name the example query looks for, or the database was
  built before the fixture was added. Rebuild the database from the
  current source and re-run.

## References

- `qlpack.yml` — pack name and language library dependencies.
- `queries/hardcoded-credential-check.ql` — bundled example query.
- `suites/custom-suite.qls` — query list executed by CI and local runs.
- `scripts/test-pack.sh` — local database build and suite run.
- `.github/workflows/codeql-custom-queries.yml` — CI harness workflow.
- `codeql/docs/wired-custom-queries-into-ci.md` — companion walkthrough of
  the same pack-plus-workflow approach.
- `codeql/manifests/multi-language-codeql-analysis.yaml` — default-suite
  multi-language workflow this scaffold complements.
