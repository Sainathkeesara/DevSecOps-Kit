#!/usr/bin/env bash
# last_verified: 2026-07-19 · kubectl · azure-cli

# Detect AKS privilege-escalation vectors for CVE-2026-33105.
# Usage: aks-privilege-escalation-hardening.sh <cluster-name>
CLUSTER="${1?Usage: $0 <cluster-name>}"

az aks get-credentials --name "$CLUSTER" --overwrite-existing >/dev/null 2>&1

echo "[*] Checking AKS privilege escalation vectors for cluster: $CLUSTER"

echo "[*] Wildcard ClusterRoleBinding subjects:"
kubectl get clusterrolebindings -o json | jq -r '.items[] | select(.subjects[]? | .name == "*") | "  [!] " + .metadata.name' || true

echo "[*] ClusterRoles granting the escalate verb:"
kubectl get clusterroles -o json | jq -r '.items[] | select(.rules[]? | .verbs[]? == "escalate") | "  [!] " + .metadata.name' || true

echo "[*] Bindings in kube-system (review for excessive privilege):"
kubectl get clusterrolebindings -o json | jq -r '.items[] | select(.subjects[]? | .namespace == "kube-system") | "  [?] " + .metadata.name' || true

echo "[*] Done. Manually review any flagged bindings before tightening RBAC."
