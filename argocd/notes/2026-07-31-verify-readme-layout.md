---
last_verified: 2026-07-31
tool_version: n/a
---

# argocd/ README Layout — verification check

> I ran a quick check to confirm the README Layout still lists argocd/ after the UF fix.

## What I did

I opened the README and searched for the Layout section. The argocd/ entry is present:

`- **argocd/** — ArgoCD GitOps delivery notes, manifests, and first-app deployments`

I also checked that the files referenced in the description actually exist:

- `argocd/manifests/` — contains `2026-07-06-sample-app-application.yaml`
- `argocd/notes/` — contains `0000-primer-argocd.md`, `2026-07-06-install-argocd-first-app.md`, and `2026-07-25-readme-layout.md`

## What I noticed

The README entry and the actual folder contents match. No broken references or missing files.

## What I'd try next

I'd want to check if the coverage table in the README needs updating too, so the argocd/ contents are reflected in the overview.