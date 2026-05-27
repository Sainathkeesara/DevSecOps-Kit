# Syft — quick primer

> First-day notes for someone who's never used Syft. Personal voice, plain language.

Just learned about Syft today. It's a CLI tool that generates a software bill of materials (SBOM) from container images or directories. Think of it as an inventory camera — point it at an image and it tells you every package inside.

You give it an image name like `syft alpine:latest` and it walks the filesystem looking for package managers (apt, pip, npm, etc.), reads their databases, and prints a table of everything installed.

Before Syft, I'd have to manually track what's in my images or trust the build logs. For supply-chain audits or SLSA compliance, you need a repeatable inventory. Syft sits in that spot — generates SBOMs that Grype or Trivy can then scan for vulnerabilities.

Key terms I hit today:
- **SBOM** — Software Bill of Materials, the full inventory. `syft alpine:latest` outputs one.
- **CycloneDX** — OWASP-standard SBOM format. `syft alpine:latest -o cyclonedx-json`.
- **SPDX** — Linux Foundation SBOM standard. `syft alpine:latest -o spdx-json`.
- **Package cataloger** — The module that detects a specific package manager (python, deb, apk, etc.).
- **Image source** — Where Syft reads from: `docker:`, `registry:`, `dir:`, `tar:`.

```bash
# One-command SBOM
syft alpine:latest
```

That's the whole thing — one command gives you a table of every package, version, and type.

Next I want to install it and generate SBOMs in both CycloneDX and SPDX to see how they differ for downstream tools.
