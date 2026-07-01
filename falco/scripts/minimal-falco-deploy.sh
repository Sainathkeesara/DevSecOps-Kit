#!/usr/bin/env bash
# Purpose: Minimal Falco deployment to Kubernetes with alert forwarding via webhook
# Usage: ./minimal-falco-deploy.sh [namespace] [webhook_url]
# Defaults: namespace=falco-system, webhook_url=

NAMESPACE="${1:-falco-system}"
WEBHOOK_URL="${2:-}"

echo "[*] Installing Falco to $NAMESPACE..."

# Create namespace
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

# Install Falco via Helm
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

# Build Helm values with webhook output for alert forwarding
if [ -n "$WEBHOOK_URL" ]; then
  VALUES_FILE="/tmp/falco-values-${NAMESPACE}.yaml"
  cat > "$VALUES_FILE" <<EOF
falco:
  json_output: true
  json_include_output_property: true
  http_event_output:
    enabled: true
    url: "$WEBHOOK_URL"
EOF
  echo "[*] Configuring webhook output: $WEBHOOK_URL"
  helm upgrade --install falco falcosecurity/falco \
    --namespace "$NAMESPACE" \
    -f "$VALUES_FILE" \
    --wait --timeout 5m
else
  helm upgrade --install falco falcosecurity/falco \
    --namespace "$NAMESPACE" \
    --wait --timeout 5m
fi

# Verify deployment
echo "[*] Verifying deployment..."
kubectl -n "$NAMESPACE" rollout status daemonset/falco --timeout=120s 2>/dev/null || true

# Show pod status
kubectl -n "$NAMESPACE" get pods -l app=falco

echo "[+] Falco deployed to $NAMESPACE"
if [ -n "$WEBHOOK_URL" ]; then
  echo "[+] Alerts will be forwarded to $WEBHOOK_URL"
fi