---
last_verified: 2026-11-09
tool_version: "n/a"
sources: []
---

# Sign the image and attach the SBOM with Cosign

You can now produce an SBOM for your image with Syft. The next shift-left step is to prove where that image came from: sign it so anyone downstream can verify it was built by your pipeline, then attach the SBOM as an attestation so verifiers can confirm exactly what was inside. This lesson picks up where Syft left off and adds keyless Cosign signing plus SBOM attestation, verified end-to-end with `cosign verify`.

## What you'll learn

- Sign a container image keylessly in CI (OIDC, no private key to manage)
- Attach the Syft SBOM as a Cosign attestation and verify both signature and attestation with `cosign verify`

## Before you start

- [Produce and read an SBOM with Syft](./10-syft-sbom.md) — you have an SBOM file for an image, which this lesson attaches as a Cosign attestation.
- `cosign` installed and available in the pipeline/CI environment. Confirm with `cosign version`.
- A container image you can push to and pull from a registry (e.g. `ghcr.io/<your-org>/myapp:<tag>`).

## Walkthrough

**1. Sign the image keylessly.**

Keyless signing uses your CI's OIDC identity (GitHub, GitLab, etc.) through Fulcio, so there's no long-lived private key to manage. Cosign requests a short-lived certificate and records the signing event in the Rekor transparency log.

```bash
IMAGE="ghcr.io/myorg/myapp:latest"

cosign sign --yes "$IMAGE"
```

You should see: a confirmation that the image was signed (Cosign reports the signed digest), with no password or key-pair prompt because `--yes` skips the interactive confirmation in CI.

**2. Attach the SBOM as an attestation.**

Your Syft SBOM is the inventory of what's inside the image. Attach it as a Cosign attestation so verifiers can prove the SBOM belongs to this exact image digest.

```bash
SBOM="sbom.cyclonedx.json"

cosign attestation create --predicate "$SBOM" \
  --type application/vnd.in-toto+json \
  "$IMAGE"
```

You should see: confirmation that the attestation was created and pushed alongside the image signature.

**3. Verify both signature and attestation.**

`cosign verify` checks the signature; the attestation form confirms the attached SBOM is present and valid for this image.

```bash
cosign verify "$IMAGE"
```

You should see: verification succeeds (exit 0) against the signed image, listing the certificate issuer and subject from the OIDC identity that signed it.

To confirm the SBOM attestation is attached and readable:

```bash
cosign verify --attestation "application/vnd.in-toto+json" "$IMAGE"
```

You should see: the attestation payload (your SBOM) returned, proving the SBOM is tied to this exact image digest rather than a mutable tag.

## Exercise

On your own, without looking at the walkthrough answers:

1. Pick a container image you can reach and push it to a registry you control.
2. Generate a CycloneDX SBOM for it with Syft (as in the previous lesson).
3. Sign the image keylessly with `cosign sign --yes`.
4. Attach that SBOM as a Cosign attestation.
5. Run `cosign verify` against the image and confirm it exits 0.
6. Run `cosign verify --attestation ...` against the image and confirm your SBOM comes back.

Do not include your solution inline — write the commands and run them yourself.

## Check your work

- `cosign version` reports a Cosign release (no error).
- `cosign sign --yes "$IMAGE"` succeeds and Cosign reports the signed digest.
- `cosign verify "$IMAGE"` exits 0 and lists the OIDC certificate issuer/subject.
- `cosign verify --attestation "application/vnd.in-toto+json" "$IMAGE"` returns your SBOM payload.

## Common mistakes

- Verifying a tag instead of a digest: tags are mutable, so a signature made against a tag may no longer match what you actually run. Pin verification to the digest captured at sign time (or use `cosign triangulate` to resolve the current digest).
- Forgetting `--yes` in CI: `cosign sign` prompts interactively for confirmation and will hang a pipeline that can't answer it.
- Treating an unsigned image as verified: a missing signature makes `cosign verify` exit non-zero — let that failure abort the pipeline rather than treating it as a warning.

## Next

[Scan the running app with ZAP](13-zap-baseline.md)