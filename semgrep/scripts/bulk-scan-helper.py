#!/usr/bin/env python3
"""Bulk Semgrep scan helper: scan a list of targets and aggregate results.

Purpose:
  Run Semgrep against multiple directories/files with a shared config,
  produce per-target and summary JSON output, and exit non-zero if any
  target has findings at or above a severity threshold.

Steps:
  1. Read target paths from a file (one per line) or CLI args.
  2. For each target, run `semgrep --config=auto --json <target>`.
  3. Collect findings; filter to the requested severity and above.
  4. Write per-target JSON and a combined summary JSON.
  5. Exit 0 when no findings match the threshold, 1 otherwise.

Usage:
  python bulk-scan-helper.py --targets-file targets.txt --severity HIGH
  python bulk-scan-helper.py /path/to/repo-a /path/to/repo-b --severity CRITICAL
"""

import argparse
import json
import subprocess
import sys
from pathlib import Path


SEVERITY_RANKS = {
    "INFO": 0,
    "LOW": 1,
    "MEDIUM": 2,
    "HIGH": 3,
    "CRITICAL": 4,
}


def severity_rank(value: str) -> int:
    return SEVERITY_RANKS.get(value.upper(), -1)


def should_include(finding_severity: str, threshold: str) -> bool:
    return severity_rank(finding_severity) >= severity_rank(threshold)


def run_semgrep(target: str, config: str) -> dict:
    result = subprocess.run(
        ["semgrep", "--config", config, "--json", target],
        capture_output=True,
        text=True,
    )
    if result.returncode not in (0, 1):
        raise RuntimeError(
            f"semgrep failed for {target} (rc={result.returncode}): {result.stderr}"
        )
    try:
        return json.loads(result.stdout)
    except json.JSONDecodeError:
        return {"results": [], "errors": result.stderr}


def filter_findings(report: dict, threshold: str) -> list:
    kept = []
    for finding in report.get("results", []):
        sev = finding.get("extra", {}).get("severity", "INFO")
        if should_include(sev, threshold):
            kept.append(finding)
    return kept


def write_json(path: Path, data: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2))


def main() -> int:
    parser = argparse.ArgumentParser(description="Bulk Semgrep scan helper")
    parser.add_argument("targets", nargs="*", help="Directories or files to scan")
    parser.add_argument(
        "--targets-file",
        help="File with one target per line (ignored if positional targets given)",
    )
    parser.add_argument(
        "--config",
        default="auto",
        help="Semgrep config (default: auto)",
    )
    parser.add_argument(
        "--severity",
        default="HIGH",
        choices=list(SEVERITY_RANKS.keys()),
        help="Minimum severity to include in results (default: HIGH)",
    )
    parser.add_argument(
        "--output-dir",
        default="semgrep-bulk-output",
        help="Directory for per-target and summary JSON files",
    )
    args = parser.parse_args()

    targets = args.targets
    if not targets and args.targets_file:
        targets = [
            line.strip()
            for line in Path(args.targets_file).read_text().splitlines()
            if line.strip() and not line.strip().startswith("#")
        ]

    if not targets:
        print("No targets provided. Pass paths or use --targets-file.", file=sys.stderr)
        return 2

    out_dir = Path(args.output_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    summary_findings = []
    had_findings = False

    for target in targets:
        print(f"Scanning: {target}")
        report = run_semgrep(target, args.config)
        findings = filter_findings(report, args.severity)
        target_label = target.replace("/", "_").replace("\\", "_")
        write_json(
            out_dir / f"{target_label}.json",
            {"target": target, "findings": findings, "count": len(findings)},
        )
        summary_findings.append({"target": target, "count": len(findings)})
        if findings:
            had_findings = True
            print(f"  -> {len(findings)} finding(s) at {args.severity}+")
        else:
            print("  -> clean")

    summary = {
        "threshold": args.severity,
        "targets": summary_findings,
        "total_findings": sum(item["count"] for item in summary_findings),
    }
    write_json(out_dir / "summary.json", summary)
    print(f"\nSummary written to {out_dir / 'summary.json'}")

    return 1 if had_findings else 0


if __name__ == "__main__":
    sys.exit(main())
