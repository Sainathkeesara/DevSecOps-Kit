---
last_verified: 2026-10-30
tool_version: n/a
---
# Integrating Fulcio and Rekor for keyless signing in production

## Purpose

Keyless signing with Sigstore removes the need to manage long-lived private keys
in CI/CD pipelines. Fulcio issues short-lived TLS certificates authenticated via
OIDC, and Rekor operates the transparency log that records signatures. Together
they enable image signing that is both automated and auditable, with signatures
verifiable by any downstream consumer.

This doc describes production-pattern integrations so that every container image
pushed from a pipeline can be signed and verified without handling secret keys.

## When to use

- A pipeline already authenticates to an OIDC provider (GitHub Actions, GitLab,
  Azure Pipelines, etc.) and wants to avoid managing GPG or RSA key pairs.
- You need cryptographically verifiable proof of image origin for compliance or
  supply-chain security requirements.
- You want signatures that are recorded in a public transparency log for
  incident response and auditability.

## Prerequisites

- A pipeline configured with OIDC identity federation (e.g., GitHub OIDC token
  for `https://token.actions.githubusercontent.com`).
- Cosign installed and available in the pipeline environment.
- Target container registry with push access and permission to store signature
  artifacts (_`cosign.sh`_ and _`cosign.pub`_).
- Understanding of the Sigstore trust model: issuers, subjects, and OIDC
  federation chains.

## Steps

### 1. Configure OIDC federation for Fulcio

The pipeline authenticates to Fulcio by presenting an OIDC token from the CI
system. The exact configuration depends on the CI platform:

**GitHub Actions**

```yaml
jobs:
  sign-image:
    runs-on: ubuntu-latest
    permissions:
      id-token: write        # requests short-lived OIDC token
      contents: read         # read package/registry metadata
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Build and push image
        run: |
          docker build -t ghcr.io/myorg/myapp:${{ github.sha }} .
          docker push ghcr.io/myorg/myapp:${{ github.sha }}
```

### 2. Sign the image digest keylessly

After the image is pushed, sign the immutable digest with `cosign sign`. The
tool fetches the OIDC token, presents it to Fulcio, and receives a certificate
that is logged in Rekor.

```bash
IMAGE_DIGEST="$(docker inspect --format='{{index .RepoDigests 0}}' \
  ghcr.io/myorg/myapp:${{ github.sha }})"

cosign sign \
  --key oidc://https://token.actions.githubusercontent.com \
  ghcr.io/myorg/myapp:${{ github.sha }}
```

The `--key oidc://...` URI tells cosign to use keyless signing via the OIDC
identity. The resulting signature is stored as an annotation on the image.

### 3. Verify the signature in deployment gates

Verification uses the same identity constraints that were used for signing.
Tighten the patterns to the exact issuer and subject your pipeline uses.

```bash
cosign verify \
  --certificate-identity-regexp '^https://github\.com/myorg/myapp/\
.github/workflows/ci\.yml@refs/heads/main$' \
  --certificate-oidc-issuer-regexp '^https://token\.actions\.githubusercontent\.com$' \
  ghcr.io/myorg/myapp:${{ github.sha }}
```

### 4. Pin verification to digest (not tag)

Tags are mutable. Always verify against the digest that was captured at sign
time, or use `cosign triangulate` to resolve the current digest before
verification.

```bash
DIGEST="$(cosign triangulate ghcr.io/myorg/myapp:${{ github.sha }})"

cosign verify \
  --certificate-identity-regexp '^https://github\.com/myorg/myapp/\
.github/workflows/ci.yml@refs/heads/main$' \
  --certificate-oidc-issuer-regexp '^https://token\.actions\.githubusercontent\.com$' \
  ghcr.io/myorg/myapp@${DIGEST}
```

### 5. Enforce verification in deployment pipelines

Add a verification step as the first gate before any cluster deployment. A
failed check must abort the pipeline rather than producing a warning.

```yaml
- name: Verify image signature
  run: |
    cosign verify \
      --certificate-identity-regexp '.*' \
      --certificate-oidc-issuer-regexp '.*' \
      ${{ env.IMAGE_REF }}
```

Tighten the `certificate-identity-regexp` and `certificate-oidc-issuer-regexp`
patterns to your organization's specific OIDC subjects and issuers.

## Verify

The integration is working when:

- A pipeline run that pushes an image also produces a Rekor-linked signature.
- A deployment stage with a deliberately broken or missing signature fails
  instead of deploying.
- Promoting an image between environments re-runs verification rather than
  trusting the earlier check.
- `cosign verify` exits 0 against a known-good signed image and exits non-zero
  against an unsigned image.

## Common errors

- **Signing the tag instead of the digest.** The tag moves, the signature no
  longer matches what runs. Always resolve the digest after pushing and verify
  against it.
- **Verify step that cannot fail the build.** A check whose exit code is
  ignored is documentation, not a gate. Let verification failures stop the
  pipeline.
- **Broad identity patterns in production.** Using `'.*'` for
  `certificate-identity-regexp` or `certificate-oidc-issuer-regexp` works for
  prototyping but does not encode organizational trust. Pin to the exact OIDC
  subject your pipeline uses.
- **OIDC token scope misconfiguration.** Ensure the pipeline's OIDC token
  includes the `https://token.actions.githubusercontent.com` or equivalent issuer
  URL scope; some platforms require explicit scope requests in the workflow
  syntax.

## Next

[Cosign verification patterns](cosign-verification-patterns.md) — policy-based
verification with custom OCI rules, annotation checks, and policy files.

[Container signing pipeline](container-signing-pipeline.md) — full pipeline
integration with build, push, sign, and verify stages.