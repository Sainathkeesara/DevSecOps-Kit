#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
TARGET="${1:-${TRUFFLEHOG_TARGET_REPO:-file://.}}"
RESULTS="${TRUFFLEHOG_RESULTS:-verified,unverified,unknown}"
OUTPUT_FILE="${TRUFFLEHOG_OUTPUT:-${REPO_DIR}/trufflehog-results.json}"
LOG_FILE="${TRUFFLEHOG_LOG:-${REPO_DIR}/trufflehog-scan.log}"
SUMMARY_FILE="${TRUFFLEHOG_SUMMARY:-${REPO_DIR}/trufflehog-summary.md}"

if ! command -v trufflehog >/dev/null 2>&1; then
    echo "trufflehog is required but was not found on PATH." >&2
    exit 127
fi

scan_command=(trufflehog git "$TARGET" --results="$RESULTS" --json)
if [ -n "${TRUFFLEHOG_TOKEN:-}" ]; then
    scan_command+=(--token="$TRUFFLEHOG_TOKEN")
fi

scan_status=0
"${scan_command[@]}" >"$OUTPUT_FILE" 2>"$LOG_FILE" || scan_status=$?

if [ ! -s "$OUTPUT_FILE" ] && [ "$scan_status" -ne 0 ]; then
    cat "$LOG_FILE" >&2
    exit "$scan_status"
fi

python3 - "$OUTPUT_FILE" "$SUMMARY_FILE" <<'PY'
import json
import sys
from pathlib import Path

output = Path(sys.argv[1])
summary = Path(sys.argv[2])
lines = [line for line in output.read_text(encoding="utf-8").splitlines() if line.strip()]
findings = []

for line in lines:
    try:
        findings.append(json.loads(line))
    except json.JSONDecodeError:
        findings.append({"raw": line})

summary_lines = ["# TruffleHog GitHub Secret Scan", ""]
if not findings:
    summary_lines.append("No TruffleHog findings were written to the JSON output.")
else:
    summary_lines.append(f"Potential secrets found: {len(findings)}")
    summary_lines.append("")
    for item in findings[:10]:
        if "raw" in item:
            summary_lines.append(f"- Raw output: {item['raw'][:180]}")
            continue
        git = item.get("SourceMetadata", {}).get("Data", {}).get("Git", {})
        location = f"{git.get('file', 'unknown')}:{git.get('line', '?')}"
        detector = item.get("DetectorName", "unknown detector")
        verified = item.get("Verified", "unknown")
        commit = git.get("commit", "unknown")[:12]
        summary_lines.append(f"- {detector} ({verified}) at {location}, commit {commit}")
    if len(findings) > 10:
        summary_lines.append(f"- ... {len(findings) - 10} more findings in {output.name}")

summary.write_text("\n".join(summary_lines) + "\n", encoding="utf-8")
print(f"No TruffleHog findings." if not findings else f"TruffleHog findings: {len(findings)}")
PY

if [ -s "$OUTPUT_FILE" ]; then
    exit 1
fi

exit 0
