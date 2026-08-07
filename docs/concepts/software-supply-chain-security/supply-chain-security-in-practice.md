---
last_verified: 2026-08-07
tool_version: n/a
---

# Software Supply Chain Security in Practice

> Bringing SBOM generation, artifact signing, and vulnerability management together into a single verification mindset. This is not a primer on any one tool — it is how the three controls reinforce each other once a pipeline runs more than one. The primer covers the vocabulary; this is what happens when the pieces stop living in isolation.

## What this covers

A supply chain compromise is only as strong as the weakest link in the pipeline. Generating a bill of materials does not help if the artifact cannot be proven authentic; signing does not help if the signature only covers bytes that were already tampered; scanning does not help if it runs against an unverified image. Software supply chain security converges on three overlapping controls that close on each other:

1. **Know what is inside** — an SBOM gives an inventory of components per artifact.
2. **Prove where it came from** — signing binds an artifact to its build provenance.
3. **Decide what is allowed** — vulnerability scanning turns that inventory into go/no-go gates.

Each control on its own is useful; together they decide whether an artifact is accepted.

## SBOM generation: the inventory step

The bill of materials is the starting point, because you can only scan or sign what you can enumerate. A cataloger inspects an image or a language manifest and emits a machine-readable list of every package, library, and base-image layer. The list is only useful if it matches what actually ships, so the cataloger usually runs in the same build job that produces the artifact, and the SBOM is attached to that artifact as an attestation rather than kept as a separate file that can drift.

A common pattern is to generate the SBOM first and then treat it as an input to both scanning (feed it to a vulnerability matcher) and signing (sign the artifact together with the SBOM so the two cannot diverge at verification time). That ordering matters more than the specific cataloger used.

## Artifact signing: the authenticity step

Signing answers "who built this and whether the build can be trusted?" rather than "is it free of known bugs." A signer binds a cryptographic signature to an artifact — typically a container image, a binary, or an SBOM — so that a later consumer can check the signature against a trusted key or identity. The signature should cover both the artifact and its SBOM, so the inventory and the signature are validated together; signing one without the other leaves a gap an attacker can exploit by swapping only the unsigned half.

Identity-bound signing is increasingly replacing long-lived signing keys. Instead of distributing a public key to every consumer, the signer proves it is a specific CI workflow and receives a short-lived token from the provider. That removes the need to store, rotate, and revoke a static key, and it makes a leaked key useless once the workflow's access changes.

## Vulnerability management: the go/no-go step

With the SBOM in hand and the artifact's origin confirmed, vulnerability matching becomes a gate that is precise rather than a blind scan of an opaque image. A matcher walks the inventory, correlates each component against a vulnerability database, and reports findings with enough context that a team can decide whether to accept, fix, or block.

The order is worth keeping straight: scanning before signing means the scan results could be forged by anyone who can tamper with the image; scanning after signing, against the SBOM the builder actually attached, keeps the scan rooted in what went into the build. The matcher should prefer the SBOM over a fresh re-scan of the image, because the SBOM is the inventory that was actually signed.

## How the three combine

This is the shape most teams converge on, and it is the part the individual tools do not show you on their own:

1. The build job publishes the artifact and, in that same job, publishes an SBOM as an attestation bound to that exact artifact.
2. The signer signs the artifact and the SBOM attestation together, using an identity-bound credential, so the signature cannot outlive the build's trust boundary.
3. A vulnerability matcher consumes the SBOM — not the image bytes — and reports findings scoped to exactly what shipped.
4. A deploy gate verifies the signature first, then enforces the matcher's verdict, refusing anything whose signature is absent or whose findings cross a declared threshold.

The loop only closes when verification actually rejects artifacts that fail any link. A signature without an SBOM is unverifiable content; an SBOM without a signature is untrustworthy inventory; a scan without verification of origin is a scan of an unauthenticated image.

## A minimal end-to-end flow

The smallest concrete demonstration combines the three controls in one script. It builds an image, attaches an SBOM, signs both, scans the SBOM, and verifies in a separate step before allowing a deploy to proceed.

```bash
# 1. Build the image
docker build -t myapp:1.0 .

# 2. Generate an SBOM and attach it to the image
syft myapp:1.0 -o cyclonedx-json > sbom.json

# 3. Sign the image together with the SBOM
cosign sign --yes myapp:1.0
cosign attest --yes -predicate sbom.json myapp:1.0

# 4. Scan the SBOM for vulnerabilities
grype sbom:sbom.json --only-fixed --output json > vulns.json

# 5. Verify signature + attestations before deploying
cosign verify --key cosign.pub myapp:1.0 || exit 1
kubectl apply -f deployment.yaml
```

This is not a turnkey pipeline — it is a sketch of the verification points. Swapping any tool for an equivalent one is fine; what matters is that each point is enforced rather than optional.

## Verifying the chain

A working chain is one where removing or swapping any control is detectable. Concretely, that means checking that:

- Dropping signing causes verification to fail.
- Attaching a mismatched SBOM fails attestation verification.
- Introducing a dependency with a known vulnerability trips the matcher, even when the image is otherwise valid.

If any of those still passes, the control is not integrated — it is decoration. The goal is to fail closed, not to collect more reports.
