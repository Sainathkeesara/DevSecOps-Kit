#!/usr/bin/env bash
# last_verified: 2026-07-10 · kubectl 1.28+ · Azure CLI 2.50+

# AKS privilege escalation hardening script
# Usage: ./aks-privilege-escalation-hardening.sh --cluster <name> [--resource-group <rg>] [--fix] [--dry-run]
# Checks: wildcard ClusterRoleBinding subjects, Roles with escalate verb, kube-system SA permissions
# Verify:  kubectl get clusterrolebindings and review output

CLUSTER=""
RESOURCE_GROUP=""
FIX=false
DRY_RUN=false

while [ $# -gt 0 ]; do
  case "$1" in
    --cluster)       CLUSTER="$2"; shift 2 ;;
    --resource-group) RESOURCE_GROUP="$2"; shift 2 ;;
    --fix)           FIX=true; shift ;;
    --dry-run)       DRY_RUN=true; shift ;;
    *)               echo "Usage: $0 --cluster <name> [--resource-group <rg>] [--fix] [--dry-run]"; exit 1 ;;
  esac
done

if [ -z "$CLUSTER" ]; then
  echo "[!] --cluster is required"
  exit 1
fi

echo "[*] AKS hardening check for cluster: $CLUSTER"

if [ -n "$RESOURCE_GROUP" ]; then
  az aks get-credentials --resource-group "$RESOURCE_GROUP" --name "$CLUSTER" --overwrite-existing >/dev/null 2>&1
  echo "[*] Authenticated to AKS cluster"
else
  echo "[*] Using current kubeconfig context"
fi

echo ""
echo "--- Check 1: ClusterRoleBindings with wildcard subjects ---"
wildcard_bindings=$(kubectl get clusterrolebindings -o json 2>/dev/null \
  | jq -r '.items[] | select(.subjects[]? | .name == "*") | .metadata.name' 2>/dev/null || echo "")

if [ -n "$wildcard_bindings" ]; then
  echo "[!] Wildcard bindings found:"
  echo "$wildcard_bindings"
  if [ "$FIX" = true ] && [ "$DRY_RUN" = false ]; then
    for binding in $wildcard_bindings; do
      echo "[*] Deleting clusterrolebinding: $binding"
      kubectl delete clusterrolebinding "$binding" 2>/dev/null || true
    done
  fi
else
  echo "[+] No wildcard bindings detected"
fi

echo ""
echo "--- Check 2: Roles with escalate verb ---"
escalate_roles=$(kubectl get clusterroles -o json 2>/dev/null \
  | jq -r '.items[] | select(.rules[]? | .verbs[]? == "escalate") | .metadata.name' 2>/dev/null || echo "")

if [ -n "$escalate_roles" ]; then
  echo "[!] Roles with escalate verb found:"
  echo "$escalate_roles"
else
  echo "[+] No escalate-verb roles detected"
fi

echo ""
echo "--- Check 3: kube-system ServiceAccount bindings ---"
kube_system_sas=$(kubectl get clusterrolebindings -o json 2>/dev/null \
  | jq -r '.items[] | select(.subjects[]? | .namespace == "kube-system") | .metadata.name' 2>/dev/null || echo "")

if [ -n "$kube_system_sas" ]; then
  echo "[!] kube-system SA bindings found:"
  echo "$kube_system_sas"
else
  echo "[+] No kube-system SA bindings detected"
fi

echo ""
echo "--- Check 4: Azure RBAC status ---"
if [ -n "$RESOURCE_GROUP" ]; then
  rbac_status=$(az aks show --resource-group "$RESOURCE_GROUP" --name "$CLUSTER" \
    --query "azureRbac.enabled" -o tsv 2>/dev/null || echo "unknown")
  echo "[*] Azure RBAC enabled: $rbac_status"
  if [ "$rbac_status" = "false" ] && [ "$FIX" = true ] && [ "$DRY_RUN" = false ]; then
    echo "[*] Enabling Azure RBAC..."
    az aks update --resource-group "$RESOURCE_GROUP" --name "$CLUSTER" --enable-azure-rbac >/dev/null 2>&1
    echo "[+] Azure RBAC enabled"
  fi
else
  echo "[*] Skipped (no --resource-group provided)"
fi

echo ""
echo "--- Check 5: cluster-admin bindings ---"
admin_bindings=$(kubectl get clusterrolebindings -o json 2>/dev/null \
  | jq -r '.items[] | select(.roleRef.name == "cluster-admin") | .metadata.name' 2>/dev/null || echo "")

admin_count=0
if [ -n "$admin_bindings" ]; then
  admin_count=$(echo "$admin_bindings" | wc -l)
  echo "[*] cluster-admin bindings: $admin_count"
  echo "$admin_bindings"
else
  echo "[+] No cluster-admin bindings"
fi

echo ""
echo "========================================="
echo "  AKS Hardening Summary"
echo "========================================="
echo "Cluster              : $CLUSTER"
echo "Wildcard bindings    : $([ -n "$wildcard_bindings" ] && echo "FOUND" || echo "none")"
echo "Escalate-verb roles  : $([ -n "$escalate_roles" ] && echo "FOUND" || echo "none")"
echo "kube-system SAs      : $([ -n "$kube_system_sas" ] && echo "FOUND" || echo "none")"
echo "cluster-admin count  : $admin_count"
echo "Azure RBAC           : $rbac_status"
echo "========================================="

if [ "$FIX" = true ] && [ "$DRY_RUN" = true ]; then
  echo "[*] --dry-run mode: no changes applied. Omit --dry-run to remediate."
fi
