# CodeQL quickstart walkthrough — what tripped me up

Following the official CodeQL quickstart docs to get familiar with the tool. I already had the CLI installed (v2.18.4) and had run basic database creation, so this was about digging deeper into the query workflow.

## Steps I followed

1. Cloned the CodeQL starter workspace: `git clone https://github.com/github/codeql-starter`
2. Created a database for my Python project: `codeql database create /tmp/testdb --language=python --source-root=.`
3. Ran the default security suite: `codeql database analyze /tmp/testdb codeql/python-queries:codeql-suites/python-security-extended.qls --format=sarif`
4. Tried a custom query file I wrote: `codeql query run my-custom-query.ql --database=/tmp/testdb`
5. Published results to GitHub: configured `codeql database upload` with a commit SHA.

## Got stuck on

- **Query pack syntax confusion.** The colon syntax in `codeql/python-queries:` packs is easy to forget. I kept typing `python-queries` without the colon, or using a space instead of colon. Neither gives a clear error.
- **Custom queries need compilation.** When I tried running my `.ql` file directly, it failed with "unable to resolve import" — I had to run `codeql query compile` first or use the `--format=query` flag.
- **SARIF output is huge.** The default SARIF file was 10MB for a small project. I had to add `--threads=4` to speed up analysis, but the output format is still unwieldy for reading in a text editor.
- **Upload requires GitHub token.** I ran `database upload` without setting `GH_TOKEN` and it failed silently. The error only shows up in the GitHub UI later as "no scans found for this ref."
- **Database location default.** I ran `database create` without `--source-root` and it assumed the current directory was the project. The database ended up in `/tmp/codeql-` with a random suffix — easy to lose track of.

## What I'd try next

I want to try the CodeQL CLI's `test run` command to run tests against my custom queries. The quickstart mentions it but doesn't show the workflow. I also need to figure out how to narrow query output — maybe with `--output-format=csv` or filtering SARIF after the fact.