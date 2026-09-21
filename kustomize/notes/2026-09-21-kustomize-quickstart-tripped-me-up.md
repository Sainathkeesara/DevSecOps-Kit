---
last_verified: 2026-09-21
tool_version: n/a
sources:
  - https://kubectl.docs.kubernetes.io/references/kustomize/
---

# Followed the official Kustomize quickstart — what tripped me up

> Walking through the kubectl built-in Kustomize quickstart, plus the gotchas the docs skip.

## What I did

I followed the official Kustomize quickstart using `kubectl kustomize` (built into kubectl since 1.14). Created a base `kustomization.yaml` with a Deployment and Service, then added an overlay for dev environment with replica count and label changes. Ran `kubectl kustomize overlays/dev` to render and `kubectl apply -k overlays/dev` to apply.

## Got stuck on

**1. `kubectl kustomize` vs `kustomize build` output differences**
The built-in `kubectl kustomize` doesn't support all the flags the standalone `kustomize` binary does (like `--enable-alpha-plugins`). I wasted time trying to use `kustomize build --enable-alpha-plugins` before realizing the built-in version ignores it. For anything beyond basics, install the standalone binary.

**2. `namePrefix` and `nameSuffix` apply to ALL resources**
I added `namePrefix: dev-` in my overlay expecting it to only prefix the Deployment. It also prefixed the Service, ConfigMap, and Secret names — which broke my Service selector because the Deployment's `matchLabels` didn't get the prefix automatically. Had to add `commonLabels` in the overlay to keep selectors in sync.

**3. `patchesStrategicMerge` vs `patchesJson6902` confusion**
The quickstart shows `patchesStrategicMerge` for simple field changes. I tried to patch a container's `env` list (add a new env var) and it replaced the entire list instead of merging. Strategic merge only works for certain list types (like `ports`); for `env`, `volumes`, or arbitrary lists you need `patchesJson6902` with a JSON patch path like `/spec/template/spec/containers/0/env/-`.

**4. `configMapGenerator` and `secretGenerator` require `generatorOptions` for immutable**
I generated a ConfigMap from a file and expected `kubectl apply -k` to update it on file change. It didn't — the generated ConfigMap had a hash suffix but the Deployment still referenced the old name. Adding `generatorOptions: { disableNameSuffixHash: true }` in the base and using `kustomize edit add configmap --from-file=...` with `behavior: replace` in the overlay fixed it. But the docs don't emphasize this workflow.

**5. Overlay `resources:` path is relative to the overlay directory**
My overlay's `kustomization.yaml` had `resources: [../../base]` and it worked from the repo root, but failed when I ran `kubectl apply -k overlays/dev` from inside the overlay directory. The path must be relative to the kustomization.yaml file location, not the CWD.

## What I'd try next

I want to try `kustomize edit set image` for image promotion across environments without editing YAML. Also want to experiment with `kustomize edit add patch` for JSON 6902 patches via CLI instead of hand-editing YAML. After that, I'll look at `kustomize edit add component` for reusable component patterns.