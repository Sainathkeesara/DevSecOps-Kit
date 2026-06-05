# 2026-06-04 — Following the Grype quickstart (what broke and what worked)

I went through the official Grype quickstart to get a feel for how it compares to Trivy, since we already have Trivy at L3 in the kit. I used a mix of the install script and scanning a few real images.

## What I ran

```bash
curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin
grype alpine:latest
grype debian:latest
grype nginx:latest --only-fixed --fail-on high
```

## What worked

- Install script was straightforward — one-liner, no extra dependencies, ended up in /usr/local/bin.
- `grype alpine:latest` came back clean (0 vulns) which was a good sanity check.
- `--only-fixed` actually filtered out unfixed issues and only showed the ones with available fixes.
- `--fail-on high` made the exit code go non-zero when there were high-severity findings — useful for CI gating.
- Saving output to JSON with `--output json --file` works so I can pipe it into jq or other tools later.
- The table output clearly shows package, installed version, fixed version, and severity in that order — easy to scan visually.

## What tripped me up

- **DB download silently on first run** — grype downloaded the vulnerability database on first scan and I didn't realize what was happening. Took ~30 seconds and I thought it was hanging. Not a bug, just not clearly announced in the terminal output.
- **Scanning a local directory with grype .** — I ran `grype .` in a project folder with node_modules and it scanned everything, including 10,000+ JS packages. Had to kill it and add `--exclude ./node_modules`. Lesson: local directory scans are broader than I expected.
- **SBOM input path syntax** — I tried `grype sbom ./sbom.json` like the docs showed, but it turns out the format is `grype sbom:<path>` (with a colon, no space). Took me a minute to figure out why the binary validation kept failing.
- **Comparing to Trivy results** — I scanned `debian:latest` with both tools. Grype and Trivy found different CVE counts on the same image. Not sure yet if it's because their DBs update at different times or if their scope is genuinely different.

## What I'd try next

- Run `grype db update` before a CI job so the first scan doesn't stall on a download mid-pipeline.
- Try `--exclude` patterns or a `.grype.yaml` ignore config for monorepos.
- Compare Grype Go SDK output vs CLI for the same scan — someone in the quickstart comments suggested the SDK has different scoring sometimes.
- Test `grype dir` vs `grype .` since they seem to scan directories differently.

Overall Grype feels lighter than Trivy for quick scanning, and the SBOM input is a real advantage if Syft is already in the pipeline. The main gotcha for me was just learning the flag syntax and output formats — nothing fundamentally broken.
