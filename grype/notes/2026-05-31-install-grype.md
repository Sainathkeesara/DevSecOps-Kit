# Installing Grype and running my first scan

Installed Grype with the official script:

```
curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin
```

Ran `grype alpine:latest`. It downloaded the vulnerability database first (took ~30s), then printed a table of findings. Alpine had 0 vulnerabilities.

## What worked
- Install script was one-liner, no dependencies
- `grype alpine:latest` — clean, no CVEs
- `grype debian:latest` found a bunch of low/medium CVEs
- Output shows package, installed version, fixed version, severity

## Got stuck on
- First scan made me think I needed Syft installed separately. I don't — Grype bundles its own Syft internally to catalog packages.
- Forgot `--only-fixed` at first. Without it, Grype shows unfixed vulnerabilities too, which is noisy.
- Ran `grype .` on a project directory and it scanned `node_modules` — need `--exclude` next time.

## What I'd try next
- `grype nginx:latest --only-fixed --fail-on high` for CI gating
- Generate an SBOM with Syft first, then scan it offline with `grype sbom:output.json`
- Compare Grype's results to Trivy for the same image
