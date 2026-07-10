#!/usr/bin/env bash
# last_verified: 2026-07-10 · kubectl · Azure CLI

CLUSTER="${1?Usage: $0 <cluster-name>}"
az aks get-credentials --name "$CLUSTER" --overwrite-existing >/dev/null 2>&1

echo "[*] Checking AKS privilege escalation vectors for cluster: $CLUSTER"

# Check for wildcard ClusterRoleBinding subjects
kubectl get clusterrolebindings -o json | jq -r '.items[] | select(.subjects[]? | .name == "*") | .metadata.name' | \
  while read -r binding; do echo "[!] Wildcard binding: $binding"; done

# Check for roles with escalate verb
kubectl get clusterroles -o json | jq -r '.items[] | select(.rules[]? | .verbs[]? == "escalate") | .metadata.name' | \
  while read -r role; do echo "[!] Escalate verb in role: $role"; done
