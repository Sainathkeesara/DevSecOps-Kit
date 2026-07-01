#!/usr/bin/env python3
"""Aggregate TruffleHog results from multiple repositories into a summary report."""

import json
import os
import glob
from pathlib import Path
from collections import Counter

REPORTS_DIR = Path("reports")
SUMMARY_FILE = REPORTS_DIR / "summary.md"

def load_results():
    """Load all JSON result files from the reports directory."""
    all_results = []
    for json_file in REPORTS_DIR.glob("*.json"):
        if json_file.name == "summary.md":
            continue
        try:
            with open(json_file) as f:
                for line in f:
                    if line.strip():
                        all_results.append({
                            **json.loads(line),
                            "_repo": json_file.stem.split("-")[0]
                        })
        except (json.JSONDecodeError, FileNotFoundError):
            continue
    return all_results

def generate_summary(results):
    """Generate markdown summary from aggregated results."""
    if not results:
        return "# TruffleHog Scan Summary\n\nNo secrets detected across all repositories."

    # Count by detector and repository
    by_detector = Counter(r.get("DetectorName", "unknown") for r in results)
    by_repo = Counter(r.get("_repo", "unknown") for r in results)
    verified = sum(1 for r in results if r.get("Verified", False))

    lines = [
        "# TruffleHog Scan Summary",
        "",
        "## Overview",
        "",
        f"- Total findings: {len(results)}",
        f"- Verified secrets: {verified}",
        f"- Unverified secrets: {len(results) - verified}",
        "",
        "## Findings by Repository",
        "",
    ]

    for repo, count in by_repo.most_common():
        lines.append(f"- {repo}: {count} findings")

    lines.extend([
        "",
        "## Findings by Detector",
        "",
    ])

    for detector, count in by_detector.most_common():
        lines.append(f"- {detector}: {count}")

    lines.extend([
        "",
        "## Recommendations",
        "",
        "- Review verified secrets first — these are actively exploitable",
        "- Update `.trufflehog/allowlist.yaml` for intentional false positives",
        "- Consider adding custom detectors for organization-specific patterns",
    ])

    return "\n".join(lines)

if __name__ == "__main__":
    results = load_results()
    summary = generate_summary(results)

    REPORTS_DIR.mkdir(exist_ok=True)
    with open(SUMMARY_FILE, "w") as f:
        f.write(summary)

    print(summary)