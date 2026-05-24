# Trivy — quick primer

> First-day notes for someone who's never used Trivy. Personal voice, plain language.

## What is it?

Trivy is a vulnerability scanner for containers, filesystems, and code repositories. Think of it like `clamav` but for container images and dependencies — it looks at what's inside an image (packages, libraries, OS packages) and checks each one against public vulnerability databases. It's built by Aqua Security, and it's one of those tools that just works out of the box with almost no config.

I came across it while looking for something simpler than running `grype` or setting up a full Clair pipeline. Trivy won on "easiest to try."

## What does it do?

It scans a target (a Docker image, a filesystem directory, a Git repo, a Kubernetes manifest, or even an SBOM file) and prints a table of every vulnerability it finds — which package, which CVE, severity level, and whether a fix is available. It also tells you if there's a fixed version you should upgrade to.

## Why does it exist?

Before Trivy, scanning a container image meant either paying for a commercial product (Snyk, Aqua, Twistlock) or running something heavyweight like Clair that needed a database server and a bunch of setup. Trivy downloads its vulnerability database once and caches it locally. No server, no daemon, no API keys. You just point it at an image and it goes. Devs and CI/CD pipelines love it because it's a single binary and a one-liner.

## Key terminology

- **Vulnerability database** — Trivy downloads a local cache of CVEs from sources like NVD, Red Hat, Debian, Alpine, and GitHub Security Advisories. This is what it compares your packages against. Example: `trivy image --download-db-only` to pre-fetch the DB.
- **SBOM (Software Bill of Materials)** — A machine-readable list of every component in your software. Trivy can generate SBOMs in CycloneDX or SPDX format and also scan existing SBOMs for vulnerabilities. Example: `trivy image --format cyclonedx myimage:latest`.
- **Severity** — Trivy ranks findings as CRITICAL, HIGH, MEDIUM, LOW, or UNKNOWN based on CVSS scores. You can filter by severity. Example: `trivy image --severity CRITICAL,HIGH myimage:latest`.
- **Fix version** — The column in Trivy output that tells you what version of a package patches the CVE. If this column is empty, no fix exists yet. Example: looking at output and seeing `Fixed Version: 1.2.3` means upgrade to that.
- **Target** — What Trivy is scanning. A target can be an OS (like Alpine 3.18), a language-specific package set (like Python pip packages, Node npm packages, Java JARs), or a filesystem. Example: Trivy lists each target separately in its output.

## A tiny example

```bash
trivy image --severity CRITICAL alpine:latest
```

This scans the official Alpine Linux image for critical-severity vulnerabilities only. First run downloads the vulnerability DB (a few hundred MB), subsequent runs reuse the cache. Output is a table listing each CVE, the affected package, and whether a fix exists.

## What I'll cover next

I want to get Trivy running on a real container image and look at the full report — not just CRITICALs but everything. Then I'll write a small script that wraps Trivy for CI/CD so I can fail a pipeline build if any HIGH or CRITICAL vulns show up in a new image.
