# OWASP ZAP — quick primer

> First-day notes for someone who's never used OWASP ZAP. Personal voice, plain language.

## What is it?

OWASP ZAP (Zed Attack Proxy) is a free, open-source web application security scanner. It sits as a proxy between my browser and a web app, intercepting traffic and checking for vulnerabilities. Think of it like a free alternative to Burp Suite Pro — but ZAP is open source and has a strong community behind it. It's probably the most widely used free web app scanner out there.

## What does it do?

It proxies HTTP traffic so it can inspect every request and response. From there it can spider a site (crawl all pages), passively scan for issues just by watching traffic, and actively attack endpoints with payloads to find vulnerabilities like SQL injection, XSS, and CSRF. It can generate reports, run headless in Docker, and integrate into CI pipelines.

## Why does it exist?

Before ZAP, finding web vulnerabilities meant either expensive commercial scanners or manual work with basic proxy tools. ZAP gave the whole community — solo devs, small teams, open-source projects — a capable scanner for free. It exists because web security testing should be accessible. Day to day, pentesters use it for recon and automated scanning, bug bounty hunters run it alongside manual testing, and DevSecOps engineers wire it into CI pipelines.

## Key terminology

- **Proxy** — The middleman between browser and target. All traffic flows through. Example: I set Firefox to localhost:8080 and ZAP captures everything.
- **Spider** — Crawls the app by following links to build a site tree. Example: Right-click a URL and choose Attack > Spider to discover all pages.
- **Active Scan** — Sends malicious payloads to endpoints to find real vulnerabilities. Example: ZAP tries SQL injection strings against login forms.
- **Passive Scan** — Watches traffic without sending any harmful requests. Example: ZAP flags missing security headers like X-Frame-Options just from observing responses.
- **Context** — A named group of URLs I care about, with auth settings. Example: I define a context for `https://myapp.example.com/*` so ZAP knows what's in scope.
- **Alert** — A finding with severity from Low (info leak) to High (SQL injection). Example: ZAP shows a High alert for "SQL Injection" with the exact URL and parameter.
- **HUD** — Heads-Up Display: an overlay in the browser showing real-time alerts as I browse. Example: Badges appear in the corner showing alert counts.

## A tiny example

```bash
# Quick baseline scan against a target using the official ZAP Docker image
docker run --rm -v $(pwd):/zap/wrk ghcr.io/zaproxy/zaproxy:stable \
  zap-baseline.py -t https://example.com -r report.html
```

This downloads ZAP, spiders the site, runs passive scanning, and writes an HTML report — all without the desktop UI. Fastest way to see ZAP in action.

## What I'll cover next

After this primer I want to install ZAP locally, explore the desktop UI to get comfortable with the interface, and then move to CLI-based scanning for CI pipeline integration. The automated scanning workflow is what I'm really after.
