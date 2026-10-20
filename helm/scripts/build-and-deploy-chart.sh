#!/usr/bin/env bash
# last_verified: 2026-10-20 · helm n/a
# Build a Helm chart from scratch and deploy it to a Kubernetes cluster.
#
# Usage:
#   ./build-and-deploy-chart.sh --name myapp --chart-dir ./myapp
#   ./build-and-deploy-chart.sh --name myapp --chart-dir ./myapp --namespace prod --values prod-values.yaml

set -u

CHART_NAME=""
CHART_DIR=""
RELEASE_NAME=""
VALUES_FILE=""
NAMESPACE="default"
DRY_RUN=false

usage() {
  cat <<EOF
Usage: $0 --name <chart-name> --chart-dir <dir> [options]

Options:
  --name <name>          Chart name (also used as the default release name)
  --chart-dir <dir>      Directory for the chart (created by 'helm create')
  --release <name>       Release name (defaults to --name)
  --values <file>        Path to a values file (defaults to \$CHART_DIR/values.yaml)
  --namespace <ns>       Target namespace (default: default)
  --dry-run              Run helm template and helm upgrade --dry-run only; do not deploy
  --help                 Show this help
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --name)      CHART_NAME="$2"; shift 2 ;;
    --chart-dir) CHART_DIR="$2"; shift 2 ;;
    --release)   RELEASE_NAME="$2"; shift 2 ;;
    --values)    VALUES_FILE="$2"; shift 2 ;;
    --namespace) NAMESPACE="$2"; shift 2 ;;
    --dry-run)   DRY_RUN=true; shift ;;
    --help|-h)   usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done

if [ -z "$CHART_NAME" ] || [ -z "$CHART_DIR" ]; then
  echo "Error: --name and --chart-dir are required." >&2
  usage >&2
  exit 2
fi

if [ -z "$RELEASE_NAME" ]; then
  RELEASE_NAME="$CHART_NAME"
fi

# Resolve the values file against the chart directory, not the current working
# directory. 'helm create ./myapp' writes ./myapp/values.yaml, so defaulting
# VALUES_FILE to a bare 'values.yaml' makes helm template and helm upgrade
# --install abort with "open values.yaml: no such file or directory" unless the
# caller happens to be standing in the chart directory.
if [ -z "$VALUES_FILE" ]; then
  VALUES_FILE="$CHART_DIR/values.yaml"
fi

fail() {
  echo "Error: $*" >&2
  exit 1
}

# ── Step 1: create the chart ────────────────────────────────────────────────
if [ ! -d "$CHART_DIR" ]; then
  echo ">> helm create $CHART_DIR"
  helm create "$CHART_DIR" || fail "helm create failed for $CHART_DIR"
else
  echo ">> Chart directory $CHART_DIR already exists; skipping helm create."
fi

# ── Step 2: lint ────────────────────────────────────────────────────────────
echo ">> helm lint $CHART_DIR"
helm lint "$CHART_DIR" || fail "helm lint reported issues for $CHART_DIR"

# ── Step 3: template to a file (never pipe to head — SIGPIPE can kill helm) ─
TEMPLATE_OUT="$(mktemp)"
trap 'rm -f "$TEMPLATE_OUT"' EXIT

echo ">> helm template $CHART_NAME $CHART_DIR --values $VALUES_FILE"
helm template "$CHART_NAME" "$CHART_DIR" --values "$VALUES_FILE" > "$TEMPLATE_OUT" \
  || fail "helm template failed for $CHART_DIR"
echo "   rendered $(wc -l < "$TEMPLATE_OUT") lines to $(basename "$TEMPLATE_OUT")"

# ── Step 4: deploy (or dry-run) ─────────────────────────────────────────────
if [ "$DRY_RUN" = true ]; then
  echo ">> helm upgrade --install $RELEASE_NAME $CHART_DIR --namespace $NAMESPACE --values $VALUES_FILE --dry-run"
  helm upgrade --install "$RELEASE_NAME" "$CHART_DIR" \
    --namespace "$NAMESPACE" \
    --values "$VALUES_FILE" \
    --dry-run \
    --atomic \
    --create-namespace \
    || fail "helm upgrade --install --dry-run failed"
  echo "Dry run succeeded; nothing was deployed."
  exit 0
fi

echo ">> helm upgrade --install $RELEASE_NAME $CHART_DIR --namespace $NAMESPACE --values $VALUES_FILE"
helm upgrade --install "$RELEASE_NAME" "$CHART_DIR" \
  --namespace "$NAMESPACE" \
  --values "$VALUES_FILE" \
  --atomic \
  --create-namespace \
  --wait \
  || fail "helm upgrade --install failed for release $RELEASE_NAME in namespace $NAMESPACE"

# ── Step 5: verify ──────────────────────────────────────────────────────────
echo ">> helm status $RELEASE_NAME --namespace $NAMESPACE"
helm status "$RELEASE_NAME" --namespace "$NAMESPACE" \
  || fail "helm status reports release $RELEASE_NAME is not healthy"

echo ">> kubectl rollout status deploy/$RELEASE_NAME --namespace $NAMESPACE"
kubectl rollout status "deploy/$RELEASE_NAME" --namespace "$NAMESPACE" \
  || fail "deployment $RELEASE_NAME rollout did not complete"

echo "Done. Check with: kubectl get all -n $NAMESPACE"