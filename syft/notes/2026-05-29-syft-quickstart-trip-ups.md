# Following the official Syft quickstart — what tripped me up

I ran through the Syft quickstart today. The official docs are pretty minimal
— basically "install syft, run `syft <image>`, get an SBOM". Here's what
actually happened when I tried it.

## Steps

1. Already had Syft installed from last session (`syft --version` → 1.x).
2. Ran `syft alpine:latest` — worked instantly, dumped a table of packages.
3. Tried `syft alpine:latest -o json > alpine-sbom.json` to get structured output.
4. Tried `syft alpine:latest -o spdx-json` to compare SPDX vs CycloneDX.

## Got stuck on

**Output format names are inconsistent.** `-o json` gives Syft's own JSON
format, not CycloneDX or SPDX. To get CycloneDX you need
`-o cyclonedx-json`, and for SPDX it's `-o spdx-json`. I assumed `-o json`
was the standard format and spent a few minutes wondering why the schema
didn't match what the docs showed.

**The quickstart doesn't mention `-o` at all.** The "getting started" section
on the README just shows the default table output. You have to scroll to
the "Formats" section to learn about the flags. I almost missed it.

**Running without a tag gives a warning.** `syft alpine` works but prints
"no explicit tag provided, defaulting to latest" — not an error, but looks
alarming if you're not expecting it.

## What I'd try next

I want to compare the three output formats side by side — Syft JSON,
CycloneDX JSON, and SPDX JSON — to understand what fields each includes
and which one is best for different consumers (GitHub Dependabot vs
Grype vs manual review). The Syft docs link to the CycloneDX and SPDX
specs, but a real comparison with the same image would be more useful.
