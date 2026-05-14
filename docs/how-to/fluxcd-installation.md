# Flux v2 Installation and GitOps Reconciliation for Declarative Cluster Management

---

SQUIRREL:
  title: "Flux v2 Installation and GitOps Configuration"
  category: "ci_cd"
  tags: ["flux", "gitops", "kubernetes", "helm", "kustomize", "reconciliation", "installation"]
  last_verified: "2026-05-14"
  version: "v2.4+"
---

## Purpose

This guide covers Flux v2 installation on Kubernetes and GitOps reconciliation for declarative cluster management. Flux provides GitOps toolkit for continuous delivery, synchronizing Kubernetes manifests from Git repositories with automated drift detection and reconciliation.

## When to use

- Setting up GitOps-based Kubernetes cluster management
- Implementing declarative infrastructure with Git as source of truth
- Automating Helm releases from Git repositories
- Synchronizing Kustomize overlays across environments
- Managing multi-cluster deployments with Git
- Implementing automated reconciliation for Kubernetes manifests
- Migrating from Flux v1 to Flux v2 (GitOps Toolkit)

## Prerequisites

- Kubernetes cluster (v1.20+) with kubectl configured
- GitHub/GitLab/Bitbucket account with repository access
- Git repository containing Kubernetes manifests
- kubectl context configured to target cluster
- 200MB+ available storage for Flux components
- Helm 3.x (optional, for Helm releases)

## Installation

### Quick Start Installation

```bash
# Install Flux CLI
curl -sL https://fluxcd.io/install.sh | sudo bash

# Verify installation
flux --version

# Install Flux into Kubernetes cluster
flux install

# Verify components
kubectl -n flux-system get pods
```

### Automated Installation with DevOps-Kit Script

```bash
# Basic installation
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/flux_toolkit/flux-install.sh | bash -s --

# Install with Git repository configuration
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/flux_toolkit/flux-install.sh | bash -s -- \
  --git-url https://github.com/myorg/my-cluster.git \
  --git-branch main \
  --namespace gitops

# Dry-run preview
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/flux_toolkit/flux-install.sh | bash -s -- --dry-run

# Using local script
./scripts/bash/flux_toolkit/flux-install.sh \
  --git-url https://github.com/myorg/my-cluster.git \
  --git-branch main
```

### Manual Installation

#### Step 1: Install Flux CLI

```bash
# Linux / macOS
curl -sL https://fluxcd.io/install.sh | sudo bash

# Or download binary directly
VERSION="2.4.0"
ARCH=$(uname -m)
case "$ARCH" in
  x86_64|amd64) ARCH="amd64" ;;
  aarch64|arm64) ARCH="arm64" ;;
esac
curl -sL "https://github.com/fluxcd/flux2/releases/download/v${VERSION}/flux_${VERSION}_$(uname -s)_${ARCH}.tar.gz" | tar -xzf - -C /tmp
sudo mv /tmp/flux /usr/local/bin/flux

# Verify
flux --version
```

#### Step 2: Bootstrap Flux

```bash
# Export GitHub token with repo permissions
export GITHUB_TOKEN=<your-token>

# Bootstrap with GitHub
flux bootstrap github \
  --owner=myorg \
  --repository=my-cluster \
  --branch=main \
  --path=./clusters/production \
  --personal
```

#### Step 3: Verify Installation

```bash
# Check Flux components
kubectl -n flux-system get pods

# Expected output:
# NAME                                       READY   STATUS    RESTARTS   AGE
# helm-controller-5c8f7f9c8d-xl2v9           1/1     Running   0          2m
# kustomize-controller-6d9c8b9c8-xl2v9       1/1     Running   0          2m
# notification-controller-7c9f7c9c8-xl2v9    1/1     Running   0          2m
# source-controller-8d9f7c9c8-xl2v9          1/1     Running   0          2m

# Verify CRDs
kubectl get crds | grep -E "(kustomization|helmrelease|gitrepository|helmrepository)"
```

## Configuration

### Git Repository Setup

```bash
# Create repository structure
mkdir -p clusters/production
mkdir -p apps

# Create kustomization.yaml for cluster
cat > clusters/production/kustomization.yaml <<EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - flux-system
  - apps
EOF

# Commit and push
git add .
git commit -m "Add cluster configuration"
git push origin main
```

### GitRepository Source Configuration

```bash
# Create Git repository source
flux create source git my-repo \
  --url=https://github.com/myorg/my-cluster \
  --branch=main \
  --interval=1m \
  --export > sources.yaml

# Apply configuration
kubectl apply -f sources.yaml
```

### Kustomization Reconciliation

```bash
# Create kustomization for application
flux create kustomization my-app \
  --source=GitRepository/my-repo \
  --path="./apps/my-app" \
  --prune=true \
  --interval=10m \
  --export > my-app-kustomization.yaml

# Apply configuration
kubectl apply -f my-app-kustomization.yaml
```

