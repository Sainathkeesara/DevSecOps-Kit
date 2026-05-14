# Argo Workflows Installation and Pipeline Template Configuration for MLOps Workflows

---

SQUIRREL:
  title: "Argo Workflows Installation and Pipeline Templates"
  category: "ci_cd"
  tags: ["argo", "workflows", "kubernetes", "cicd", "mlops", "installation", "pipeline"]
  last_verified: "2026-05-14"
  version: "v3.5+"
---

## Purpose

This guide covers Argo Workflows installation on Kubernetes and pipeline template configuration for MLOps workflows. Argo Workflows provides Kubernetes-native workflow orchestration with declarative pipeline definitions, artifact management, and integration with containerized machine learning pipelines.

## When to use

- Setting up production-grade workflow orchestration on Kubernetes
- Implementing MLOps pipelines with model training and deployment workflows
- Building CI/CD pipelines with container-native execution
- Running parallel and distributed computational workloads
- Integrating with artifact storage for ML model versioning
- Migrating from legacy workflow engines to cloud-native solutions
- Implementing GitOps-style workflow definitions

## Prerequisites

- Kubernetes cluster (v1.20+) with kubectl configured
- Helm 3.x installed locally or in-cluster
- Storage class configured for artifact persistence
- Namespace creation permissions
- Container registry access for workflow images
- kubectl context configured to target cluster
- 500MB+ available storage for Argo components

## Installation

### Quick Start Installation

```bash
# Install with kubectl (quick method)
curl -sL https://github.com/argoproj/argo-workflows/releases/download/v3.5.8/install.yaml | kubectl apply -f -

# Or install with Helm
helm repo add argo https://argoproj.github.io/argo-helm
helm install argo-workflows argo/argo-workflows -n argo --create-namespace --set ui.enabled=true

# Verify installation
kubectl -n argo get pods
kubectl -n argo get deployments
```

### Automated Installation with DevOps-Kit Script

```bash
# Install with default settings
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/argo_toolkit/argo-workflows-install.sh | bash -s --

# Install with namespace and artifact configuration
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/argo_toolkit/argo-workflows-install.sh | bash -s -- \
  --namespace ml-workflows \
  --artifact-repo s3://my-bucket/artifacts \
  --artifact-s3-bucket my-workflow-artifacts

# Dry-run to preview
curl -sL https://raw.githubusercontent.com/opencode-ai/DevOps-Kit/main/scripts/bash/argo_toolkit/argo-workflows-install.sh | bash -s -- --dry-run
```

### Manual Installation with kubectl

#### Step 1: Create Namespace

```bash
kubectl create namespace argo
```

#### Step 2: Install Argo Workflows

```bash
# Download and apply manifest
curl -sL https://github.com/argoproj/argo-workflows/releases/download/v3.5.8/install.yaml | kubectl apply -n argo -f -
```

#### Step 3: Configure Artifact Storage (Optional)

```bash
# Create artifact repository configuration
kubectl -n argo apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: artifact-repos
  namespace: argo
data:
  default: |
    s3:
      bucket: my-workflow-artifacts
      endpoint: s3.amazonaws.com
      accessKeySecret:
        name: artifact-s3-credentials
        key: accessKey
      secretKeySecret:
        name: artifact-s3-credentials
        key: secretKey
EOF
```

#### Step 4: Create S3 Credentials Secret

```bash
kubectl -n argo create secret generic artifact-s3-credentials \
  --from-literal=accessKey=$AWS_ACCESS_KEY_ID \
  --from-literal=secretKey=$AWS_SECRET_ACCESS_KEY
```

## Configuration

### Namespace Configuration

```bash
# Create dedicated namespace for workflows
kubectl create namespace ml-workflows

# Set resource quotas
kubectl -n ml-workflows apply -f - <<EOF
apiVersion: v1
kind: ResourceQuota
metadata:
  name: workflow-quota
  namespace: ml-workflows
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 8Gi
    limits.cpu: "8"
    limits.memory: 16Gi
    persistentvolumeclaims: "4"
    pods: "20"
EOF
```

### Workflow Controller Configuration

