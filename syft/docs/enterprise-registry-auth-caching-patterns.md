---
last_verified: 2026-07-06
tool_version: n/a
---

# Syft enterprise registry authentication and caching patterns

Reference guide for running Syft at scale in CI environments — covering authentication to private registries, cache management for fast repeat scans, and configuration patterns that keep SBOM generation predictable across teams.

## Purpose

When Syft scans a container image, it first pulls the image from a registry. In enterprise CI, those images live in private registries (ECR, GAR, ACR, Harbor, self-hosted Docker Registry) that require authentication. Without configurable auth, every scan attempt hits a `403` or `denied` error and the pipeline fails before generating a single SBOM.

Once auth works, the second bottleneck is performance. Scanning the same image across multiple CI jobs or re-scanning a base image that hasn't changed wastes build time. A caching strategy for Syft's package catalog cache cuts redundant work and keeps scan times under 10 seconds for cached images.

## When to use

Use these patterns when:

- Images are stored in a private or authenticated registry (ECR with IAM roles, GAR with service accounts, Harbor with robot accounts, or any registry behind basic auth).
- CI pipelines rebuild or re-deploy the same base image across multiple jobs in a short window.
- Teams share a common set of approved base images and want to centralise SBOM generation.
- Multi-architecture images need scanning — Syft resolves manifests differently depending on registry auth.

## Prerequisites

- Syft binary installed (download from GitHub releases or install via `brew`, `apt`, or container image).
- Network access to the target container registry from the CI runner.
- Valid credentials for the registry — Docker config file (`~/.docker/config.json`), environment variables, or cloud-provider IAM roles.

## Steps

### 1. Configure registry authentication

Syft resolves registry credentials in the following order (first match wins):

| Method | How Syft discovers it | Best for |
|---|---|---|
| Docker config | Reads `~/.docker/config.json` (or `DOCKER_CONFIG` env var) | CI runners with Docker-in-Docker or pre-configured Docker auth |
| Explicit registry flags | `--registry-auth-*` flags passed at scan time | Ephemeral runners where Docker config is not available |
| Environment variables | `SYFT_REGISTRY_AUTH_*` prefixed env vars | Kubernetes-native CI (Tekton, BuildKit) without filesystem persistence |

#### Docker config auth (recommended for compatibility)

If the CI runner already authenticates to the registry for `docker pull`, Syft reads the same credentials:

```bash
docker login myregistry.example.com -u "$USERNAME" -p "$TOKEN"
syft myregistry.example.com/team/app:latest
```

Set the `DOCKER_CONFIG` environment variable to point at a non-standard location when the config file lives outside `~/.docker/`:

```bash
export DOCKER_CONFIG=/etc/docker-auth
syft myregistry.example.com/team/app:latest
```

#### Explicit registry flags

Use these when the Docker config file is absent or you want per-registry credentials independent of the Docker daemon:

```bash
syft registry:myregistry.example.com/team/app:latest \
  --registry-auth-address myregistry.example.com \
  --registry-auth-username "$REGISTRY_USER" \
  --registry-auth-password "$REGISTRY_PASSWORD" \
  --registry-auth-insecure-skip-tls-verify false
```

The `registry:` scheme tells Syft to pull directly from the registry without consulting a local Docker daemon. This is the preferred source for CI because it does not require Docker-in-Docker.

#### Environment variables

For Kubernetes-native CI engines where injecting files is awkward, set per-registry auth via environment variables:

```bash
export SYFT_REGISTRY_AUTH_ADDRESS=myregistry.example.com
export SYFT_REGISTRY_AUTH_USERNAME="$REGISTRY_USER"
export SYFT_REGISTRY_AUTH_PASSWORD="$REGISTRY_PASSWORD"
syft registry:myregistry.example.com/team/app:latest
```

### 2. Choose the image source for CI

Syft supports four image source schemes. For enterprise CI, `registry:` is the most reliable because it does not depend on a local container runtime:

| Scheme | Command example | Requires Docker daemon | Best for |
|---|---|---|---|
| `docker:` | `syft docker:alpine:latest` | Yes | Local dev, pre-pull patterns |
| `registry:` | `syft registry:alpine:latest` | No | CI, ephemeral runners |
| `docker-archive:` | `syft docker-archive:/tmp/img.tar` | No | Offline scanning, artifact pipelines |
| `oci-dir:` | `syft oci-dir:/tmp/oci-image` | No | OCI layout bundles |

For CI, standardise on `registry:` and use the `--registry-auth-*` flags from step 1.

### 3. Enable and tune the package catalog cache

Syft caches package-catalog results per image digest. When the same image is scanned again (same digest, same catalogers), the cache is hit and the scan completes in seconds instead of pulling and cataloging from scratch.

The cache lives at `~/.cache/syft` by default. Override with `SYFT_CACHE_DIR`:

```bash
export SYFT_CACHE_DIR=/tmp/syft-cache
syft registry:alpine:latest
```

#### Cache key behaviour

- Cache key is the image digest (`sha256:...`) combined with the set of enabled catalogers.
- A new image tag that points at the same digest hits the cache.
- Changing catalogers (adding or removing entries in `.syft.yaml`) invalidates the cache even for the same digest.

