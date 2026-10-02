#!/usr/bin/env bash
# last_verified: 2026-10-02 · checkov 3.x
# Purpose: Validate custom Checkov policies in the kit's policies/ directory.
# Use: ./validate-policies.sh [--root <path>] [policy-dir...]
# Requires: checkov, python3, yamllint (optional)

set -euo pipefail

POLICIES_ROOT="${CHECKOV_POLICIES_ROOT:-checkov/policies}"
TARGET_DIRS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root) POLICIES_ROOT="${2:-}"; shift ;;
    *) TARGET_DIRS+=("$1") ;;
  esac
  shift
done

if [[ ${#TARGET_DIRS[@]} -eq 0 ]]; then
  mapfile -t TARGET_DIRS < <(find "$POLICIES_ROOT" -mindepth 1 -maxdepth 1 -type d | sort)
fi

if [[ ${#TARGET_DIRS[@]} -eq 0 ]]; then
  echo "No policy directories found under $POLICIES_ROOT"
  exit 0
fi

PY_VALIDATOR=$(cat <<'PYEOF'
import sys, yaml, json, os

def validate_policy_file(path):
    errors = []
    warnings = []
    try:
        with open(path, 'r') as f:
            data = yaml.safe_load(f)
    except yaml.YAMLError as e:
        errors.append(f"YAML parse error: {e}")
        return errors, warnings

    if not isinstance(data, dict):
        errors.append("Root must be a mapping")
        return errors, warnings

    required = ["metadata", "scope", "definition"]
    for key in required:
        if key not in data:
            errors.append(f"Missing required section: {key}")

    if "metadata" in data:
        meta = data["metadata"]
        if not isinstance(meta, dict):
            errors.append("metadata must be a mapping")
        else:
            for field in ("id", "name"):
                if field not in meta:
                    warnings.append(f"metadata.{field} is recommended but missing")

    if "scope" in data:
        scope = data["scope"]
        if not isinstance(scope, dict):
            errors.append("scope must be a mapping")
        elif "provider" not in scope:
            warnings.append("scope.provider is recommended but missing")

    if "definition" in data:
        definition = data["definition"]
        if not isinstance(definition, dict):
            errors.append("definition must be a mapping")
        else:
            if "cond_type" not in definition:
                errors.append("definition.cond_type is required")
            if "resource_types" not in definition:
                warnings.append("definition.resource_types is recommended but missing")

    return errors, warnings

def main():
    all_errors = []
    all_warnings = []
    for root, dirs, files in os.walk(sys.argv[1]):
        for f in files:
            if f.endswith(('.yaml', '.yml')):
                path = os.path.join(root, f)
                errs, warns = validate_policy_file(path)
                for e in errs:
                    all_errors.append(f"{path}: {e}")
                for w in warns:
                    all_warnings.append(f"{path}: {w}")

    for w in all_warnings:
        print(f"WARN: {w}", file=sys.stderr)
    for e in all_errors:
        print(f"ERROR: {e}", file=sys.stderr)

    if all_errors:
        sys.exit(1)

if __name__ == "__main__":
    main()
PYEOF
)

validate_with_python() {
  python3 -c "$PY_VALIDATOR" "$1"
}

validate_with_checkov() {
  local dir="$1"
  checkov --directory "$dir" --external-checks-dir "$dir" --check CHECKOV_CUSTOM 2>&1 | head -20
}

echo "Validating Checkov policies in: ${TARGET_DIRS[*]}"

HAS_ERRORS=0

for dir in "${TARGET_DIRS[@]}"; do
  echo "--- Checking $dir ---"

  if ! validate_with_python "$dir"; then
    HAS_ERRORS=1
    continue
  fi

  if command -v checkov >/dev/null 2>&1; then
    if ! validate_with_checkov "$dir"; then
      echo "Checkov validation reported issues for $dir"
      HAS_ERRORS=1
    else
      echo "Checkov validation passed for $dir"
    fi
  else
    echo "Checkov not installed; skipping runtime validation"
  fi

  if [[ -f "$dir/.yamllint" ]] && command -v yamllint >/dev/null 2>&1; then
    yamllint -c "$dir/.yamllint" "$dir" || true
  elif command -v yamllint >/dev/null 2>&1; then
    yamllint "$dir" || true
  fi
done

if [[ $HAS_ERRORS -eq 1 ]]; then
  echo "Policy validation failed."
  exit 1
fi

echo "All policies validated successfully."
exit 0