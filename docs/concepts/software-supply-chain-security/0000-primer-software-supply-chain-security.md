# Software Supply Chain Security — quick primer

> First-day notes on Software Supply Chain Security. What it is, why it matters, and the key ideas to know.

## What is it?

Software supply chain security is about making sure the code and dependencies you pull into your project haven't been tampered with. I think of it like the food supply chain — you trust that the bag of flour you bought at the store doesn't have sawdust mixed in, because there are inspections and quality checks along the way. Software works the same way, except the sawdust is malicious code hidden in an open-source package.

Every project I build pulls in dozens or hundreds of dependencies. Each one is a link in the chain. If any link is compromised — a maintainer's account gets hijacked, a build server gets popped, a malicious contributor sneaks in a backdoor — that tainted code becomes part of my software too.

## Why does it matter for DevSecOps?

Supply chain attacks are on the rise because they're efficient for attackers. Instead of breaking into one company, they compromise a widely-used library and get access to thousands of companies that depend on it. The SolarWinds attack and the xz utils backdoor are the most famous examples, but smaller ones happen constantly.

For DevSecOps, supply chain security means I need to verify everything that enters my pipeline: dependencies should be scanned for known vulnerabilities, container images should be signed so I know they came from a trusted build, and any change to source dependencies should be auditable.

## Key terminology

- **SBOM (Software Bill of Materials)** — A machine-readable inventory of every component in your software. Like a nutrition label but for code. Example: Syft generating an SPDX-formatted SBOM for a container image so I can check every layer's contents.
- **SLSA (Supply-chain Levels for Software Artifacts)** — A security framework that grades how trustworthy a build pipeline is. Level 1 means there's provenance; Level 4 means the build is fully hermetic and verifiable.
- **Provenance** — Metadata about who or what produced an artifact and how. Example: a signed attestation saying "this binary was built from commit abc123 by GitHub Actions workflow ci.yml."
- **Signing** — Cryptographically proving that an artifact came from a specific source. Example: using Cosign to sign a container image so a deployment gate can verify the signature before allowing it to run.
- **Dependency confusion** — A technique where an attacker publishes a package with the same name as a private internal package to a public registry. If the build tool checks the public registry first, it pulls the malicious version.
- **Typosquatting** — Publishing a package with a name that looks like a popular one (e.g., `requsts` instead of `requests`). Someone typing fast installs the wrong one.
- **Registry** — A server that stores and serves packages or container images. Public (npm, PyPI, Docker Hub) and private (Artifactory, GitHub Container Registry).
- **Attestation** — A signed statement about something in the supply chain. Example: an in-toto attestation that records every command run during a build.

## A concrete example

Here's a minimal verification workflow showing why supply chain security matters. I check a container image's signature before deploying:

```bash
# Download an unsigned image and run it — no way to know who built it
docker pull myapp:latest
docker run myapp:latest

# With signing, the deploy gate checks first
cosign verify --key cosign.pub myapp:latest || exit 1
kubectl apply -f deployment.yaml
```

Without signing, that image could have been built by anyone — including an attacker who compromised the CI. With signing, I know the deploy gate only lets images with a valid signature through.

## How this connects to what's next

Supply chain security ties together dependency scanning (Trivy, Grype, Snyk), artifact signing (Cosign), SBOM generation (Syft), and build integrity frameworks (SLSA, in-toto). Each of those tools addresses one link in the chain, and understanding the full picture is what makes supply chain security more than just running a scanner.
