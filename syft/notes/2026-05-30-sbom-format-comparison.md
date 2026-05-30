# Comparing CycloneDX vs SPDX vs Syft JSON SBOM output formats

I generated SBOMs for the same image (`alpine:latest`) in all three formats Syft supports and picked through the JSON to see what's different.

## Steps

1. Ran `syft alpine:latest -o syft-json > alpine-syft.json` — the native Syft format.
2. Ran `syft alpine:latest -o cyclonedx-json > alpine-cdx.json` — CycloneDX 1.5 output.
3. Ran `syft alpine:latest -o spdx-json > alpine-spdx.json` — SPDX 2.3 output.
4. Compared the three side by side with `jq` and `diff`.

## What I found

**CycloneDX** is the most structured for security tooling. It has a `vulnerabilities` array (empty unless you pipe through grype), a `metadata` block with the toolchain used, and each component gets a `bom-ref` identifier. The component list is nested the same way as syft-json — packages with their purl, version, and type. The schema is clean.

**SPDX** is more legal-oriented. It includes `creationInfo` (who made the SBOM, when), `documentNamespace` (a UUID per doc), and a `relationships` array that links packages together. The `packages` array uses SPDX identifiers (`SPDXRef-xxx`) instead of bom-refs. Feels heavier but the relationship tracking could be useful for dependency chains.

**Syft JSON** is the simplest. Just a list of `artifacts` with keys like `id`, `name`, `version`, `type`, `locations`, `licenses`, `cpes`, `purl`. No relationship graph, no document metadata. It's the raw output Syft uses internally.

## Got stuck on

- **Format flag naming**: `cyclonedx-json` vs `spdx-json` vs `syft-json` — I kept trying `--format` instead of `-o`, and `cyclonedx` vs `cyclonedx-json` was whack-a-mole.
- **Schema validation**: CycloneDX and SPDX both have official JSON schemas. Syft JSON doesn't — it's whatever Syft decides to emit. That means if you're building a pipeline, you either commit to the syft-json shape or you normalize into one of the standards.
- **File size**: SPDX was ~50% bigger than CycloneDX for the same image. Syft JSON was the smallest. Not a huge deal for alpine, but matters at scale.

## What I'd try next

I want to pipe CycloneDX output into Grype (they integrate natively) and see how the vulnerability info fills into the CycloneDX `vulnerabilities` array. Also curious how the relationship tracking in SPDX actually works when you have a multi-layer image.
