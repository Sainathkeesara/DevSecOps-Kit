# Grype + Syft integration guide for container image SBOM workflows

## Purpose

Grype pairs with Syft to scan container images and filesystems for known vulnerabilities. Syft generates a software bill of materials (SBOM), and Grype checks each package in that SBOM against vulnerability databases. Decoupling SBOM generation from scanning makes it possible to capture an SBOM at build time and scan it later offline, in air-gapped environments, or across multiple scanners. This is one approach — the Syft docs also show a direct Grype pipe without an intermediate file.

## When to use this

- Capture an SBOM during a build and scan it with Grype in a separate stage.
- Scan the same image with multiple tools without pulling it repeatedly.
- Pipeline runs in an air-gapped or restricted network where live vulnerability DB lookups are not possible.

## Prerequisites

- Syft v0.60+ (`syft version`)
- Grype v0.60+ (`grype version`)
- Docker or a container runtime to pull test images
- `jq` for inspecting JSON output (optional)

## Steps

### 1. Generate an SBOM with Syft

Generate a CycloneDX SBOM from a local image:

```
syft alpine:latest -o cyclonedx-json > alpine-sbom.json
```

This produces a CycloneDX JSON document with every package in the image.

### 2. Scan the SBOM with Grype

Point Grype at the SBOM file instead of the image directly:

```
grype alpine:latest --only-fixed
grype sbom:alpine-sbom.json --only-fixed
```

Both should produce the same vulnerability results. The second form works entirely from the SBOM without the image present locally — one reason to decouple the steps.

### 3. Compare outputs

Run both and diff the match counts:

```
grype alpine:latest --only-fixed -o json > scan-direct.json
grype sbom:alpine-sbom.json --only-fixed -o json > scan-from-sbom.json
jq --argfile a scan-direct.json --argfile b scan-from-sbom.json -n '
  ($a.matches | length) as $direct
  | ($b.matches | length) as $fromSbom
  | { direct: $direct, from_sbom: $fromSbom, same: ($direct == $fromSbom) }'
```

When the SBOM is current and the image hasn't changed, counts match. One gotcha: Syft's native `-o json` is a different schema than CycloneDX — Grype won't read it. The Syft docs recommend `cyclonedx-json` or `spdx-json` for Grype consumption.

### 4. Offline SBOM scan workflow

For air-gapped use, pull the image and generate the SBOM on a connected host, then transfer the SBOM to the offline system:

```
# Connected host
docker pull alpine:latest
syft alpine:latest -o cyclonedx-json > alpine-sbom.json
grype db update
# Copy alpine-sbom.json and grype DB cache to offline host
```

On the offline host:

```
grype sbom:alpine-sbom.json -o json --only-fixed
```

Grype reads from its cached DB — no network needed.

### 5. CI pipeline integration

A straightforward CI step pair that generates and scans:

```yaml
- name: Generate SBOM
  run: syft ${{ env.IMAGE }} -o cyclonedx-json > sbom.json

- name: Scan SBOM
  run: grype sbom:sbom.json --fail-on high --only-fixed
```

The SBOM can also be uploaded as a build artifact for later auditing or downstream tools.

## Verify

- `grype sbom:<file>` exits 0 when no vulnerabilities meet the threshold.
- `grype sbom:<file>` exits non-zero when the threshold is exceeded.
- Direct and SBOM-based scans produce the same match set for the same image tag.

## Common errors

- **SBOM format mismatch** — Grype expects CycloneDX or SPDX JSON. Syft's native `-o json` uses a different schema that Grype cannot read. Use `-o cyclonedx-json` or `-o spdx-json`.
- **Stale SBOM** — When a tag like `alpine:latest` updates, the old SBOM no longer matches. Regenerate before scanning or pin the image digest.
- **Missing DB** — Grype downloads its vulnerability DB on first run. Without the cached DB, `grype sbom:` fails. Run `grype db update` before offline use.

## References

- [Syft docs](https://github.com/anchore/syft)
- [Grype docs](https://github.com/anchore/grype)
- [Anchore SBOM workflow guide](https://docs.anchore.com/)
