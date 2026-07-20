---
last_verified: 2026-07-20
tool_version: n/a
---

# Install OWASP ZAP and launch my first baseline scan

Just tried setting up OWASP ZAP for the first time. The Docker quickstart looked like the easiest path: `docker run -t owasp/zap2docker-stable zap-baseline.py -t https://example.com`. I assumed it would just work, but the first run failed because the `-stable` image I pulled didn't have a JRE bundled.

Switched to `owasp/zap2docker-latest` and the baseline scan ran right away. The report saved as `zap-report.html` in the mounted working directory. My main trip-up was assuming the stable tag was the ready-to-use one — checking Docker Hub's tag descriptions first would have saved a few minutes.