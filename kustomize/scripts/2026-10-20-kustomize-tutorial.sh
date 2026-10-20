#!/usr/bin/env bash
# last_verified: 2026-10-20 · kustomize n/a
#
# What I learned doing the kustomize tutorial, written as one re-runnable script.
#
# The tutorial is short: a `base` folder holds the manifests that are the same
# everywhere, an `overlays/dev` folder holds only what changes for dev, and
# `kustomize build` prints the merged result. I kept hand-editing the same
# three YAML files, so I turned the whole tutorial into a script I can re-run
# and diff.
#
# Usage: bash kustomize/scripts/2026-10-20-kustomize-tutorial.sh [workdir]
#
# There is no kustomize binary in the environment I wrote this on, so I could
# not run the render step here. The manifest shapes come from the
# kustomization examples already in this kit (kustomize/configs/).

WORKDIR="${1:-./kustomize-tutorial}"
BASE_DIR="$WORKDIR/base"
OVERLAY_DIR="$WORKDIR/overlays/dev"

mkdir -p "$BASE_DIR" "$OVERLAY_DIR"

# The base is the part that never changes between environments. I keep the
# selector labels in the Deployment and the Service selector matching, because
# that is the bit that bites when an overlay renames or relabels things.
cat > "$BASE_DIR/deployment.yaml" <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app-web
  labels:
    app: my-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
        - name: web
          image: nginx:1.25
          ports:
            - containerPort: 80
EOF

cat > "$BASE_DIR/service.yaml" <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: my-app-service
  labels:
    app: my-app
spec:
  selector:
    app: my-app
  ports:
    - port: 80
      targetPort: 80
  type: ClusterIP
EOF

cat > "$BASE_DIR/kustomization.yaml" <<'EOF'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - deployment.yaml
  - service.yaml
EOF

# The overlay only says what is different for dev. Everything it does not
# mention is inherited from the base.
cat > "$OVERLAY_DIR/kustomization.yaml" <<'EOF'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - ../../base

namePrefix: dev-

commonLabels:
  app: my-app
  managed-by: kustomize

namespace: development

patches:
  - patch: |-
      - op: replace
        path: /spec/replicas
        value: 1
    target:
      kind: Deployment
      name: my-app-web

configMapGenerator:
  - name: app-config
    literals:
      - ENV=development
      - LOG_LEVEL=debug

generatorOptions:
  disableNameSuffixHash: true
EOF

# The standalone kustomize binary has more flags than the copy built into
# kubectl, so I use it when it is around and fall back to `kubectl kustomize`.
if command -v kustomize >/dev/null 2>&1; then
  BUILD=(kustomize build)
elif command -v kubectl >/dev/null 2>&1; then
  BUILD=(kubectl kustomize)
else
  echo "Neither kustomize nor kubectl is on PATH - install one of them and re-run."
  exit 1
fi

echo "== base only =="
"${BUILD[@]}" "$BASE_DIR"

echo
echo "== dev overlay =="
"${BUILD[@]}" "$OVERLAY_DIR"

cat <<'EOF'

What tripped me up:
  * namePrefix renames everything in the overlay, not just the Deployment -
    I only wanted the Deployment renamed and got the Service too.
  * The patch target names the resource as it is written in the base
    (my-app-web). The prefix is applied after the patch, so I left the target
    without the dev- prefix on it.
  * A generated ConfigMap gets a hash suffix unless generatorOptions turns
    that off, and anything referencing it has to follow the renamed one.
  * The `resources: - ../../base` path is relative to the kustomization.yaml,
    not to the directory I happen to be standing in.
  * Printing the base build next to the overlay build was the only way I
    could see which change came from where.
EOF
