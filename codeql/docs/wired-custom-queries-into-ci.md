# How I wired CodeQL custom queries into a GitHub Actions CI pipeline

## Purpose

The default CodeQL analysis runs the standard suite of security queries. To
scan for project-specific patterns — internal API key formats, bespoke crypto
usage, custom credential sinks — you need to inject your own query pack into
the pipeline. This doc covers one way to do it: keep a `codeql-custom/`
directory in the repo, reference it from a pack file, and point the workflow
at the pack instead of running individual `.ql` files.

## Steps

**1. Set up the custom pack structure.**

The CodeQL CLI expects a certain layout inside a pack directory. I used this:

```
codeql-custom/
  qlpack.yml          # pack metadata
  queries/
    hardcoded-creds.ql
  suites/
    custom-suite.qls   # references individual queries
```

The `qlpack.yml` declares the language and a dependency on the standard library:

```yaml
name: my-custom-queries
version: 0.0.1
dependencies:
  codeql/python-all: "*"
```

The suite file lists which queries to run:

```
+ queries/hardcoded-creds.ql
```

**2. Install the pack so CodeQL finds it.**

The workflow's `init` step needs extra flags so CodeQL knows about the custom
pack. I added `source-root` and `packs` — this turned out to be the part I
spent most time on because the docs show `packs` for the GitHub-hosted pack
registry but not for local packs:

```yaml
- name: Initialize CodeQL
  uses: github/codeql-action/init@v3
  with:
    languages: python
    packs: ./codeql-custom
    source-root: .
```

An alternative is `codeql resolve packs` in a script step, but the action
handles it if you point `packs` at the directory holding `qlpack.yml`.

**3. Build the database and run the analysis.**

The standard `autobuild` and `analyze` steps work the same — once the init
step knows about the custom pack, the analysis includes your queries alongside
the defaults:

```yaml
- name: Autobuild
  uses: github/codeql-action/autobuild@v3

- name: Perform CodeQL Analysis
  uses: github/codeql-action/analyze@v3
```

**4. Filter results to your queries (optional).**

I wanted a separate SARIF file containing only my custom findings, so I ran a
second analysis pass in a script step using `codeql database analyze` with my
suite file and a distinct output path. This only works if you also upload the
extra SARIF with a separate artifact name.

## Verify

- Push a change that introduces a hardcoded secret matching your custom query
  and confirm the pipeline **alerts** on it.
- Push a safe change (no hardcoded secrets) and confirm the pipeline **passes**.
- Check the SARIF artifact: it should contain rows from both the default suite
  and your custom pack. If you used a separate analysis pass, verify the extra
  SARIF appears under its own name in the workflow run summary.

## What I'd try next

The `packs` approach above bundles all custom queries into one CI step. I want
to experiment with splitting them by severity — running critical-priority
queries on every push and low-priority queries on a schedule — so the PR
feedback loop stays fast while deep scans still run nightly.
