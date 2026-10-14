---
last_verified: 2026-10-14
tool_version: n/a
---

# Following the trivy quickstart — what tripped me up

I finally sat down with the trivy quickstart today. I had trivy installed already from an earlier try, so I skipped straight to the scanning part — figured an image scan would take two minutes.

## Steps I actually ran

First I tried the obvious one, scanning a small image I already had pulled:

```bash
trivy image nginx:alpine
```

It spent the first couple of minutes downloading its vulnerability database before printing anything, which I was not expecting — I thought the scan itself had hung. Once the download finished, I got a table grouped by target with library, severity, and fixed-version columns. Most of what I saw was medium stuff, with one high that had a fixed version listed.

Then I tried pointing it at my own checkout instead of an image, since that is the loop I actually care about:

```bash
trivy fs .
```

That worked without any image pull, and it finished much faster on the second run because the database was already cached.

## Got stuck on

**The first run looks frozen.** The database download prints very little while it works, so I killed it once thinking it was stuck, then re-ran and waited — the second attempt showed progress and completed. Lesson: just let the first run sit.

**Severity filtering took two tries.** I first ran with a lowercase filter and got back everything, unfiltered. Looking at the table output, severities print uppercase, so I matched that:

```bash
trivy image --severity HIGH,CRITICAL nginx:alpine
```

That cut the table down to the one finding I actually wanted to look at.

**JSON output is nested more than I expected.** I piped a scan to JSON and tried to read it flat, but results are grouped per target, so I had to dig one level in before reaching the findings list. Took me a minute of scrolling before the shape clicked.

## What I'd try next

I want to run `trivy fs .` on a repo with a lockfile and see whether it picks up anything beyond OS packages. Also curious how the config file works for keeping the severity filter so I stop retyping the flag every time.
