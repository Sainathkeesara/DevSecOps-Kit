# Google Artifact Registry (GAR) Installation for GKE Integration

---
SQUIRREL:
  title: "Google Artifact Registry (GAR) Installation for GKE Integration"
  category: "oci-registry"
  tags: ["gcp", "google-artifact-registry", "gar", "gke", "docker", "container-registry", "artifact-management", "ci-cd"]
  last_verified: "2026-05-12"
  version: "GAR v2"
---

## Purpose

Deploy and configure Google Artifact Registry (GAR) for storing and managing container images, Helm charts, and language artifacts. This guide covers GAR creation via Google Cloud CLI (gcloud), repository configuration, authentication setup for GKE clusters, VPC Service Controls, and artifact lifecycle management.

## When to use

- Storing Docker container images for Google Kubernetes Engine (GKE) workloads
- Managing Helm chart repositories with version control and access policies
- Implementing artifact management for multi-language environments (Go, Java, Python, npm)
- Setting up private artifact registries with fine-grained IAM access control
- Integrating with Cloud Build and Cloud Run for CI/CD pipelines
- Configuring artifact replication across regions for disaster recovery
- Meeting compliance requirements with VPC Service Controls and Binary Authorization

## Prerequisites

- Google Cloud Platform account with project owner or artifact registry admin role
- Google Cloud SDK installed (version 400.0.0 or later): `gcloud --version`
- Docker installed locally for image push/pull operations
- kubectl installed for GKE cluster operations (optional)
- Project with billing enabled
- APIs enabled: `artifactregistry.googleapis.com`, `container.googleapis.com`
- For VPC Service Controls: Organization-level access with VPC SC perimeter configured

## Steps

### Step 1: Install Google Cloud SDK and authenticate

If Google Cloud SDK is not installed:

```bash
# Ubuntu/Debian
curl https://sdk.cloud.google.com | bash
exec -l $SHELL

# macOS
brew install google-cloud-sdk

# Verify installation
gcloud --version
```

Authenticate to Google Cloud:

```bash
# Interactive login
gcloud auth login

# Or using a service account for automation
gcloud auth activate-service-account --account=sa-name@project.iam.gserviceaccount.com --key-file=key.json

# Set default project
gcloud config set project my-project-id

# Verify authentication
gcloud auth list
```

### Step 2: Enable required APIs

```bash
# Enable Artifact Registry API
gcloud services enable artifactregistry.googleapis.com

# Enable Kubernetes Engine API (for GKE integration)
gcloud services enable container.googleapis.com

# Enable Cloud Build API (for CI/CD integration)
gcloud services enable cloudbuild.googleapis.com

# Verify APIs are enabled
gcloud services list --enabled --filter="artifactregistry"
```

### Step 3: Create Artifact Registry repository

```bash
# Define variables
PROJECT_ID="my-project-id"
LOCATION="us-central1"
REPOSITORY_NAME="docker-repo"
REPOSITORY_FORMAT="docker"
DESCRIPTION="Primary Docker repository for GKE workloads"

# Create standard Docker repository
gcloud artifacts repositories create "$REPOSITORY_NAME" \
  --location="$LOCATION" \
  --repository-format="$REPOSITORY_FORMAT" \
  --description="$DESCRIPTION"

# Verify repository creation
gcloud artifacts repositories describe "$REPOSITORY_NAME" \
  --location="$LOCATION"

# List all repositories
gcloud artifacts repositories list --location="$LOCATION"
```

Create repository with specific configuration:

```bash
# Create with encryption (Google-managed key by default)
gcloud artifacts repositories create "secure-repo" \
  --location="us-central1" \
  --repository-format="docker" \
  --description="Repository with Google-managed encryption" \
  --encryption-key="projects/my-project/locations/us-central1/keyRings/my-keyring/cryptoKeys/my-key"

# Create with labels
gcloud artifacts repositories create "prod-repo" \
  --location="us-east1" \
  --repository-format="docker" \
  --description="Production Docker repository" \
  --labels="environment=production,team=platform"

# Create Maven repository for Java artifacts
gcloud artifacts repositories create "maven-repo" \
  --location="us-central1" \
  --repository-format="maven" \
  --description="Maven artifact repository" \
  --version-policy="release"

# Create npm repository for Node.js artifacts
gcloud artifacts repositories create "npm-repo" \
  --location="us-central1" \
  --repository-format="npm" \
  --description="npm package repository" \
  --version-policy="release"
```

