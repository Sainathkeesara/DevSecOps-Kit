# Cosign — quick primer

> First-day notes for someone who's never used Cosign. Personal voice, plain language.

## What is it?

Cosign is a tool for signing container images and verifying those signatures. It's part of the Sigstore project, which is a whole ecosystem for software supply chain security. If you've ever wanted to prove that a container image you pulled was actually built by whoever claims to have built it, Cosign is the tool for that.

## What does it do?

It signs container images using cryptographic keys (or even without keys via OIDC identity), stores the signature alongside the image in a registry, and lets anyone verify that signature before they run the image. Think `gpg --sign` but for Docker images.

## Why does it exist?

Before Cosign, signing container images was technically possible but nobody did it because the tooling was scattered and hard to use. You'd need to manage keys, figure out where to store signatures, and wire up verification yourself. Cosign (and Sigstore) made it practical by supporting keyless signing (using your existing GitHub/Google identity), storing signatures in the registry alongside the image, and making verification a one-liner.

## Key terminology

- **Sigstore** — The umbrella project that Cosign belongs to. Includes Fulcio (CA), Rekor (transparency log), and Cosign itself.
- **Signing** — Attaching a digital signature to an image digest. Cosign stores this as an additional tag or OCI artifact in the registry.
- **Verification** — Checking that an image's signature matches a trusted public key or identity. `cosign verify` does this.
- **Keypair** — A public/private key pair used for signing. Cosign generates these with `cosign generate-key-pair`.
- **Keyless signing** — Instead of managing keys, Cosign uses OIDC to get a short-lived signing certificate from Fulcio, tied to your email/identity.
- **Rekor** — An immutable transparency log that records signing events. Lets you verify that a signature existed at a point in time.
- **Digest** — The SHA256 hash of an image, used to uniquely identify it. Signatures are tied to the digest, not the tag.

## A tiny example

```bash
# Sign an image with a keypair
cosign generate-key-pair
cosign sign --key cosign.key myregistry.io/myimage:latest

# Verify it
cosign verify --key cosign.pub myregistry.io/myimage:latest
```

This generates a keypair, signs the image, and verifies the signature.

## What I'll cover next

I want to actually install Cosign, sign a real image (maybe an nginx I have locally), push it to a registry, and verify it. After that I want to understand keyless signing with GitHub OIDC since that's what production workflows seem to use.
