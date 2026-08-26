---
last_verified: 2026-08-25
tool_version: n/a
sources: []
---

# Cosign verification patterns — policy-based verification with custom OCI rules

## Purpose

Describe practical patterns for verifying Cosign signatures using policy-based approaches. Move beyond basic `cosign verify --key` into reusable verification policies that encode organizational trust requirements.

## When to use

- You need to enforce that all container images deployed to an environment are signed by a trusted identity
- You want to codify verification rules (allowed issuers, required annotations, digest pinning) as policy rather than ad-hoc CLI flags
- You are building a GitHub Actions or CI/CD gate that rejects unsigned or improperly signed images

## Prerequisites

- Cosign installed and available in PATH
- Access to the target container registry (read permissions for the image and its signature artifacts)
- Understanding of Sigstore identity model: issuer (e.g., `https://token.actions.githubusercontent.com`), subject (e.g., `https://github.com/org/repo/.github/workflows/ci.yml@refs/heads/main`)

## Steps

### 1. Basic keyless verification with identity constraints

```bash
# Verify an image signed keylessly via GitHub OIDC
# Requires the image to have a signature from the expected workflow
cosign verify \
  --certificate-identity-regexp '^https://github\.com/myorg/myapp/\.github/workflows/.*@refs/heads/main$' \
  --certificate-oidc-issuer-regexp '^https://token\.actions\.githubusercontent\.com$' \
  ghcr.io/myorg/myapp:latest
```

The `--certificate-identity-regexp` and `--certificate-oidc-issuer-regexp` flags let you pin verification to a specific CI workflow without managing public keys.

### 2. Verification with required annotations

Cosign signatures can carry arbitrary annotations. Use them to encode deployment metadata and enforce it at verify time.

```bash
# Sign with custom annotations
cosign sign \
  --annotation "environment=production" \
  --annotation "deployed-by=github-actions" \
  ghcr.io/myorg/myapp:v1.2.3

# Verify that the signature carries the expected annotations
cosign verify \
  --certificate-identity-regexp '^https://github\.com/myorg/myapp/\.github/workflows/.*@refs/heads/main$' \
  --certificate-oidc-issuer-regexp '^https://token\.actions\.githubusercontent\.com$' \
  --annotation "environment=production" \
  ghcr.io/myorg/myapp:v1.2.3
```

The `--annotation` flag on verify requires an exact match. Missing or mismatched annotations cause verification to fail.

### 3. Policy file for reusable verification rules

Create a policy file (JSON) to centralize verification logic.

```json
{
  "version": "0.1",
  "rules": [
    {
      "type": "match",
      "identity": {
        "issuer": "https://token.actions.githubusercontent.com",
        "subject": "https://github.com/myorg/myapp/.github/workflows/release.yml@refs/heads/main"
      }
    },
    {
      "type": "match",
      "annotations": {
        "environment": "production",
        "sbom": "true"
      }
    }
  ]
}
```

Apply the policy:

```bash
cosign verify --policy policy.json ghcr.io/myorg/myapp:v1.2.3
```

Policy files support multiple rules; all must pass for verification to succeed.

### 4. Digest pinning for immutable verification

Tags are mutable. Verify against a specific digest to guarantee the exact artifact that was signed.

```bash
# Get the digest of the image you intend to verify
DIGEST=$(cosign triangulate ghcr.io/myorg/myapp:v1.2.3)

# Verify the digest directly
cosign verify \
  --certificate-identity-regexp '^https://github\.com/myorg/myapp/\.github/workflows/.*@refs/heads/main$' \
  --certificate-oidc-issuer-regexp '^https://token\.actions\.githubusercontent\.com$' \
  ghcr.io/myorg/myapp@${DIGEST}
```

`cosign triangulate` resolves a tag to its current digest. Pinning to digest prevents tag-mutation attacks.

### 5. Composite verification in CI

A reusable GitHub Actions step that combines the patterns above:

```yaml
- name: Verify image signature
  uses: sigstore/cosign-installer@v3
  with:
    cosign-release: 'latest'

- name: Verify cosign signature with policy
  env:
    COSIGN_EXPERIMENTAL: "1"
  run: |
    cosign verify \
      --certificate-identity-regexp '${{ env.EXPECTED_IDENTITY }}' \
      --certificate-oidc-issuer-regexp '^https://token\.actions\.githubusercontent\.com$' \
      --annotation "environment=${{ env.TARGET_ENV }}" \
      --annotation "sbom=true" \
      ${{ env.IMAGE_REF }}
```

Set `EXPECTED_IDENTITY`, `TARGET_ENV`, and `IMAGE_REF` as environment variables or secrets.

## Verify

- Run `cosign verify` with the policy or flags above against a known-good signed image — it should exit 0
- Run the same command against an unsigned image or one signed by a different identity — it should exit non-zero
- Check that annotation mismatches (e.g., `environment=staging` when policy requires `production`) cause failure

## Common errors

- **Certificate identity mismatch**: The regex pattern doesn't match the actual OIDC subject in the certificate. Inspect the certificate with `cosign verify --certificate-identity-regexp '.*' --certificate-oidc-issuer-regexp '.*' <image> --output json` to see the exact values.
- **Annotation not found**: The signature was created without the expected annotation. Re-sign with `--annotation` flags.
- **Digest mismatch**: The tag was re-pointed after signing. Always verify against the digest captured at sign time, or use `cosign triangulate` in the same pipeline step.