### Step 4: Configure repository permissions (IAM)

```bash
# Grant artifact registry reader to a service account
gcloud artifacts repositories add-iam-policy-binding "$REPOSITORY_NAME" \
  --location="$LOCATION" \
  --member="serviceAccount:sa-name@my-project.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.reader"

# Grant artifact registry writer to CI/CD service account
gcloud artifacts repositories add-iam-policy-binding "$REPOSITORY_NAME" \
  --location="$LOCATION" \
  --member="serviceAccount:cloud-build-sa@my-project.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.writer"

# Grant artifact registry admin for automation
gcloud artifacts repositories add-iam-policy-binding "$REPOSITORY_NAME" \
  --location="$LOCATION" \
  --member="serviceAccount:automation-sa@my-project.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.admin"

# View current IAM policy
gcloud artifacts repositories get-iam-policy "$REPOSITORY_NAME" \
  --location="$LOCATION"
```

### Step 5: Configure authentication for local Docker

```bash
# Configure Docker authentication for Artifact Registry
gcloud auth configure-docker "$LOCATION"-docker.pkg.dev

# This adds the following to ~/.docker/config.json:
# {
#   "credHelpers": {
#     "us-central1-docker.pkg.dev": "gcloud"
#   }
# }

# Verify authentication
docker-credential-gcloud configure-docker

# Test connection
docker info 2>/dev/null | grep -i artifact || echo "Docker info check complete"
```

### Step 6: Push and pull images from GAR

```bash
# Pull a base image
docker pull nginx:1.25

# Tag for GAR
docker tag nginx:1.25 "$LOCATION"-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_NAME/library/nginx:1.25"

# Push to GAR
docker push "$LOCATION"-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_NAME/library/nginx:1.25"

# Pull from GAR
docker pull "$LOCATION"-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_NAME/library/nginx:1.25"

# List repositories
gcloud artifacts repositories list --project="$PROJECT_ID"

# List images in a repository
gcloud artifacts docker images list "$LOCATION"-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_NAME

# List image tags
gcloud artifacts docker tags list "$LOCATION"-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_NAME/library/nginx"
```

### Step 7: GKE cluster integration

Configure GKE clusters to pull images from GAR:

```bash
# Create GKE cluster with Workload Identity (recommended)
gcloud container clusters create "my-cluster" \
  --location="us-central1" \
  --workload-pool="$PROJECT_ID.svc.id.goog" \
  --enable-image-streaming

# Or use standard node pool with service account
gcloud container clusters create "my-cluster" \
  --location="us-central1" \
  --service-account="node-service-account@my-project.iam.gserviceaccount.com"

# Grant GKE service account artifact registry access
gcloud artifacts repositories add-iam-policy-binding "$REPOSITORY_NAME" \
  --location="$LOCATION" \
  --member="serviceAccount:node-service-account@my-project.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.reader"

# Deploy image from GAR to GKE
kubectl create deployment myapp --image="$LOCATION"-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_NAME/myapp:latest"

# Verify deployment
kubectl get pods -l app=myapp
```

### Step 8: Configure Artifact Analysis (Vulnerability scanning)

```bash
# Enable vulnerability scanning on repository
gcloud artifacts repositories update "$REPOSITORY_NAME" \
  --location="$LOCATION" \
  --enable-upstream-policy

# Enable Binary Authorization for GKE
gcloud container clusters update "my-cluster" \
  --location="us-central1" \
  --enable-binauthz

# Create Binary Authorization policy
cat > binauthz-policy.yaml << 'EOF'
defaultAdmissionRule:
  enforcementMode: ENFORCED_BLOCK_AND_AUDIT_LOG
  evaluationMode: REQUIRE_ATTESTATION
  requireAttestationsBy:
    - projects/my-project/attestors/my-attestor
admissionWhitelistPatterns:
  - namePattern: gcr.io/google-containers/*
  - namePattern: k8s.gcr.io/*
  - namePattern: marketplace.gke.io/*
EOF

gcloud binauthz policies import binauthz-policy.yaml \
  --project="$PROJECT_ID"
```

