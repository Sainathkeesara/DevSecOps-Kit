# SBOM format comparison: SPDX vs CycloneDX vs Syft JSON

## Purpose

When generating Software Bill of Materials (SBOMs) with Syft, the output format determines tooling compatibility, metadata richness, and integration potential. Syft supports three primary SBOM formats: its native JSON format, CycloneDX, and SPDX. This doc compares these formats for practical integration into DevSecOps pipelines — when to use each and what tradeoffs they carry.

## Steps

### 1. Generate SBOMs in all three formats

Syft's `-o` (output) flag accepts format specifiers. The commands below produce equivalent SBOMs for `alpine:latest`:

```bash
syft alpine:latest -o syft-json > alpine-syft.json
syft alpine:latest -o cyclonedx-json > alpine-cdx.json
syft alpine:latest -o spdx-json > alpine-spdx.json
```

Each format produces valid output, but the structures differ significantly.

### 2. CycloneDX format

CycloneDX is designed for security tooling integration. Key characteristics:

- **Schema**: Well-defined JSON schema (1.5+), widely adopted across vulnerability scanners
- **Structure**: Components array with `bom-ref` identifiers for cross-referencing
- **Metadata**: `metadata.tools` array tracks generation toolchain; `vulnerabilities` array can be populated via Grype

The CycloneDX output includes a `metadata` block identifying Syft as the tool, and each component gets a `bom-ref` that persists across scans. When piped through Grype, vulnerability findings are injected directly into the `vulnerabilities` array.

### 3. SPDX format

SPDX is the Linux Foundation's legal-standard format, optimized for license compliance and supply chain integrity.

- **Schema**: Official JSON schema (2.3+), ISO/IEC standard
- **Structure**: `packages` array with `SPDRef-xxx` identifiers instead of bom-refs
- **Metadata**: `creationInfo` captures creator identity, creation date, and document namespace (a UUID)
- **Relationships**: `relationships` array links packages via semantic relationships

SPDX includes `DataLicense` (CC0-1.0), `documentNamespace`, and `creationInfo` blocks that CycloneDX omits. The `relationships` array can express dependency chains, which is useful for multi-layer container images where packages span different layers.

### 4. Syft JSON format

Syft's native format is a direct serialization of its internal artifact model.

- **Schema**: Informal; structure changes with Syft releases
- **Structure**: Flat `artifacts` array with `id`, `name`, `version`, `type`, `locations`, `licenses`, `cpes`, `purl` fields
- **Metadata**: Minimal; just the artifact data with no document-level assertions

Syft JSON is the smallest output (roughly 50% smaller than SPDX for equivalent images) because it strips all standard SBOM metadata. This makes it ideal for internal tooling or when Syft is the only consumer.

### 5. Format selection guide

| Use case | Recommended format | Reason |
|----------|-------------------|--------|
| Security pipeline, integrates with scanners | CycloneDX | Native vulnerability array, tool metadata, widely supported |
| License compliance, legal review | SPDX | Standard document model, relationship graph, ISO acceptance |
| Internal tooling, Syft-only consumption | Syft JSON | Minimal, stable internal structure, smallest file size |

### 6. Validation

Validate output structure before integrating into pipelines:

```bash
jq 'keys' alpine-cdx.json   # CycloneDX: ["bom", "components", "vulnerabilities"]
jq 'keys' alpine-spdx.json   # SPDX: ["creationInfo", "dataLicense", "packages", "relationships"]
jq 'keys' alpine-syft.json   # Syft JSON: ["artifacts"]
```

## Verify

1. Run all three commands against a test image and confirm each produces valid JSON.
2. Check that CycloneDX output includes a `metadata.tools[]` entry identifying Syft.
3. Verify SPDX includes `creationInfo.created` timestamp and `documentNamespace` UUID.
4. Confirm Syft JSON has the simplest structure with just an `artifacts` array.