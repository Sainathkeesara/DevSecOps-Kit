---
last_verified: 2026-11-04
tool_version: n/a
sources:
  - /work/research.md
---

# Scan the running app with ZAP

ZAP is the DAST tool in our shift-left pipeline: it spiders and probes the running app, so this lesson picks up where the Cosign lesson left off by adding dynamic testing before release.

## What you'll learn
- Run a ZAP baseline scan against the running sample app
- Read the report and decide which alerts need a fix

## Before you start
- [Application security testing — SAST, DAST, SCA and secrets](../../docs/concepts/application-security-testing-concepts/0000-primer-application-security-testing-concepts.md) — what DAST is and where it fits
- [Build the sample app image](../02-build-and-ship/03-docker-sample-app-image.md) — the running app we scan
- [Read an HTTP exchange and a certificate](../01-foundations/05-http-and-tls.md) — how ZAP talks to the app
- Confirm ZAP is available: `docker run --rm ghcr.io/zaproxy/zaproxy:stable zap-baseline.py --version`

## Walkthrough
1. Start the sample app on a reachable URL.
   ```bash
   docker run -d --name sample-app -p 8080:8080 <your-sample-app-image>
   ```
   You should see: the container running and `curl <your-app-url>` returning the app's home page.

2. Run the ZAP baseline scan against it.
   ```bash
   docker run --rm -t ghcr.io/zaproxy/zaproxy:stable zap-baseline.py \
     -t <your-app-url> -r zap-report.html
   ```
   You should see: a summary of alert counts (High/Medium/Low/Informational) and an exit code of 0 (pass) or 1 (fail on high-risk alerts).

3. Open `zap-report.html` and read the alerts. Each alert has a risk level, a description, and a solution.
   You should see: a list of alerts grouped by risk; decide which need a code fix vs. a configuration or accepted-risk decision.

## Exercise
Run the baseline scan against your own running build of the sample app, save the HTML report, and write down one alert you will fix in code and one you will accept as risk with a justification.

## Check your work
```bash
test -f zap-report.html && grep -q "<title>" zap-report.html && echo "report OK"
```
Expected: `report OK`.

## Common mistakes
- Scanning before the app is fully started, producing false "connection refused" errors.
- Treating every alert as a blocker instead of triaging by risk level.

## Next
[Bring all findings together in DefectDojo](../../00_index/learning-path.md)