#!/usr/bin/env bash
# last_verified: 2026-09-19 · falco n/a
# Test harness for the custom rules library. Fails the run when a rule file
# does not parse, misses required keys, reuses a rule name, or uses a
# priority outside the Falco set. Runs `falco --validate` when the binary
# is available; otherwise the offline checks are the gate.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(dirname "$SCRIPT_DIR")"
ALLOWED_PRIORITIES="EMERGENCY ALERT CRITICAL ERROR WARNING NOTICE INFORMATIONAL DEBUG"
failures=0

fail() {
  echo "FAIL: $1" >&2
  failures=$((failures + 1))
}

check_yaml_parses() {
  local file="$1"
  if ! python3 -c "import sys, yaml; yaml.safe_load(open(sys.argv[1]))" "$file"; then
    fail "$file does not parse as YAML"
    return 1
  fi
  return 0
}

check_rule_shapes() {
  local file="$1"
  RULE_FILE="$file" PRIORITIES="$ALLOWED_PRIORITIES" python3 - <<'PY'
import os
import sys
import yaml

allowed = set(os.environ["PRIORITIES"].split())
docs = yaml.safe_load(open(os.environ["RULE_FILE"])) or []
names = []


def reject(msg):
    print("FAIL: " + msg, file=sys.stderr)
    raise SystemExit(1)


for entry in docs:
    if not isinstance(entry, dict) or len(entry) != 1:
        reject("entry is not a single-key mapping: %r" % (entry,))
    kind, body = next(iter(entry.items()))
    if kind == "rule":
        for key in ("desc", "condition", "output", "priority"):
            if not body.get(key):
                reject("rule %r missing %r" % (body.get("rule"), key))
        if body["priority"] not in allowed:
            reject("rule %r has unexpected priority %r" % (body.get("rule"), body["priority"]))
        names.append(body.get("rule"))
    elif kind in ("macro", "list"):
        if not body:
            reject("empty %s definition" % kind)
    else:
        reject("unexpected top-level key %r" % kind)
for name in names:
    if name:
        print(name)
PY
}

collect_names() {
  check_rule_shapes "$1"
}

main() {
  if ! python3 -c "import yaml" 2>/dev/null; then
    echo "ERROR: python3 with the yaml module is required (see Prerequisites in README.md)" >&2
    exit 2
  fi
  local files=("$LIB_DIR"/rules/*.yaml "$LIB_DIR"/examples/*.yaml)
  if [ ! -e "${files[0]}" ]; then
    fail "no rule files found under $LIB_DIR/rules"
  fi

  local all_names=""
  local file
  for file in "${files[@]}"; do
    [ -e "$file" ] || continue
    echo "checking $file"
    check_yaml_parses "$file" || continue
    names="$(collect_names "$file")" || { fail "$file has invalid rule shapes"; continue; }
    all_names+="$names"$'\n'
  done

  duplicates="$(printf '%s' "$all_names" | grep -v '^$' | sort | uniq -d || true)"
  if [ -n "$duplicates" ]; then
    fail "duplicate rule names across files: $duplicates"
  fi

  if command -v falco >/dev/null 2>&1; then
    for file in "${files[@]}"; do
      [ -e "$file" ] || continue
      if ! falco --validate -r "$file" >/dev/null 2>&1; then
        fail "falco --validate rejected $file"
      fi
    done
  else
    echo "falco binary not found; skipping --validate pass (offline checks only)"
  fi

  if [ "$failures" -gt 0 ]; then
    echo "$failures check(s) failed" >&2
    exit 1
  fi
  echo "all rule checks passed"
}

main "$@"
