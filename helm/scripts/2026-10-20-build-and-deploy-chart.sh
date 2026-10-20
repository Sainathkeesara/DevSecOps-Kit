#!/usr/bin/env bash
# last_verified: 2026-10-20 · helm n/a
# Build a small Helm chart deploy from scratch (L3 workflow notes)

CHART_DIR="${CHART_DIR:-./myapp}"
RELEASE_NAME="${RELEASE_NAME:-myapp}"
NAMESPACE="${NAMESPACE:-default}"
VALUES_FILE="${VALUES_FILE:-values.yaml}"

echo "Step 1: Scaffold a new chart"
helm create "$CHART_DIR"

echo "Step 2: Customize values (example)"
# Edit values.yaml to set image, replicas, service type as needed

echo "Step 3: Lint the chart"
helm lint "$CHART_DIR"

echo "Step 4: Render templates locally (dry-run)"
helm template "$RELEASE_NAME" "$CHART_DIR" --values "$VALUES_FILE" | head -40

echo "Step 5: Install or upgrade the release"
helm upgrade --install "$RELEASE_NAME" "$CHART_DIR" \
  --namespace "$NAMESPACE" \
  --values "$VALUES_FILE" \
  --wait

echo "Done. Check with: kubectl get all -n $NAMESPACE"
