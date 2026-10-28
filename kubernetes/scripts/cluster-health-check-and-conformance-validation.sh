#!/usr/bin/env bash
# last_verified: 2026-10-28 · kubernetes n/a
# Cluster health check and conformance validation script
# I wanted a way to quickly verify my cluster is healthy before running workloads,
# and this script became my go-to for checking the most common issues.

set -o pipefail

CLUSTER_CMD="${CLUSTER_CMD:-kubectl}"
NAMESPACE="${NAMESPACE:-default}"

log() { echo "[$(date +'%H:%M:%S')] $*"; }

warn() { echo "WARNING: $*" >&2; }

die() { warn "$1"; exit "${2:-1}"; }

# ---- Check kubectl availability ----
if ! command -v "${CLUSTER_CMD}" >/dev/null 2>&1; then
  die "Required command not found: ${CLUSTER_CMD}. Install it first."
fi

# ---- Check cluster connectivity ----
log "Checking cluster connectivity via ${CLUSTER_CMD}..."
if ! "${CLUSTER_CMD}" cluster-info >/dev/null 2>&1; then
  die "Cluster unreachable. Verify your kubeconfig and cluster status."
fi
log "Cluster info: reachable"

# ---- Check node health ----
log "Checking node status..."
NODES=$("${CLUSTER_CMD}" get nodes -o jsonpath='{.items[*].metadata.name}' 2>/dev/null)
if [ -z "${NODES}" ]; then
  die "No nodes found. Is the control plane running?"
fi
for node in ${NODES}; do
  STATUS=$("${CLUSTER_CMD}" get node "${node}" -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)
  if [ "${STATUS}" = "True" ]; then
    log "Node ${node}: Ready"
  else
    warn "Node ${node}: Not Ready (${STATUS})"
  fi
done

# ---- Check pod health ----
log "Checking pod health across namespaces..."
PODS=$("${CLUSTER_CMD}" get pods --all-namespaces -o jsonpath='{.items[*].metadata.name}' 2>/dev/null)
if [ -z "${PODS}" ]; then
  warn "No pods found in the cluster."
else
  READY_COUNT=0
  TOTAL_COUNT=0
  for ns in $("${CLUSTER_CMD}" get namespaces -o jsonpath='{.items[*].metadata.name}' 2>/dev/null); do
    for pod in $("${CLUSTER_CMD}" get pods -n "${ns}" -o jsonpath="{.items[*].metadata.name}" 2>/dev/null); do
      READY=$("${CLUSTER_CMD}" get pod "${pod}" -n "${ns}" -o jsonpath='{.status.containerStatuses[?(@.ready=="true")].length}' 2>/dev/null || echo 0)
      TOTAL=$("${CLUSTER_CMD}" get pod "${pod}" -n "${ns}" -o jsonpath'{.status.containerStatuses.length}' 2>/dev/null || echo 0)
      if [ "${TOTAL}" -gt 0 ] && [ "${READY}" -eq "${TOTAL}" ]; then
        log "Pod ${pod} (ns: ${ns}): Ready"
        READY_COUNT=$((READY_COUNT + 1))
      else
        warn "Pod ${pod} (ns: ${ns}): Not fully ready (${READY}/${TOTAL})"
      fi
      TOTAL_COUNT=$((TOTAL_COUNT + 1))
    done
  done
  log "Summary: ${READY_COUNT}/${TOTAL_COUNT} pods ready"
fi

# ---- Check API server ----
log "Checking API server responsiveness..."
if "${CLUSTER_CMD}" get --raw "/api/v1" >/dev/null 2>&1; then
  log "API server: responsive"
else
  warn "API server: not responsive"
fi

# ---- Check DNS ----
log "Checking DNS resolution..."
POD_NAME=$("${CLUSTER_CMD}" get pods --all-namespaces -l k8s-app=kube-dns -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
if [ -n "${POD_NAME}" ]; then
  DNS_TEST=$("${CLUSTER_CMD}" exec "${POD_NAME}" -n kube-system -- sh -c 'nslookup google.com' 2>/dev/null)
  if [ -n "${DNS_TEST}" ]; then
    log "DNS: resolving"
  else
    warn "DNS: not resolving external domains"
  fi
else
  warn "kube-dns pod not found; skipping DNS check"
fi

# ---- Summary ----
log "=== Health Check Summary ==="
NODE_COUNT=$("${CLUSTER_CMD}" get nodes -o jsonpath={.items[*].metadata.name} 2>/dev/null | wc -w)
log "Nodes: ${NODE_COUNT:-0}"
log "Done. Review any warnings above and address before deploying workloads."