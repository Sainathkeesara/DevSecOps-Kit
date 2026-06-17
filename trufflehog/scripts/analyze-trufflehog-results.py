#!/usr/bin/env python3
"""
Analyze TruffleHog JSON results — filter, group, and summarize.

Reads TruffleHog JSON from stdin or a file, then prints a summary grouped
by detector, file, or severity.  Useful as a CI post-processing step or
for triaging a large result set.

Usage:
    trufflehog filesystem ./repo --json | python3 analyze-trufflehog-results.py
    python3 analyze-trufflehog-results.py --input results.json --group detector
"""

import argparse
import json
import sys
from collections import Counter, defaultdict


def load_results(source: str | None) -> list[dict]:
    """Read TruffleHog JSON lines or array from *source* (file or stdin)."""
    if source:
        with open(source) as f:
            raw = f.read()
    else:
        raw = sys.stdin.read()

    # TruffleHog outputs one JSON object per line (JSON lines) *or* a JSON array
    objects: list[dict] = []
    for line in raw.strip().splitlines():
        stripped = line.strip()
        if not stripped:
            continue
        try:
            obj = json.loads(stripped)
        except json.JSONDecodeError:
            continue  # skip non-JSON lines
        if isinstance(obj, list):
            objects.extend(obj)
        else:
            objects.append(obj)
    return objects


def detector_name(result: dict) -> str:
    """Return the detector name, falling back to *Unknown*."""
    return result.get("DetectorName") or result.get("detector_name") or "Unknown"


def source_file(result: dict) -> str:
    """Best-effort file path from a TruffleHog result."""
    meta = result.get("SourceMetadata") or result.get("source_metadata") or {}
    data = meta.get("Data") or meta.get("data") or {}
    fs = data.get("Filesystem") or data.get("filesystem") or {}
    git = data.get("Git") or data.get("git") or {}
    return fs.get("file") or git.get("file") or git.get("commit") or "unknown"


def severity_label(result: dict) -> str:
    """Classify severity based on verification status and detector name."""
    if result.get("Verified") or result.get("verified"):
        return "CRITICAL"
    name = detector_name(result).lower()
    if "private" in name or "credential" in name or "token" in name:
        return "HIGH"
    if "key" in name or "secret" in name:
        return "MEDIUM"
    return "LOW"


def print_grouped(results: list[dict], group_key: str) -> None:
    """Print analysis grouped by *group_key* (detector | file | severity)."""
    groups: dict[str, list[dict]] = defaultdict(list)
    key_funcs = {
        "detector": detector_name,
        "file": source_file,
        "severity": severity_label,
    }
    fn = key_funcs.get(group_key)
    if not fn:
        print(f"Unknown group key: {group_key}", file=sys.stderr)
        sys.exit(1)

    for r in results:
        groups[fn(r)].append(r)

    for key in sorted(groups):
        items = groups[key]
        verified = sum(1 for i in items if i.get("Verified") or i.get("verified"))
        print(f"\n{'='*60}")
        print(f"{group_key.upper()}: {key}  ({len(items)} results, {verified} verified)")
        print(f"{'='*60}")
        for i in items:
            file_ = source_file(i)
            dn = detector_name(i)
            ver = "✓" if i.get("Verified") or i.get("verified") else " "
            print(f"  [{ver}] {dn:30s}  {file_}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Analyze TruffleHog JSON results")
    parser.add_argument("--input", "-i", help="Read from file instead of stdin")
    parser.add_argument(
        "--group",
        "-g",
        default="detector",
        choices=["detector", "file", "severity"],
        help="Grouping key (default: detector)",
    )
    parser.add_argument(
        "--min-severity",
        choices=["LOW", "MEDIUM", "HIGH", "CRITICAL"],
        help="Minimum severity to show",
    )
    args = parser.parse_args()

    results = load_results(args.input)
    if not results:
        print("No results to analyze.", file=sys.stderr)
        sys.exit(1)

    if args.min_severity:
        levels = {"LOW": 0, "MEDIUM": 1, "HIGH": 2, "CRITICAL": 3}
        threshold = levels[args.min_severity]
        results = [r for r in results if levels[severity_label(r)] >= threshold]

    total = len(results)
    verified = sum(1 for r in results if r.get("Verified") or r.get("verified"))
    detector_counts = Counter(detector_name(r) for r in results)

    print(f"Total results: {total}  |  Verified: {verified}")
    print(f"Unique detectors: {len(detector_counts)}")
    print(f"Top detectors:")
    for det, count in detector_counts.most_common(5):
        print(f"  {det}: {count}")

    print_grouped(results, args.group)


if __name__ == "__main__":
    main()
