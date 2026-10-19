---
last_verified: 2026-10-19
tool_version: n/a
sources: []
---

# DefectDojo quickstart — what tripped me up

Following the official DefectDojo quickstart today. Mostly straightforward, but
a few things caught me.

## What I did

1. Cloned the repo and ran the docker-compose setup.
2. Waited for the web container to come up, then logged in with the default
   admin credentials.
3. Created a product and an engagement to attach scan results to.

## Where I got stuck

- The compose file took longer than expected to pull images; I thought it had
  hung. It hadn't — just slow.
- I initially tried to import a scan before creating an engagement, which
  failed. Engagement must exist first.
- The API v2 base path tripped me up; I kept hitting v1 endpoints.

## What I'd try next

- Automate product/engagement creation via the API instead of the UI.
- Pipe a tfsec or snyk report into DefectDojo and see how it parses.
