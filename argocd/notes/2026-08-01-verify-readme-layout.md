---
last_verified: 2026-08-01
tool_version: n/a
---

# argocd/ root folder — README Layout recheck

> Re-checking the README Layout section today to confirm argocd/ is still listed after the upstream fix.

## What I did

I opened the README and went to the Layout section. Searching for `argocd`, I found it on line 36:

`- **`argocd/`** — ArgoCD GitOps delivery notes, manifests, and first-app deployments`

Then I listed the actual `argocd/` directory to confirm the description lines up with what's actually there:

- `manifests/` — holds `2026-07-06-sample-app-application.yaml` (an ArgoCD Application manifest for the guestbook app)
- `notes/` — holds the primer, install-first-app notes, the readme-layout note, and the previous verification note

The README says "notes, manifests, and first-app deployments" and that's exactly what the folder contains. No broken references, no missing files. The entry was added as an upstream fix and it's still present in the latest README.

## What I'd try next

I noticed the coverage table in the README doesn't include an argocd row — the entry is only in the Layout section. That's fine for now, but adding argocd to the coverage table would keep the counts in sync as the folder grows.