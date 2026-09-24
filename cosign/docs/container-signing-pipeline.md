---
last_verified: 2026-09-24
tool_version: n/a
---

# Integrating cosign with container signing pipelines

## Purpose

Explain where cosign signing and verification steps belong in a container image
pipeline, so that every image reaching a cluster has a signature that can be
checked at deploy time. Covers stage ordering, key-management choices, and the
verify gate that rejects unsigned images.

## When to use

- A pipeline builds and pushes container images and needs proof of origin
  before those images are deployed.
- The team wants signing to happen automatically on every release build rather
  than as a manual step.
- A deployment gate or admission check must reject images without a valid
  signature.

## Prerequisites

- Cosign installed where the pipeline runs (build agent or signing job).
- Push access to the container registry holding the images.
- Agreement on key management: keyless signing via the pipeline identity
  provider, or a stored key pair whose private half lives in the CI secret
  store.

## Steps

### 1. Order the stages as build, push, sign, verify

Signing must come after the image digest is fixed. The reliable order is:

1. Build the image.
2. Push it so the registry assigns a digest.
3. Sign the image by digest, not by mutable tag.
4. Verify the signature in a later step before deploying.

Signing by digest matters because tags can be moved after signing. A signature
over the digest stays bound to the exact bytes that were built.

### 2. Pick keyless or key-based signing for the pipeline

Keyless signing fits pipelines that already authenticate to an identity
provider: the pipeline mints a short-lived certificate for the run, so there
is no long-lived private key to store or rotate. Key-based signing fits
environments without that identity plumbing: generate one key pair, keep the
private key in the CI secret store, and distribute the public key to every
place that verifies.

Use one mode per pipeline rather than mixing both. Mixed modes make the verify
gate harder to reason about, since each image may need a different check.

### 3. Add the signing step right after the push

A minimal signing stage looks like this:

```bash
# Push first so the digest exists, then sign the exact digest.
docker push "${IMAGE_REPO}:${IMAGE_TAG}"
IMAGE_DIGEST="$(docker inspect --format='{{index .RepoDigests 0}}' "${IMAGE_REPO}:${IMAGE_TAG}")"

# Keyless signing: identity comes from the pipeline environment.
cosign sign "${IMAGE_DIGEST}"
```

For key-based signing, the same step instead points at the stored private key
and never prints it to logs:

```bash
cosign sign --key "${COSIGN_PRIVATE_KEY_PATH}" "${IMAGE_DIGEST}"
```

Keep the signing step in the same job that performed the push when possible.
Handing the digest between jobs through files or outputs works but adds places
where a stale tag can slip in.

### 4. Gate deployment on a verification step

No image should reach the cluster without passing verification. Run the check
as its own stage after signing (and again in promotion pipelines that move an
image between environments):

```bash
# Keyless verification pinned to the pipeline identity.
cosign verify \
  --certificate-identity-regexp '.*' \
  --certificate-oidc-issuer-regexp '.*' \
  "${IMAGE_DIGEST}"
```

Tighten the identity patterns to the exact issuer and workflow subject the
team uses; the broad patterns above only show where the pins go. Key-based
pipelines verify against the distributed public key instead:

```bash
cosign verify --key cosign.pub "${IMAGE_DIGEST}"
```

A failing verification must fail the pipeline. Do not downgrade it to a
warning, or unsigned images will drift into the environment unnoticed.

### 5. Plan key storage and rotation up front

For key-based pipelines, store the private key as a CI secret with restricted
read access, and keep the public half next to the deployment configuration so
verifiers can find it. When rotating, generate the new pair, publish the new
public key, re-sign the images that matter, and only then retire the old
private key. For keyless pipelines there is nothing to rotate, but the
identity patterns in the verify step need updating if the pipeline moves to a
different repository or workflow path.

## Verify

The integration is working when:

- Every pipeline run that pushes an image also produces a signature over the
  pushed digest.
- A deployment stage with a deliberately broken or missing signature fails
  instead of deploying.
- Promoting an image between environments re-runs verification rather than
  trusting the earlier check.

## Common errors

- **Signing the tag instead of the digest.** The tag moves, the signature no
  longer matches what runs. Always resolve the digest after pushing.
- **Verify step that cannot fail the build.** A check whose exit code is
  ignored is documentation, not a gate. Let verification failures stop the
  pipeline.
- **Two signing modes in one pipeline.** Some images end up keyless, others
  key-based, and the verify step covers neither fully. Standardize on one.
- **Private key in build logs or baked into images.** Pass the key by path
  from the secret store and keep it out of layers and output.

## References

- Verification-side patterns: `cosign-verification-patterns.md` in this
  directory.
- Keyless pipeline example: `../configs/keyless-signing-github-actions.yaml`.
