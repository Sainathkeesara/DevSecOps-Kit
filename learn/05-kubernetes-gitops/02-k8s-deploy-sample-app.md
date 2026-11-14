---
last_verified: 2026-11-13
tool_version: n/a
sources: []
---

# Deploy and debug the sample app on kind

You built the sample app image in the previous lesson. Now you'll run it on a real local cluster with kind, wire it up with a namespace, Deployment and Service, lock it down with a least-privilege service account, and practice debugging a CrashLoopBackOff the way you would on a real cluster.

## What you'll learn

- Deploy the app with a Deployment, Service and namespace
- Give it a least-privilege service account with RBAC
- Debug a CrashLoopBackOff with describe, logs and events

## Before you start

- [Kubernetes — quick primer](../../kubernetes/notes/0000-primer-kubernetes.md) — you should know Pods, Deployments, Services, Namespaces and how to talk to a cluster with kubectl
- [Build the sample app image](../02-build-and-ship/03-docker-sample-app-image.md) — you should have the `sample-app:dev` image built locally
- kind installed: `kind --version`
- kubectl installed: `kubectl version --client`

## Walkthrough

1. Create a local kind cluster.

   ```bash
   kind create cluster --name sample-app
   ```

   You should see kind provision a node and report that cluster creation is complete.

2. Load the sample app image into the kind cluster so its nodes can run it without a registry.

   ```bash
   kind load docker-image sample-app:dev --name sample-app
   ```

   You should see the image being transferred and a success message.

3. Create a namespace for the app.

   Save this as `namespace.yaml`:

   ```yaml
   apiVersion: v1
   kind: Namespace
   metadata:
     name: sample-app
     labels:
       env: dev
       owner: me
   ```

   Then apply it:

   ```bash
   kubectl apply -f namespace.yaml
   ```

   You should see `namespace/sample-app created`.

4. Deploy the app with a Deployment.

   Save this as `deployment.yaml`:

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: sample-app
     namespace: sample-app
     labels:
       app: sample-app
   spec:
     replicas: 2
     selector:
       matchLabels:
         app: sample-app
     template:
       metadata:
         labels:
           app: sample-app
       spec:
         containers:
         - name: app
           image: sample-app:dev
           imagePullPolicy: Never
           ports:
           - containerPort: 8000
   ```

   Apply it and wait for the rollout:

   ```bash
   kubectl apply -f deployment.yaml
   kubectl rollout status deployment/sample-app -n sample-app
   ```

   You should see `deployment.apps/sample-app created` and the rollout report success.

5. Expose the app with a Service.

   Save this as `service.yaml`:

   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: sample-app-svc
     namespace: sample-app
   spec:
     selector:
       app: sample-app
     ports:
     - port: 80
       targetPort: 8000
   ```

   Apply it:

   ```bash
   kubectl apply -f service.yaml
   ```

   You should see `service/sample-app-svc created`.

6. Give the app a least-privilege service account with RBAC.

   The app only needs to read its own pods in this namespace, so grant exactly that — nothing cluster-wide. This follows the namespace-scoped role pattern described in [RBAC design patterns for multi-tenant clusters](../../kubernetes/docs/rbac-design-patterns-for-multi-tenant-clusters.md).

   Save this as `rbac.yaml`:

   ```yaml
   apiVersion: v1
   kind: ServiceAccount
   metadata:
     name: sample-app-sa
     namespace: sample-app
   ---
   apiVersion: rbac.authorization.k8s.io/v1
   kind: Role
   metadata:
     name: sample-app-reader
     namespace: sample-app
   rules:
   - apiGroups: [""]
     resources: ["pods"]
     verbs: ["get", "list", "watch"]
   ---
   apiVersion: rbac.authorization.k8s.io/v1
   kind: RoleBinding
   metadata:
     name: sample-app-reader
     namespace: sample-app
   subjects:
   - kind: ServiceAccount
     name: sample-app-sa
     namespace: sample-app
   roleRef:
     kind: Role
     name: sample-app-reader
     apiGroup: rbac.authorization.k8s.io
   ```

   Apply it:

   ```bash
   kubectl apply -f rbac.yaml
   ```

   Then verify the service account can read pods but nothing more:

   ```bash
   kubectl auth can-i get pods -n sample-app --as=system:serviceaccount:sample-app:sample-app-sa
   ```

   You should see `yes`.

7. Debug a CrashLoopBackOff.

   Break the Deployment on purpose by pointing it at an image that does not exist:

   ```bash
   kubectl set image deployment/sample-app app=sample-app:does-not-exist -n sample-app
   ```

   Then inspect what went wrong:

   ```bash
   kubectl get pods -n sample-app
   kubectl describe pod <crashing-pod> -n sample-app
   kubectl logs <crashing-pod> -n sample-app --previous
   kubectl get events -n sample-app --sort-by=.lastTimestamp
   ```

   `describe` shows the `BackOff` state with an `ErrImagePull` / `ImagePullBackOff` reason, `logs --previous` shows the last container output before it crashed, and `events` confirms the pull failure. Restore the good image and confirm the rollout recovers:

   ```bash
   kubectl set image deployment/sample-app app=sample-app:dev -n sample-app
   kubectl rollout status deployment/sample-app -n sample-app
   ```

## Exercise

From scratch on a fresh kind cluster: create the namespace, deploy the sample app with a Deployment and Service, attach the least-privilege service account, then intentionally break the image and use `describe`, `logs` and `events` to identify why the pods are crashing. Fix the image and confirm the rollout recovers — without copying the walkthrough blocks verbatim.

## Check your work

Run:

```bash
kubectl get deployment sample-app -n sample-app -o jsonpath='{.status.readyReplicas}'
kubectl get service sample-app-svc -n sample-app
kubectl auth can-i get pods -n sample-app --as=system:serviceaccount:sample-app:sample-app-sa
```

You should see `2`, the Service line with a ClusterIP, and `yes`. Then break the image again and confirm `kubectl get pods -n sample-app` shows a pod in `CrashLoopBackOff` or `ImagePullBackOff`.

## Common mistakes

- Forgetting `imagePullPolicy: Never` on a locally-built image, so kind's nodes try to pull `sample-app:dev` from a registry and fail.
- Using `kubectl logs` without `--previous` on a restarting pod, which shows nothing because the current container has not started yet.
- Binding a `ClusterRole` instead of a namespaced `Role`, which grants permissions cluster-wide instead of least-privilege.

## Next

[Environment overlays with Kustomize](03-kustomize-overlays.md)
