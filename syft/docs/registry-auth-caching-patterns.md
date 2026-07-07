---
last_verified: 2026-07-06
tool_version: n/a
---

# Syft enterprise registry authentication and caching patterns for high-scale CI

## Purpose

When Syft is integrated into a CI pipeline that scans dozens or hundreds of images per day, two problems dominate: authenticating to private registries without leaking credentials, and avoiding redundant SBOM generation on the same image layers. This doc covers patterns for both, organized from simplest to most scalable.

## When to use

- Your CI pipeline scans images from private registries (ECR, GCR, ACR, Docker Hub private repos, self-hosted registries).
- The same image is scanned across multiple pipeline runs or branches and you want to reuse SBOM output instead of regenerating it.
- You need to authenticate to multiple registries in a single CI job.

## Prerequisites

- Syft installed (any recent version).
- Access to target registry credentials (read-only is sufficient).
- CI runner with network access to the registry and any artifact cache (S3, GCS, or GitHub Actions cache).

## Steps

### 1. Registry credential resolution

Syft reads registry credentials from the Docker CLI configuration file (`~/.docker/config.json`), in the same way as `docker pull`. The resolution order is:

1. `DOCKER_CONFIG` environment variable overrides the config path.
2. Credential helpers registered in `config.json` (e.g. `ecr-login`, `gcloud auth configure-docker`).
3. Base64-encoded credentials stored directly under `auths`.

To verify credentials are reachable before running Syft:

```bash
# Check that the Docker config exists and is valid JSON
jq '.auths | keys' ~/.docker/config.json
```

If the registry appears in the output, Syft will use those credentials automatically.

### 2. Non-Docker credential injection

In environments that do not run Docker (e.g. a minimal CI container), you can inject credentials via environment variables that Syft's underlying OCI library recognizes:

**Amazon ECR:**
```bash
aws ecr get-login-password --region us-east-1 \
  | syft registry:my-repo  \
    --source-version latest
```

The ECR credential helper (`docker-credential-ecr-login`) handles token refresh internally. Install it and add the helper entry to `config.json`:

```json
{
  "credHelpers": {
    "<account>.dkr.ecr.<region>.amazonaws.com": "ecr-login"
  }
}
```

**Google Artifact Registry (GAR) / Container Registry (GCR):**
```bash
gcloud auth configure-docker us-central1-docker.pkg.dev
syft us-central1-docker.pkg.dev/my-project/my-repo/my-image:latest
```

**Azure Container Registry (ACR):**
```bash
az acr login --name myregistry
syft myregistry.azurecr.io/my-image:latest
```

**Self-hosted registries with basic auth:**
```bash
export DOCKER_CONFIG=/tmp/.docker
mkdir -p $DOCKER_CONFIG
echo '{"auths":{"https://registry.example.com":{"auth":"'$(echo -n "user:password" | base64)'"}}}' \
  > $DOCKER_CONFIG/config.json
syft registry.example.com/my-image:latest
```

### 3. Multi-registry authentication in a single job

When a pipeline scans images from multiple registry providers, create a consolidated Docker config that registers all credential helpers:

```bash
mkdir -p ~/.docker
cat > ~/.docker/config.json <<'EOF'
{
  "credHelpers": {
    "123456789012.dkr.ecr.us-east-1.amazonaws.com": "ecr-login",
    "us-central1-docker.pkg.dev": "gcloud",
    "myregistry.azurecr.io": "acr"
  }
}
EOF
# Authenticate each helper
aws ecr get-login-password --region us-east-1 | docker login \
  --username AWS --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com
az acr login --name myregistry
```

Now `syft` can resolve credentials for any of the three registries in the same invocation.

### 4. SBOM result caching

Regenerating an SBOM on every CI run for an unchanged image is wasteful. Cache the Syft output keyed by the image digest (not the tag — tags move, digests are immutable).

**GitHub Actions cache:**
```yaml
- name: Resolve image digest
  id: digest
  run: |
    DIGEST=$(skopeo inspect docker://my-image:latest \
      --format '{{.Digest}}' 2>/dev/null || echo "unknown")
    echo "digest=$DIGEST" >> $GITHUB_OUTPUT

- name: Cache Syft SBOM
  uses: actions/cache@v4
  with:
    path: sbom.json
    key: syft-sbom-${{ steps.digest.outputs.digest }}

- name: Generate SBOM (if not cached)
  if: steps.cache.outputs.cache-hit != 'true'
  run: |
    syft my-image:latest -o cyclonedx-json > sbom.json
```

**S3/GCS cache (shell wrapper):**
```bash
#!/usr/bin/env bash
set -euo pipefail

IMAGE="$1"
FORMAT="${2:-cyclonedx-json}"
CACHE_BUCKET="s3://my-sbom-cache"
DIGEST=$(skopeo inspect "docker://$IMAGE" --format '{{.Digest}}' 2>/dev/null || echo "unknown")
CACHE_KEY="$CACHE_BUCKET/syft/$(echo "$DIGEST" | tr ':' '/')/sbom.json"

if aws s3 cp "$CACHE_KEY" sbom.json 2>/dev/null; then
  echo "SBOM cache hit for $IMAGE ($DIGEST)"
else
  echo "SBOM cache miss for $IMAGE ($DIGEST) — generating..."
  syft "$IMAGE" -o "$FORMAT" > sbom.json
  aws s3 cp sbom.json "$CACHE_KEY"
fi
```

### 5. Layer-aware caching strategy

For mutable tags (e.g. `latest`), comparing image digests misses the opportunity to reuse SBOMs for unchanged layers. Use Syft's own layer-awareness:

```bash
#!/usr/bin/env bash
syft my-image:latest -o cyclonedx-json \
  | jq 'reduce .components[]? as $c ({}; .[$c.purl] = $c.version)' \
  > current-manifest.json
```

Store this manifest keyed by `image-name:tag` and compare hashes on subsequent runs. If the manifest content matches, skip Syft entirely.

## Verify

1. Run `syft` against a private image without Docker configured and confirm it fails with an authentication error.
2. Configure the credential helper, re-run, and confirm the scan succeeds.
3. Trigger two CI runs on the same image digest — the second run should use the cached SBOM.
4. For multi-registry setup, scan one image from each registry in sequence and confirm all resolve.

## Common errors

| Error | Likely cause | Fix |
|-------|-------------|------|
| `authentication required` | No credentials or wrong registry URL | Check `config.json` registry URL format; verify credential helper is installed |
| `no child manifests` | Not a valid OCI image reference or registry path | Use full registry URL (e.g. `123456789012.dkr.ecr.us-east-1.amazonaws.com/my-repo:tag`) |
| `credential helper not found` | Docker credential helper binary missing from PATH | Install the helper (e.g. `docker-credential-ecr-login`) and ensure it is on `PATH` |
| `cache key too long` | Image digest exceeds cache key length limits | Hash the digest with `sha256sum` and use the first 20 characters as the cache key |
