---
last_verified: 2026-10-08
tool_version: n/a
sources: []
---

# CodeQL integration reference for security analysis

## Purpose

This reference describes how the CodeQL scan stages used across this kit fit together into a security-analysis pipeline: where each stage runs, what it consumes and produces, and how the kit's own workflow files, manifests, and local CLI script relate to each other. It is the map; the sibling docs cover the individual routes.

## When to use

- Use this reference when adding CodeQL scanning to a repository that does not have it yet, or when reviewing whether an existing setup still matches the kit's pattern.
- Use the multi-language manifest shape when the repository contains more than one supported language and each language needs its own separately categorized result set.
- Use the minimal single-language workflow shape when starting out with one language before expanding the matrix.
- Use the local CLI loop when iterating on a query or reproducing a CI finding without pushing commits.
- For writing project-specific queries, see `query-writing-patterns-dataflow-javascript-typescript.md`; for injecting a custom query pack into the pipeline, see `wired-custom-queries-into-ci.md`. This doc does not repeat either.

## Prerequisites

- A checkout of the repository to be scanned, with the languages to analyze already decided.
- A CI runner that can check out the repository and upload security results. The kit's workflows declare `security-events: write` alongside `actions: read` and `contents: read` for exactly this reason.
- For the local loop: a machine with the CodeQL CLI installed and a query pack available on disk.

## Steps

### 1. Check out the repository with full history

Both kit workflows start with a checkout step. The multi-language manifest requests the full history (`fetch-depth: 0`) so the analysis can attribute findings across the whole tree; the minimal workflow uses the default shallow checkout, which is sufficient for a first single-language scan.

```yaml
- name: Checkout repository
  uses: actions/checkout@v4
  with:
    fetch-depth: 0
```

### 2. Initialize the analysis per language

The `init` step declares which language is being analyzed in that job. The kit runs one job per language via a matrix (`python`, `javascript`, `go`, `java` in the multi-language manifest; `python` only in the minimal workflow) with `fail-fast: false` so a failure in one language does not cancel the others.

```yaml
- name: Initialize CodeQL
  uses: github/codeql-action/init@v3
  with:
    languages: ${{ matrix.language }}
    config-file: ./.github/codeql/codeql-config.yml
```

The `config-file` input is optional and appears only in the multi-language manifest: it points at a repository-local configuration that narrows which queries run. Omit it when the default suite selection is acceptable, as the minimal workflow does.

### 3. Build the codebase

```yaml
- name: Autobuild
  uses: github/codeql-action/autobuild@v3
```

Autobuild attempts to detect and run the build automatically. Interpreted languages typically need no compilation step here; compiled languages may require replacing autobuild with explicit build commands when automatic detection does not cover the project's build system.

### 4. Run the analysis and handle the results

```yaml
- name: Perform CodeQL analysis
  uses: github/codeql-action/analyze@v3
  with:
    category: "/language:${{ matrix.language }}"
    output: sarif-results
    upload: Failure
```

Three details matter here:

- `category` labels each language's result set so findings from different matrix jobs stay distinguishable in a single run.
- `output` directs the result file to a known directory instead of leaving it at the default location.
- `upload` controls the failure behavior: with this setting, results are uploaded only when the step fails, which keeps successful scheduled runs quiet while preserving the evidence for failing ones.

### 5. Schedule recurring scans

The multi-language manifest adds a weekly schedule on top of push and pull-request triggers so code that is not changing still gets re-analyzed against the current query set:

```yaml
on:
  push:
    branches: [master, main]
  pull_request:
    branches: [master, main]
  schedule:
    - cron: "0 6 * * 1"
```

The minimal workflow triggers on push and pull request only. Add the schedule once the per-push results are trusted.

### 6. Reproduce locally with the CLI

The local loop mirrors the CI stages without the CI harness: create a database from a source root, run a query against it, and inspect the output file. This is the same sequence the kit's helper script performs:

```bash
codeql database create "$DB_DIR" --language=javascript --source-root="$SRC_DIR"
codeql query run "$QUERY" --database="$DB_DIR" --output="$OUT"
```

Use this loop to confirm a CI finding before changing code, or to test a query edit before wiring it into the pipeline.

## Verify

- Trigger the workflow on a pull request and confirm one analysis job runs per matrix language with `fail-fast: false` honored.
- Confirm the result set carries the per-language `category` label from the analyze step.
- Confirm the declared permissions include `security-events: write`; without it the results cannot be recorded.
- For the scheduled path, confirm the cron entry fires and that a run with no code changes still completes the full init, build, and analyze sequence.
- Locally, confirm `codeql database create` followed by `codeql query run` writes a non-empty output file for the sample source.

## Rollback

- To stop blocking on CodeQL without deleting the setup, remove the schedule trigger first, then restrict the workflow to pull requests so findings stay advisory.
- To return to the default query selection, remove the `config-file` input from the init step.
- To fully detach, delete the workflow file; previously recorded results remain visible but no new runs are produced.

## Common errors

1. **Results cannot be recorded.** The job lacks `security-events: write`. Compare the job permissions against the kit's workflow files, which declare it explicitly.
2. **One language failure cancels the rest.** `fail-fast` defaulted back to stopping the matrix. The kit sets `fail-fast: false` under the strategy for this reason.
3. **Findings from different languages are indistinguishable.** The `category` input was dropped from the analyze step. Restore the per-language category assignment.
4. **Autobuild finds nothing to build.** Expected for projects whose build system is not auto-detected; replace the autobuild step with explicit build commands for that language.
5. **Local query run reports a missing pack.** The query path assumed a pack root that does not exist on this machine; locate the installed pack directory and adjust the query path accordingly.

## References

- `codeql/configs/first-codeql-analysis.yml` — minimal single-language workflow (push and pull request triggers, Python matrix).
- `codeql/manifests/multi-language-codeql-analysis.yaml` — multi-language workflow with full-history checkout, config file, categorized results, and weekly schedule.
- `codeql/manifests/codeql-multi-language-scan.yaml` — companion multi-language scan manifest.
- `codeql/scripts/first-codeql-analysis.sh` — local database-create and query-run loop with a sample source.
- `codeql/docs/wired-custom-queries-into-ci.md` — injecting a custom query pack into the pipeline.
- `codeql/docs/query-writing-patterns-dataflow-javascript-typescript.md` — writing dataflow queries for JavaScript and TypeScript.
