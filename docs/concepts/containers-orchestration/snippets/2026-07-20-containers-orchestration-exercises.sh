#!/usr/bin/env bash
# last_verified: 2026-07-20 - bash 5.1+
# Containers & Orchestration exercises (L2)
# I wrote this to practice moving between Docker CLI commands and a single Kubernetes
# manifest without leaving my terminal. Each section is one command I ran and what
# it showed me about the difference between "it runs on my laptop" and "it runs in a cluster."

echo "=== Exercise 1: Run a container with a custom bridge network ==="
docker network create my-bridge-net
docker run -d --name web --network my-bridge-net nginx:alpine
docker inspect web --format '{{ .NetworkSettings.Networks }}'
docker stop web && docker rm web
docker network rm my-bridge-net

echo "=== Exercise 2: Run the same image with a named volume ==="
docker run -d --name db -v pgdata:/var/lib/postgresql/data postgres:16-alpine
docker volume ls | grep pgdata
docker stop db && docker rm db
docker volume rm pgdata

echo "=== Exercise 3: Write a minimal pod + service manifest and apply it ==="
cat <<'EOF' > /tmp/hello-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: hello-pod
  labels:
    app: hello
spec:
  containers:
    - name: hello
      image: nginx:alpine
      ports:
        - containerPort: 80
      resources:
        requests:
          cpu: "50m"
          memory: "64Mi"
        limits:
          cpu: "200m"
          memory: "128Mi"
      securityContext:
        readOnlyRootFilesystem: true
---
apiVersion: v1
kind: Service
metadata:
  name: hello-svc
spec:
  selector:
    app: hello
  ports:
    - port: 80
      targetPort: 80
  type: ClusterIP
EOF

kubectl apply -f /tmp/hello-pod.yaml
kubectl get pods -l app=hello
kubectl get svc hello-svc
kubectl describe pod hello-pod | grep -A4 "Containers:"
kubectl delete -f /tmp/hello-pod.yaml
rm /tmp/hello-pod.yaml

echo "=== Done. Re-run this script anytime to refresh the exercises ==="
