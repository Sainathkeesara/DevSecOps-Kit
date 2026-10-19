---
last_verified: 2026-10-19
tool_version: n/a
sources: []
---

# Trivy first image scan — what tripped me up

I installed Trivy for the first time today and ran my first container image scan. The tool itself is a single binary with no daemon or API keys, but the first run still had a few snags.

## Steps I actually ran

1. Downloaded the Trivy binary and added it to `PATH`, then confirmed it with `trivy --version`.
2. Ran `trivy image --download-db-only` to pull the vulnerability database once, so the first real scan wouldn't spend minutes downloading it.
3. Scanned a small image: `trivy image alpine:latest`.
4. Wrote the results to a file: `trivy image alpine:latest --file first-scan.txt`.

## Got stuck on

**The first run looks frozen.** Trivy downloads its vulnerability database (a few hundred MB) before printing anything, and the download prints almost no progress. I killed it once thinking it was stuck, then re-ran and waited — the second attempt completed. Lesson: let the first run sit.

**The database only downloads once.** After the first run, the DB is cached locally, so subsequent scans start immediately. I confirmed this by running the same scan twice — the second was instant.

**Output goes to stdout by default.** I expected a report file, but Trivy prints a table to the terminal unless I pass `--file`. I added `--file first-scan.txt` to save the table for later review.

**Severity names are uppercase.** I tried `--severity high,critical` (lowercase) and got everything back, unfiltered. Matching the table's uppercase spelling — `--severity HIGH,CRITICAL` — cut the output down to the findings I actually wanted.

## What I'd try next

Point Trivy at a local directory with a lockfile (`trivy fs .`) to see whether it catches language-specific packages beyond OS packages, and create a config file so I stop retyping the severity flag every time.
