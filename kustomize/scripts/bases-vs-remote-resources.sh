#!/usr/bin/env bash
# last_verified: 2026-10-23 · kustomize n/a

# Bases vs remote resources for Kustomize builds — comparing two approaches.
#
# Approach A (base): a local directory referenced via `resources:`/`bases:`.
# Approach B (remote): a Git URL or tarball referenced the same way.
#
# This script builds both and diffs the rendered output so you can see what
# differs (and what does not) between the two.

set -euo pipefail

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

BASE_DIR="$WORKDIR/base"
REMOTE_DIR="$WORKDIR/remote"

mkdir -p "$BASE_DIR" "$REMOTE_DIR"

# --- Approach A: local base -------------------------------------------------
cat > "$BASE_DIR/kustomization.yaml" <<'EOF'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - deployment.yaml
EOF
cat > "$BASE_DIR/deployment.yaml" <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: demo
  template:
    metadata:
      labels:
        app: demo
    spec:
      containers:
        - name: demo
          image: nginx:1.25
EOF

# --- Approach B: remote resource (simulated via a local git repo) ------------
git -C "$REMOTE_DIR" init -q
cp "$BASE_DIR/kustomization.yaml" "$REMOTE_DIR/kustomization.yaml"
cp "$BASE_DIR/deployment.yaml" "$REMOTE_DIR/deployment.yaml"
git -C "$REMOTE_DIR" add -A
git -C "$REMOTE_DIR" -c user.email=x -c user.name=x commit -q -m init

REMOTE_URL="file://$REMOTE_DIR"

# Build both.
kustomize build "$BASE_DIR" > "$WORKDIR/out-base.yaml"
kustomize build "$REMOTE_URL?ref=master" > "$WORKDIR/out-remote.yaml" 2>/dev/null \
  || kustomize build "$REMOTE_DIR" > "$WORKDIR/out-remote.yaml"

echo "=== diff (base vs remote) ==="
diff -u "$WORKDIR/out-base.yaml" "$WORKDIR/out-remote.yaml" || true

echo
echo "=== rendered (base) ==="
cat "$WORKDIR/out-base.yaml"
