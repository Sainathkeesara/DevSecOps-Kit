---
last_verified: 2026-08-04
tool_version: n/a
---

# Exploring the DefectDojo UI

> First-day notes on DefectDojo's UI. What I saw, where I got confused, and what I plan to try next.

## What I did

I opened DefectDojo and started clicking around. The main dashboard shows a list of products, each with a count of engagements and findings. I created a test product called "demo-app" and added an engagement for it.

## Products, Engagements, and Findings

I learned the three-tier structure by doing:

- **Product** — I made one called "demo-app". It's just a container for everything related to that application.
- **Engagement** — Inside the product, I created an engagement called "initial-scan". This is like a test window or a sprint.
- **Finding** — After importing a scan result, the findings showed up inside the engagement. Each one had a severity, a title, and a description.

## What tripped me up

I kept looking for a "Run scan" button. There isn't one — DefectDojo doesn't run scanners itself. You import results from tools like Trivy or Semgrep. I had to export a sample report from Trivy first, then upload it through the UI.

The engagement status field confused me too. I didn't realize you have to set it to "In Progress" before importing findings, or the import just silently does nothing useful.

## What I'll try next

I want to connect DefectDojo to a CI pipeline so scan results auto-import on every push. I also want to play with the deduplication settings and see how it merges findings from different scanners.