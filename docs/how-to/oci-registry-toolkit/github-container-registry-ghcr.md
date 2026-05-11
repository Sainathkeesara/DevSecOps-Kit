# GitHub Container Registry (ghcr.io) Configuration

---
SQUIRREL:
  title: "GitHub Container Registry (ghcr.io) Configuration"
  category: "oci-registry"
  tags: ["github", "container-registry", "ghcr", "docker", "images", "ci-cd", "github-actions", "packages"]
  last_verified: "2026-05-11"
  version: "GHCR v3"
---

## Purpose

This guide provides steps to configure and use GitHub Container Registry (ghcr.io) for storing, managing, and publishing Docker container images within GitHub-based workflows. It covers authentication, image publishing, access control, GitHub Actions integration, and automated build pipelines.

## When to use

- Publishing container images from GitHub Actions workflows
- Hosting private container images for GitHub organizations
- Integrating container registry with GitHub Packages for unified artifact management
- Setting up automated image builds with GitHub Actions
- Managing access control for organization-owned images
- Distributing Helm charts and OCI artifacts via ghcr.io

## Prerequisites

- GitHub account (personal or organization)
- GitHub Personal Access Token (PAT) with appropriate package scopes
- Docker installed locally or in CI/CD environment
- GitHub Actions (optional, for automated builds)
- Repository to publish images from

## Authentication

### Option 1: GitHub Actions (Recommended)

Use the official `docker/login-action` for GitHub Actions workflows:

```yaml
- name: Login to Container Registry
  uses: docker/login-action@v3
  with:
    registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}
```

### Option 2: Personal Access Token (Local Development)

```bash
# Create PAT with scopes: read:packages, write:packages, delete:packages, repo

# Login with PAT
echo "ghp_YOUR_PAT_TOKEN" | docker login ghcr.io -u your_username --password-stdin

# Or interactively
docker login ghcr.io
# Username: your_github_username
# Password: your_personal_access_token

# Verify login
cat ~/.docker/config.json | jq '.auths["ghcr.io"]'
```

### Option 3: Docker Config for CI/CD

```bash
# Create secret for Kubernetes
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=your_username \
  --docker-password=YOUR_PAT_TOKEN \
  --docker-email=your_email@example.com

# Attach to service account
kubectl patch serviceaccount default \
  -p '{"imagePullSecrets":[{"name":"ghcr-secret"}]}'
```

## Building and Publishing Images

### Basic Build and Push

```bash
# Build image
docker build -t myimage:latest .

# Tag for ghcr.io
docker tag myimage:latest ghcr.io/username/myimage:latest
docker tag myimage:latest ghcr.io/username/myimage:v1.0.0

# Push to registry
docker push ghcr.io/username/myimage:latest
docker push ghcr.io/username/myimage:v1.0.0

# Or for organization images
docker tag myimage:latest ghcr.io/myorg/myimage:latest
docker push ghcr.io/myorg/myimage:latest
```

### Multi-Architecture Images

```bash
# Set up Buildx
docker buildx create --use
docker buildx inspect --bootstrap

# Build and push multi-platform image
docker buildx build --platform linux/amd64,linux/arm64 \
  -t ghcr.io/username/myimage:latest \
  --push .
```

### GitHub Actions Workflow

Create `.github/workflows/build-push.yml`:

```yaml
name: Build and Push Container Image

on:
  push:
    branches: [main]
    tags: ['v*']
  pull_request:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Log in to Container Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=sha,prefix=
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: ${{ github.event_name != 'pull_request' }}
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

## Access Control

### Configure Visibility

#### Via GitHub CLI

```bash
# Make image public
gh api \
  --method PATCH \
  -H "Accept: application/vnd.github+json" \
  /packages/container/username/myimage \
  -f visibility=public

# Make image private
gh api \
  --method PATCH \
  -H "Accept: application/vnd.github+json" \
  /packages/container/username/myimage \
  -f visibility=private
```

#### Via Web Interface

1. Navigate to your package page
2. Click **Package settings**
3. Configure organization access settings
4. Set visibility for teams and individual users

### Fine-Grained Access Control

```yaml
# .github/ghcr-access.yml - for automation
packages:
  - name: myimage
    visibility: private
    access:
      - users: ["@username"]
      - teams: ["@org/team-name"]
      - organizations: ["@other-org"]
