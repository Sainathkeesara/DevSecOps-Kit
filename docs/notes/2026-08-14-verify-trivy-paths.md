---
last_verified: 2026-08-14
tool_version: n/a
---

# docs-017 — verify trivy doc paths

> The two trivy docs had broken relative paths. I checked if the working-tree fixes are real.

## What I checked

I opened `docs/how-to/trivy-jenkins-integration.md` first. It referenced `./scripts/bash/ci_cd_toolkit/jenkins/trivy-jenkins-integration.sh` before the fix. The working tree already has `../../scripts/bash/ci_cd_toolkit/jenkins/trivy-jenkins-integration.sh`.

Then I checked `docs/how-to/trivy-severity-filtering.md`. Same pattern — `./scripts/triage-vulnerabilities.sh` became `../../scripts/triage-vulnerabilities.sh`.

I ran `ls` on both target scripts. Both exist. The paths resolve correctly from `docs/how-to/`.

## What's next

Just committing these two files now. I'll mark docs-017 complete once the PR is open.
