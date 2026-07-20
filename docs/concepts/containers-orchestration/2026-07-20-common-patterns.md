---
last_verified: 2026-07-20
tool_version: n/a
---

# Containers & Orchestration — common patterns

I spent this week wiring containers into a local Kubernetes cluster and kept running into the same patterns. Here's what actually worked.

## Image tagging discipline

I used `latest` for a day and lost hours debugging why pod A was running code from pod B's commit. Switching to SHA-tagged images (`image: myapp@sha256:...`) stopped the drift immediately. I also set `imagePullPolicy: Always` while iterating so the cluster would pull fresh builds without me manually deleting pods. Once I settled on a release tag, I switched back to `IfNotPresent` to reduce registry load.

## Resource requests and limits

My first manifests had no resource blocks. The scheduler packed everything onto one node, and one noisy container starved the rest. Adding `resources.requests.memory` and `resources.limits.cpu` spread the pods evenly. I didn't set limits at first because I thought they were optional — they're not on a shared cluster. Now I set requests slightly above the observed baseline and limits at 1.5x to give headroom for traffic spikes.

## Health probes

I added liveness and readiness probes after a container silently failed but the pod stayed `Running`. Without probes Kubernetes never knew to restart it. The simplest probe is a TCP socket check on the app port; I'll upgrade to HTTP probes once the endpoint is stable. I also set `initialDelaySeconds` high enough for the app to finish bootstrapping, otherwise the probe kills the container before it's ready.

## Got stuck on

Secrets management. I hard-coded an API key in an env var while testing and forgot to switch to a Kubernetes Secret before committing. The key is now in the deployment manifest in git history. I'm rotating it and moving to `secretKeyRef` so the value never touches a ConfigMap or plaintext manifest. I also learned that `kubectl create secret` encodes values in base64, which is not encryption — anyone with repo access can decode them.

## What I'd try next

ConfigMaps for non-sensitive config so I can change env vars without rebuilding the image. I also want to try a Helm chart to template the manifests instead of copy-pasting them for each environment. After that, I'll look at resource quotas and limit ranges so new namespaces start with sane defaults instead of inheriting nothing.