---
last_verified: 2026-09-26
tool_version: n/a
sources:
  - https://tetragon.io/docs/
---

# How I wired Tetragon into my runtime security workflow

## Purpose

This is one way to fold Tetragon's runtime observations into a regular review loop: install it on a test cluster, apply a small tracing policy, and check the events it reports. The docs also describe deeper paths (metrics export, enforcement modes), but this keeps to the observe-first flow I actually walked through.

## Steps

1. Installed Tetragon on a throwaway test cluster following the project's install guide, and confirmed its agent pods were running before doing anything else.
2. Started with a narrow policy. I kept my earlier experiment at `../configs/first-tracing-policy-exec-file.yaml` as the reference point — it watches process execution and file access — and applied a copy of it with a test-only name so the original stayed untouched:
   ```bash
   kubectl apply -f ../configs/first-tracing-policy-exec-file.yaml
   kubectl get tracingpolicy
   ```
3. Generated a little activity on the cluster (started a pod, ran a shell command inside it) so there was something for the policy to observe.
4. Read back what Tetragon saw from the agent output:
   ```bash
   kubectl logs -n tetragon-system -l app.kubernetes.io/name=tetragon --tail=50
   ```
5. Copied the interesting event lines into my review notes with the pod name and timestamp, so a later scan of the same workload can be compared against them.

## Verify

The wiring works when each link in the chain is visible: the policy shows up under `kubectl get tracingpolicy`, the agent log stream produces event entries after the test activity, and the saved notes name the workload that triggered them. When I re-ran the test pod, I got fresh events with the new timestamps, which told me the policy was still attached and not a leftover from the first run.