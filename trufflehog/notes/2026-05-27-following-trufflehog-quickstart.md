# Following the TruffleHog quickstart — what tripped me up

I followed the official TruffleHog quickstart to scan a GitHub repo for secrets. Here's what worked and where I got stuck.

## Steps

1. Installed TruffleHog via the script — `curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh | sh -s -- -b /usr/local/bin`. Worked first try.

2. Ran the quickstart command from the README: `trufflehog git https://github.com/trufflesecurity/test_keys --results=verified`. This scanned the test repo and found a verified AWS key. The output showed the detector type, line number, commit hash, and file.

3. Tried the org scan: `trufflehog github --org=trufflesecurity --results=verified`. This took a while — the org has a lot of repos and TruffleHog enumerates them all via the GitHub API. Got rate-limited without a token, so I added `--token` with a personal access token and it went much faster.

4. Tried JSON output: `trufflehog git https://github.com/trufflesecurity/test_keys --results=verified --json | jq '.SourceMetadata.Data.Git'`. The JSON includes SourceMetadata with commit, file, line, and repository info — good for automation.

5. Scanned issues and PR comments: `trufflehog github --repo=https://github.com/trufflesecurity/test_keys --issue-comments --pr-comments`. Found a few secrets in issue comments that weren't in the source code.

## Got stuck on

- The org scan hit GitHub API rate limits fast (60 req/hr unauthenticated). Adding a `--token` fixed it but the docs don't call this out prominently in the quickstart.
- `--results=verified` by default only shows verified results. I expected to see unverified results too but had to add `--results=verified,unverified,unknown` to get everything.
- The `filesystem` subcommand doesn't accept a `--path` flag — it takes positional args. I kept writing `trufflehog filesystem --path=./dir` before checking `--help`.
- Scanning a local git repo needs a `file://` URI, not a plain path: `trufflehog git file://./my-repo`. The quickstart shows this but it's easy to miss.

## What I'd try next

I want to wire TruffleHog into a GitHub Actions workflow so every PR gets scanned automatically. Also curious about the `--config` file approach with custom regex detectors for internal secret formats.
