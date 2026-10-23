# last_verified: 2026-10-23 · Application Security Testing Concepts n/a
# 2026-10-23 — tried wiring SAST into a pipeline step; minimal working sketch

set -u

# Semgrep config path (adjust to your repo)
SEMGREP_CONFIG="${SEMGREP_CONFIG:-p/owasp-top-ten}"

# run semgrep, write SARIF-ish output for later upload
semgrep --config "$SEMGREP_CONFIG" --sarif --output semgrep.sarif . || echo "semgrep found findings or failed — check semgrep.sarif"

echo "SAST scan finished; artifact: semgrep.sarif"