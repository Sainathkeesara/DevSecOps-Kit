#!/usr/bin/env bash
# last_verified: 2026-08-27 · OPA Gatekeeper
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
POLICIES_DIR="$REPO_ROOT/policies"

if ! command -v opa >/dev/null 2>&1; then
  echo "opa CLI not found -- install it before running this script"
  exit 1
fi

echo "Running OPA policy tests in $POLICIES_DIR ..."
FAIL=0

for rego in "$POLICIES_DIR"/*_test.rego; do
  [ -f "$rego" ] || continue
  echo "  testing: $(basename "$rego")"
  if ! opa test "$rego" -v; then
    FAIL=1
  fi
done

# Also evaluate each policy against a sample violating input if no test file exists
for rego in "$POLICIES_DIR"/*.rego; do
  [ -f "$rego" ] || continue
  basename "$rego" | grep -q "_test.rego" && continue
  echo "  evaluating: $(basename "$rego")"
  if ! opa eval --format pretty --data "$rego" --input <(echo '{"review": {"object": {"spec": {"containers": [{"name": "app", "securityContext": {"privileged": true}}], "hostNetwork": true}}}}') "data.k8s.security_baseline.deny" >/dev/null 2>&1; then
    echo "  warning: evaluation produced no violations -- check policy logic"
  fi
done

if [ "$FAIL" -eq 0 ]; then
  echo "All policy tests passed."
else
  echo "One or more policy tests failed."
  exit 1
fi
