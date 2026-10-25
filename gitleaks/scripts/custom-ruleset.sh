#!/usr/bin/env bash
# last_verified: 2026-10-25 · gitleaks n/a
#
# Build a custom gitleaks ruleset for internal patterns.
#
# Purpose
#   Generate a .gitleaks.toml ruleset that flags internal secret patterns the
#   default ruleset misses -- internal service-token prefixes, internal API
#   keys, and internal auth-service issuers -- plus an allowlist for test
#   fixtures and docs examples so CI is not flooded with known noise.
#
# Steps
#   1. Write the ruleset TOML to gitleaks/configs/custom-ruleset.toml.
#   2. Build a throwaway fixture with planted internal patterns and one
#      allowlisted example.
#   3. Run `gitleaks detect` against the fixture. Exit 0 means clean,
#      exit 1 means findings present (review by hand), anything else means
#      the command itself broke.
#   4. Print a short summary and the report path.
#
# Verify
#   Run the script and confirm the planted internal patterns show up in the
#   report while the allowlisted docs example stays quiet.
#
# This is one way to wire a custom ruleset; the gitleaks docs also suggest
# editing the default .gitleaks.toml in place, which may be simpler for a
# single-repo setup.

# Where the generated ruleset lands. Committed so a CI job can point --config
# at it without regenerating on every run.
RULESET="gitleaks/configs/custom-ruleset.toml"

# --- Step 1: write the ruleset ----------------------------------------------

cat > "$RULESET" <<'TOML'
# Custom gitleaks ruleset for internal patterns.
# TOML keys vs CLI behaviour:
#   [rules]        -- loaded with --config; config-only, no single CLI flag
#   [[rules]] id   -- shown per finding; config-only, no CLI equivalent
#   [allowlist]    -- paths/regexes skipped; CLI has --allowlist-path / --allowlist
#   [reporting]    -- mirrors --report-format / --report-path

[rules]
  [[rules]]
    id = "internal-service-token"
    description = "internal service token with isvc- prefix"
    regex = "isvc-[A-Za-z0-9]{24}"
    tags = ["internal", "service-token"]
    severity = "CRITICAL"

  [[rules]]
    id = "internal-api-key"
    description = "internal API key with int-key- prefix"
    regex = "int-key-[A-Za-z0-9]{20}"
    tags = ["internal", "api-key"]
    severity = "HIGH"

  [[rules]]
    id = "internal-issuer"
    description = "internal auth-service issuer string"
    regex = "issuer=internal-auth"
    tags = ["internal", "issuer"]
    severity = "MEDIUM"

[allowlist]
  paths = [
    "gitleaks/notes/**",
    "**/fixtures/**",
    "**/*-example.txt",
  ]

[reporting]
  format = "json"
  path = "gitleaks-reports/custom-ruleset.json"
TOML

echo "wrote $RULESET"

# --- Step 2: build a throwaway fixture --------------------------------------

FIXTURE="$(mktemp -d)"
trap 'rm -rf "$FIXTURE"' EXIT

cat > "$FIXTURE/internal-service.cfg" <<'CFG'
token=isvc-AbCdEfGhIjKlMnOpQrStUvWx
CFG

cat > "$FIXTURE/docs-example.txt" <<'CFG'
# Allowlisted docs example -- gitleaks should skip this file.
token=isvc-ZzZzZzZzZzZzZzZzZzZzZzZz
CFG

# --- Step 3: run gitleaks detect -------------------------------------------

REPORT="$FIXTURE/scan.json"

gitleaks detect --source "$FIXTURE" --config "$RULESET" \
  --report-path "$REPORT" --report-format json >/dev/null 2>&1
SCAN_STATUS=$?

# Exit 0 = no findings. Exit 1 = findings present (scan worked, review by
# hand). Anything else = the command itself broke.
if [ $SCAN_STATUS -eq 0 ]; then
  echo "scan clean: no findings in $FIXTURE"
elif [ $SCAN_STATUS -eq 1 ]; then
  echo "findings present in $FIXTURE -- review $REPORT by hand"
else
  echo "gitleaks detect exited $SCAN_STATUS -- command itself failed" >&2
  exit $SCAN_STATUS
fi

echo "done. ruleset: $RULESET   report: $REPORT"
