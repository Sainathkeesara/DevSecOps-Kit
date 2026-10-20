#!/usr/bin/env bash
# last_verified: 2026-10-20 · kubernetes v1.32.0
# What I learned doing the kubernetes tutorial — a script that reproduces
# the six modules imperatively so I can re-run it on a fresh cluster.
# Not a replacement for kubectl apply -f (that's the declarative way),
# but a record of the commands I actually ran.

CLUSTER_CMD="${CLUSTER_CMD:-minikube}"
NAMESPACE="${NAMESPACE:-default}"

log() { echo "[$(date +'%H:%M:%S')] $*"; }

# Module 1: Create cluster
log "Starting cluster with $CLUSTER_CMD..."
if ! $CLUSTER_CMD status >/dev/null 2>&1; then
  $CLUSTER_CMD start
fi
log "Cluster ready: $($CLUSTER_CMD ip 2>/dev/null || echo 'no IP yet')"

# Module 2: Deploy app
log "Creating deployment..."
kubectl create deployment kubernetes-bootcamp \
  --image=gcr.io/google-samples/kubernetes-bootcamp:v1 \
  -n "$NAMESPACE"

log "Waiting for rollout..."
kubectl rollout status deployment/kubernetes-bootcamp -n "$NAMESPACE" --timeout=60s

log "Pods created:"
kubectl get pods -l app=kubernetes-bootcamp -n "$NAMESPACE"

# Module 3: Explore
log "Describing first pod..."
POD=$(kubectl get pods -l app=kubernetes-bootcamp -n "$NAMESPACE" -o jsonpath='{.items[0].metadata.name}')
kubectl describe pod "$POD" -n "$NAMESPACE" | head -30

log "Pod logs:"
kubectl logs "$POD" -n "$NAMESPACE" | head -20

log "Exec into pod (using sh, not bash — the image doesn't have bash):"
kubectl exec "$POD" -n "$NAMESPACE" -- sh -c 'echo "inside container: $(hostname)"'

# Module 4: Expose
log "Exposing as NodePort service..."
kubectl expose deployment/kubernetes-bootcamp \
  --type=NodePort --port=8080 \
  -n "$NAMESPACE"

SVC_PORT=$(kubectl get svc kubernetes-bootcamp -n "$NAMESPACE" -o jsonpath='{.spec.ports[0].nodePort}')
CLUSTER_IP=$($CLUSTER_CMD ip 2>/dev/null || echo "localhost")
log "Service URL: http://$CLUSTER_IP:$SVC_PORT"
log "Or run: $CLUSTER_CMD service kubernetes-bootcamp -n $NAMESPACE"

# Module 5: Scale
log "Scaling to 4 replicas..."
kubectl scale deployment/kubernetes-bootcamp --replicas=4 -n "$NAMESPACE"
kubectl rollout status deployment/kubernetes-bootcamp -n "$NAMESPACE" --timeout=60s
log "Pods after scale:"
kubectl get pods -l app=kubernetes-bootcamp -n "$NAMESPACE"

# Module 6: Update
log "Rolling update to v2..."
kubectl set image deployment/kubernetes-bootcamp \
  kubernetes-bootcamp=gcr.io/google-samples/kubernetes-bootcamp:v2 \
  -n "$NAMESPACE"
kubectl rollout status deployment/kubernetes-bootcamp -n "$NAMESPACE" --timeout=60s
log "Pods after update (should show v2 image):"
kubectl get pods -l app=kubernetes-bootcamp -n "$NAMESPACE" \
  -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[0].image}{"\n"}{end}'

log "Done. To undo: kubectl rollout undo deployment/kubernetes-bootcamp -n $NAMESPACE"