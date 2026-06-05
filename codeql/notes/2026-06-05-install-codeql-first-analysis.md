# Installing CodeQL CLI and running my first analysis

I grabbed the CodeQL CLI bundle from GitHub releases and unzipped it. The binary is `codeql` — ran `./codeql version` to confirm:

```
2.18.4
```

Next step was creating a database from a small Python repo I have locally:

```bash
./codeql database create /tmp/codedb --language=python --source-root=/path/to/repo
```

That worked — saw the extractor run, then a progress bar for the `intermediate-stage` and `finalize` steps.

Then ran a query suite:

```bash
./codeql database analyze /tmp/codedb codeql/python-queries:codeql-suites/python-security-extended.qls --format=sarif-latest --output=/tmp/results.sarif
```

Output was a SARIF file. Opened it — saw several alerts including hardcoded passwords and potential SQL injection points.

Things I tripped on:
- The `codeql` binary needs to be in PATH or called with the full path; I kept forgetting the `./` prefix initially
- Database creation took a while on a real-size repo — the progress bar is accurate but slow
- The query pack syntax `codeql/python-queries:` is easy to mistype; missing the colon silently fails
- SARIF output is JSON — useful for tooling but not human-readable without a viewer
