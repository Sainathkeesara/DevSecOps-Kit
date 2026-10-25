#!/usr/bin/env python3
# last_verified: 2026-10-25 · assets n/a
# Asset inventory collector — walks a directory and records size, type, and mtime.

import os
import sys
import json
from pathlib import Path


def collect(root: str) -> list:
    out = []
    for p in Path(root).rglob("*"):
        if not p.is_file():
            continue
        stat = p.stat()
        out.append({
            "path": str(p.relative_to(root)),
            "size_bytes": stat.st_size,
            "mtime": int(stat.st_mtime),
            "ext": p.suffix.lower(),
        })
    return out


if __name__ == "__main__":
    root = sys.argv[1] if len(sys.argv) > 1 else "."
    items = collect(root)
    print(json.dumps(items, indent=2))
    print(f"collected {len(items)} files from {root}", file=sys.stderr)
