#!/usr/bin/env bash
# Purpose: Deploy custom Falco ruleset via Helm to Kubernetes cluster
# Usage: ./deploy-falco-ruleset.sh <namespace> [rules-file-path]
# Defaults: namespace=falco-system, rules-file=./custom-rules.yaml

set -euo pipefail

NAMESPACE="${1:-falco-system}"
RULES_FILE="${2:-./custom-rules.yaml}"

echo "[*] Deploying Falco custom ruleset to $NAMESPACE..."

# Create namespace if it doesn't exist
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

# Create or update the custom rules ConfigMap
echo "[*] Creating ConfigMap from $RULES_FILE..."
kubectl create configmap falco-custom-rules \
  --namespace "$NAMESPACE" \
  --from-file=custom-rules.yaml="$RULES_FILE" \
  --dry-run=client -o yaml | kubectl apply -f -

# Wait for ConfigMap to be ready
kubectl rollout status configmap/falco-custom-rules --namespace "$NAMESPACE" 2>/dev/null || true

# Install/upgrade Falco with custom rules mounted
echo "[*] Running Helm install/upgrade..."
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

helm upgrade --install falco falcosecurity/falco \
  --namespace "$NAMESPACE" \
  --set customRules.enabled=true \
  --set customRules.name=falco-custom-rules \
  --wait --timeout 5m

echo "[*] Verifying deployment..."
kubectl -n "$NAMESPACE" wait --for=condition=available deployment/falco \
  --timeout=60s 2>/dev/null || true

# Show recent logs to confirm custom rules are loaded
kubectl -n "$NAMESPACE" logs -l app=falco --tail=20

echo "[+] Falco ruleset deployment complete"