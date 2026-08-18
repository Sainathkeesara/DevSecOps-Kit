---
last_verified: 2026-08-18
tool_version: n/a
sources: []
---

# Trivy Kubernetes Workload Scanning — pipeline scaffold

## Purpose

This scaffold packages the configuration, Kubernetes manifests, and runner script
needed to run Trivy against Kubernetes workloads on a schedule or on-demand.

## When to use

- You need recurring vulnerability scans of running container images in a cluster.
- You want scan results in SARIF for downstream CI processing or archival.
- You prefer a Kubernetes-native trigger (CronJob) over a CI-only workflow.

## Prerequisites

- Trivy CLI or container image accessible from the cluster.
- Kubernetes cluster with RBAC permissions to list pods, namespaces, and container images.
- A dedicated namespace (e.g., `security-tools`) for scan jobs and result storage.

## Steps

1. Copy the scaffold into your repository or deploy the manifests directly.
2. Edit `trivy-config.yaml` to set severity thresholds, ignore rules, and namespace exclusions.
3. Deploy `k8s-scan-job.yaml` for on-demand scans or `k8s-scan-cronjob.yaml` for scheduled scans.
4. Review SARIF output in the configured location.

## Verify

- Run `kubectl apply -f k8s-scan-job.yaml` and confirm the Job completes without errors.
- Check that SARIF output appears in the expected location.
- If using the CronJob, verify it fires on schedule with `kubectl get cronjob`.

## Common errors

- **RBAC denied**: The ServiceAccount used by the scan job needs `list` and `get` permissions on pods, namespaces, and container image resources.
- **Image pull failures**: Ensure the Trivy container image is accessible from cluster nodes and the image pull policy is set appropriately.
- **Large cluster timeouts**: Scanning all namespaces can exceed default Job timeouts; adjust `activeDeadlineSeconds` or `ttlSecondsAfterFinished` accordingly.
