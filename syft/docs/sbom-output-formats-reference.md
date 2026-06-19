# Syft SBOM output formats reference

## Purpose

Syft can output SBOMs in three formats: its native JSON, CycloneDX, and SPDX. This reference documents the structure of each format so you can navigate the output, extract fields, and wire them into downstream tools without guessing keys.

## Output structure by format

### Syft JSON (native)

The native format is the simplest — a flat array of discovered artifacts.

```json
{
  "artifacts": [
    {
      "id": "1b8e2a4f9c3d7e5f",
      "name": "openssl",
      "version": "3.3.0",
      "type": "apk",
      "locations": [
        {
          "path": "/lib/apk/db/installed",
          "layerID": "sha256:a1b2c3d4..."
        }
      ],
      "licenses": ["Apache-2.0"],
      "cpes": ["cpe:2.3:a:openssl:openssl:3.3.0:*:*:*:*:*:*:*"],
      "purl": "pkg:apk/alpine/openssl@3.3.0?arch=x86_64",
      "metadata": {
        "source": {
          "id": "alpine",
          "version": "3.20"
        }
      }
    }
  ],
  "source": {
    "type": "image",
    "target": {
      "userInput": "alpine:latest",
      "imageID": "sha256:b4c5d6e7..."
    }
  },
  "descriptor": {
    "name": "syft",
    "version": "1.6.0"
  }
}
```

Key fields:

- `artifacts[]` — all discovered packages; each has `name`, `version`, `type`, `locations`, `licenses`, `cpes`, `purl`
- `source` — what was scanned (image, directory, file)
- `descriptor` — Syft version that generated the SBOM

### CycloneDX JSON

CycloneDX wraps artifact metadata in a formal JSON schema designed for security tooling.

```json
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.5",
  "version": 1,
  "metadata": {
    "timestamp": "2026-06-19T10:00:00Z",
    "tools": [
      {
        "vendor": "anchore",
        "name": "syft",
        "version": "1.6.0"
      }
    ],
    "component": {
      "name": "alpine:latest",
      "type": "container"
    }
  },
  "components": [
    {
      "bom-ref": "pkg:apk/alpine/openssl@3.3.0?arch=x86_64",
      "type": "library",
      "name": "openssl",
      "version": "3.3.0",
      "licenses": [
        {
          "license": {
            "id": "Apache-2.0"
          }
        }
      ],
      "purl": "pkg:apk/alpine/openssl@3.3.0?arch=x86_64",
      "properties": [
        {
          "name": "syft:package:foundBy",
          "value": "apk-db-cataloger"
        }
      ]
    }
  ],
  "dependencies": [
    {
      "ref": "pkg:apk/alpine/openssl@3.3.0?arch=x86_64",
      "dependsOn": []
    }
  ]
}
```

Key fields:

- `bomFormat` / `specVersion` — format identifier and version
- `metadata.tools[]` — generation toolchain; Grype appends itself here
- `components[]` — each package with `bom-ref` for cross-referencing
- `dependencies[]` — dependency graph (often empty for container scans)
- Vulnerabilities can be added to a `vulnerabilities[]` array by Grype

### SPDX JSON

SPDX follows the ISO/IEC 5962 standard. Its structure is document-oriented with a package list.

```json
{
  "spdxVersion": "SPDX-2.3",
  "dataLicense": "CC0-1.0",
  "SPDXID": "SPDXRef-DOCUMENT",
  "name": "alpine:latest",
  "creationInfo": {
    "created": "2026-06-19T10:00:00Z",
    "creators": [
      "Tool: syft-1.6.0"
    ]
  },
  "packages": [
    {
      "SPDXID": "SPDXRef-1b8e2a4f9c3d7e5f",
      "name": "openssl",
      "versionInfo": "3.3.0",
      "supplier": "Organization: Alpine Linux",
      "downloadLocation": "NOASSERTION",
      "filesAnalyzed": false,
      "licenseConcluded": "Apache-2.0",
      "licenseDeclared": "Apache-2.0",
      "externalRefs": [
        {
          "referenceCategory": "PACKAGE-MANAGER",
          "referenceType": "purl",
          "referenceLocator": "pkg:apk/alpine/openssl@3.3.0?arch=x86_64"
        }
      ]
    }
  ],
  "relationships": [
    {
      "spdxElementId": "SPDXRef-DOCUMENT",
      "relatedSpdxElement": "SPDXRef-1b8e2a4f9c3d7e5f",
      "relationshipType": "DESCRIBES"
    }
  ]
}
```

Key fields:

- `spdxVersion` / `dataLicense` — standard identifiers
- `creationInfo` — document creator (Syft) and timestamp
- `packages[]` — each with `SPDXID`, `name`, `versionInfo`, `licenseConcluded`, `externalRefs`
- `relationships[]` — links between document and packages

## Format selection

| When | Format | Reason |
|------|--------|--------|
| Feeding a vulnerability scanner | CycloneDX | Grype injects findings into `vulnerabilities[]` |
| License compliance or legal audit | SPDX | ISO standard, `licenseConcluded` field, relationship graph |
| Internal tooling, quick extraction | Syft JSON | Flattest structure, smallest file, no schema ceremony |

## Extract key fields with jq

```bash
# Syft JSON: list all package names and versions
jq -r '.artifacts[] | "\(.name) \(.version)"' alpine-syft.json

# CycloneDX: list components with bom-ref
jq -r '.components[] | "\(.name) \(.version) \(."bom-ref")"' alpine-cdx.json

# SPDX: list packages with license
jq -r '.packages[] | "\(.name) \(.versionInfo) \(.licenseConcluded)"' alpine-spdx.json
```

## Verify

1. Run `syft alpine:latest -o syft-json | jq '.artifacts | length'` — should return a positive integer
2. Run `syft alpine:latest -o cyclonedx-json | jq '.bomFormat'` — should output `"CycloneDX"`
3. Run `syft alpine:latest -o spdx-json | jq '.spdxVersion'` — should output `"SPDX-2.3"`

## Common errors

- **Missing `bom-ref` in CycloneDX**: occurs with older Syft versions (< 0.90). Upgrade to 1.x.
- **`filesAnalyzed: false` in SPDX**: Syft does not analyze individual files in container scans; this is expected.
- **`purl` mismatch across formats**: Syft JSON uses `purl` at top level; CycloneDX uses it inside `components[].purl`; SPDX puts it in `externalRefs[]`.

## References

- [Syft output format docs](https://github.com/anchore/syft#output-formats)
- [CycloneDX 1.5 JSON schema](https://cyclonedx.org/specification/overview/)
- [SPDX 2.3 JSON schema](https://spdx.dev/specifications/)
