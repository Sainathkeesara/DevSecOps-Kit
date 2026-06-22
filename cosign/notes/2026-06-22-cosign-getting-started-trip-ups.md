# Following the Cosign getting-started tutorial — what tripped me up

I went through the official Cosign getting-started tutorial from start to finish. Here is what worked, where I got stuck, and what I'd do differently next time.

## What I ran

Install:

```bash
brew install cosign   # macOS
# or
go install github.com/sigstore/cosign/v2/cmd/cosign@latest
```

Verify it is there:

```bash
cosign version
```

Generate a key pair:

```bash
cosign generate-key-pair
# writes cosign.key and cosign.pub to the current directory
```

Sign an image I built locally with Docker:

```bash
docker build -t demo-app:dev .
cosign sign --key cosign.key demo-app:dev
```

Wait, that failed first because `demo-app:dev` was not in a registry. The tutorial assumes you have already pushed. Easy fix — push it to Docker Hub or a local registry first.

```bash
docker tag demo-app:dev mydockerhubuser/demo-app:dev
docker push mydockerhubuser/demo-app:dev
cosign sign --key cosign.key mydockerhubuser/demo-app:dev
```

Verify:

```bash
cosign verify --key cosign.pub mydockerhubuser/demo-app:dev --output json
```

The verify output printed a JSON object with `critical` and `optional` sections. I had to re-run it twice because I did not realize `--output json` is required — without it, the command prints human-readable success text but no structured data.

## Got stuck on

1. **Signing an un-pushed image** — Cosign did not refuse the image outright, but the verification step returned nothing useful. Turns out the registry needs the image to exist before the signature gets written. The tutorial does not call this out until the Kubernetes section.

2. **Key pair location surprise** — `generate-key-pair` drops files in the current directory. I ran from `/tmp` and lost them. A `cosign generate-key-pair --output-key-prefix=$(pwd)/keys/cosign` pattern is mentioned later but not in the very first step.

3. **`verify` output without `--output json`** — I expected a boolean exit code, which does work, but the JSON payload I wanted only appears with the flag. Watching CI logs without it makes troubleshooting harder.

4. **Keyless signing prerequisites** — The tutorial jumps into keyless OIDC signing and I got a 404 from the OIDC issuer. I was running in a sandbox without a known OIDC provider set up. I skipped ahead to the attested build step instead.

5. **Attestation flags** — The `cosign attest` command uses `--predicate` from a file, but I passed a JSON string inline and it silently accepted an empty predicate. The image was attested, but there was nothing useful inside. The docs should make the file requirement louder.

## What I'd try next

I want to walk through the keyless flow on GitHub Actions next — the `cosign sign` with `--yes` and `--default-repo` pattern looks useful for CI. Also planning to try `cosign attest` with a generated SBOM and see how verification reads the predicates back.
