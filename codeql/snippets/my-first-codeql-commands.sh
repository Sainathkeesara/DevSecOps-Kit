#!/usr/bin/env bash
# My first CodeQL commands: creating a database, running a query, and viewing results
# L1 scratch snippet — minimal working example

REPO_DIR="${1:-.}"
DB_DIR="/tmp/codeql-db-$(date +%s)"
OUTPUT_DIR="${2:-/tmp/codeql-results}"
LANGUAGE="${3:-python}"

mkdir -p "$OUTPUT_DIR"

echo "[1] Creating CodeQL database..."
codeql database create "$DB_DIR" --language="$LANGUAGE" --source-root="$REPO_DIR"

echo "[2] Running security query suite..."
codeql database analyze "$DB_DIR" \
  "codeql/${LANGUAGE}-queries:codeql-suites/${LANGUAGE}-security-extended.qls" \
  --format=sarif-latest \
  --output="$OUTPUT_DIR/results.sarif"

echo "[3] Done. SARIF at $OUTPUT_DIR/results.sarif"
