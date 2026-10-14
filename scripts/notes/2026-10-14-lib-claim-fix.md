---
last_verified: 2026-10-14
tool_version: n/a
sources: []
---

# Fixing the scripts/lib claim

I checked whether `scripts/lib/` exists because `scripts/README.md` documents seven shared modules under it. `ls scripts/` shows no `lib/` directory, and I grepped the whole tree for `lib/logging`, `lib/retry`, `lib/config`, and `k8s-common` — the only hits are the README lines themselves. Nothing sources from `lib/`.

So I fixed both docs instead of building the modules: the README's shared-libraries section now describes the flat layout, and I corrected the same claim in my `2026-09-20` explore note. Building the seven modules would step on scripts-005, which already owns that work at L4.

What tripped me up: the README claim looked authoritative, so I almost started writing the modules. Glad I listed the directory first.

What I'd try next: keep shared helpers inside each toolkit dir until scripts-005 lands.
