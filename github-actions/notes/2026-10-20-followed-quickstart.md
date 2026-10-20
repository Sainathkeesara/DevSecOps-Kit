---
last_verified: 2026-10-20
tool_version: n/a
sources: []
---

# GitHub Actions — followed the quickstart, what tripped me up

> First-day notes. Personal voice, plain language.

## What I did

I followed the official GitHub Actions quickstart: created a `.github/workflows/` directory, added a workflow file, committed, and watched the run appear under the Actions tab.

## Where I tripped

- YAML indentation. A misplaced space under `jobs:` silently made the whole job invalid. The UI error was vague; `act` locally reproduced it faster.
- Trigger names. I wrote `on: push` then wondered why nothing ran on PRs. Need `on: [push, pull_request]`.
- Secrets. Referencing `${{ secrets.FOO }}` in a step that runs on fork PRs gives empty values; the step just no-ops. Took a while to notice.
- `actions/checkout` version. Pinned to `v4` as the quickstart showed; older runners complained.

## What I'd try next

Wire a second job that depends on the first with `needs:` and pass an artifact between them.
