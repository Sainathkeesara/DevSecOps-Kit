# CodeQL — quick primer

> First-day notes for someone who's never used CodeQL. Writing this as I explore.

## What is it?

CodeQL is GitHub's code analysis engine. It treats code as data — you query it like a database to find bugs and security issues. It's the engine behind GitHub code scanning and Advanced Security. Compare it to Semgrep: Semgrep matches patterns across many languages, while CodeQL builds an actual queryable model of your code's dataflow.

## What does it do?

You create a CodeQL database from your source code, then run queries against it to find vulnerabilities. GitHub runs it automatically on pull requests for public and private repos with GHAS enabled. You can also run it locally with the CLI — create a DB, run a query pack (like the default security-and-quality suite), and get results in SARIF.

## Why does it exist?

Before semantic analysis, we grepped for patterns or used linters that only see one line at a time. CodeQL tracks how data flows through a program — so it catches tainted variables, SQL injection, and path-traversal issues that surface-level tools miss. Security teams and developers use it to catch vulnerabilities before code ships.

## Key terminology

- **Database** — extracted representation of a codebase. Example: `codeql database create mydb --language=python`.
- **Query pack** — collection of queries. Example: `codeql query run --pack=codeql/python-queries`.
- **QL** — the query language. Example: `select * from Call where ...`.
- **Suite** — grouped queries executed together. Example: `codeql database analyze --suite=security-extended`.
- **SARIF** — Static Analysis Results Interchange Format. Example: `codeql database analyze ... --format=sarif-latest`.
- **Extractor** — language-specific parser that builds the DB. Example: the Python extractor reads imports, methods, AST.
- **Workspace** — root dir for CodeQL databases. Example: `/work/codeql-dbs/`.

## A tiny example

```bash
codeql database create /tmp/mydb --language=python --source-root=.
codeql database analyze /tmp/mydb codeql/python-queries:codeql-suites/python-security-extended.qls --format=sarif-latest --output=results.sarif
```

Two commands: build a queryable snapshot, then run the security query suite and dump results to SARIF.

## What I'll cover next

Next I'll install the CLI properly, build my first database from a small Python repo, and run a single custom query against it. Then I want to compare the default suite results with a custom query targeting a specific CWE.