### Helm Release Configuration

```bash
# Add Helm repository
flux create source helm bitnami \
  --url=https://charts.bitnami.com/bitnami \
  --interval=1h

# Create Helm release
flux create helmrelease nginx \
  --source=HelmRepository/bitnami \
  --chart=nginx \
  --version="13.x" \
  --target-namespace=default \
  --create-target-namespace \
  --interval=10m \
  --export > nginx-release.yaml

# Apply configuration
kubectl apply -f nginx-release.yaml
```

### Multi-Environment Setup

```bash
# Production cluster kustomization
cat > clusters/production/kustomization.yaml <<EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - flux-system
  - ../../base
  - ../../apps/production
patches:
  - patch: |
      - op: replace
        path: /spec/inSync
        value: true
    target:
      kind: Kustomization
EOF

# Staging cluster kustomization
cat > clusters/staging/kustomization.yaml <<EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - flux-system
  - ../../base
  - ../../apps/staging
patches:
  - patch: |
      - op: replace
        path: /spec/inSync
        value: false
    target:
      kind: Kustomization
EOF
```

## Pipeline Templates

### GitOps Repository Structure

```
clusters/
├── production/
│   ├── flux-system/           # Bootstrap-generated
│   ├── apps.yaml              # Applications kustomization
│   └── infrastructure.yaml    # Infrastructure components
├── staging/
│   ├── flux-system/
│   ├── apps.yaml
│   └── infrastructure.yaml
├── base/
│   ├── apps/                  # Shared application manifests
│   └── infrastructure/        # Shared infrastructure manifests
└── dev/
    ├── flux-system/
    └── apps.yaml
```

### Application Kustomization Template

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: my-app
  namespace: flux-system
spec:
  interval: 10m0s
  path: ./apps/production/my-app
  prune: true
  sourceRef:
    kind: GitRepository
    name: my-repo
  postBuild:
    substituteFrom:
      - kind: ConfigMap
        name: cluster-settings
  patches:
    - patch: |
        - op: replace
          path: /spec/replicas
          value: 3
      target:
        kind: Deployment
        name: my-app
  validation: client
  timeout: 5m
```

### Helm Release Template

```yaml
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: nginx-ingress
  namespace: networking
spec:
  interval: 10m
  chart:
    spec:
      chart: nginx-ingress-controller
      version: "13.x"
      sourceRef:
        kind: HelmRepository
        name: bitnami
      interval: 1h
  values:
    service:
      type: LoadBalancer
    replicaCount: 2
    resources:
      limits:
        cpu: 200m
        memory: 256Mi
      requests:
        cpu: 100m
        memory: 128Mi
```

### Notification Configuration

```yaml
apiVersion: notification.toolkit.fluxcd.io/v1beta3
kind: Provider
metadata:
  name: slack
  namespace: flux-system
spec:
  type: slack
  channel: '#gitops-alerts'
  secretRef:
    name: slack-webhook

---
apiVersion: notification.toolkit.fluxcd.io/v1beta3
kind: Alert
metadata:
  name: git-sync-failed
  namespace: flux-system
spec:
  providerRef:
    name: slack
  eventSeverity: error
  eventSources:
    - kind: Kustomization
      name: '*'
    - kind: HelmRelease
      name: '*'
  exclusionList:
    - exact: 'dependencies'
    - exact: 'depends on'
```

### Helm Repository Template

```yaml
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: bitnami
  namespace: flux-system
spec:
  interval: 1h
  url: https://charts.bitnami.com/bitnami
  timeout: 60s
```

### OCIRepository Source

```yaml
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: OCIRepository
metadata:
  name: my-app
  namespace: flux-system
spec:
  interval: 1h
  url: oci://ghcr.io/myorg/charts/my-app
  ref:
    semver: "1.x"
  timeout: 60s
```

## Using the CLI

```bash
# List all Flux resources
flux get all -A

# List Git repositories
flux get sources git

# List Helm repositories
flux get sources helm

# List Kustomizations
flux get kustomizations

# List Helm releases
flux get helmreleases -A

# Reconcile a specific resource
flux reconcile kustomization my-app

# Suspend reconciliation
flux suspend kustomization my-app

# Resume reconciliation
flux resume kustomization my-app

# Delete a Kustomization
flux delete kustomization my-app

# Export current configuration
flux export kustomization my-app > my-app.yaml
```

## Verification

### Check Flux Components

```bash
# Verify all controllers are running
kubectl -n flux-system get pods

# Verify CRDs are installed
kubectl get crds | grep -E "(kustomization|helmrelease|gitrepository|ocirepository)"

