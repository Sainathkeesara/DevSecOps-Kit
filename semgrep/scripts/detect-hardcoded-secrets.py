#!/usr/bin/env python3
"""Build a custom Semgrep rule for hardcoded secrets and test it.

Purpose:
  Create a Semgrep rule that flags Python source files containing
  hardcoded strings that look like API keys, tokens, or passwords,
  then run it against a small crafted codebase and report findings.

Steps:
  1. Write a Semgrep rule YAML to a temp directory.
  2. Create a test Python file with hardcoded secrets mixed with
     safe assignments.
  3. Run `semgrep --config=<rule> <test_file>`.
  4. Parse the JSON output and print findings.
  5. Clean up temp files.

Usage:
  python detect-hardcoded-secrets.py [--keep-temps]
"""

import argparse
import json
import os
import subprocess
import sys
import tempfile


CUSTOM_RULE_YAML = """
rules:
  - id: hardcoded-secret-value
    message: String assigned to sensitive variable looks like a hardcoded secret
    severity: WARNING
    languages: [python]
    patterns:
      - pattern-either:
          - pattern: |
              $VAR = "..."
          - pattern: |
              $VAR = '...'
      - metavariable-regex:
          metavariable: $VAR
          regex: (?i).*(?:password|secret|token|api[_-]?key|auth|credential|access[_-]?key).*
"""


TEST_CODEBASE = """
# This file has a mix of safe and unsafe assignments.
# The safe ones should not trigger, the hardcoded secrets should.

import os

# Safe — config import from environment
db_host = os.getenv("DB_HOST")
db_port = int(os.getenv("DB_PORT", "5432"))

# Hardcoded secret — should be flagged
api_key = "sk-live-a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p"

# Also hardcoded — environment-specific password left in source
db_password = "postgres:supersecret!2024"

# Safe — short variable, not a secret pattern
greeting = "hello world"

# Hardcoded token — should be flagged
github_token = "ghp_xxxxxxxxxxxxyyyyyyyyyzzzzzzzzzzzzzzz"

# Safe — test fixture, not production code
expected = "expected_value"
"""


def write_rule(rule_dir: str) -> str:
    """Write the Semgrep rule YAML and return the path."""
    rule_path = os.path.join(rule_dir, "secrets-rule.yaml")
    with open(rule_path, "w") as f:
        f.write(CUSTOM_RULE_YAML.strip())
    return rule_path


def write_test_codebase(test_dir: str) -> str:
    """Write a crafted Python file containing hardcoded secrets."""
    test_path = os.path.join(test_dir, "sample_app.py")
    with open(test_path, "w") as f:
        f.write(TEST_CODEBASE.strip())
    return test_path


def run_semgrep(rule_path: str, target_path: str) -> dict:
    """Run semgrep scan with the custom rule and return parsed JSON."""
    result = subprocess.run(
        ["semgrep", "--config", rule_path, "--json", target_path],
        capture_output=True,
        text=True,
    )
    if result.returncode not in (0, 1):
        # Semgrep exits 1 when findings are found — that's expected here
        raise RuntimeError(
            f"semgrep failed (rc={result.returncode}): {result.stderr}"
        )
    return json.loads(result.stdout)


def print_findings(report: dict) -> None:
    """Pretty-print the list of findings."""
    results = report.get("results", [])
    if not results:
        print("No hardcoded secrets detected. (Rule may need tuning.)")
        return

    print(f"Found {len(results)} potential hardcoded secret(s):\n")
    for r in results:
        path = r.get("path", "?")
        start = r.get("start", {})
        line = start.get("line", "?")
        col = start.get("col", "?")
        lines = r.get("extra", {}).get("lines", "")
        print(f"  {path}:{line}:{col}")
        print(f"    {lines.strip()}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--keep-temps",
        action="store_true",
        help="Keep temp files after run (useful for debugging)",
    )
    args = parser.parse_args()

    tmp_root = tempfile.mkdtemp(prefix="semgrep-secrets-")

    try:
        rule_dir = os.path.join(tmp_root, "rules")
        test_dir = os.path.join(tmp_root, "test_codebase")
        os.makedirs(rule_dir)
        os.makedirs(test_dir)

        rule_path = write_rule(rule_dir)
        test_path = write_test_codebase(test_dir)

        print("--- Rule ---")
        print(CUSTOM_RULE_YAML.strip())
        print()

        print("--- Test target ---")
        print(TEST_CODEBASE.strip())
        print()

        print("--- Scan ---")
        report = run_semgrep(rule_path, test_path)
        print_findings(report)

    except FileNotFoundError:
        print("Error: semgrep not found. Install it with: pip install semgrep", file=sys.stderr)
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"Error: could not parse semgrep output — {e}", file=sys.stderr)
        sys.exit(1)
    except RuntimeError as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
    finally:
        if not args.keep_temps:
            import shutil

            shutil.rmtree(tmp_root, ignore_errors=True)
        else:
            print(f"Temp files kept at: {tmp_root}")


if __name__ == "__main__":
    main()
