---
last_verified: 2026-10-14
tool_version: n/a
sources: []
---

# Deduping the observability primer

I diffed `prometheus/notes/0000-primer-observability.md` against `docs/concepts/observability-monitoring/notes/0000-primer-observability.md` and `cmp` says they're byte-identical. Same words, same shape — the concept-voice intro about why observability matters lives in both places.

I kept the concept copy as the canonical one and deleted the prometheus copy. Two reasons: the text reads as a concept primer, not a tool primer, and prometheus already has its own `0000-primer-prometheus.md`. One primer per slot, so the two copies can't drift apart again.

What tripped me up: `00_index/topics.md` still links the deleted prometheus path, but I'm not touching any `00_index/*` file — the Maintainer regenerates the index from the file tree, so the stale link resolves on the next regen. The learning-path link already points at the canonical copy.

What I'd try next: re-run the link checker after the regen to confirm nothing still points at the old path.
