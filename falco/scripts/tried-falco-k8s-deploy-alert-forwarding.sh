#!/usr/bin/env bash
# Trying to deploy Falco on Kubernetes with alert forwarding
# Following the Falco Helm chart docs — here's what worked and where it tripped me up

NAMESPACE="${1:-falco}"
FORWARDER="${2:-stdout}"  # stdout or webhook

echo "=== Step 1: Add Falco Helm repo ==="
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

echo "=== Step 2: Install Falco on Kubernetes ==="
# I tried without values first but the default chart doesn't set up
# alert forwarding — had to pass a custom values file
helm upgrade --install falco falcosecurity/falco \
  --namespace "$NAMESPACE" \
  --create-namespace \
  --set falco.jsonOutput=true \
  --wait

# Got stuck on: the first install took a while because it pulls the
# driver image. I thought it was stuck but it just needed more time.

echo "=== Step 3: Wait for pods ==="
kubectl -n "$NAMESPACE" rollout status daemonset falco --timeout=120s

echo "=== Step 4: Check Falco is running ==="
kubectl -n "$NAMESPACE" get pods -l app=falco

echo "=== Step 5: Set up alert forwarding ==="
if [ "$FORWARDER" = "webhook" ]; then
  # I wanted to forward alerts to a webhook endpoint.
  # The Falco chart supports falcosidekick for this, so I'm
  # upgrading the release to include it.
  helm upgrade falco falcosecurity/falco \
    --namespace "$NAMESPACE" \
    --reuse-values \
    --set falcosidekick.enabled=true \
    --set falcosidekick.config.webhook.address="http://example.com/webhook"
  echo "Webhook forwarding configured to http://example.com/webhook"
else
  # JSON stdout is enough for now — I can pipe it from kubectl logs later
  echo "Using stdout JSON output (default)"
fi

echo "=== Step 6: Generate a test alert ==="
# The simplest way to trigger a Falco rule is running a shell in a container
kubectl -n "$NAMESPACE" run test-alert --image=alpine --restart=Never -- sh -c "id"
sleep 3

echo "=== Step 7: Check for alerts ==="
kubectl -n "$NAMESPACE" logs ds/falco --tail=30 2>/dev/null | grep -E "(Warning|Alert|shell)" || \
  echo "No shell alerts found — might need a different test. Trying cat /etc/shadow..."
kubectl -n "$NAMESPACE" run test-alert-2 --image=alpine --restart=Never -- cat /etc/shadow 2>/dev/null
sleep 2
kubectl -n "$NAMESPACE" logs ds/falco --tail=20 2>/dev/null | grep -E "(Warning|Alert|output)" || \
  echo "No alerts detected yet. The rules might need tuning."

echo "=== Cleanup test pods ==="
kubectl -n "$NAMESPACE" delete pod test-alert test-alert-2 --ignore-not-found=true

# What I'd try next:
# - Set up falcosidekick with Slack or PagerDuty integration
# - Write a custom rule and test it triggers correctly
# - Use the gRPC API instead of log scraping for forwarding
echo ""
echo "Falco deployment complete in namespace '$NAMESPACE'"
echo "View live alerts: kubectl -n $NAMESPACE logs -l app=falco -f"
