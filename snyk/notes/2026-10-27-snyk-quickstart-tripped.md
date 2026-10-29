---
last_verified: 2026-10-29
tool_version: n/a
sources:
---
# Snyk — quickstart and what tripped me up

> Followed the official Snyk quickstart and noted the gotchas I hit along the way. First-person, plain language.

## What I did
I installed Snyk, logged in, and ran my first test against a small Node.js project. The goal was to see how the workflow feels from zero to "I have a report I can act on."

## What worked
1. `npm install -g snyk` installed the CLI.
2. `snyk auth` opened a browser window and logged me in — the token got stored in `~/.snyk`.
3. `snyk test` scanned `package.json` and reported vulnerabilities — the default output was a table showing severity, dependency, and a brief description.
4. `snyk monitor` created a project in the Snyk UI and began continuous monitoring. The first push linked the local git branch to the remote project.

## What tripped me up
- **`snyk test` hung on a private repo.** The CLI couldn't resolve the dependency tree because the private package wasn't accessible without an access token. I had to set `NPM_TOKEN` in the environment so Snyk could fetch the package metadata.
- **`snyk auth` kept asking for re-auth.** My session expired after a few hours, and there's no obvious `snyk logout` in the quickstart docs. I ended up deleting `~/.snyk` and running the auth flow again.
- **The remediation suggestions pointed to `npm install <pkg>@latest` without noting peer‑dependency conflicts.** Updating one dependency broke a consumer project, so I learned to check the full diff before upgrading.

## What I'll try next
I want to set up Snyk CI scanning so every PR comment includes a severity summary, and I'd like to explore the `snyk code` command for finding vulnerabilities in source logic — not just dependency flaws. I'm also going to add a `.snyk` ignore file to exclude `node_modules` from the initial scan scope, since the default included everything and flooded the first report.