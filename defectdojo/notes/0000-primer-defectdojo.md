# DefectDojo — quick primer

> First-day notes for someone who's never used DefectDojo. Personal voice, plain language.

## What is it?
DefectDojo is an open-source application security vulnerability management platform. It's a single dashboard that aggregates findings from scanners like Semgrep, Trivy, OWASP ZAP, and Snyk, then tracks each issue through its lifecycle. Instead of juggling fifteen CSV exports and Slack threads, you get one place where findings are normalized, deduplicated, and prioritized. Think of it as the issue tracker built specifically for security findings.

## What does it do?
DefectDojo imports scan results via REST API, file upload, or CLI integrations. Every result gets mapped to a common Finding model, so a Trivy "HIGH" and a Snyk "HIGH" sit side by side in the same format. You group work into Products and Engagements — a product is an application, an engagement is a test cycle — and each import becomes a Test inside that engagement. It also handles deduplication, Jira ticket sync, Slack notifications, and SSO out of the box. The platform tracks the full lifecycle, from initial discovery through remediation and verification.

## Why does it exist?
Before DefectDojo, AppSec teams dumped scanner output into spreadsheets or wrote custom portals on top of databases. Neither scaled well. Tracking an issue from "found" to "fixed" or "false positive" was manual and error-prone. DefectDojo gives teams a free, self-hosted platform built for this workflow so you can focus on fixing vulnerabilities instead of building the tool to track them.

## Key terminology
- **Product** — An application or service you're tracking (e.g., "payment-gateway")
- **Engagement** — A time-boxed testing window or sprint within a product
- **Finding** — A single vulnerability or issue imported from a scanner
- **Test** — The result of importing one scan file into an engagement
- **Deduplication** — Merging identical findings across scans so one issue doesn't fan out into ten tickets
- **API Token** — DefectDojo's per-user key used for programmatic imports
- **Jira Sync** — Automatic ticket creation and status sync with Jira

## A tiny example
```bash
git clone https://github.com/DefectDojo/django-DefectDojo.git
cd django-DefectDojo && docker compose up -d
```
Clones the repo and starts DefectDojo on port 8080. Log in with `admin` / `admin` at `http://localhost:8080`.

## What I'll cover next
I want to import a sample scan report and watch DefectDojo deduplicate it across runs. Then I'll try the REST API for CI-triggered imports and see how engagement creation fits into a pipeline.