```bash
# Create workflow controller config
kubectl -n argo apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: workflow-controller-configmap
  namespace: argo
data:
  config: |
    executor:
      containerRuntimeExecutor: docker
    persistence:
      archive: true
      archiveTTL: "30d"
    workflowDefaults:
      serviceAccountName: argo-workflows-workflow
EOF
```

### Service Account Configuration

```bash
# Create service account for workflows
kubectl -n argo apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: argo-workflows-workflow
  namespace: argo
imagePullSecrets:
- name: regcred
EOF

# Create role and role binding
kubectl -n argo apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: argo-workflows-role
  namespace: argo
rules:
- apiGroups:
  - ""
  resources:
  - pods
  - pods/exec
  - services
  - configmaps
  - secrets
  verbs:
  - create
  - delete
  - get
  - list
  - watch
  - update
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: argo-workflows-binding
  namespace: argo
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: argo-workflows-role
subjects:
- kind: ServiceAccount
  name: argo-workflows-workflow
  namespace: argo
EOF
```

### Artifact Repository Configuration

```bash
# S3 artifact repository
kubectl -n argo apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: artifact-repos
  namespace: argo
data:
  default: |
    s3:
      bucket: my-ml-artifacts
      endpoint: s3.amazonaws.com
      accessKeySecret:
        name: s3-creds
        key: accessKey
      secretKeySecret:
        name: s3-creds
        key: secretKey
      insecure: false
      region: us-west-2
EOF
```

## Pipeline Templates

### MLOps Training Pipeline Template

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: ml-training-
  namespace: ml-workflows
spec:
  entrypoint: ml-pipeline
  arguments:
    parameters:
    - name: model-image
      value: ml-training:latest
    - name: data-source
      value: s3://my-data-bucket/training/
    - name: output-model
      value: s3://my-model-bucket/models/

  templates:
  - name: ml-pipeline
    dag:
      tasks:
      - name: data-preprocessing
        template: preprocess
        arguments:
          parameters:
          - name: source
            value: "{{workflow.parameters.data-source}}"
      - name: model-training
        dependencies: [data-preprocessing]
        template: train
        arguments:
          parameters:
          - name: data-path
            value: "/tmp/preprocessed-data"
          - name: image
            value: "{{workflow.parameters.model-image}}"
      - name: model-evaluation
        dependencies: [model-training]
        template: evaluate
      - name: model-publish
        dependencies: [model-evaluation]
        template: publish
        arguments:
          parameters:
          - name: model-path
            value: "/tmp/trained-model"
            value: "{{workflow.parameters.output-model}}"

  - name: preprocess
    container:
      image: "{{workflow.parameters.model-image}}"
      command: [python, preprocess.py]
      args: ["--input", "{{inputs.parameters.source}}", "--output", "/tmp/data"]

  - name: train
    container:
      image: "{{inputs.parameters.image}}"
      command: [python, train.py]
      args: ["--data", "{{inputs.parameters.data-path}}", "--epochs", "100"]

  - name: evaluate
    container:
      image: "{{workflow.parameters.model-image}}"
      command: [python, evaluate.py]

  - name: publish
    container:
      image: "{{workflow.parameters.model-image}}"
      command: [python, publish.py]
      args: ["--model", "{{inputs.parameters.model-path}}", "--destination", "{{inputs.parameters.destination}}"]
```

### CI/CD Pipeline Template

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: ci-cd-
  namespace: argo
spec:
  entrypoint: build-and-test
  arguments:
    parameters:
    - name: git-branch
      value: main
    - name: image-name
      value: my-app

  templates:
  - name: build-and-test
    dag:
      tasks:
      - name: checkout
        template: git-checkout
      - name: lint
        dependencies: [checkout]
        template: run-linter
      - name: test
        dependencies: [lint]
        template: run-tests
      - name: build
        dependencies: [test]
        template: build-image
      - name: scan
        dependencies: [build]
        template: security-scan
      - name: deploy
        dependencies: [scan]
        template: deploy-app

  - name: git-checkout
    container:
      image: alpine/git:latest
      command: [sh, -c]
      args: ["git clone https://github.com/myorg/{{workflow.parameters.image-name}}.git src && cd src && git checkout {{workflow.parameters.git-branch}}"]

  - name: run-linter
    container:
      image: python:3.11
      command: [sh, -c]
      args: ["cd src && pip install flake8 && flake8 ."]
      workingDir: /workspace

  - name: run-tests
    container:
      image: python:3.11
      command: [sh, -c]
      args: ["cd src && pip install -r requirements-test.txt && pytest tests/"]

  - name: build-image
    container:
      image: docker:23-dind
      command: [sh, -c]
      args: ["docker build -t {{workflow.parameters.image-name}}:$(date +%s) ."]
      env:
      - name: DOCKER_HOST
        value: tcp://localhost:2375

  - name: security-scan
    container:
      image: aquasec/trivy:latest
      command: [trivy, image, "--exit-code", "1", "--severity", "CRITICAL,HIGH", "{{workflow.parameters.image-name}}"]

  - name: deploy-app
    container:
      image: bitnami/kubectl:latest
      command: [kubectl, apply, "-f", "k8s/"]
      workingDir: /src
```

