---
last_verified: 2026-08-26
tool_version: n/a
sources: []
---

# Install CodeQL CLI and run my first query

Grabbed the CodeQL CLI from the GitHub releases page. Unzipped it, added the `codeql` directory to PATH, and ran `codeql --version` to confirm it was there.

## Creating my first database

I set up a tiny Python project with one intentionally vulnerable file (a function that concatenates user input into a SQL string). Then created the database:

```bash
codeql database create /tmp/codeql-db \
  --language=python \
  --source-root=/path/to/my/project
```

The CLI prints extractor progress — took about 10 seconds for my tiny project. The database lives in `/tmp/codeql-db/` and contains the extracted facts.

## Running a built-in query suite

I tried the default Python security suite first:

```bash
codeql database analyze /tmp/codeql-db \
  codeql/python-queries:Security \
  --format=sarif-latest \
  --output=/tmp/results.sarif
```

It found my intentionally bad function. The SARIF output is verbose but structured — I can see the rule ID, the message, and the exact file/line.

## Writing a custom query

Wrote a simple QL file to find any call to `execute()` with a string literal:

```ql
/**
 * @name Direct SQL execute with string concatenation
 * @description Finds calls to execute() that may be vulnerable to injection.
 * @kind problem
 */
import python

from Call call, string sql
where
  call.getFunc().(Name).getId() = "execute" and
  sql = call.getArg(0).(Format).getValue()
select call, "Direct string in SQL execute call"
```

Ran it with:

```bash
codeql database analyze /tmp/codeql-db \
  my-queries/sql-injection.ql \
  --format=sarif-latest \
  --output=/tmp/custom.sarif
```

## What tripped me up

- **Missing `--language`**: the CLI asks interactively if you omit it, which broke my script. Always pass it explicitly.
- **Database path vs source root**: `database create` takes the output path first, then `--source-root`. I swapped them and got a confusing error about an existing directory.
- **QL compilation errors**: my first query had a syntax error in the `from` clause. `codeql query compile` catches these before running analysis — use it to debug.
- **SARIF is huge**: for real codebases the output is thousands of lines. I filtered with `jq` to get just the results I cared about.

## What I'll cover next

I want to try running CodeQL in CI with GitHub Actions and see how the SARIF output integrates with GitHub's code scanning alerts.