### Step 9: Set up lifecycle policy for cleanup

```bash
# Create lifecycle policy for image retention
cat > lifecycle-policy.json << 'EOF'
{
  "name": "cleanup-old-tags",
  "action": "delete",
  "condition": {
    "tagPattern": "tag-regex",
    "tagRegexes": ["v[0-9]+.*"],
    "olderThan": "30d"
  }
}
EOF

# Apply lifecycle policy
gcloud artifacts repositories set-lifecycle-policy "$REPOSITORY_NAME" \
  --location="$LOCATION" \
  --policy=lifecycle-policy.json

# Or keep only last N versions
cat > retention-policy.json << 'EOF'
{
  "maximumVersions": 10
}
EOF

gcloud artifacts repositories set-lifecycle-policy "$REPOSITORY_NAME" \
  --location="$LOCATION" \
  --policy=retention-policy.json

# View current lifecycle policy
gcloud artifacts repositories describe "$REPOSITORY_NAME" \
  --location="$LOCATION" \
  --format=yaml
```

### Step 10: Configure VPC Service Controls (optional security)

```bash
# Create a service perimeter (requires Organization-level access)
gcloud vpc-sc perimeters create "artifact-registry-perimeter" \
  --projects="$PROJECT_ID" \
  --resources="projects/$PROJECT_ID" \
  --service="artifactregistry.googleapis.com"

# Add repository to perimeter
gcloud vpc-sc perimeters update "artifact-registry-perimeter" \
  --add-resources="projects/$PROJECT_ID/locations/$LOCATION/repositories/$REPOSITORY_NAME"

# Configure ingress policies
gcloud vpc-sc ingress-policies create "allow-from-gke" \
  --src-resources="projects/$PROJECT_ID" \
  --src-service-methods="artifactregistry.googleapis.com" \
  --from-source-identities="service-accounts/*@container.googleapis.com"
```

### Step 11: CI/CD integration with Cloud Build

```bash
# Create Cloud Build trigger for container builds
gcloud builds triggers create github \
  --repo-name="my-repo" \
  --repo-owner="my-org" \
  --branch-pattern="^main$" \
  --build-config="cloudbuild.yaml" \
  -- substitutions="_REGION=$LOCATION,_PROJECT=$PROJECT_ID,_REPO=$REPOSITORY_NAME"

# Example cloudbuild.yaml
cat > cloudbuild.yaml << 'EOF'
steps:
  - name: 'gcr.io/cloud-builders/docker'
    args:
      - 'build'
      - '-t'
      - '$_REGION-docker.pkg.dev/$_PROJECT/$_REPO/app:$COMMIT_SHA'
      - '.'
  - name: 'gcr.io/cloud-builders/docker'
    args:
      - 'push'
      - '$_REGION-docker.pkg.dev/$_PROJECT/$_REPO/app:$COMMIT_SHA'
  - name: 'gcr.io/cloud-builders/gcloud'
    args:
      - 'run'
      - 'deploy'
      - 'myapp'
      - '--image=$_REGION-docker.pkg.dev/$_PROJECT/$_REPO/app:$COMMIT_SHA'
      - '--platform=managed'
      - '--region=$_REGION'
EOF

# Create trigger for Helm chart builds
gcloud builds triggers create github \
  --repo-name="helm-charts" \
  --repo-owner="my-org" \
  --tag-pattern="v*" \
  --build-config="helm.yaml" \
  --substitutions="_REGION=$LOCATION,_PROJECT=$PROJECT_ID"
```

## Verify

1. Check repository status:

```bash
gcloud artifacts repositories describe "$REPOSITORY_NAME" \
  --location="$LOCATION" \
  --format="yaml(name,format,location,createTime,updateTime)"
```

2. Verify Docker authentication:

