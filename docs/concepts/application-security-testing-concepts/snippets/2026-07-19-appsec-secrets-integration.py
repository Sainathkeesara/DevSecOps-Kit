# last_verified: 2026-07-19 · Application Security Testing + Secrets & Access Management

"""
L3 integration exercise: combining Application Security Testing (AST) with
Secrets & Access Management (SAM).

The pattern below shows how an AST finding (a hardcoded secret in source)
and the runtime secret store (Vault-style) are reconciled into a single
source of truth: the scanner reports where secrets leak, SAM tells the
pipeline how to stop storing them in code.

Research note: hardcoded secrets are a first-class AST finding. Real
pipelines pair secrets scanning (GitGuardian/TruffleHog) with Vault-style
secrets management so the scanner's findings and the runtime's secret
storage are the same single source of truth.
[source: https://www.invicti.com/blog/web-security/integrating-appsec-into-ci-cd-workflows]
"""

import os
import re
import sys
from dataclasses import dataclass


# A minimal secret pattern. Real scanners use a far larger, tuned ruleset.
SECRET_PATTERNS = {
    "aws_access_key": re.compile(r"AKIA[0-9A-Z]{16}"),
    "generic_api_key": re.compile(r"(?i)api[_-]?key\s*=\s*['\"][A-Za-z0-9]{16,}['\"]"),
    "private_key": re.compile(r"-----BEGIN (RSA |EC )?PRIVATE KEY-----"),
}


@dataclass
class Finding:
    path: str
    line: int
    kind: str
    snippet: str


def scan_source(path: str) -> list[Finding]:
    """Run a small SAST secret scan over a single file."""
    findings: list[Finding] = []
    with open(path, "r", encoding="utf-8", errors="ignore") as fh:
        for lineno, line in enumerate(fh, start=1):
            for kind, pattern in SECRET_PATTERNS.items():
                if pattern.search(line):
                    findings.append(Finding(path, lineno, kind, line.strip()))
    return findings


def reconcile_with_secret_store(findings: list[Finding], vault_keys: set[str]) -> dict:
    """
    Map each AST secret finding to its managed equivalent in the secret
    store. Findings whose key already exists in SAM are 'promoted' (the
    code reference should be replaced with a lookup); findings with no
    managed equivalent are flagged for rotation + registration.
    """
    report = {"promotable": [], "unmanaged": []}
    for f in findings:
        # Derive a stable key name from the matched line when possible.
        match = re.search(r"['\"]([A-Za-z0-9_]{8,})['\"]", f.snippet)
        candidate = match.group(1) if match else f.snippet[:16]
        if candidate in vault_keys:
            report["promotable"].append(f)
        else:
            report["unmanaged"].append(f)
    return report


if __name__ == "__main__":
    target = sys.argv[1] if len(sys.argv) > 1 else "sample.py"
    # In a real pipeline the vault key set would come from `vault list`.
    managed = set(os.environ.get("VAULT_KEYS", "").split(",")) if os.environ.get("VAULT_KEYS") else set()
    found = scan_source(target)
    summary = reconcile_with_secret_store(found, managed)
    print(f"Scanned {target}: {len(found)} secret finding(s)")
    print(f"  promotable (exists in SAM): {len(summary['promotable'])}")
    print(f"  unmanaged (register + rotate): {len(summary['unmanaged'])}")
