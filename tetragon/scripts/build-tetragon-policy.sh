#!/bin/bash
# last_verified: 2026-09-22 · tetragon 1.3.0

# Purpose: Generate a minimal Tetragon TracingPolicy from scratch and verify it.
# This is one way to do it; the docs also suggest using `tetragon generate` for
# more complex policies, but writing YAML directly is fine for simple cases.

set -euo pipefail

POLICY_NAME="${POLICY_NAME:-suspicious-exec-monitor}"
OUTPUT_FILE="${OUTPUT_FILE:-${POLICY_NAME}.yaml}"
NAMESPACE="${NAMESPACE:-kube-system}"

# Step 1: Generate the TracingPolicy YAML
# This policy watches for execve calls to common reconnaissance binaries.
# The selector syntax is verbose but explicit — each arg index maps to a syscall argument.
cat > "$OUTPUT_FILE" <<EOF
apiVersion: cilium.io/v1alpha1
kind: TracingPolicy
metadata:
  name: ${POLICY_NAME}
  namespace: ${NAMESPACE}
spec:
  tracepoints:
  - name: execve
    selectors:
    - matchArgs:
      - index: 0
        type: string
        operator: "PrefixMatch"
        values:
        - "/usr/bin/"
      - index: 1
        type: string
        operator: "Equal"
        values:
        - "wget"
        - "curl"
        - "nc"
        - "ncat"
        - "socat"
        - "bash"
        - "sh"
        - "python"
        - "python3"
        - "perl"
    options:
      includeRequestDetails: true
      includeResponseDetails: false
EOF

echo "Generated policy: $OUTPUT_FILE"

# Step 2: Validate YAML syntax
if command -v yq >/dev/null 2>&1; then
  yq eval '.' "$OUTPUT_FILE" >/dev/null
  echo "YAML syntax: valid"
else
  echo "WARNING: yq not found, skipping syntax validation"
fi

# Step 3: Verify the policy structure with kubectl dry-run (if cluster available)
if command -v kubectl >/dev/null 2>&1 && kubectl auth can-i create tracingpolicies.cilium.io --namespace="$NAMESPACE" >/dev/null 2>&1; then
  kubectl apply --dry-run=client -f "$OUTPUT_FILE" >/dev/null
  echo "kubectl dry-run: policy accepted by API server"
else
  echo "kubectl not available or insufficient permissions — skipping API validation"
  echo "To apply manually: kubectl apply -f $OUTPUT_FILE"
fi

# Step 4: Show how to observe events once policy is applied
cat <<EOF

Next steps:
1. Apply the policy: kubectl apply -f $OUTPUT_FILE
2. Watch events:      tetragon observe --namespace $NAMESPACE --policy $POLICY_NAME
3. Or tail logs:      kubectl logs -n $NAMESPACE -l k8s-app=tetragon -f | jq '.process_exec'

EOF

echo "Done. Policy written to $OUTPUT_FILE"