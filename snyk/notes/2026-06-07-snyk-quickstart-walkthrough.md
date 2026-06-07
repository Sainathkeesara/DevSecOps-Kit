# Snyk quickstart walkthrough — what I actually ran

Following the [official Snyk quickstart](https://docs.snyk.io/getting-started/quickstart) to test a real Node.js project. Here's what worked and what tripped me up.

## Steps I followed

1. **Installed Snyk CLI** — `npm install -g snyk` (took about 15s). Also could have used `brew install snyk` but I went with npm since I already had it.
2. **Authenticated** — `snyk auth` opened a browser tab to log in via GitHub OAuth. The CLI showed "You are now authenticated" pretty quickly.
3. **Tested a project** — `cd ~/projects/my-node-app && snyk test` scanned `package-lock.json` and found 12 vulnerabilities (3 high, 5 medium, 4 low).
4. **Ran monitor** — `snyk monitor` pushed the snapshot to my Snyk dashboard so I could track it over time.
5. **Tried multi-project** — In a monorepo with `packages/` subdirs, `snyk test --all-projects` scanned each one. Took longer but caught everything.

## Got stuck on

- **`snyk test` hung** on a project with no lockfile — it tried to run `npm install` under the hood to build a dependency tree. Adding `--file=package-lock.json` fixed it.
- **`--all-projects` flagged yarn workspaces weirdly** — some sub-projects showed duplicate results. I think it's because yarn uses `yarn.lock` and `--all-projects` picks up both npm and yarn conventions.
- **The dashboard URL after `snyk monitor`** was buried in the CLI output. I missed it the first time. Got it by running `snyk monitor --json | jq -r '.uri'`.
- **Auth expired** after a few hours. `snyk auth` again fixed it, but I expected the token to be cached longer.

## What I'd try next

Test a Java/Gradle project to see if Snyk handles Maven vs Gradle differently. Also want to set up `snyk test` in CI — maybe start with a simple GitHub Action that fails on high-severity findings.
