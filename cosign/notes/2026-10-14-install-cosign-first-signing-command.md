---
last_verified: 2026-10-14
tool_version: n/a
---

# Cosign — install and my first signing command

I installed Cosign and ran my first signing command. Here's what happened.

## What I did

I grabbed the binary from the Cosign release page and dropped it on my PATH. Then I generated a keypair — a private key and a matching public key — with `cosign generate-key-pair`. That creates two files on disk and asks you to set a password on the private one, which I did.

With the keypair ready I ran `cosign sign --key cosign.key myregistry.io/myimage:latest`. That's the whole first signing command: it takes the image, the private key, and pushes a signature up to the registry alongside the image.

## What tripped me up

The first snag was the registry path. Cosign wants the full `registry.io/repo:tag`, not a short name. I typed `myimage:latest` and it failed with a confusing error about the reference. Adding the registry prefix fixed it.

The second was the password prompt. `cosign sign` prompts for the key password interactively, so it does not work in a script unless you pipe it in. I got a clean run by using `--password` or `COSIGN_PASSWORD` in a follow-up.

## What I'd try next

I want to verify the signature back with `cosign verify --key cosign.pub`, and then try keyless signing with `cosign sign-blob` so I don't have to manage a keypair at all.