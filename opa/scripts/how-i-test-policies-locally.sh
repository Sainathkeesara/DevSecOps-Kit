#!/bin/bash
# testing OPA policies locally before deploying to Gatekeeper
# I kept messing up the Rego syntax so this saves me time

POLICY=${1:-policy.rego}
INPUT=${2:-input.json}

if [ ! -f "$POLICY" ]; then
  # hmm I should check if opa is installed first
  echo "Usage: $0 <policy.rego> <input.json>"
  echo "  runs 'opa eval' with your policy and input"
  exit 1
fi

if [ ! -f "$INPUT" ]; then
  echo "Usage: $0 <policy.rego> <input.json>"
  exit 1
fi

# using --fail-defined so it only returns violations that are actually defined
# still not 100% sure why --fail vs --fail-defined matters
opa eval --format pretty \
  --data "$POLICY" \
  --input "$INPUT" \
  --fail-defined \
  "data.package_name.violation"
