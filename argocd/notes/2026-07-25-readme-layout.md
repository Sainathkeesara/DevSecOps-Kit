---
last_verified: 2026-07-25
tool_version: n/a
---

# argocd/ root folder — README Layout entry

> I checked the README Layout section and confirmed the argocd/ folder is documented there. Here's my observation.

## What I found

I looked at the README Layout section and it already lists the argocd/ folder:

`- argocd/ — ArgoCD GitOps delivery notes, manifests, and first-app deployments`

This entry was added as a UF fix, and the latest README does have it. I verified the existing files match the description — there's a `manifests/` subfolder with a sample Application manifest and a `notes/` subfolder with a primer and an install notes file.

## Why this matters

When someone browses the kit for the first time, the README Layout section is their map. If a folder isn't listed there, it's easy to miss. Having argocd/ documented makes it discoverable alongside the other GitOps, Kubernetes, and security tool folders.

## What I'd double-check next

I'd want to verify the coverage table in the README also reflects the argocd/ contents accurately so the numbers stay in sync when new files are added.