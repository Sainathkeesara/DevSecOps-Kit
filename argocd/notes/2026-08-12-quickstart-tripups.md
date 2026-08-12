---
last_verified: 2026-08-12
tool_version: 3.5.0
sources:
  - https://github.com/argoproj/argo-cd/releases/tag/v3.5.0
  - https://argo-cd.readthedocs.io/en/stable/getting_started/
  - https://cloudaqube.com/blog/gitops-argocd-tutorial
---

# Following the official ArgoCD quickstart — what tripped me up

I worked through the official getting-started guide against v3.5.0 and, as usual, the happy path in the docs hid about six small traps. Here's what the guide glosses over.

## The steps that "just worked"

The install was one line, but with two flags I didn't expect:

```bash
kubectl apply --server-side --force-conflicts -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.5.0/manifests/install.yaml
```

Then I grabbed the bootstrap password, logged in, and created an app:

```bash
argocd admin initial-password -n argocd
argocd login localhost:8080 --insecure
argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git \
  --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default
argocd app sync guestbook
```

## Where I tripped

- **`stable` is a moving target, and v3.5.0's own page is honest about it.** The guide's copy-paste URL uses `/stable/`, and separately says pinning a specific version is the safe move for a real cluster. So the guide contradicts itself a little. I pinned to `v3.5.0` in the raw URL — control plane shouldn't drift under me.
- **Plain `kubectl apply` silently skips the ApplicationSet CRD.** The release notes explain that Argo CD CRDs exceed the 262 KB annotation limit for client-side apply, so without `--server-side --force-conflicts` the applicationset-controller CrashLoopBackOffs and nothing tells you why. That flag pair is now a reflex, not an option.
- **The login cert dance.** The server serves a self-signed cert, so `argocd login` refused until I added `--insecure`. The guide mentions `argocd login --core` as the "skip everything, I'm in-cluster anyway" shortcut, which I used for testing.
- **It does NOT sync the instant you create the app.** ArgoCD polls Git every 3 minutes by default. I created the app, stared, saw it sit in `OutOfSync`, and assumed I'd messed up. `argocd app sync` is the manual trigger — after that the app went Healthy quickly.
- **`OutOfSync` right after a successful sync.** Even after a clean apply the app reported out of sync. Kubernetes normalizes fields (`1000m` → `1`, `3072Mi` → `3Gi`), so live state stops byte-matching Git. `ignoreDifferences` in the Application fixes that.
- **Base64 Secrets are not encrypted.** I already knew this, but the guide's sample prints secrets to the screen. If I commit a Secret manifest, ArgoCD stores it base64 — not encrypted. Which is why tools like Sealed Secrets or SOPS belong in the flow.

## The conceptual bit that mattered

ArgoCD is a **CD** tool, not CI. It renders and applies already-built manifests; it never builds images or runs tests. Re-reading everything through that lens dissolved most of my initial confusion about "where's the build?"

## What I'd try next

How `selfHeal` interacts with an HPA that also manages `replicas` — apparently they tug-of-war unless `replicas` is removed from the manifest or added to `ignoreDifferences`. And I'd write an Application manifest by hand instead of `argocd app create`.