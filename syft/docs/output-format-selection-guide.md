---
last_verified: 2026-09-03
tool_version: n/a
sources: []
---

# Syft output format selection guide

## Purpose

Syft can emit SBOMs and package manifests in several output formats. The right choice depends on what consumes the output next — a vulnerability scanner, a license compliance workflow, GitHub's dependency graph, or a human reading a terminal. This guide maps each format to its optimal integration target.

## When to use

| Integration target | Recommended format | Why |
|---|---|---|
| Vulnerability scanning (Grype, Trivy, Snyk) | CycloneDX JSON | Most scanners ingest CycloneDX directly; Grype appends findings into the `vulnerabilities` array |
| License compliance or legal audit | SPDX JSON or SPDX tag-value | ISO/IEC standard; `licenseConcluded` and `relationships` fields are expected by compliance tooling |
| GitHub dependency graph | GitHub JSON | Syft emits packages in the exact schema GitHub's dependency submission API expects; no post-processing required |
| Internal pipelines, quick extraction | Syft JSON | Smallest output, flat structure, no schema ceremony — fastest to parse with `jq` |
| Human review in CI logs | table | Column-aligned output designed for terminal readability; no downstream parsing needed |
| Air-gapped or archival storage | CycloneDX XML or SPDX tag-value | Text-based, line-oriented, and diff-friendly in git or artifact repositories |

## Prerequisites

- Syft installed and available on `PATH`.
- Target image, directory, or filesystem path to scan.

## Steps

### 1. Identify the downstream consumer

Before generating an SBOM, determine what will process it. If the next step is a vulnerability scanner, CycloneDX JSON is the safe default. If the SBOM feeds a compliance report, SPDX is the expected schema. If the output goes to GitHub's dependency graph, use `github-json`.

### 2. Generate in the selected format

Use the `-o` flag to specify the output format:

```bash
# Vulnerability scanner input
syft alpine:latest -o cyclonedx-json > sbom.cdx.json

# License audit
syft alpine:latest -o spdx-json > sbom.spdx.json

# GitHub dependency graph
syft alpine:latest -o github-json > sbom.github.json

# Internal pipeline, fast parsing
syft alpine:latest -o syft-json > sbom.native.json

# Human-readable CI output
syft alpine:latest -o table
```

### 3. Wire the output into the consumer

- **CycloneDX**: pass the file directly to Grype (`grype sbom:sbom.cdx.json`) or upload to a platform that accepts CycloneDX.
- **SPDX**: feed into license scanners such as FOSSology or ScanCode; the `packages[].licenseConcluded` field is the primary extraction target.
- **GitHub JSON**: submit via `gh attestation` or GitHub's dependency submission API; the schema matches `manifest["packageVersion"]` and `packageNodes[]` expectations.
- **Syft JSON**: parse with `jq`; the `artifacts[]` array is the entry point.

### 4. Lock the format in CI

Pin the output format in CI scripts rather than relying on defaults. Syft's default output is Syft JSON, which is not universally accepted by downstream tools. Explicit flags prevent silent format drift when Syft upgrades.

## Verify

1. Run `syft alpine:latest -o cyclonedx-json | jq '.bomFormat'` — should output `"CycloneDX"`.
2. Run `syft alpine:latest -o spdx-json | jq '.spdxVersion'` — should output a valid SPDX version string.
3. Run `syft alpine:latest -o github-json | jq '.packageVersion'` — should return the scanned image or directory reference.
4. Run `syft alpine:latest -o table | head -n 3` — should display column-aligned package rows.

## Common errors

- **Feeding Syft JSON to a CycloneDX consumer**: Grype and most vulnerability scanners expect `bomFormat: CycloneDX`. Syft's native JSON uses a different schema and will be rejected.
- **Missing `packageNodes` in GitHub JSON**: GitHub's submission API expects `packageNodes[]` with `packageName` and `version`. Older Syft versions emitted a flatter structure; verify the schema matches the target API version.
- **SPDX tag-value confusion**: The `tag-value` format is line-oriented and easy to diff, but many parsers expect JSON. Confirm the consumer supports tag-value before choosing it for automation.
- **Table output in scripts**: `-o table` is human-readable only. Piping it into `jq` or another parser will fail; reserve table for direct terminal inspection.

## References

- Syft output formats: `syft <target> --help` or `syft <target> -o help`
