"""Convert Grype JSON results to SARIF 2.1.0 format.

Reads Grype JSON output from a file or stdin and produces a SARIF log
suitable for GitHub Code Scanning, Azure DevOps, or other SARIF consumers.

Usage:
    grype-results-to-sarif.py <input.json> -o <output.sarif>
    grype grype-results-to-sarif.py <input.json>
    grype image alpine:latest -o json | grype-results-to-sarif.py --stdin
"""

import argparse
import json
import sys
from pathlib import Path


def parse_grype_results(data: dict) -> list[dict]:
    matches = data.get("matches", [])
    if not matches and "vulnerabilities" in data:
        matches = data["vulnerabilities"]
    return matches


def severity_to_sarif_level(severity: str) -> str:
    mapping = {
        "Critical": "error",
        "High": "error",
        "Medium": "warning",
        "Low": "note",
        "Negligible": "note",
        "Unknown": "none",
    }
    return mapping.get(severity, "none")


def build_sarif_log(matches: list[dict]) -> dict:
    results = []
    for match in matches:
        vuln = match.get("vulnerability", match)
        artifact = match.get("artifact", {})
        severity = vuln.get("severity", "Unknown")
        fix = vuln.get("fix", {})
        fix_versions = fix.get("versions", []) if isinstance(fix, dict) else []

        locations = []
        for loc in artifact.get("locations", []):
            path = loc.get("path", "")
            if path:
                locations.append({
                    "physicalLocation": {
                        "artifactLocation": {"uri": path},
                        "region": {"startLine": loc.get("lineNumber", 1)},
                    }
                })
        if not locations:
            locations.append({
                "physicalLocation": {
                    "artifactLocation": {"uri": artifact.get("name", "unknown")},
                }
            })

        fix_text = (
            f"Fixed in: {', '.join(fix_versions)}"
            if fix_versions
            else "No fix available"
        )
        results.append({
            "ruleId": vuln.get("id", ""),
            "level": severity_to_sarif_level(severity),
            "message": {
                "text": (
                    f"{vuln.get('id', '')} in {artifact.get('name', 'unknown')} "
                    f"{artifact.get('version', '')}: {vuln.get('description', '')} "
                    f"({fix_text})"
                ),
            },
            "locations": locations,
            "properties": {
                "severity": severity,
                "package": artifact.get("name", ""),
                "version": artifact.get("version", ""),
                "type": artifact.get("type", ""),
                "fix_versions": fix_versions,
            },
        })

    return {
        "$schema": "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/master/Schemata/sarif-schema-2.1.0.json",
        "version": "2.1.0",
        "runs": [
            {
                "tool": {
                    "driver": {
                        "name": "Grype",
                        "informationUri": "https://github.com/anchore/grype",
                        "version": "",
                    }
                },
                "results": results,
            }
        ],
    }


def main():
    parser = argparse.ArgumentParser(
        description="Convert Grype JSON output to SARIF 2.1.0 format"
    )
    source = parser.add_mutually_exclusive_group()
    source.add_argument("input", nargs="?", help="Path to Grype JSON file")
    source.add_argument("--stdin", action="store_true", help="Read JSON from stdin")
    parser.add_argument("-o", "--output", help="Write SARIF to file instead of stdout")
    args = parser.parse_args()

    if args.stdin:
        try:
            data = json.load(sys.stdin)
        except json.JSONDecodeError as e:
            print(f"Error: invalid JSON from stdin: {e}", file=sys.stderr)
            sys.exit(1)
    elif args.input:
        path = Path(args.input)
        if not path.exists():
            print(f"Error: file not found: {args.input}", file=sys.stderr)
            sys.exit(1)
        try:
            with open(path) as f:
                data = json.load(f)
        except json.JSONDecodeError as e:
            print(f"Error: invalid JSON in {args.input}: {e}", file=sys.stderr)
            sys.exit(1)
    else:
        print("Error: provide an input file or --stdin", file=sys.stderr)
        sys.exit(1)

    matches = parse_grype_results(data)
    sarif = build_sarif_log(matches)

    output = json.dumps(sarif, indent=2)
    if args.output:
        Path(args.output).write_text(output)
        print(f"Wrote SARIF to {args.output}")
    else:
        print(output)


if __name__ == "__main__":
    main()
