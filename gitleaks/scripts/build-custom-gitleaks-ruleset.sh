#!/usr/bin/env bash
# last_verified: 2026-10-25 · gitleaks n/a
# Build a custom gitleaks ruleset for internal secret patterns.
# L3 — building on my own; real error handling, no paranoid boilerplate.

set -euo pipefail

RULES_FILE="${1:-.gitleaks.toml}"
OUT_DIR="${2:-.}"

if ! command -v gitleaks >/dev/null 2>&1; then
    echo "gitleaks not found on PATH" >&2
    exit 1
fi

cat > "$RULES_FILE" <<'EOF'
title = "internal custom ruleset"

[[rules]]
id = "internal-api-token"
description = "Internal service API token"
regex = '''(?i)internal[_-]?api[_-]?token\s*[:=]\s*["']?[A-Za-z0-9_-]{24,}["']?'''
tags = ["secret", "internal"]

[[rules]]
id = "internal-db-password"
description = "Internal database password assignment"
regex = '''(?i)(db|database)[_-]?password\s*[:=]\s*["']?[^\s"']{8,}["']?'''
tags = ["secret", "internal"]

[allowlist]
description = "Allow test fixtures and examples"
paths = [
  '''tests/.*''',
  '''examples/.*''',
  '''.*\.example$''',
]
regexes = [
  '''EXAMPLE_TOKEN''',
]
EOF

echo "Wrote ruleset to $RULES_FILE"
gitleaks detect --source . --config "$RULES_FILE" --no-git 2>&1 || true
echo "Done."
EOF
chmod +x /work/DevSecOps-Kit/gitleaks/scripts/build-custom-gitleaks-ruleset.sh