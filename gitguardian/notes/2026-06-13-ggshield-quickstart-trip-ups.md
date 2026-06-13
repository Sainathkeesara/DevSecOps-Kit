# Following the ggshield quickstart

I worked through the official GitGuardian ggshield quickstart to see how easy (or hard) it is to get up and running on a real project. This is my scratch pad — what worked, where it tripped me up, and what I still want to figure out.

## Setup steps

1. Installed with pip: `pip install ggshield`
2. Created a GitGuardian account and grabbed an API token from the dashboard.
3. Authenticated locally: `ggshield auth login` — this drops a config file at `~/.config/ggshield` so I don't have to keep passing the token on every run.
4. Ran my first scan against the project root: `ggshield scan path .`

It actually found things immediately. The output groups findings by severity and prints the file path plus line number. Colors helped during local runs, though I'd want JSON or SARIF output when I plug this into a pipeline.

## Got stuck on

**Auth requirement for local scans.** The docs don't make it obvious that `ggshield scan path` wants an authenticated account even when I'm just scanning my own laptop. The first run threw a `401` and pointed me to `ggshield auth login`. Once I ran that, the browser-based login flow was smooth and saved the token.

**Pre-commit hook scope.** I tried `ggshield install pre-commit` and it modified `.git/hooks/pre-commit`. The docs mention both `pre-commit` and `pre-push`, but I didn't realize at first that the hook only scans staged files. When I staged a new fake secret and committed, it caught it. When I committed without staging changes, nothing happened. That took a minute to wrap my head around.

**JSON output in CI.** I wanted to pipe results into a script. `ggshield scan path . --json` works, but the schema felt under-documented. I had to run it once and inspect the keys myself to figure out how to pull out `incident_url` for follow-up triage.

## What I'd try next

- Set up the GitHub Action (`gitguardian/ggshield-action`) on a throwaway repo and compare the SARIF output to the CLI JSON format.
- Try the `--exclude` flag to ignore the `.env` file in my test repo — I want to see how the ignore-diff logic behaves when a secret is on the ignore list but also shows up in another file.
- Read up on the policy file format for ignoring specific secret types; I'm curious whether you can whitelist by regex or only by incident ID.
