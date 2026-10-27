#!/usr/bin/env bash
# last_verified: 2026-10-27 · argocd n/a
# Applies the ArgoCD root Application (App of Apps parent) so child
# Applications under apps/environments/ are created and synced automatically.
set -euo pipefail

ROOT_APP="apps/root-application.yaml"

if [ ! -f "$ROOT_APP" ]; then
  echo "error: $ROOT_APP not found — run this from the scaffold root" >&2
  exit 1
fi

if ! command -v kubectl >/dev/null 2>&1; then
  echo "error: kubectl is required but not on PATH" >&2
  exit 1
fi

echo "Applying root Application: $ROOT_APP"
kubectl apply -f "$ROOT_APP"

echo "Root Application applied. ArgoCD creates the child Applications"
echo "under apps/environments/ on its next reconcile (default ~3 minutes)."
echo "Check status with: kubectl -n argocd get applications"
