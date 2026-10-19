#!/usr/bin/env python3
# last_verified: 2026-10-19 · snippets L2
# Minimal reusable Python snippet for the kit: a tiny helper to load a YAML config file
# and return a typed dict. Used by other snippets that need shared configuration.

from pathlib import Path
from typing import Any
import yaml


def load_config(config_path: str | Path) -> dict[str, Any]:
    """Load a YAML config file and return its contents as a dict.

    Args:
        config_path: Path to the YAML file (relative to repo root or absolute).

    Returns:
        Parsed YAML content as a dictionary. Returns empty dict if file not found.

    Example:
        config = load_config("snippets/configs/2026-09-20-first-category.yaml")
        print(config["categories"][0]["name"])  # -> "bash-scripting"
    """
    path = Path(config_path)
    if not path.is_absolute():
        # Assume relative to repo root; caller can adjust as needed
        repo_root = Path(__file__).parents[2]  # snippets/snippets/ -> repo root
        path = repo_root / path

    if not path.exists():
        return {}

    with path.open("r", encoding="utf-8") as f:
        data = yaml.safe_load(f)

    return data if isinstance(data, dict) else {}


if __name__ == "__main__":
    # Quick self-test: load the existing category config and print category names
    cfg = load_config("snippets/configs/2026-09-20-first-category.yaml")
    for cat in cfg.get("categories", []):
        print(f"- {cat['name']}: {cat['description']}")