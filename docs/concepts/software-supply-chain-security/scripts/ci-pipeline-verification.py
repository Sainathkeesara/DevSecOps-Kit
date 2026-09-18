#!/usr/bin/env python3
# last_verified: 2026-09-18 · software-supply-chain-security (concept, n/a)
"""CI pipeline verification gate: Software Supply Chain Security + CI/CD stages.

This pattern combines Software Supply Chain Security with CI/CD Pipeline
Concepts — the SCS prevention/triage/governance gates slot into the pipeline
stages (commit -> build -> registry -> deploy) instead of being bolted on at
the end. It follows the model in NIST SP 800-204D ("Strategies for the
Integration of Software Supply Chain Security in DevSecOps CI/CD Pipelines",
final February 2024, DOI 10.6028/NIST.SP.800-204D), which treats the
build, test, package, and deploy stages as the software supply chain itself.

Three gates, evaluated in order so the cheapest check fails first:

1. Shift-left prevention gate — block risky components before they enter the
   pipeline (package firewall idea: policy-based blocking of non-compliant
   downloads, plus SCA mapping of direct AND transitive dependencies).
2. Reachability triage — only findings whose vulnerable method is actually
   invoked from first-party code count as exploitable; the rest are
   deprioritised instead of paging anyone.
3. Governance — require an SBOM for the build and an enforced policy;
   without those, the release is not compliant no matter what gates 1-2 say.

Why this matters: most critical security debt sits in third-party code, so
an unverified dependency chain is the normal path to a breach, not an edge
case. This script is the executable half of that idea: run it as a CI step
and let its exit code gate the pipeline (0 = pass, 1 = gate failed,
2 = bad input/usage).

Sources:
- https://csrc.nist.gov/pubs/sp/800/204/d/final
- https://www.veracode.com/blog/devsecops-framework-software-supply-chain-security

Usage:
    python3 ci-pipeline-verification.py pipeline-input.json
    python3 ci-pipeline-verification.py --demo   # run on built-in sample data
"""

import json
import sys

DEMO_INPUT = {
    "dependencies": [
        {"name": "acme-web-framework", "version": "2.4.0", "transitive": False},
        {"name": "acme-template-engine", "version": "1.9.1", "transitive": True},
        {"name": "blocked-evil-miner", "version": "0.0.3", "transitive": True},
    ],
    "findings": [
        {"id": "F-001", "package": "acme-template-engine", "summary": "vulnerable render method"},
        {"id": "F-002", "package": "acme-web-framework", "summary": "vulnerable helper never called"},
    ],
    "invoked": {"F-001": True, "F-002": False},
    "sbom": {"generated": True, "artifact": "app-1.2.3.spdx.json"},
    "policy": {"blocked_packages": ["blocked-evil-miner"], "require_sbom": True},
}


def load_input(path):
    """Load and shape-check the pipeline input file; exit 2 on any problem."""
    try:
        with open(path, encoding="utf-8") as handle:
            data = json.load(handle)
    except FileNotFoundError:
        print(f"error: input file not found: {path}", file=sys.stderr)
        raise SystemExit(2)
    except json.JSONDecodeError as exc:
        print(f"error: invalid JSON in {path}: {exc}", file=sys.stderr)
        raise SystemExit(2)
    if not isinstance(data, dict):
        print(f"error: top-level JSON in {path} must be an object", file=sys.stderr)
        raise SystemExit(2)
    return data


def prevention_gate(data):
    """Gate 1: reject blocked packages (direct or transitive)."""
    blocked = set(data.get("policy", {}).get("blocked_packages", []))
    hits = [d for d in data.get("dependencies", []) if d.get("name") in blocked]
    for hit in hits:
        scope = "transitive" if hit.get("transitive") else "direct"
        print(f"BLOCKED ({scope} dependency): {hit.get('name')} {hit.get('version', '')}")
    return hits


def reachability_triage(data):
    """Gate 2: only invoked findings are exploitable; the rest are deferred."""
    invoked = data.get("invoked", {})
    exploitable = [f for f in data.get("findings", []) if invoked.get(f.get("id"))]
    deferred = [f for f in data.get("findings", []) if not invoked.get(f.get("id"))]
    for finding in exploitable:
        print(f"EXPLOITABLE: {finding.get('id')} in {finding.get('package')}")
    for finding in deferred:
        print(f"deferred (not invoked): {finding.get('id')} in {finding.get('package')}")
    return exploitable


def governance_check(data):
    """Gate 3: SBOM present when policy requires it."""
    gaps = []
    if data.get("policy", {}).get("require_sbom") and not data.get("sbom", {}).get("generated"):
        gaps.append("policy requires an SBOM but none was generated for this build")
    for gap in gaps:
        print(f"POLICY GAP: {gap}")
    return gaps


def main(argv):
    if len(argv) == 2 and argv[1] == "--demo":
        data = DEMO_INPUT
    elif len(argv) == 2:
        data = load_input(argv[1])
    else:
        print("usage: ci-pipeline-verification.py <pipeline-input.json|--demo>", file=sys.stderr)
        raise SystemExit(2)

    failures = []
    failures.extend(prevention_gate(data))
    failures.extend(reachability_triage(data))
    failures.extend(governance_check(data))

    if failures:
        print(f"GATE FAILED: {len(failures)} blocking issue(s) — stopping the pipeline")
        raise SystemExit(1)
    print("GATE PASSED: no blocked, exploitable, or non-compliant issues")
    raise SystemExit(0)


if __name__ == "__main__":
    main(sys.argv)