#### CI cache persistence

Share the cache directory across CI runs using the platform's cache action:

```yaml
# GitHub Actions example
- uses: actions/cache@v4
  with:
    path: ~/.cache/syft
    key: syft-cache-${{ hashFiles('**/.syft.yaml') }}-${{ github.sha }}
    restore-keys: |
      syft-cache-${{ hashFiles('**/.syft.yaml') }}-
      syft-cache-
```

The hash of `.syft.yaml` in the key ensures cataloger changes invalidate the cache. The fallback `restore-keys` lets jobs reuse the most recent cache even on a cache miss for the exact key.

### 4. Configure `.syft.yaml` for enterprise CI

Centralise scan settings in a repo-level `.syft.yaml` so every CI job uses the same catalogers, exclusions, and output preferences:

```yaml
# Cataloger selection — limit to ecosystems actually in use
catalogers:
  - python-package
  - javascript-package
  - go-module
  - java-pom
  - dpkg
  - rpm
  - apk

# Exclude known uninteresting paths
exclude:
  - "**/node_modules/**"
  - "**/__pycache__/**"
  - "**/.git/**"
  - "**/tests/**"

# Default output format
output: cyclonedx-json

quiet: true
```

Place this at the repo root. Syft discovers it automatically when run from that directory, or point to it explicitly with `-c /path/to/.syft.yaml`.

### 5. Multi-architecture image scanning

When scanning multi-arch images from a private registry, Syft resolves the manifest list and selects the matching platform variant. Registry auth must be configured before Syft can fetch the manifest list. Without auth, even the manifest list request fails:

```bash
# Resolves the linux/amd64 variant automatically on x86 CI runners
syft registry:myregistry.example.com/team/app:latest
```

To scan a non-native platform explicitly, pass `--platform`:

```bash
syft registry:myregistry.example.com/team/app:latest --platform linux/arm64
```

### 6. Programmatic auth for cloud registries

For registries backed by short-lived credentials (ECR, GAR), generate the token in a preceding step and pass it to Syft:

```bash
# Amazon ECR — retrieve password and pipe to docker login
aws ecr get-login-password --region us-east-1 \
  | docker login --username AWS --password-stdin "$ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com"

# Syft reads the Docker config and scans without additional flags
syft registry:"$ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/team/app:latest"
```

For Google Artifact Registry, use `gcloud auth configure-docker` before the Syft invocation, or pass an access token directly:

```bash
export SYFT_REGISTRY_AUTH_ADDRESS=us-central1-docker.pkg.dev
export SYFT_REGISTRY_AUTH_USERNAME=oauth2accesstoken
export SYFT_REGISTRY_AUTH_PASSWORD=$(gcloud auth print-access-token)
syft registry:us-central1-docker.pkg.dev/my-project/team/app:latest
```

## Verify

After configuring auth and cache, run these checks to confirm the setup works:

1. **Auth check** — Scan an image from the private registry without local credentials:
   ```bash
   rm -f ~/.docker/config.json
   syft registry:myregistry.example.com/team/app:latest --registry-auth-address myregistry.example.com --registry-auth-username "$USER" --registry-auth-password "$PASS"
   ```
   Expected: SBOM table printed. Error if auth fails: `unable to determine image version for remote` or `denied`.

2. **Cache hit** — Run the same scan twice. The second run should complete in under 3 seconds and log `"cached"` for package counts:
   ```bash
   time syft registry:alpine:latest   # first run: pulls + catalogs
   time syft registry:alpine:latest   # second run: cache hit
   ```

3. **Config override** — Run with a non-default `.syft.yaml` and confirm only the specified catalogers are active:
   ```bash
   syft -c test-syft.yaml registry:alpine:latest -o json | jq '.artifacts | group_by(.type) | length'
   ```

4. **Multi-arch resolution** — For a multi-arch image, confirm the reported digest matches the running platform:
   ```bash
   syft registry:myregistry.example.com/team/app:latest -o json | jq '.source.target.digest'
   ```

## Common errors

| Error | Likely cause | Fix |
|---|---|---|
| `unable to determine image version for remote` | Registry auth missing or credentials expired | Re-authenticate with the registry and retry. Check that `--registry-auth-address` matches the registry host exactly (including port). |
| `denied` or `unauthorized: access forbidden` | Insufficient registry permissions | Verify the IAM role or robot account has `pull` access on the repository. |
| `manifest unknown` | Typo in image tag or the tag does not exist in the registry | Confirm the tag with `docker pull` from the same credentials. |
| Cache not persisting across CI runs | Cache path not included in workflow cache action | Verify the cache action key and path match `~/.cache/syft` (or the custom `SYFT_CACHE_DIR` value). |
| `no child directories found` for `dir:` source | Path argument points to an empty or invalid directory | Confirm the directory exists and contains a filesystem Syft can traverse. |
| `unsupported media type` for multi-arch images | Registry returned an OCI manifest but Syft expected Docker V2 | Some registries serve OCI manifests by default. Syft handles both, but if the error persists, pull the image first and scan from a tarball. |


