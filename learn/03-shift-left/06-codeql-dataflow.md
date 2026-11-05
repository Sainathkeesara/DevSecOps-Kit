---
last_verified: 2026-11-05
tool_version: n/a
sources:
  - https://codeql.github.com/docs/codeql-language-guides/analyzing-data-flow-in-javascript-and-typescript/
  - https://codeql.github.com/docs/
  - https://docs.github.com/en/code-security/code-scanning/creating-an-advanced-setup-for-code-scanning/customizing-your-advanced-setup-for-code-scanning
---
# Follow tainted data with CodeQL

CodeQL goes beyond pattern matching: it builds a database of your code and traces how untrusted data flows through it. This lesson shows how to run CodeQL in CI and read a dataflow path to understand exactly how a vulnerability is reached.

## What you'll learn
- Run CodeQL in CI and read a dataflow path
- Explain what CodeQL finds that a pattern rule misses

## Before you start
- [Find the SQL injection with Semgrep](05-semgrep-sast.md) — the local pattern-based scan CodeQL complements
- CodeQL CLI installed — confirm with `codeql --version`

## Walkthrough

1. Build the CodeQL database for your language.
   ```bash
   codeql database create codeql-db --language=python --source-root=.
   ```
   You should see: `Successfully created database at codeql-db.`

2. Run the default CodeQL query suite.
   ```bash
   codeql database analyze codeql-db --format=sarif-latest --output=results.sarif python-security-extended
   ```
   You should see: a SARIF file written; any finding includes a `codeFlows` entry showing the taint path.

3. Read a dataflow path in the results. A CodeQL finding backed by `DataFlow::PathGraph` reports source and sink nodes connected by `hasFlowPath`, listing each step the tainted value passes through.
   ```ql
   import python
   import semmle.python.dataflow.new.DataFlow

   from DataFlow::PathNode source, DataFlow::PathNode sink
   where hasFlowPath(source, sink)
   select sink.getNode(), source, sink, "Tainted data reaches a sink."
   ```
   You should see: results where the path spans multiple functions, showing inter-procedural flow.

4. Add CodeQL to CI.
   ```yaml
   - name: Initialize CodeQL
     uses: github/codeql-action/init@v3
     with:
       languages: python
   - name: Autobuild
     uses: github/codeql-action/autobuild@v3
   - name: Perform CodeQL Analysis
     uses: github/codeql-action/analyze@v3
   ```
   You should see: the analysis job complete and upload results to the Security tab.

## Exercise

Take a small Python app with a function that reads a request parameter and passes it through a helper into a database call. Run CodeQL, then write a query using `DataFlow::PathGraph` and `hasFlowPath` to surface the full inter-procedural path. Explain in one sentence why a Semgrep pattern rule would miss this flow.

## Check your work

codeql database analyze codeql-db --format=sarif-latest --output=results.sarif python-security-extended 2>&1 | tail -5
Expected: analysis completes and writes `results.sarif` containing `codeFlows` for any finding.

## Common mistakes
- Skipping the database build step — CodeQL has nothing to analyze.
- Using the wrong language matrix — results are empty or for the wrong language.
- Treating CodeQL like a grep tool — it models dataflow, so a finding's value is the path, not just the line.

## Next
[Software supply chain security — concepts](../../docs/concepts/software-supply-chain-security/0000-primer-software-supply-chain-security.md)