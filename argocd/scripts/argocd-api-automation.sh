# last_verified: 2026-10-27 · argocd —

# ArgoCD API automation: sync, wait, verify from CI
# Purpose: trigger an application sync, wait for completion, verify health & sync status.

set -euo pipefail

ARGOCD_SERVER="${ARGOCD_SERVER:?ARGOCD_SERVER required}"
ARGOCD_TOKEN="${ARGOCD_TOKEN:?ARGOCD_TOKEN required}"
APP_NAME="${1:?usage: $0 <app-name>}"

API="https://${ARGOCD_SERVER}/api/v1/applications/${APP_NAME}"

sync_app() {
  curl -sS -X POST "${API}/sync" \
    -H "Authorization: Bearer ${ARGOCD_TOKEN}" \
    -H "Content-Type: application/json" \
    -d '{}' >/dev/null
}

wait_sync() {
  for i in $(seq 1 60); do
    status=$(curl -sS "${API}" -H "Authorization: Bearer ${ARGOCD_TOKEN}" \
      | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d["status"]["sync"]["status"], d["status"]["health"]["status"])')
    echo "sync/health: ${status}"
    case "${status}" in
      "Synced Healthy") return 0 ;;
      *"Degraded"*) echo "degraded"; return 1 ;;
    esac
    sleep 5
  done
  echo "timeout waiting for sync"
  return 1
}

sync_app
wait_sync
echo "application ${APP_NAME} synced and healthy"
