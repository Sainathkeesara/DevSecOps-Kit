#!/usr/bin/env bash
# Trying to deploy Falco on Kubernetes with alert forwarding via Falcosidekick
# Following the official Helm chart docs to understand how Falco events flow
# Usage: ./falco-k8s-alert-forwarding.sh [webhook-url]
#   webhook-url defaults to a placeholder — swap it for your actual endpoint

NAMESPACE="${FALCO_NAMESPACE:-falco-test}"
WEBHOOK_URL="${1:-https://hooks.example.com/alerts}"

echo "=== Adding Falco Helm repos ==="
helm repo add falcosecurity https://falcosecurity.github.io/charts 2>/dev/null
helm repo update

echo "=== Creating $NAMESPACE namespace ==="
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

echo "=== Deploying Falco with JSON output ==="
# JSON output is required here because Falcosidekick expects JSON-formatted events.
# Without jsonOutput=true, Falco emits key=value pairs that Falcosidekick can't parse.
helm upgrade --install falco falcosecurity/falco \
  --namespace "$NAMESPACE" \
  --set falco.jsonOutput=true \
  --set falco.httpOutput.enabled=true \
  --set falco.httpOutput.url="http://falco-falcosidekick:2801/" \
  --wait

echo "=== Deploying Falcosidekick for alert forwarding ==="
# Falcosidekick reads events from Falco's HTTP output and forwards them to
# a target destination. I'm using the webhook output here, but it also
# supports Slack, Teams, Datadog, and many more.
helm upgrade --install falcosidekick falcosecurity/falcosidekick \
  --namespace "$NAMESPACE" \
  --set config.webhook.address="$WEBHOOK_URL" \
  --wait

echo "=== Verifying deployment ==="
kubectl -n "$NAMESPACE" get pods

echo ""
echo "Falco and Falcosidekick are running."
echo ""
echo "Got stuck on:"
echo "  - First install omitted jsonOutput=true — Falcosidekick showed parsing errors"
echo "  - The httpOutput.url must use the Kubernetes service DNS name, not localhost"
echo "  - --wait timed out on a node without privileged container support"
echo ""
echo "What I'd try next:"
echo "  - Add custom Falco rules for application-specific detections"
echo "  - Wire up falco-exporter for Prometheus alertmanager integration"
echo "  - Try the Slack output in Falcosidekick instead of a generic webhook"
