# Following the Trivy quickstart

I followed the official Trivy quickstart (the one on their GitHub README) to get past just scanning single images. The primer and install notes from L1 got me through install and basic scans, so this time I wanted to try more of the scan types they advertise.

## What I did

Started with `trivy fs` to scan a local project directory without building a container:

```bash
trivy fs ./my-app
```

This scanned the filesystem for vulnerable dependencies — pip packages, npm modules, and the Go binary that was in there. It took about the same time as an image scan. The output is the same table format, just targeted at the filesystem instead of an image layer.

Then I tried `trivy repo`:

```bash
trivy repo https://github.com/velancio/vulnerable-api
```

This clones the repo to a temp directory and runs a filesystem scan. Handy for auditing open source projects before pulling them in. First run downloads the whole repo so it's slow if the repo is big.

I also tried `trivy config` to scan Kubernetes manifests and Terraform files for misconfigurations:

```bash
trivy config ./deploy/
```

It checks things like privileged containers, hostPath mounts, and IAM policies. Picked up a few things in my test YAML files.

## What tripped me up

- **`trivy repo` needs a clean workspace.** It failed the first time with a temp dir error because I had limited disk space in my VM. Trivy downloads the full repo before scanning.
- **`trivy config` and `trivy fs` have different severity scales.** Config checks use a different severity model (e.g., MEDIUM for missing security contexts) that doesn't map 1:1 to the vuln severity levels. That caught me off guard when I tried to filter by severity.
- **The quickstart example uses `--ignore-unfixed`** which I'd already seen but didn't fully grok. It suppresses findings where no fix version exists. Useful for reducing noise but you could miss knowing about a vulnerability if you ignore it too early.
- **Downloading the DB again.** I thought caching meant I'd never download again, but a new scan after 24 hours re-downloads it. Not a bug, just something I didn't notice in the docs.

## What I'd try next

I want to set up a GitHub Actions workflow that runs `trivy fs` on every PR and comments the results. Also want to try generating an SBOM with `trivy image --format cyclonedx` and piping it into `grype` for a comparison.
