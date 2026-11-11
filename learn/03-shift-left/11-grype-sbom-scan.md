---
last_verified: 2026-11-11
tool_version: "0.121.3"
sources:
  - https://github.com/anchore/grype/releases
---

# Scan the SBOM with Grype and compare with Trivy

The previous lesson taught you how to build an SBOM — a machine-readable inventory of every package in an image. This lesson picks up exactly there: you take that SBOM and scan it with Grype to find known vulnerabilities in those packages. You'll also see why Grype's report won't always match Trivy's for the same image, so you don't over-interpret a difference between the two scanners.

## What you'll learn

- Scan the SBOM with Grype
- Explain why Grype and Trivy can report different findings

## Before you start

- [Produce and read an SBOM with Syft](10-syft-sbom.md) — you need the `sbom.cyclonedx.json` and `sbom.spdx.json` files that lesson produced (the CycloneDX file is what Grype ingests directly).
- `grype` installed. Confirm with `grype --version`. This lesson was written against Grype v0.121.3; install it from the Anchore releases page if you don't have it.
- `jq` installed. Confirm with `jq --version`.

## Walkthrough

**1. Confirm the SBOM files exist.**

```bash
ls -lh sbom.cyclonedx.json sbom.spdx.json
```

You should see: both files listed with non-zero sizes. These came from the previous lesson's scan of `alpine:latest`.

**2. Scan the CycloneDX SBOM with Grype.**

Grype can scan an SBOM directly with the `sbom:` prefix, so you don't need the image or a cluster:

```bash
grype sbom:sbom.cyclonedx.json
```

You should see: a table of findings with one row per vulnerability — package name, installed version, the vulnerability ID, its severity, and the fixed version (if one exists). If the image had nothing above the default threshold, Grype prints a short no-findings message instead, which is still a valid result.

**3. Save machine-readable output and inspect it.**

```bash
grype sbom:sbom.cyclonedx.json --output json > grype-results.json
```

You should see: `grype-results.json` written with no terminal error.

Now count findings by severity with `jq`:

```bash
jq '[.Matches[]? | .Vulnerability.Severity] | group_by(.) | map({severity: .[0], count: length})' grype-results.json
```

You should see: an array of `{severity, count}` objects, one per severity level present in the scan.

**4. Understand why Grype and Trivy can disagree.**

Grype and Trivy are both reputable scanners, but they will not always flag the same vulnerabilities for the same image. A few reasons:

- **Different vulnerability databases.** Grype downloads its own database (maintained by Anchore) on first run; Trivy uses its own (maintained by Aqua Security). They update on different schedules and may ingest different advisories, so one can know about a CVE the other hasn't indexed yet.
- **Different package identification.** Each scanner parses installed packages and maps them to vulnerability records (often via CPE) in its own way, so a package version might match in one scanner but not the other.
- **Different severity mappings.** The same CVE can be rated medium by one scanner and high by another.
- **Different default scopes.** Whether unfixed vulnerabilities, OS packages, or language packages are included varies by scanner and by default flags.

Because of this, treat the two reports as complementary signals rather than contradictory ones. A finding that appears in Grype but not Trivy isn't necessarily a false positive — and vice versa.

## Exercise

On your own, without looking at the walkthrough answers:

1. Re-run the Syft step from the previous lesson against a container image of your choice (or reuse `alpine:latest`) to produce a fresh CycloneDX SBOM.
2. Scan that SBOM with Grype, both as a table and saving JSON output.
3. Inspect the JSON output with `jq` to list the vulnerability IDs and severities Grype found.
4. If you have Trivy installed, scan the same image with `trivy image <image>` and note any finding that appears in one scanner but not the other.

Do not include your solution inline — run the commands yourself.

## Check your work

- `grype --version` reports Grype 0.121.3 (or later).
- `sbom.cyclonedx.json` exists from the previous lesson.
- `grype sbom:sbom.cyclonedx.json` runs without error and prints a findings table (or a no-findings message).
- `grype-results.json` exists and `jq '.Matches | length'` prints the number of Grype matches found.
- You can explain, in your own words, two reasons Grype and Trivy might report different findings for the same image.

## Common mistakes

- Scanning the image with `grype alpine:latest` instead of the SBOM: both work, but this lesson's point is scanning the SBOM artifact your CI already produced, which works offline and in air-gapped pipelines.
- Assuming every Grype finding is a Trivy finding (and vice versa): database, parser, and severity differences mean the two scanners legitimately disagree sometimes.
- Treating Syft's native JSON as the SBOM Grype wants: feed Grype the CycloneDX file (`sbom.cyclonedx.json`), not Syft's native output schema.

## Next

[Sign the image and attach the SBOM with Cosign](12-cosign-sign.md)
