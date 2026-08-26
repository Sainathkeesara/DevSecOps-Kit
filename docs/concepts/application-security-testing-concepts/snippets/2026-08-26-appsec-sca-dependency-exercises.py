#!/usr/bin/env python3
# last_verified: 2026-08-26 · python 3.12+
"""Practice exercises for SCA (Software Composition Analysis) concepts.

I wrote this to understand how dependency scanning differs from SAST/DAST.
SCA doesn't analyze my code — it analyzes what my code pulls in.
This script simulates a dependency manifest, checks it against a mock
vulnerability database, and shows how SCA tools prioritize findings.
"""

import json
import subprocess
import sys
from dataclasses import dataclass
from typing import Optional


@dataclass
class Dependency:
    name: str
    version: str
    ecosystem: str  # "pypi", "npm", "maven", "go", etc.


@dataclass
class Vulnerability:
    id: str
    package: str
    affected_versions: str  # e.g., ">=1.0.0, <2.5.0"
    severity: str  # "critical", "high", "medium", "low"
    cwe: Optional[str] = None
    description: str = ""


MOCK_VULN_DB = [
    Vulnerability(
        id="CVE-2024-12345",
        package="requests",
        affected_versions="<2.32.0",
        severity="high",
        cwe="CWE-200",
        description="Information exposure via redirect headers",
    ),
    Vulnerability(
        id="CVE-2024-23456",
        package="urllib3",
        affected_versions="<2.2.0",
        severity="critical",
        cwe="CWE-20",
        description="Improper input validation in proxy handling",
    ),
    Vulnerability(
        id="CVE-2024-34567",
        package="django",
        affected_versions=">=4.0, <4.2.10",
        severity="high",
        cwe="CWE-79",
        description="XSS in admin interface via crafted URL",
    ),
    Vulnerability(
        id="CVE-2024-45678",
        package="numpy",
        affected_versions="<1.26.0",
        severity="medium",
        cwe="CWE-125",
        description="Out-of-bounds read in array processing",
    ),
    Vulnerability(
        id="GHSA-xxxx-yyyy-zzzz",
        package="pyyaml",
        affected_versions="<6.0.1",
        severity="critical",
        cwe="CWE-502",
        description="YAML deserialization allows arbitrary code execution",
    ),
]


def parse_version(version: str) -> tuple:
    """Parse a version string into comparable tuple. Handles basic semver."""
    parts = []
    for part in version.split("."):
        try:
            parts.append(int(part))
        except ValueError:
            parts.append(part)
    return tuple(parts)


def version_matches(version: str, constraint: str) -> bool:
    """Check if a version matches a constraint like '<2.32.0' or '>=4.0, <4.2.10'."""
    constraints = [c.strip() for c in constraint.split(",")]
    v = parse_version(version)

    for c in constraints:
        if c.startswith(">="):
            min_v = parse_version(c[2:])
            if v < min_v:
                return False
        elif c.startswith(">"):
            min_v = parse_version(c[1:])
            if v <= min_v:
                return False
        elif c.startswith("<="):
            max_v = parse_version(c[2:])
            if v > max_v:
                return False
        elif c.startswith("<"):
            max_v = parse_version(c[1:])
            if v >= max_v:
                return False
        elif c.startswith("=="):
            exact_v = parse_version(c[2:])
            if v != exact_v:
                return False
        elif c.startswith("!="):
            exact_v = parse_version(c[2:])
            if v == exact_v:
                return False
    return True


def scan_dependencies(deps: list[Dependency]) -> list[dict]:
    """Scan a list of dependencies against the mock vulnerability database."""
    findings = []
    for dep in deps:
        for vuln in MOCK_VULN_DB:
            if vuln.package.lower() == dep.name.lower():
                if version_matches(dep.version, vuln.affected_versions):
                    findings.append({
                        "tool": "SCA",
                        "package": dep.name,
                        "version": dep.version,
                        "vulnerability_id": vuln.id,
                        "severity": vuln.severity,
                        "cwe": vuln.cwe,
                        "description": vuln.description,
                    })
    return findings


