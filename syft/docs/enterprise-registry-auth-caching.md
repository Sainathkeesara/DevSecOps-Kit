---
last_verified: 2026-07-06
tool_version: n/a
---

# Syft enterprise registry authentication and caching patterns for high-scale CI

## Purpose

Syft needs access to private container registries to generate SBOMs for images that are not publicly available. In high-scale CI environments — hundreds of pipelines scanning images from multiple private registries — naive per-scan authentication and repeated metadata downloads create bottlenecks. This document covers authentication patterns for private registries and caching strategies to keep scan times predictable at scale.

## When to use

Apply these patterns when:

- Images are hosted in private registries (ECR, GCR, ACR, self-hosted Docker Registry, Harbor, Quay, etc.)
- The CI pipeline runs Syft as a step in every build and must authenticate per scan
- Multiple registries are in use (e.g., dev, staging, prod environments each have their own registry)
- Scans execute in ephemeral CI runners where credential caching is not available by default
- Builds run frequently enough that repeated SBOM generation against identical base images wastes time

## Prerequisites

- Syft installed in the CI environment (runner, container, or host)
- Credentials for each private registry (username/password, token, or TLS client certificate)
- Network connectivity from the CI runner to the registry
- For Docker config–based auth: write access to `~/.docker/config.json` or the ability to set `DOCKER_CONFIG`
- For config-file auth: write access to the Syft configuration file path (`.syft.yaml`, `~/.syft.yaml`, or `XDG_CONFIG_HOME`)

## Steps

### 1. Authenticate with local Docker credentials

When no container runtime is active, Syft uses the same credential store as the Docker CLI. Authenticate once with `docker login`, then Syft reads from `~/.docker/config.json` automatically.

```bash
docker login my-registry.example.com -u user -p "$REGISTRY_PASSWORD"
syft my-registry.example.com/team/app:latest
```

To use a non-default Docker config path, set `DOCKER_CONFIG`:

```bash
export DOCKER_CONFIG=/etc/docker-auth
syft my-registry.example.com/team/app:latest
```

### 2. Authenticate with environment variables

For CI environments where writing a config file is impractical, set the `SYFT_REGISTRY_AUTH_*` environment variables:

```bash
export SYFT_REGISTRY_AUTH_USERNAME=robot-user
export SYFT_REGISTRY_AUTH_PASSWORD=$(vault read -field=password secret/registry)
syft private.registry.io/app:latest
```

For token-based auth, use `SYFT_REGISTRY_AUTH_TOKEN` (mutually exclusive with username/password):

```bash
export SYFT_REGISTRY_AUTH_AUTHORITY=private.registry.io
export SYFT_REGISTRY_AUTH_TOKEN=ghp_exampleTokenValue
syft private.registry.io/app:latest
```

### 3. Authenticate with a configuration file

Place a `.syft.yaml` in the project root or `~/.syft.yaml` for user-level config. Multiple registry entries are supported:

```yaml
registry:
  insecure-skip-tls-verify: false
  insecure-use-http: false
  auth:
    - authority: docker.io
      username: ${DOCKER_IO_USER}
      password: ${DOCKER_IO_PASS}
    - authority: ecr.us-east-1.amazonaws.com
      username: AWS
      password: ${ECR_PASSWORD}
    - authority: private-registry.example.com
      token: ${REGISTRY_TOKEN}
      tls-cert: /etc/certs/registry-client.crt
      tls-key: /etc/certs/registry-client.key
```

Environment variable interpolation works for config values set before Syft starts. The config file path is resolved in this order:

1. `.syft.yaml` in the current working directory
2. `.syft/config.yaml` in the current working directory
3. `~/.syft.yaml`
4. `$XDG_CONFIG_HOME/syft/config.yaml`

The first file found is used exclusively; no merging of multiple config files occurs.

### 4. Authenticate across multiple registries in CI

In CI pipelines that build and scan images pushed to different registries per environment, use a combination of environment variables and a generated config file:

```yaml
# .github/workflows/sbom-scan.yml (GitHub Actions)
jobs:
  sbom:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Generate Syft config
        run: |
          cat > .syft.yaml <<EOF
          registry:
            auth:
              - authority: ${{ vars.REGISTRY_HOST }}
                username: ${{ secrets.REGISTRY_USER }}
                password: ${{ secrets.REGISTRY_PASS }}
          EOF
      - name: Generate SBOM
        uses: anchore/syft-action@v1
        with:
          image: ${{ vars.REGISTRY_HOST }}/app:${{ github.sha }}
          output: cyclonedx-json=sbom.cdx.json
```

### 5. Configure TLS and CA certificates

For registries using self-signed certificates or internal CAs, provide the CA bundle path:

```bash
export SYFT_REGISTRY_CA_CERT=/etc/ssl/certs/internal-ca.crt
syft internal-registry.example.com/app:latest
```

Or in the config file:

```yaml
registry:
  ca-cert: /etc/ssl/certs/internal-ca.crt
  auth:
    - authority: internal-registry.example.com
      username: svc-syft
      password: ${SYFT_REG_PASS}
```

To skip TLS verification entirely (not recommended in production):

```bash
export SYFT_REGISTRY_INSECURE_SKIP_TLS_VERIFY=true
```

### 6. Optimize scan performance with caching

Syft caches the image layer metadata and package catalog between runs. In ephemeral CI runners, configure caching so that repeated scans of the same base image do not re-download metadata.

**Cache directory**

```bash
export SYFT_CACHE_DIR=/tmp/syft-cache
syft my-registry.example.com/app:latest
```

**CI cache persistence (GitHub Actions)**

```yaml
- name: Cache Syft metadata
  uses: actions/cache@v4
  with:
    path: ~/.cache/syft
    key: syft-cache-${{ runner.os }}-${{ hashFiles('Dockerfile') }}
    restore-keys: |
      syft-cache-${{ runner.os }}-

- name: Generate SBOM
  run: syft docker.io/library/alpine:latest -o cyclonedx-json
```

**Docker layer caching**

When scanning the same image tag across multiple builds, Syft reuses previously fetched layer metadata if the cache directory persists. For CI systems that reuse workspaces (e.g., self-hosted runners with persistent volumes), mount a shared cache volume:

```bash
docker run --rm \
  -v ~/.cache/syft:/home/syft/.cache/syft \
  -e SYFT_REGISTRY_AUTH_USERNAME \
  -e SYFT_REGISTRY_AUTH_PASSWORD \
  anchore/syft:latest \
  private-registry.io/app:latest
```

## Verify

1. **Authentication test**: Run `syft private-registry.io/alpine:latest -o syft-json` and confirm the output contains `"artifacts"` with a non-empty array.
2. **Auth failure test**: Run `SYFT_REGISTRY_AUTH_PASSWORD=wrongpassword syft private-registry.io/alpine:latest 2>&1` and confirm an authentication error is returned.
3. **Cache effectiveness**: Run the same scan twice in succession. The second run should complete faster and produce no registry pull logs when verbosity is increased (`SYFT_LOG_LEVEL=debug`).
4. **Multi-registry**: Configure two registry auth entries in `.syft.yaml`, scan an image from each, and verify both produce valid SBOMs.
5. **CA cert**: Point Syft at a registry with a custom CA; verify the scan succeeds without `insecure-skip-tls-verify`.

## Common errors

- **`unable to determine registry auth`: no credentials found for registry`** — The registry URL in the image tag does not match the `authority` field in the auth config. Check for port suffixes, registry path prefixes, and scheme mismatches.
- **`authentication required` on every scan** — The `DOCKER_CONFIG` environment variable points to a directory without a readable `config.json`, or the config file is missing the registry entry. Confirm the file exists and contains the expected credentials.
- **`failed to fetch image: unexpected status code 401 Unauthorized`** — Token has expired or was revoked. Refresh the token and restart the scan. For short-lived tokens, fetch them in a setup step before the Syft invocation.
- **Cache directory permission denied** — The Syft process runs as a non-root user and cannot write to the configured cache path. Ensure the cache directory is writable by the runtime user, or set `SYFT_CACHE_DIR` to a user-writable path.
- **Config file ignored** — A config file exists but its values are not applied. Check the resolution order: a `.syft.yaml` in the working directory takes precedence over `~/.syft.yaml`. There is no merging — only the first file found is read.
