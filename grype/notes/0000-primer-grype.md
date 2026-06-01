# Grype — quick primer

I kept hearing about Grype at work — Anchore's vulnerability scanner for containers. It pairs with Syft (same team) to find known vulnerabilities in images and filesystems.

Grype takes an image name, a directory, or an SBOM file and checks every package it finds against a vulnerability database. It tells you what's vulnerable, how bad it is, and what version fixes it.

Before Grype, I'd have used Trivy or Clair. What's different is Grype is built to work with Syft — you can generate an SBOM with Syft and scan it later with Grype offline. That decoupling is useful for air-gapped CI pipelines.

Key terms I ran into:
- **SBOM** — A list of every package in an image. Grype can scan these directly.
- **CPE** — A standard way to identify software versions so vulnerability databases can match them.
- **Severity** — Grype rates findings negligible / low / medium / high / critical. I'll focus on high+critical.
- **Match** — How Grype decided a package maps to a CVE. Exact CPE match, or indirect match.
- **DB** — Grype downloads a vulnerability database on first run. Needs occasional updates.

Smallest example:
```
grype alpine:latest
```
One command. Downloads the DB, scans the image, prints a table of vulnerabilities.

Next I want to install it, scan a few real images, and compare the output to Trivy's.
