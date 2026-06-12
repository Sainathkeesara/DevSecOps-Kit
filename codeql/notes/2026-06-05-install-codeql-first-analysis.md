# Following the CodeQL quickstart: custom query and upload trip-ups

I followed the CodeQL CLI quickstart with the goal of moving past "it found something" and into the part I actually want to understand: how a custom query becomes SARIF, and how that SARIF gets uploaded.

## Steps I followed

First I made a small local repo with one intentionally risky Python endpoint. Then I created a CodeQL database for it:

```bash
codeql database create /tmp/codeql-db \
  --language=python \
  --source-root=/tmp/codeql-demo
```

That part felt straightforward once I remembered the order: database path first, then language and source root. The CLI printed extractor and finalize progress, so I could tell when the database was really ready instead of guessing.

Next I wrote a tiny custom query in `custom-queries/python/queries/PathTraversal.ql`. I tried running it directly with `database analyze` first:

```bash
codeql database analyze /tmp/codeql-db \
  custom-queries/python/queries/PathTraversal.ql \
  --format=sarif-latest \
  --output=/tmp/codeql-results.sarif
```

That is the command I want for analysis. It takes the database, the query or query suite, and writes results to SARIF.

## Got stuck on

`query compile` confused me at first. I thought it was another way to scan the repo, but it is really a query-side check. It compiles or checks the QL itself before analysis:

```bash
codeql query compile \
  --search-path=custom-queries \
  -- custom-queries/python/queries/PathTraversal.ql
```

If that fails, the problem is in my query or pack path, not in the target database. If `database analyze` fails, then I should look at the database, the query reference, or the output format.

The CSV output flag also tripped me up. I kept wanting to write `--output-format=csv`, but CodeQL CLI uses `--format=csv`:

```bash
codeql database analyze /tmp/codeql-db \
  custom-queries/python/queries/PathTraversal.ql \
  --format=csv \
  --output=/tmp/codeql-results.csv
```

Uploading results is another separate step. The command is `codeql github upload-results`, not "database upload":

```bash
codeql github upload-results \
  --repository=OWNER/REPO \
  --ref=refs/heads/main \
  --commit=<full-commit-sha> \
  --sarif=/tmp/codeql-results.sarif \
  --github-url=https://github.com
```

If I do not already have `GITHUB_TOKEN` in the environment, I should pass the token on stdin with `--github-auth-stdin`.

## What I'd try next

I want to turn the custom query into a small CodeQL pack and test it with `codeql test run`, because that seems like the safer loop for query edits. I also want to compare a single `.ql` file against a `.qls` suite so I know when I am scanning one custom rule versus a whole set of rules.
