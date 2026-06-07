# First ggshield scan

Installed ggshield today. Went pretty smooth but hit one snag.

## Steps

1. Installed via pip: `pip install ggshield`
2. Ran `ggshield scan path .` in a test repo with a fake API key
   - It found it. Output is color-coded, shows the file and line number.
3. Got an auth error — turns out ggshield needs a GitGuardian API token even for local-only scans. You can set `GITGUARDIAN_API_KEY` env var or use `ggshield auth login`.
4. After setting the token with `ggshield auth login` (opens browser), re-ran and it worked.

## Got stuck on

The auth requirement surprised me. I expected local scans to work offline. The error message said something about rate limiting without an account. Makes sense but would've been nice to know upfront.

## What I'd try next

Set up the pre-commit hook (`ggshield install pre-commit`) and try scanning a commit range instead of just paths. Also want to see what the JSON output looks like for CI integration.
