# Install Cosign and generate my first keypair

Installed Cosign using the official release binary:

```
curl -O -L https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64
sudo mv cosign-linux-amd64 /usr/local/bin/cosign
chmod +x /usr/local/bin/cosign
```

`cosign version` confirmed v2.4.1.

## Generating a keypair

The getting-started guide says to run:

```
cosign generate-key-pair
```

This creates `cosign.key` (private) and `cosign.pub` (public) in the current directory. The private key is password-protected by default — Cosign prompts for a passphrase when you generate it and again when you sign.

I didn't set a passphrase this time (just hit Enter). Now I have two files:

- `cosign.key` — my private key, keep this secret
- `cosign.pub` — my public key, share this so others can verify my signatures

## Where the files go

By default Cosign puts them in whatever directory you're running from. The docs don't enforce a standard location — some people drop them in `~/.cosign/`, others keep them per-project. I left mine in `~/cosign-demo/` for now.

Fine for learning. Not fine for real use — I'd want these in a secrets manager or at least a dedicated keys directory with restrictive permissions.

## What tripped me up

- I expected `cosign generate-key-pair` to take flags for output path. It doesn't — it just drops them in CWD.
- The passphrase prompt uses the terminal's disabled-echo mode, which confused me at first because nothing seemed to be happening.
- On macOS you might need `cosign generate-key-pair --output-key-file ./mykey.pem` to control the path — that's a more recent feature.

## What I'd try next

Actually sign something with the key I just made, then try keyless signing to compare.