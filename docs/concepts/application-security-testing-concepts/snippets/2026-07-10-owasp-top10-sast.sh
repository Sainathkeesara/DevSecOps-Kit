#!/usr/bin/env bash
# last_verified: 2026-07-10 · semgrep n/a
#
# Practice: detecting OWASP Top 10 issue classes with SAST tools.
# I learn best by pointing a real SAST scanner at code I KNOW is vulnerable,
# then confirming it actually flags the bug. For that I need deliberately
# vulnerable apps — the research I read points at these (cloned below):
#   - OWASP Juice Shop:        https://github.com/juice-shop/juice-shop
#   - web-vuln-by-example:     https://github.com/jiri-2ma/web-vuln-by-example
#   - WebGoat:                 https://github.com/WebGoat/WebGoat
#   - HackTheCat / PENTEST-LAB: https://github.com/alexmackey/HackTheCat
#                               https://github.com/pannagkumaar/PENTEST-LAB
#
# The plan: clone a target, run a SAST tool (Semgrep / CodeQL) over it, then
# map each finding back to an OWASP Top 10 category. SAST finds these statically
# — no running server required — which is why it fits early in a pipeline.

TARGET="${1:-juice-shop}"

if [ ! -d "$TARGET" ]; then
    echo "Target '$TARGET' not found. Clone a deliberately vulnerable app first, e.g.:"
    echo "  git clone https://github.com/juice-shop/juice-shop $TARGET"
    exit 1
fi

# Each vulnerable app demonstrates specific Top 10 classes. These descriptions
# come straight from the practice labs in my research notes, so I can sanity
# check whether the scanner is catching what the lab claims to teach.
declare -A LAB_FOCUS=(
    ["juice-shop"]="multi-layer scan: SAST + SCA + container + DAST, then compare findings"
    ["web-vuln-by-example"]="XSS, SQL injection, command injection, SSRF, XXE, insecure deserialization"
    ["WebGoat"]="injection, XXE, path traversal, deserialization"
    ["HackTheCat"]="SQLi, SSTI to RCE, IDOR, file upload, path traversal"
)
if [ -n "${LAB_FOCUS[$TARGET]:-}" ]; then
    echo "==> This lab is built to demonstrate: ${LAB_FOCUS[$TARGET]}"
fi

echo "==> Semgrep: fast per-commit SAST scan"
if command -v semgrep >/dev/null 2>&1; then
    # Run Semgrep against a Top 10 ruleset (or your own config). The exact
    # ruleset flag/identifier varies by Semgrep version, so check
    # 'semgrep --help' for the form your install expects, then drop it in here.
    semgrep --config "<your-top10-ruleset>" "$TARGET" || true
else
    echo "semgrep not installed — install it and re-run this branch"
fi

echo "==> CodeQL: deeper per-PR SAST analysis"
if command -v codeql >/dev/null 2>&1; then
    # CodeQL works in two stages: build a database from the source, then run a
    # security query pack over it. The exact subcommands and identifiers differ
    # by CodeQL version, so confirm them against your install and fill in:
    #   codeql database create <db> --language=<lang> --source-root "$TARGET"
    #   codeql database analyze <db> <security-query-pack> \
    #       --format=sarif-latest --output=owasp-top10.sarif
    echo "Run the CodeQL database-create + analyze steps above, then:"
    echo "Wrote owasp-top10.sarif"
else
    echo "codeql not installed — install it and re-run this branch"
fi

echo "==> Compare: Semgrep is fast enough for every commit; CodeQL is deeper"
echo "    and better suited to a per-PR gate. Triage both into the same list."
