# Passive vs active scanning in ZAP — what I learned

The two scan modes in ZAP serve completely different purposes, and mixing them up leads to either wasted time or missed findings. Here's what I figured out after running both against a test app.

## Passive scanning

Runs automatically while ZAP proxies traffic or spiders pages. It inspects requests and responses for issues like missing security headers, cookie flags, information disclosure in response bodies, and server version leaks.

No payloads are sent. Nothing is modified. ZAP just watches what flows through and flags what looks wrong. This means:

- Safe to run on any target, even production
- Fast — finishes as soon as the spider or manual browsing is done
- Results depend entirely on coverage — if ZAP didn't see a page, it can't check it

## Active scanning

ZAP sends crafted attack payloads to endpoints and evaluates responses. It checks for SQL injection, XSS, command injection, path traversal, and similar server-side issues.

This is where the real findings come from, but:

- Takes significantly longer — each URL gets dozens of attack variations
- Can damage stateful applications (submits forms, triggers actions, writes data)
- Needs scope control — out-of-context URLs can be hit by accident

## Which one to use when

| Situation | Scan type | Why |
|---|---|---|
| CI/CD smoke test on staging | Passive (baseline) | Fast, non-destructive, catches low-hanging fruit |
| Pre-release deep assessment | Active (full scan) | Finds injection flaws passive won't see |
| Third-party or production | Passive only | Active scan could disrupt or corrupt data |
| API with documented endpoints | Active with narrowed scope | Fewer URLs means faster active scan |

## A practical split

I settled on this pattern for my workflow: run a baseline (passive-only) scan on every staging deploy, and save the full active scan for the pre-release window. The baseline catches regressions in headers, CSP, and cookie config. The active scan finds the actual vulnerabilities.

One thing that tripped me up: ZAP's "full scan" mode still starts with a spider + passive scan phase, then moves to active. So even if you just want active, you still have to wait for the spider to finish first. The baseline script (`zap-baseline.py`) is purely passive — it runs the spider and reports passive findings only.