```

### Organization Access

```yaml
# In organization settings, configure:
# Settings > Packages > Container permissions
# Options: Private, Internal, Public organization packages
```

## Pulling Images

### Standard Pull

```bash
docker pull ghcr.io/username/myimage:latest
```

### Kubernetes Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    spec:
      containers:
        - name: myapp
          image: ghcr.io/username/myimage:latest
      imagePullSecrets:
        - name: ghcr-secret
---
apiVersion: v1
kind: Secret
metadata:
  name: ghcr-secret
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: |
    {"auths":{"ghcr.io":{"auth":"BASE64_ENCODED_CREDS"}}}
```

## Image Lifecycle Management

### Delete Old Versions

```bash
# List all versions
VERSION_IDS=$(gh api \
  -H "Accept: application/vnd.github+json" \
  /packages/container/username/myimage/versions \
  --jq '.[].id')

# Delete specific version
gh api \
  --method DELETE \
  -H "Accept: application/vnd.github+json" \
  /packages/container/username/myimage/versions/12345

# Bulk delete old versions (keep last 10)
gh api \
  -H "Accept: application/vnd.github+json" \
  /packages/container/username/myimage/versions \
  --paginate \
  --jq '.[10:] | .[].id' | while read id; do
    gh api --method DELETE \
      -H "Accept: application/vnd.github+json" \
      /packages/container/username/myimage/versions/$id
  done
```

### Retention Policy Script

```bash
#!/bin/bash
# retention-policy.sh - Keep only last N versions
REPO="username/myimage"
KEEP=10

VERSIONS=$(gh api \
  -H "Accept: application/vnd.github+json" \
  /packages/container/$REPO/versions \
  --paginate --jq '.[].id')

COUNT=0
DELETE_IDS=""
for id in $VERSIONS; do
  COUNT=$((COUNT + 1))
  if [ $COUNT -gt $KEEP ]; then
    DELETE_IDS="$DELETE_IDS $id"
  fi
done

for id in $DELETE_IDS; do
  echo "Deleting version $id..."
  gh api --method DELETE \
    -H "Accept: application/vnd.github+json" \
    /packages/container/$REPO/versions/$id
done
```

## Verification

### Check Authentication

```bash
# Verify login
cat ~/.docker/config.json | jq '.auths["ghcr.io"]'
# Expected: non-null auth value

# Test registry access
docker pull ghcr.io/username/myimage:latest
```

### List Packages

```bash
# List your packages
gh api \
  -H "Accept: application/vnd.github+json" \
  /users/username/packages --jq '.[].name'

# List package versions
gh api \
  -H "Accept: application/vnd.github+json" \
  /packages/container/username/myimage/versions \
  --jq '.[].name, .[].created_at'
```

### Verify Image

```bash
# Check image manifest
docker manifest inspect ghcr.io/username/myimage:latest

# Check image metadata
curl -s \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/packages/container/username/myimage" | jq '.'
```

## Rollback

### Remove Local Tag

```bash
docker rmi ghcr.io/username/myimage:latest
docker rmi ghcr.io/username/myimage:v1.0.0
```

### Delete Remote Version

```bash
# Get latest version ID
VERSION_ID=$(gh api -H "Accept: application/vnd.github+json" \
  /packages/container/username/myimage/versions \
  --jq '.[0].id')

# Delete it
gh api --method DELETE -H "Accept: application/vnd.github+json" \
  /packages/container/username/myimage/versions/$VERSION_ID

# Revoke compromised tokens
# GitHub Settings → Developer settings → Personal access tokens → Revoke
```

## Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `denied: permission denied` | Missing `write:packages` scope | Regenerate PAT with correct scopes |
| `authentication required` | Not logged in | Run `docker login ghcr.io` |
| `invalid username or password` | Wrong credentials | Verify PAT is valid and not expired |
| `no basic auth credentials` | K8s secret not configured | Create registry secret with correct credentials |
| `denied: requested access to resource is denied` | Organization restrictions | Check organization package settings |
| `manifest unknown` | Tag doesn't exist | Verify tag with `docker manifest inspect` |
| `rate limit exceeded` | Too many requests | Use authenticated requests or wait |
| `image does not exist` | Wrong image path | Check format: `ghcr.io/owner/repo:tag` |
| `unauthorized: authentication required` | Expired token | Refresh GITHUB_TOKEN or PAT |

## References

- [GitHub Packages Documentation](https://docs.github.com/en/packages)
- [Container Registry Documentation](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [docker/login-action](https://github.com/docker/login-action)
- [docker/build-push-action](https://github.com/docker/build-push-action)
- [docker/metadata-action](https://github.com/docker/metadata-action)
- [GitHub Actions Workflow Syntax](https://docs.github.com/en/actions/using-workflows)
- [Managing Package Access Control](https://docs.github.com/en/packages/learn-github-packages/configuring-access-control-and-visibility)
- [Container Registry API](https://docs.github.com/en/rest/packages)