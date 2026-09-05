---
last_verified: 2026-09-05
tool_version: n/a
sources: []
---

# Install OWASP ZAP and launch my first baseline scan

I wanted to try OWASP ZAP for automated web app scanning. The Docker image seemed like the quickest way in — no Java install, no desktop UI.

## What I tried

Pulled the stable Docker image and ran a baseline scan against a local test app:

```bash
docker run -t ghcr.io/zaproxy/zaproxy:stable zap-baseline.py -t http://host.docker.internal:8080
```

## What tripped me up

**Networking first.** The container can't reach `localhost` on the host. I had to use `host.docker.internal` (macOS/Windows) or `--network host` (Linux). Spent a few minutes staring at connection-refused errors before remembering this.

**The scan ran but found nothing.** Baseline mode only does passive scanning — it spiders the site and checks responses but doesn't inject payloads. I expected active findings and got zero. Had to read the docs to learn that `zap-full-scan.py` is the one that actually attacks the app.

**Report format.** The baseline outputs an HTML report by default, but I wanted JSON for CI integration. Flag `-r report.html` for HTML, `-J report.json` for JSON. Easy once you know, but the `--help` output is dense.

**ZAP isn't in PATH after Docker pull.** I kept trying `zap-baseline.py` directly until I remembered it's inside the container, not on the host.

## What I'd try next

Run `zap-full-scan.py` against a deliberately vulnerable app like DVWA to see real findings. Also want to try the ZAP Automation Framework for CI integration — YAML-based scan plans look more repeatable than CLI flags.
