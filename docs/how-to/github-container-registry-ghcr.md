# GitHub Container Registry (ghcr.io) Configuration

## Purpose

Configure and use GitHub Container Registry (ghcr.io) for storing, managing, and publishing Docker container images within a GitHub-based workflow. This guide covers authentication, image publishing, access control, and automated build pipelines.

## When to Use

- Publishing container images from GitHub Actions workflows
- Hosting private container images for GitHub organizations
- Integrating container registry with GitHub Packages
- Setting up automated image builds with GitHub Actions
- Managing access control for organization-owned images

## Prerequisites

- GitHub personal account or organization
- GitHub Personal Access Token (PAT) with `write:packages` scope
- Docker installed locally or in CI/CD environment
- GitHub Actions (optional, for automated builds)
- Repository to publish images from

## Steps

### Step 1: Create GitHub Personal Access Token

Create a PAT with appropriate package scopes:

1. Navigate to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click "Generate new token (classic)"
3. Configure scopes:
   - `read:packages` - Read packages
   - `write:packages` - Upload packages
   - `delete:packages` - Delete packages (if needed)
   - `repo` - Full control of private repositories (for workflow access)
4. Set expiration and generate token
5. Copy and store the token securely

### Step 2: Authenticate to ghcr.io

Authenticate using Docker:

```bash
# Using PAT as password
echo "ghp_your_personal_access_token" | docker login ghcr.io -u your_username --password-stdin

# Or interactively
docker login ghcr.io
# Username: your_github_username
# Password: your_personal_access_token
```

For CI/CD environments, use secrets:

```bash
# In GitHub Actions
- name: Login to Container Registry
  uses: docker/login-action@v3
  with:
    registry: ghcr.io
    username: ${{ secrets.GHCR_USERNAME }}
    password: ${{ secrets.GHCR_TOKEN }}
```

### Step 3: Tag and Push Images

Tag your image for ghcr.io:

```bash
# Tag with full registry path
docker tag myimage:latest ghcr.io/username/myimage:latest
docker tag myimage:latest ghcr.io/username/myimage:v1.0.0

# Or for organization images
docker tag myimage:latest ghcr.io/myorg/myimage:latest
```

Push to the registry:

```bash
# Push the image
docker push ghcr.io/username/myimage:latest
docker push ghcr.io/username/myimage:v1.0.0

# Push all tags
docker push --all-tags ghcr.io/username/myimage
```

### Step 4: Configure Access Control

Set visibility and access for your images:

#### Make Image Public

```bash
# Using GitHub CLI
gh api \
  --method PATCH \
  -H "Accept: application/vnd.github+json" \
  /packages/container/username/myimage \
  -f visibility=public
```

#### Configure Organization Access

In GitHub web interface:
1. Navigate to your package page
2. Click "Package settings"
3. Configure "Organization access" - choose which organizations can access
4. Set visibility for teams and individual users

#### Use Access Control YAML

Create `.github/ghcr-access.yml` in your repository:

```yaml
packages:
  - name: myimage
    visibility: private  # private, public, or internal
    access:
      - users: ["@username"]
      - teams: ["@org/team-name"]
      - organizations: ["@other-org"]
```

### Step 5: Set Up GitHub Actions for Automated Builds

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
            type=sha
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

### Step 6: Pull Images from ghcr.io

Pull images using various authentication methods:

```bash
# Using Docker credentials from login
docker pull ghcr.io/username/myimage:latest

# Using PAT programmatically
echo "ghp_token" | docker login ghcr.io -u your_username --password-stin
docker pull ghcr.io/username/myimage:v1.0.0

# In Kubernetes/Containerd using secret
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=your_username \
  --docker-password=your_token \
  --docker-email=your_email@example.com
```

### Step 7: Delete Old Image Versions

Manage image lifecycle:

```bash
# Delete specific version via API
curl -X DELETE \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/packages/container/username/myimage/versions/123"

# Use GitHub CLI
gh api \
  --method DELETE \
  -H "Accept: application/vnd.github+json" \
  /packages/container/username/myimage/versions/123

# List all versions first
gh api \
  -H "Accept: application/vnd.github+json" \
  /packages/container/username/myimage/versions \
  --jq '.[].id'
```

## Verify

```bash
# Verify login succeeded
cat ~/.docker/config.json | jq '.auths["ghcr.io"]'
# Should show non-null auth value

# List your packages
gh api \
  -H "Accept: application/vnd.github+json" \
  /users/username/packages --jq '.[].name'

# Check specific image versions
curl -s \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/users/username/packages/container/myimage/versions" | jq 'length'

# Verify image exists in registry
docker manifest inspect ghcr.io/username/myimage:latest
```

## Rollback

If you need to remove a published image:

```bash
# Remove local tag
docker rmi ghcr.io/username/myimage:latest

# Delete remote version (via API)
VERSION_ID=$(gh api -H "Accept: application/vnd.github+json" \
  /packages/container/username/myimage/versions \
  --jq '.[0].id')
gh api --method DELETE -H "Accept: application/vnd.github+json" \
  /packages/container/username/myimage/versions/$VERSION_ID

# Revoke token if compromised
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
| `manifest unknown` | Tag doesn't exist | Verify the tag exists with `docker manifest inspect` |
| `rate limit exceeded` | Too many requests | Use authenticated requests or wait |
| `image does not exist` | Wrong image path | Check format: `ghcr.io/owner/repo:tag` |

## References

- [GitHub Packages Documentation](https://docs.github.com/en/packages)
- [Container Registry Documentation](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [docker/login-action](https://github.com/docker/login-action)
- [docker/build-push-action](https://github.com/docker/build-push-action)
- [GitHub Actions Workflow Syntax](https://docs.github.com/en/actions/using-workflows)
- [Managing Package Access Control](https://docs.github.com/en/packages/learn-github-packages/configuring-access-control-and-visibility)