# Check controller logs
kubectl -n flux-system logs -l app=source-controller --tail=100
kubectl -n flux-system logs -l app=kustomize-controller --tail=100
kubectl -n flux-system logs -l app=helm-controller --tail=100
```

### Test Reconciliation

```bash
# Create test deployment
cat > test-deployment.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: test
  template:
    metadata:
      labels:
        app: test
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
EOF

# Add to Git repository
git add test-deployment.yaml
git commit -m "Add test deployment"
git push origin main

# Wait for reconciliation (check interval)
sleep 60

# Verify deployment was created
kubectl -n default get deployments
```

### Check Synchronization Status

```bash
# Check specific kustomization status
flux get kustomizations my-app

# Output example:
# NAME      READY   MESSAGE                         REVISION                                        SUSPENDED
# my-app    True    Applied revision: main/abc123   main/abc123                                     False

# Check Helm release status
flux get helmreleases -n default nginx

# Check Git repository status
flux get sources git my-repo
```

## Rollback

### Uninstall Flux

```bash
# Using Flux CLI
flux uninstall -n flux-system

# Using kubectl (manual)
kubectl delete namespace flux-system

# Clean up CRDs (if needed)
kubectl delete crd \
  kustomizations.kustomize.toolkit.fluxcd.io \
  helmreleases.helm.toolkit.fluxcd.io \
  gitrepositories.source.toolkit.fluxcd.io \
  helmrepositories.source.toolkit.fluxcd.io \
  ocirepositories.source.toolkit.fluxcd.io \
  providers.notification.toolkit.fluxcd.io \
  alerts.notification.toolkit.fluxcd.io
```

### Suspend Reconciliation

```bash
# Suspend all kustomizations
flux suspend kustomization --all

# Suspend all helm releases
flux suspend helmrelease --all

# Resume when ready
flux resume kustomization --all
flux resume helmrelease --all
```

### Revert to Previous Revision

```bash
# Find revision history
git log --oneline

# Revert to specific commit
git revert <commit-hash>
git push origin main

# Flux will reconcile to the reverted state
```

## Common Errors

**"GitRepository URL not accessible"**
- Verify repository URL is correct
- Check token/credentials have access
- Ensure repository is not private without auth
- Verify network connectivity from cluster

**"Kustomization reconciliation failed"**
- Check manifest syntax: `kubectl apply --dry-run=client -f manifest.yaml`
- Verify source reference exists
- Check namespace exists for target resources
- Review controller logs for specific error

**"Helm release failed"**
- Check Helm chart exists and version is valid
- Verify values are correctly formatted
- Ensure target namespace exists
- Check Helm repository is accessible

**"Source controller timeout"**
- Increase timeout in GitRepository spec
- Check network connectivity to Git server
- Verify Git credentials are correct
- Consider using SSH instead of HTTPS

**"Drift detection not working"**
- Ensure prune: true is set on kustomization
- Check validation settings
- Verify cluster has write permissions to resources

## Troubleshooting

### Debug Reconciliation Issues

```bash
# Check kustomization status
flux get kustomizations my-app -o yaml

# View controller events
kubectl -n flux-system get events --field-selector involvedObject.kind=Kustomization,involvedObject.name=my-app

# Check source status
flux get sources git my-repo -o yaml

# View detailed logs
kubectl -n flux-system logs -l app=kustomize-controller --since=1h
```

### Network Connectivity Issues

```bash
# Test Git connectivity from cluster
kubectl run debug --image=curlimages/curl --rm -it -- sh

# Inside pod:
apk add git
git ls-remote https://github.com/myorg/my-repo.git

# Test proxy settings (if applicable)
env | grep -i proxy
```

### Permission Issues

```bash
# Check service account permissions
kubectl -n flux-system get sa

# View role bindings
kubectl -n flux-system get roles,rolebindings

# Test token (if using impersonation)
kubectl auth can-i get pods --as=system:serviceaccount:flux-system:kustomize-controller
```

## Security Considerations

- Use deploy keys or machine users for repository access (not personal tokens)
- Enable branch protection rules in Git repository
- Use signed commits for production environments
- Implement policy-as-code with tools like Kyverno
- Restrict RBAC permissions for Flux controllers
- Use sealed secrets or external secrets for sensitive data
- Enable audit logging for Flux controller actions
- Regularly rotate Git tokens and credentials
- Use network policies to restrict controller egress

## References

- [Flux CD Documentation](https://fluxcd.io/docs/)
- [Flux v2 GitHub](https://github.com/fluxcd/flux2)
- [GitOps Toolkit](https://github.com/fluxcd/toolkit)
- [Flux Monitoring](https://fluxcd.io/docs/installation/#monitoring)
- DevOps-Kit CI/CD Toolkit: `docs/how-to/ci_cd_toolkit.md`