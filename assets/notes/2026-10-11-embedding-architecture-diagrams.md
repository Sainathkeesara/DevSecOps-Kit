---
last_verified: 2026-10-11
tool_version: n/a
---

# Embedding the three architecture diagrams

> First-day notes on fixing the orphaned diagrams in `assets/`. The 2026-10-10 note confirmed zero inbound links — time to embed or drop.

## What I did

I embedded each PNG where it actually belongs:

1. **`architecture-overview.png`** → `README.md` after the Layout section. The README lists `assets/` as a layout bullet but never showed the picture. Now it does.

2. **`cicd-workflow.png`** → `docs/concepts/ci-cd-pipeline-concepts/0000-primer-ci-cd-pipeline-concepts.md` right after the "What is it?" section. The primer describes the assembly-line mental model; the diagram illustrates it.

3. **`devsecops-pipeline.png`** → `docs/concepts/application-security-testing-concepts/0000-primer-application-security-testing-concepts.md` after the "What is it?" section. That primer explicitly says "we weave security testing into the CI/CD pipeline" — the diagram shows that weaving.

All three use relative paths (`../assets/...` or `../../../assets/...`) so they render on GitHub and locally.

## What I checked

Ran a quick grep for `assets/` in `.md` files — all three diagrams now have at least one inbound link. The asset index YAML still marks them as used by the README, which is now true for the overview diagram.

## What I'd try next

The asset index config could be updated to reflect the actual referrers (README, CI/CD primer, AppSec primer) instead of claiming all three are used by the README. That's a separate config task though.