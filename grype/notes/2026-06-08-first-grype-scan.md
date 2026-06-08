# Installed Grype and ran my first vulnerability scan

I installed Grype to scan container images for known vulnerabilities.

```
curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin
grype alpine:latest
```

The first scan downloaded the vulnerability database, then showed Alpine had 0 CVEs. Tried `grype nginx:latest` next — that found a handful of low-severity issues.

## What I noticed
- The `--only-fixed` flag filters out vulns without a fix available, which cuts down noise
- `grype <image> -o json` gives structured output I could pipe to jq
- `--fail-on high` would be useful for CI gating

Next I want to try scanning an SBOM file with `grype sbom:output.json` and compare results with Trivy.
