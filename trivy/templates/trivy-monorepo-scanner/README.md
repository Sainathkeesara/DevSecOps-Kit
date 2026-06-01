# Trivy Monorepo Scanner

A project scaffold for scanning container images, filesystem paths, and Git repository
history in a monorepo using Trivy.

## Purpose

Monorepos often bundle multiple services, each with their own Dockerfiles, language
dependencies, and infrastructure configs. A single `trivy fs .` misses image-specific
vulnerabilities, and maintaining separate scan commands for every target is error-prone.
This scaffold centralises the target list in one place (`trivy.yaml`) and provides a
unified entry point — one way to keep scans consistent across a team.

## When to use

- Your repo contains more than one Dockerfile or service.
- You want CI to catch regressions in any part of the monorepo.
- You need SARIF output for GitHub code-scanning integration.

## Structure

```
├── trivy.yaml                  # Target definitions and scan options
├── Makefile                    # Common task shortcuts
├── .trivyignore                # False-positive / acknowledged vulnerabilities
├── scripts/
│   └── scan-all.sh             # Multi-target scan entry point
└── .github/workflows/
    └── ci-scan.yml             # GitHub Actions CI workflow
```

## Prerequisites

- Trivy CLI v0.50+ (install via `brew`, `rpm`, `deb`, or the official script)
- Docker (only needed if you run image scans locally)
- `gh` CLI (optional, for creating PR annotations from SARIF)

## Quick start

1. Copy the scaffold into your monorepo root.
2. Edit `trivy.yaml` — add your image names, filesystem paths, and Git targets.
3. Run `make scan` to scan everything locally.
4. Push to GitHub — the CI workflow runs on every PR and push to `main`.

## Configuration

Edit `trivy.yaml`:

| Field | Description |
|-------|-------------|
| `images` | List of image references with optional Dockerfile paths |
| `fs-paths` | Directories to scan as filesystems |
| `git-paths` | Git repos / subdirectories to scan for history |
| `severity` | Minimum severity to report (`UNKNOWN`, `LOW`, `MEDIUM`, `HIGH`, `CRITICAL`) |
| `scan.skip-dirs` | Directories to exclude from filesystem scans |

## Verify

After `make scan`, results appear in `trivy-results/`:

```
trivy-results/
├── images.sarif
├── filesystem.sarif
├── git.sarif
└── images.log        # (also fs.log, git.log)
```

Upload `*.sarif` files to GitHub code scanning or open them in a SARIF viewer.