def prioritize_findings(findings: list[dict]) -> list[dict]:
    """Sort findings by severity: critical > high > medium > low > info."""
    severity_order = {"critical": 0, "high": 1, "medium": 2, "low": 3, "info": 4}
    return sorted(findings, key=lambda f: severity_order.get(f["severity"], 5))


def generate_sbom_snippet(deps: list[Dependency]) -> dict:
    """Generate a minimal SPDX-like SBOM snippet for the dependencies."""
    return {
        "spdxVersion": "SPDX-2.3",
        "dataLicense": "CC0-1.0",
        "SPDXID": "SPDXRef-DOCUMENT",
        "name": "appsec-exercise-sbom",
        "documentNamespace": "https://example.com/sbom/appsec-exercise",
        "packages": [
            {
                "SPDXID": f"SPDXRef-{dep.name}",
                "name": dep.name,
                "versionInfo": dep.version,
                "downloadLocation": f"pkg:{dep.ecosystem}/{dep.name}@{dep.version}",
                "licenseConcluded": "NOASSERTION",
            }
            for dep in deps
        ],
    }


def main():
    print("=" * 70)
    print("Exercise: SCA dependency scanning + SBOM generation")
    print("=" * 70)

    project_deps = [
        Dependency("requests", "2.31.0", "pypi"),
        Dependency("urllib3", "1.26.18", "pypi"),
        Dependency("django", "4.2.5", "pypi"),
        Dependency("numpy", "1.25.3", "pypi"),
        Dependency("pyyaml", "5.4.1", "pypi"),
        Dependency("certifi", "2024.2.2", "pypi"),  # no vulns in mock DB
    ]

    print("\n--- Project Dependencies ---")
    for dep in project_deps:
        print(f"  {dep.name}=={dep.version} ({dep.ecosystem})")

    print("\n--- Step 1: SCA Scan ---")
    findings = scan_dependencies(project_deps)
    findings = prioritize_findings(findings)

    if not findings:
        print("  No vulnerabilities found in mock database.")
    else:
        for f in findings:
            cwe_str = f" [{f['cwe']}]" if f["cwe"] else ""
            print(f"  [{f['severity'].upper()}] {f['package']}=={f['version']}: {f['vulnerability_id']}{cwe_str}")
            print(f"    {f['description']}")
    print("  -> SCA finds known vulnerabilities in dependencies, not in your code.")

    print("\n--- Step 2: Severity-based gating (pipeline simulation) ---")
    block_on = {"critical", "high"}
    blocking = [f for f in findings if f["severity"] in block_on]
    warning = [f for f in findings if f["severity"] not in block_on]

    print(f"  Blocking findings (fail pipeline): {len(blocking)}")
    print(f"  Warning findings (pass with notice): {len(warning)}")
    if blocking:
        print("  -> Pipeline would FAIL. Fix or pin safe versions before merge.")
    else:
        print("  -> Pipeline would PASS (with warnings).")

    print("\n--- Step 3: Generate SBOM (SPDX snippet) ---")
    sbom = generate_sbom_snippet(project_deps)
    print(f"  Packages in SBOM: {len(sbom['packages'])}")
    print("  Sample entry:")
    print(f"    {json.dumps(sbom['packages'][0], indent=4)}")
    print("  -> SBOM gives downstream consumers a machine-readable inventory.")

    print("\n--- Takeaway ---")
    print("  SCA is distinct from SAST/DAST: it scans declared dependencies,")
    print("  not source code or running apps. It's fast (no build needed) and")
    print("  catches supply-chain issues (CVE-2024-3094 style).")
    print("  Combine with SAST (per-commit) and DAST (per-deploy) for coverage.")


if __name__ == "__main__":
    main()