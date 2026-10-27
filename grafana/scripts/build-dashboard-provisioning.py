# last_verified: 2026-10-27 · grafana n/a
"""Build Grafana dashboard provisioning files from a small Python data model.

Reads a list of dashboard definitions (title, uid, panels) from a JSON
file and writes one provisioning YAML plus one dashboard JSON per entry
into an output directory. Intended to be run in CI before packaging a
Grafana image or before applying manifests to a cluster.
"""

import argparse
import json
import os
import sys
from pathlib import Path

import yaml


def load_dashboards(path: Path) -> list[dict]:
    with path.open() as fh:
        data = json.load(fh)
    if not isinstance(data, list):
        raise ValueError("dashboard file must contain a JSON array")
    for entry in data:
        if "title" not in entry or "uid" not in entry:
            raise ValueError("each dashboard needs 'title' and 'uid'")
    return data


def render_dashboard(entry: dict) -> dict:
    return {
        "uid": entry["uid"],
        "title": entry["title"],
        "schemaVersion": 39,
        "version": 1,
        "refresh": entry.get("refresh", "30s"),
        "panels": entry.get("panels", []),
    }


def write_provisioning(out_dir: Path, dashboards: list[dict]) -> None:
    provisioning = {
        "apiVersion": 1,
        "providers": [
            {
                "name": "default",
                "orgId": 1,
                "folder": "",
                "type": "file",
                "disableDeletion": False,
                "updateIntervalSeconds": 30,
                "allowUiUpdates": True,
                "options": {"path": "/var/lib/grafana/dashboards"},
            }
        ],
    }
    (out_dir / "provisioning").mkdir(parents=True, exist_ok=True)
    (out_dir / "provisioning" / "dashboards.yaml").write_text(
        yaml.safe_dump(provisioning, sort_keys=False)
    )
    dash_dir = out_dir / "dashboards"
    dash_dir.mkdir(parents=True, exist_ok=True)
    for entry in dashboards:
        (dash_dir / f"{entry['uid']}.json").write_text(
            json.dumps(render_dashboard(entry), indent=2) + "\n"
        )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path, help="JSON file of dashboard definitions")
    parser.add_argument("out_dir", type=Path, help="output directory")
    args = parser.parse_args()

    try:
        dashboards = load_dashboards(args.source)
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        print(f"error loading dashboards: {exc}", file=sys.stderr)
        return 2

    try:
        write_provisioning(args.out_dir, dashboards)
    except OSError as exc:
        print(f"error writing output: {exc}", file=sys.stderr)
        return 3

    print(f"wrote {len(dashboards)} dashboard(s) to {args.out_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
