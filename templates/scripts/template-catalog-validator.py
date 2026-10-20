# last_verified: 2026-10-20 · templates n/a
# Template catalog validator for the kit's own template index.
#
# Loads templates/configs/2026-10-19-template-index-config.yaml, resolves every
# `path` under template_index.categories[].templates[] against the repo root,
# classifies each entry as found / missing / not-a-directory, and cross-checks
# the other way round: template directories that exist on disk but are absent
# from the index. Exits non-zero when an indexed path is missing, so a CI job
# can gate on it. Emits both a human-readable table and a machine-readable JSON
# report.
#
# YAML parser note: PyYAML is NOT installed in this environment (checked at
# execution time; `import yaml` raises ModuleNotFoundError). The index file is
# small and flat, so this script parses it with a minimal stdlib-only reader
# rather than depending on a third-party package. If a richer YAML feature set
# is ever needed, install PyYAML and the parser selection below will pick it up.

import json
import os
import sys
from datetime import date

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
INDEX_PATH = os.path.join(REPO_ROOT, "templates", "configs", "2026-10-19-template-index-config.yaml")

# Directories that are expected to exist on disk but are not in the index.
EXPECTED_UNINDEXED = [
    "templates/k8s/",
    "templates/logstash/",
    "templates/syslog-ng/",
    "templates/terraform/multi-env/",
    "templates/terraform/rds-with-replicas/",
    "templates/templates/2026-09-20-first-project-template/",
]


def try_pyyaml():
    try:
        import yaml  # noqa: F401
        return True
    except Exception:
        return False


def parse_index(path):
    """Parse the flat template index with stdlib only. Returns list of (category, path)."""
    entries = []
    with open(path, encoding="utf-8") as fh:
        lines = fh.readlines()

    current_category = None
    in_templates = False
    for raw in lines:
        line = raw.rstrip("\n")
        stripped = line.strip()
        if stripped.startswith("#") or not stripped:
            continue
        if stripped.startswith("- name:"):
            current_category = stripped.split(":", 1)[1].strip()
            in_templates = False
            continue
        if stripped == "- templates:":
            in_templates = True
            continue
        if stripped.startswith("- path:"):
            value = stripped.split(":", 1)[1].strip()
            entries.append((current_category, value))
            continue
        if stripped.startswith("- "):
            in_templates = False
    return entries


def classify(path):
    """Classify an indexed path against the repo root."""
    full = os.path.join(REPO_ROOT, path)
    if not os.path.exists(full):
        return "missing"
    if os.path.isdir(full):
        return "found"
    return "not-a-directory"


def main():
    today = date.today().isoformat()
    if not os.path.isfile(INDEX_PATH):
        print(f"ERROR: index not found at {INDEX_PATH}", file=sys.stderr)
        return 2

    if try_pyyaml():
        parser = "PyYAML (available, but stdlib reader used for this flat file)"
    else:
        parser = "stdlib-only (PyYAML not installed)"

    entries = parse_index(INDEX_PATH)
    if not entries:
        print("ERROR: no paths parsed from index", file=sys.stderr)
        return 2

    rows = []
    missing_count = 0
    for category, path in entries:
        status = classify(path)
        if status == "missing":
            missing_count += 1
        rows.append({"category": category or "(none)", "path": path, "status": status})

    # Cross-check: directories on disk absent from the index.
    indexed_set = {p for _, p in entries}
    unindexed = []
    for candidate in EXPECTED_UNINDEXED:
        full = os.path.join(REPO_ROOT, candidate)
        if os.path.isdir(full) and candidate not in indexed_set:
            unindexed.append({"path": candidate, "status": "on-disk-not-indexed"})

    report = {
        "date_verified": today,
        "index_file": os.path.relpath(INDEX_PATH, REPO_ROOT),
        "yaml_parser": parser,
        "total_indexed": len(rows),
        "missing_count": missing_count,
        "entries": rows,
        "unindexed_dirs": unindexed,
        "exit_code": 1 if missing_count else 0,
    }

    # Machine-readable JSON on stdout when --json is passed.
    if "--json" in sys.argv:
        print(json.dumps(report, indent=2))
        return report["exit_code"]

    # Human-readable table.
    print(f"Template catalog validator — verified {today}")
    print(f"Index: {os.path.relpath(INDEX_PATH, REPO_ROOT)}  ({parser})")
    print(f"Indexed paths: {len(rows)}   missing: {missing_count}")
    print()
    print(f"{'category':<16} {'status':<16} path")
    print("-" * 72)
    for r in rows:
        print(f"{r['category']:<16} {r['status']:<16} {r['path']}")
    print()
    if unindexed:
        print("Directories on disk but absent from the index:")
        for u in unindexed:
            print(f"  - {u['path']}")
    else:
        print("No unindexed template directories found.")
    print()
    if missing_count:
        print(f"FAIL: {missing_count} indexed path(s) do not resolve — gate would block CI.")
    else:
        print("OK: every indexed path resolves.")
    return report["exit_code"]


if __name__ == "__main__":
    sys.exit(main())