### Reusable Workflow Template

```yaml
apiVersion: argoproj.io/v1alpha1
kind: WorkflowTemplate
metadata:
  name: ml-training-template
  namespace: ml-workflows
spec:
  entrypoint: training-pipeline
  arguments:
    parameters:
    - name: model-type
      value: "cnn"
    - name: epochs
      value: "50"
    - name: batch-size
      value: "32"

  templates:
  - name: training-pipeline
    steps:
    - - name: preprocess
        template: preprocess-step
    - - name: train
        template: train-step
        arguments:
          parameters:
          - name: model-type
            value: "{{workflow.parameters.model-type}}"
          - name: epochs
            value: "{{workflow.parameters.epochs}}"
    - - name: evaluate
        template: evaluate-step

  - name: preprocess-step
    container:
      image: ml-pipeline:latest
      command: [python, preprocess.py]

  - name: train-step
    container:
      image: ml-pipeline:latest
      command: [python, train.py, "--model", "{{inputs.parameters.model-type}}", "--epochs", "{{inputs.parameters.epochs}}"]
      resources:
        requests:
          memory: "4Gi"
          cpu: "2"
        limits:
          memory: "8Gi"
          cpu: "4"

  - name: evaluate-step
    container:
      image: ml-pipeline:latest
      command: [python, evaluate.py]
```

### Cron Scheduled Workflow

```yaml
apiVersion: argoproj.io/v1alpha1
kind: CronWorkflow
metadata:
  name: daily-model-retrain
  namespace: ml-workflows
spec:
  schedule: "0 2 * * *"  # Run daily at 2 AM
  workflowSpec:
    entrypoint: retrain
    templates:
    - name: retrain
      container:
        image: ml-training:latest
        command: [python, retrain.py]
        args: ["--incremental", "--model-path", "/models/latest"]
    - name: notify
      container:
        image: curlimages/curl:latest
        command: [curl, "-X", "POST", "{{workflow.parameters.slack-webhook}}", "-d", "text=Training complete"]
```

## Using the CLI

```bash
# Submit a workflow
kubectl -n argo apply -f my-workflow.yaml

# Submit from local file
argo submit my-workflow.yaml -n ml-workflows

# List workflows
argo list -n ml-workflows

# Watch workflow execution
argo watch my-workflow-123

# Get workflow logs
argo logs my-workflow-123

# Resume a suspended workflow
argo resume my-workflow-123

# Retry failed workflow
argo retry my-workflow-123

# Delete completed workflow
argo delete my-workflow-123
```

## Verification

### Check Argo Workflows Components

```bash
# Verify pods are running
kubectl -n argo get pods

# Expected output:
# NAME                                                  READY   STATUS    RESTARTS   AGE
# argo-workflows-server-7d7c8b9b8-xl2v9                 1/1     Running   0          5m
# workflow-controller-5b8c6c9c79-9xk2n                  1/1     Running   0          5m

# Verify services
kubectl -n argo get svc

# Verify CRDs installed
kubectl get crds | grep argo

# Expected output:
# workflows.argoproj.io
# workflowtemplates.argoproj.io
# cronworkflows.argoproj.io
```

### Submit Test Workflow

