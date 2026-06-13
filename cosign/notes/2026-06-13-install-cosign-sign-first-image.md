# Installing Cosign and signing my first image

Installed Cosign from the official release:

```
curl -O -L https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64
sudo mv cosign-linux-amd64 /usr/local/bin/cosign
chmod +x /usr/local/bin/cosign
```

Verified it works: `cosign version` showed v2.4.1.

## Signing a test image

I needed an image to sign. Picked `docker.io/nginx:latest` and pulled it locally. Then generated a keypair:

```
cosign generate-key-pair
```

This made `cosign.key` (private) and `cosign.pub` (public). I threw the private key password in a temp file for now — `cosign sign` prompts for it interactively, and passing `--key cosign.key` without a password file kept pausing.

Signed it:

```
cosign sign --key cosign.key --password-file /tmp/cosign-pw myregistry.io/nginx:signed
```

Wait — I don't have a registry. I need a container registry to push the signature to. Cosign stores signatures in the registry alongside the image.

Set up a local registry with:

```
docker run -d -p 5000:5000 --name registry registry:2
docker tag nginx:latest localhost:5000/nginx:latest
docker push localhost:5000/nginx:latest
```

Then signed:

```
cosign sign --key cosign.key --password-file /tmp/cosign-pw localhost:5000/nginx:latest
```

It pushed a new manifest tagged `localhost:5000/nginx:sha256-<hash>.sig`. The signature lives in the registry.

## What tripped me up

- Cosign needs a registry. You can't sign a local-only image.
- `cosign sign` prompts for a password if you don't use `--password-file`. I had to restart after it hung.
- `--tarball` mode is for saving to disk but `cosign verify` didn't work on the tarball later.

## What I'd try next

Verifying the signature I just made, then trying keyless signing with GitHub OIDC.
