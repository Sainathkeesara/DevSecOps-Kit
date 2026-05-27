# Syft — quick primer

> First-day notes for someone who's never used Syft. Personal voice, plain language.

## What is it?

Syft is a CLI tool that generates software bills of materials (SBOMs) from container images and filesystems. If you know what Trivy does for vulnerability scanning — Syft is like the inventory side of that coin. It catalogs every package, library, and dependency it finds in an image or directory and spits it out in a structured format. Anchore makes it.

## What does it do?

You point Syft at a container image (like `docker pull` first, then `syft`), or at a local directory, and it walks the filesystem looking for package managers (apt, pip, npm, apk, gem, etc.), reads their lockfiles or database files, and builds a complete inventory. It can output in CycloneDX JSON, SPDX JSON, or a simple table format.

## Why does it exist?

Before Syft, generating an SBOM meant either trusting your CI/CD pipeline to track dependencies (which it never did comprehensively) or manually listing packages. For compliance frameworks like SLSA or supply-chain security audits, you need a repeatable, automatic way to say "here's exactly what's in this image." Syft gives you that. The SBOM it creates can then be fed to Grype (also by Anchore) for vulnerability scanning — though Trivy also accepts Syft output.

## Key terminology

- **SBOM** — Software Bill of Materials. A formal inventory of all components in a piece of software. Example: `syft alpine:latest` outputs a list of every package in the Alpine image.
- **CycloneDX** — An OWASP-standard SBOM format (XML or JSON). Example: `syft alpine:latest -o cyclonedx-json` produces a CycloneDX JSON document.
- **SPDX** — Another SBOM standard from the Linux Foundation, widely used in legal/compliance. Example: `syft alpine:latest -o spdx-json`.
- **Package cataloger** — The internal module Syft uses to detect a specific package manager's artifacts. Example: the `python` cataloger reads `site-packages` directories; the `deb` cataloger reads the dpkg database.
- **Image source** — How you tell Syft what to scan: `docker:` (from local Docker daemon), `registry:` (pull directly from a registry), `dir:` (a local directory), `tar:` (a saved image tarball). Example: `syft dir:./myapp`.
- **Grype** — Anchore's vulnerability scanner that consumes Syft SBOMs. Example: `syft alpine:latest -o json | grype` pipes the SBOM directly into Grype.

## A tiny example

```bash
# Generate an SBOM from a public image and print it as a table
syft alpine:latest
```

That's it. One command. It pulls the latest Alpine image (if not cached), walks the filesystem, and prints every package with its version and type (apk, binary, etc.). The output looks like a table with columns for Name, Version, and Type.

## What I'll cover next

Now that I know what Syft is and how the basic command works, I want to actually install it and generate my first real SBOM — then try outputting in CycloneDX and SPDX formats to see how they compare for different downstream tools.
