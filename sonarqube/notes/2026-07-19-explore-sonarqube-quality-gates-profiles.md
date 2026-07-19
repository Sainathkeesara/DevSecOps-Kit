---
last_verified: 2026-07-19
tool_version: n/a
sources: []
---

# Exploring SonarQube — Quality Gates, profiles, and issues

> First-person notes from running SonarQube locally and clicking through the web UI for the first time.

## Quality Gates

I created a project and ran a scan, then opened the Quality Gates settings. The default gate turned red because I had 0% new code coverage. I lowered the coverage threshold to 50% just to see it pass, but that felt like cheating. The conditions are plain English — "Coverage on New Code is less than 80%" — and each one has a severity.

## Profiles

Profiles define which rules run for a language. I opened the built-in Python profile and saw rules grouped by bugs, vulnerabilities, and code smells. I activated an extra rule for "XPath injection" and reran the scan. The issue count went up. I wasn't sure whether activating a rule on a profile affects existing projects or only new analyses, but a quick test showed it affects the next scan.

## Issues

The Issues page shows individual findings. I clicked through a few and saw the highlighted code, the rule description, and a remediation example. I tried marking one as "won't fix" and it disappeared from the open list. Later I wanted to reopen it and couldn't find a button for that, which was frustrating.

## What I'd try next

I want to set up branch-specific Quality Gates, connect PR decoration to GitHub, and explore custom rules for my team's patterns.