```bash
# Check Docker config
cat ~/.docker/config.json | jq '.credHelpers'

# Test Docker push
docker push "$LOCATION"-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_NAME/test:latest
docker images | grep "$LOCATION"
```

3. Test GKE deployment:

```bash
# Deploy test image
kubectl run test-app --image="$LOCATION"-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_NAME/test:latest
kubectl get pods -l run=test-app
kubectl logs -l run=test-app

# Verify image pull from GAR
kubectl describe pod test-app-xxx | grep "pulling"
```

4. Check vulnerability scanning results:

```bash
gcloud artifacts docker images list "$LOCATION"-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_NAME" --include-tags

# View vulnerability report
gcloud artifacts docker images describe "$LOCATION"-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_NAME/app:latest" \
  --include-lifecycle-policy
```

## Rollback

### Remove repository:

```bash
# Delete repository (with all images)
gcloud artifacts repositories delete "$REPOSITORY_NAME" \
  --location="$LOCATION" \
  --async

# Verify deletion
gcloud artifacts repositories describe "$REPOSITORY_NAME" \
  --location="$LOCATION" 2>/dev/null || echo "Repository deleted"
```

### Restore from backup:

GAR does not support native backup/restore. For disaster recovery:

- Replicate artifacts to a secondary region: `gcloud artifacts repositories create repo-name --location=secondary-region --copy-existing`
- Use Artifact Analysis for vulnerability tracking across regions
- Set up Cross-Region Replication for production workloads

### Remove authentication:

```bash
# Remove Docker credential helper
gcloud auth configure-docker "$LOCATION"-docker.pkg.dev --remove

# Revoke service account access
gcloud artifacts repositories remove-iam-policy-binding "$REPOSITORY_NAME" \
  --location="$LOCATION" \
  --member="serviceAccount:sa-name@project.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.reader"
```

## Common Errors

### Error: API has not been used in project

**Symptom:** `API has not been used in project xxx`

**Solution:** Enable the Artifact Registry API:

```bash
gcloud services enable artifactregistry.googleapis.com
```

### Error: Permission denied for artifact registry

**Symptom:** `ERROR: (gcloud.artifacts.docker.builds) PERMISSION_DENIED`

**Solution:**
- Verify service account has `roles/artifactregistry.writer` role
- Check if using Workload Identity with correct annotations
- Ensure Cloud Build service account has access to the repository

### Error: Docker authentication failed

**Symptom:** `unauthorized: authentication required`

**Solution:**
- Run `gcloud auth configure-docker us-central1-docker.pkg.dev`
- Verify Docker version is 19.03 or later
- Check that credential helper is properly configured

### Error: Repository location conflict

**Symptom:** `ALREADY_EXISTS: Resource already exists in the project`

**Solution:**
- Use different repository name: `gcloud artifacts repositories create new-repo --location=us-central1`
- Or delete existing repository first

### Error: VPC Service Controls blocked request

**Symptom:** `Request blocked by VPC Service Controls`

**Solution:**
- Add source project/VM to the service perimeter
- Configure ingress/egress policies for the perimeter
- Use Private Google Access for VPC-connected resources

### Error: Image exceeds size limit

**Symptom:** `RESOURCE_EXHAUSTED: image size exceeds maximum limit`

**Solution:**
- Optimize Docker image by using multi-stage builds
- Split large images into multiple layers
- Use base images with Alpine or distroless

## References

- [Google Artifact Registry documentation](https://cloud.google.com/artifact-registry)
- [GAR Docker quickstart](https://cloud.google.com/artifact-registry/docs/docker/quickstart)
- [Configuring authentication for Artifact Registry](https://cloud.google.com/artifact-registry/docs/docker/authentication)
- [GKE image streaming](https://cloud.google.com/kubernetes-engine/docs/how-to/image-streaming)
- [Binary Authorization](https://cloud.google.com/binary-authorization/docs/overview)
- [VPC Service Controls for Artifact Registry](https://cloud.google.com/vpc-service-controls/docs/supported-services#artifact-registry)
- [gcloud artifacts commands](https://cloud.google.com/sdk/gcloud/reference/artifacts)