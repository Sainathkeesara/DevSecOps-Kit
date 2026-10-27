---
last_verified: 2026-10-27
tool_version: n/a
sources: []
---

# CodeQL CLI: install and first query on a sample repo

I downloaded the CodeQL CLI archive from the GitHub releases page, unzipped it, and added the `codeql` folder to my PATH. `codeql --version` printed a version string, so the install stuck.

I wanted to run my first query against a real sample repo rather than a toy folder, so I cloned a small Java demo app and extracted a database:

```bash
codeql database create /tmp/codeql-demo-db \
  --language=java \
  --source-root=./sample-java-app
```

The extractor ran through the source tree and wrote the facts into `/tmp/codeql-demo-db/`. Next I ran a built-in security query:

```bash
codeql database analyze /tmp/codeql-demo-db \
  codeql/java-queries:Security \
  --format=sarif-latest \
  --output=/tmp/demo-results.sarif
```

It returned a handful of results with rule IDs and file/line locations — enough to see how CodeQL maps findings back to source.

## What tripped me up

- I forgot `--language` the first time and the CLI prompted me interactively, which broke any hope of scripting it.
- I mixed up the database output path and `--source-root` once and got a confusing "directory already exists" error.
- I haven't figured out which query pack to use for JavaScript vs Java yet — the pack names look similar.

## What I'll cover next

I want to try the small QL snippet I wrote for hardcoded secrets (`codeql/snippets/2026-10-27-hardcoded-secrets.ql`) against this database, and then figure out how to run CodeQL from GitHub Actions.
