# Syft — quick primer

> First-day notes for someone who's never used Syft. Personal voice, plain language.

## What is it?

Just learned about Syft today. It's a CLI tool that generates a software bill of materials (SBOM) from container images or directories. Think of it as an inventory camera — point it at an image and it tells you every package inside.

## What does it do?

You give it `syft alpine:latest` and it walks the filesystem looking for package managers (apt, pip, npm, etc.), reads their databases, and prints a table of everything installed — name, version, type. It can output JSON, CycloneDX, or SPDX format.

## Why does it exist?

Before Syft, I'd have to manually track what's in my images or trust the build logs. For supply-chain audits or SLSA compliance, you need a repeatable inventory. Syft generates SBOMs that Grype or Trivy can then scan for vulnerabilities.

## Key terminology

- **SBOM** — Software Bill of Materials, the full inventory of packages in an image. `syft alpine:latest` outputs one.
- **CycloneDX** — OWASP-standard SBOM format. Use `-o cyclonedx-json`.
- **SPDX** — Linux Foundation SBOM standard. Use `-o spdx-json`.
- **Package cataloger** — The module that detects a specific package manager (python, deb, apk, etc.).
- **Image source** — Where Syft reads from: `docker:`, `registry:`, `dir:`, `tar:`.

## A tiny example

```bash
syft alpine:latest
```

One command gives you a table of every package, version, and type.

## What I'll cover next

I want to install it, generate SBOMs in CycloneDX and SPDX, then pipe them into Grype for vulnerability scanning.