```bash
# Submit hello-world workflow
kubectl -n argo apply -f - <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  name: hello-world
  namespace: argo
spec:
  entrypoint: main
  templates:
  - name: main
    container:
      image: docker/whalesay:latest
      command: [cowsay]
      args: ["hello world"]
EOF

# Check workflow status
argo -n argo list
argo -n argo get hello-world

# View logs
argo -n argo logs hello-world
```

### Access Argo UI

```bash
# Port forward to access UI locally
kubectl -n argo port-forward svc/argo-workflows-server 2746:2746

# Then open https://localhost:2746 in browser
```

## Rollback

### Uninstall Argo Workflows

```bash
# Using install manifest
kubectl delete -n argo -f https://github.com/argoproj/argo-workflows/releases/download/v3.5.8/install.yaml

# Using Helm
helm uninstall argo-workflows -n argo

# Remove namespace
kubectl delete namespace argo
```

### Downgrade Version

```bash
# List available versions
helm search repo argo/argo-workflows --versions

# Install specific version
helm install argo-workflows argo/argo-workflows -n argo --version 3.4.5
```

### Remove Custom Resources

```bash
# Delete all workflows
kubectl -n argo delete workflows --all

# Delete workflow templates
kubectl -n argo delete workflowtemplates --all

# Delete cron workflows
kubectl -n argo delete cronworkflows --all
```

## Common Errors

**"WorkflowController is not ready"**
- Check if all pods are running: `kubectl -n argo get pods`
- Check controller logs: `kubectl -n argo logs deployment/workflow-controller`
- Verify RBAC permissions are correct

**"Failed to create workflow: forbidden"**
- Ensure ServiceAccount has correct RBAC permissions
- Check namespace exists and has resource quota
- Verify workflow CR definition is valid

**"Artifact not found" or "S3 access denied"**
- Check artifact repository configuration
- Verify S3 credentials secret exists and is correct
- Ensure IAM permissions for S3 bucket access

**"Image pull back off"**
- Verify image exists in registry
- Check image pull secrets are configured
- Confirm registry authentication is correct

**"Workflow stuck in Running state"**
- Check pod status: `kubectl -n argo describe pod <pod-name>`
- View pod logs: `kubectl -n argo logs <pod-name>`
- Check resource constraints: `kubectl -n argo top pods`

**"UI not accessible"**
- Verify server pod is running: `kubectl -n argo get pods -l app=argo-workflows-server`
- Check service: `kubectl -n argo get svc argo-workflows-server`
- Port-forward command: `kubectl -n argo port-forward svc/argo-workflows-server 2746:2746`

## Troubleshooting

### Debug Workflow Execution

```bash
# Check workflow status
argo -n ml-workflows get my-workflow-123

# View detailed status
kubectl -n ml-workflows describe workflow my-workflow-123

# Check individual pod status
kubectl -n ml-workflows get pods -l workflows.argoproj.io/workflow=my-workflow-123

# View workflow YAML
kubectl -n ml-workflows get workflow my-workflow-123 -o yaml
```

### Workflow Controller Issues

```bash
# Check controller logs
kubectl -n argo logs deployment/workflow-controller --follow

# Check controller config
kubectl -n argo get cm workflow-controller-configmap -o yaml

# Restart controller if needed
kubectl -n argo rollout restart deployment/workflow-controller
```

### RBAC Debugging

```bash
# Check service account
kubectl -n argo get sa argo-workflows-workflow -o yaml

# Check role bindings
kubectl -n argo get roles,rolebindings

# Test permissions
kubectl -n argo auth can-i create pods --as=system:serviceaccount:argo:argo-workflows-workflow
```

## Security Considerations

- Use dedicated service accounts with minimal permissions
- Configure network policies to restrict pod communication
- Enable artifact encryption for sensitive data
- Implement resource quotas to prevent DoS
- Use sealed secrets or external secrets for credentials
- Enable audit logging for workflow execution
- Restrict kubectl access to authorized users only
- Regularly update Argo Workflows to latest stable version

## References

- [Argo Workflows Documentation](https://argoproj.github.io/argo-workflows/)
- [Argo Workflows GitHub](https://github.com/argoproj/argo-workflows)
- [Kubernetes Workflow Patterns](https://kubernetes.io/docs/concepts/extend-kubernetes/)
- DevOps-Kit CI/CD Toolkit: `docs/how-to/ci_cd_toolkit.md`