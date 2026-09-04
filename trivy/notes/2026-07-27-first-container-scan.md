---
last_verified: 2026-09-04
tool_version: n/a
sources: []
---

# Install Trivy and scan my first container image

I wanted to see what vulnerabilities were hiding in a container image I had built locally. I'd heard Trivy mentioned in CI pipelines but had never run it myself.

I installed Trivy using Homebrew on my Mac — `brew install aquasecurity/trivy/trivy`. One line, done. No binary downloads or apt repository juggling.

Then I picked a quick target — the official `nginx:alpine` image that was already cached. I ran:

```bash
trivy image nginx:alpine
```

The first thing it did was download the vulnerability database, which took a couple of minutes. Then it printed a table — Library, Vulnerability ID, Severity, and a Fixed version column. I saw entries for `busybox` and `apk-tools`, mostly MEDIUM. One was HIGH with a fix version available.

I tried filtering to just the serious stuff:

```bash
trivy image --severity HIGH,CRITICAL nginx:alpine
```

Down to one finding. I also tried JSON output to dig deeper:

```bash
trivy image --format json nginx:alpine | jq '.Results[].Vulnerabilities[]'
```

The JSON has nested results per package target, which took a minute to navigate. Each finding has a description, severity, and details for looking things up later.

What I'd try next: run Trivy in a Dockerfile build pipeline, or scan a local directory with `trivy fs .` to catch issues before building the image at all.
