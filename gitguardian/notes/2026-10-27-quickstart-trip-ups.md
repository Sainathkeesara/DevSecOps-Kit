---
last_verified: 2026-10-27
tool_version: n/a
---

# GitGuardian quickstart — what tripped me up

> Following the quickstart, here's what worked and where it broke.

I installed ggshield and ran my first scan. The install itself went fine, but the scan refused to run until I set the API key. I had exported `GITGUARDIAN_API_KEY` in a different shell, so the scan failed with a missing-credentials error. Fix: put the export in my shell profile, not just the current session.

Got stuck on: ggshield defaults to scanning the whole repo history, which took a while on a large repo. I only wanted the working tree, so I used `--pre-commit` style invocation scoped to staged files.

What I'd try next: wire ggshield into pre-commit hooks and CI so secrets never reach the default branch.

- **Term** — `ggshield` CLI scans repos for secrets. Example: `ggshield secret scan repo .`
- **Term** — pre-commit integration blocks commits containing secrets. Example: hook runs on `git commit`.
