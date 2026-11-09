---
last_verified: 2026-11-06
tool_version: "1.57.0"
sources:
  - https://github.com/anchore/syft/releases
  - https://github.com/anchore/syft/blob/main/README.md
---

# Produce and read an SBOM with Syft

You can now build and push the sample app image and gate it with Trivy in CI. The missing piece is an inventory: a machine-readable list of exactly what's inside the image, so you can prove what was shipped and trace any package back to its version. This lesson picks up where the Trivy CI gate left off and adds Syft to generate SPDX and CycloneDX SBOMs for an image — the inventory that Grype and Trivy will later scan for vulnerabilities.

## What you'll learn

- Generate an SPDX SBOM for a container image
- Generate a CycloneDX SBOM for a container image
- Find a given package and its version in either SBOM format

## Before you start

- [Software supply chain security — concepts](../../docs/concepts/software-supply-chain-security/0000-primer-software-supply-chain-security.md) — SBOMs are the inventory layer of supply chain security; Syft is one tool that produces them.
- [Gate the image on Trivy findings in CI](./09-trivy-ci-gate.md) — you've already wired a Trivy image scan into CI, so you have a build-and-push image target to scan.
- `syft` installed. Confirm with `syft --version`. Install the latest stable release (v1.57.0) with:
  `curl -sSfL https://get.anchore.io/syft | sudo sh -s -- -b /usr/local/bin`
- `jq` installed. Confirm with `jq --version`.

## Walkthrough

**1. Pick a target image.**

```bash
IMAGE="alpine:latest"
```

You should see: the variable set with no error. `alpine:latest` is small and fast to scan, making it a good first target.

**2. Generate a CycloneDX SBOM.**

CycloneDX is the OWASP standard format that vulnerability scanners such as Grype ingest directly.

```bash
syft "$IMAGE" -o cyclonedx-json > sbom.cyclonedx.json
```

You should see: a JSON file written to `sbom.cyclonedx.json` with no terminal error. Confirm it parsed as CycloneDX:

```bash
jq '.bomFormat' sbom.cyclonedx.json
```

You should see: `"CycloneDX"`.

**3. Generate an SPDX SBOM.**

SPDX is the Linux Foundation standard, widely used for license compliance and legal audits.

```bash
syft "$IMAGE" -o spdx-json > sbom.spdx.json
```

You should see: `sbom.spdx.json` written with no error. Confirm it parsed as SPDX:

```bash
jq '.spdxVersion' sbom.spdx.json
```

You should see: a valid SPDX version string (for example `SPDX-2.3`).

**4. Find a given package and its version.**

Package lookup is format-dependent: SPDX lists packages under `packages[]`, CycloneDX lists them under `components[]`. Don't assume one field path works for both.

Find `apk-tools` (Alpine's package manager) in the SPDX SBOM:

```bash
jq '.packages[] | select(.name == "apk-tools") | {name, version}' sbom.spdx.json
```

You should see: an object with the package `name` and its `version`.

Find the same package in the CycloneDX SBOM:

```bash
jq '.components[] | select(.name == "apk-tools") | {name, version}' sbom.cyclonedx.json
```

You should see: the same package name, with its version under the CycloneDX `version` field.

The two reports describe the same image but with different schemas — which is exactly why you inspect each format on its own terms rather than copying a jq filter from one to the other.

## Exercise

On your own, do the following without looking at the walkthrough answers:

1. Choose a container image (any image you can reach) and generate both an SPDX SBOM and a CycloneDX SBOM for it with Syft.
2. Pick one package that appears in both reports.
3. Print that package's name and version from each file using a format-appropriate `jq` filter, and note how the field paths differ between SPDX and CycloneDX.
4. Confirm your Syft version with `syft --version`.

Do not include your solution inline — write the commands and run them yourself.

## Check your work

- `syft --version` reports Syft 1.57.0 (or later).
- `sbom.cyclonedx.json` exists and `jq '.bomFormat' sbom.cyclonedx.json` outputs `"CycloneDX"`.
- `sbom.spdx.json` exists and `jq '.spdxVersion' sbom.spdx.json` outputs a valid SPDX version string.
- A `jq` filter prints the chosen package's `name` and `version` from `sbom.spdx.json` (`.packages[]`) and from `sbom.cyclonedx.json` (`.components[]`).

## Common mistakes

- Conflating the SBOM inventory with vulnerability scanning: Syft lists what's in the image; Grype/Trivy are the tools that then flag known vulnerabilities in that list.
- Feeding Syft's native JSON to a CycloneDX consumer: scanners such as Grype expect `bomFormat: CycloneDX` and will reject Syft's native schema.
- Assuming one field path for package+version: SPDX uses `packages[].name`/`version` while CycloneDX uses `components[].name`/`version` — inspect each format on its own terms.

## Next

[Scan the SBOM with Grype and compare with Trivy](../../00_index/learning-path.md)