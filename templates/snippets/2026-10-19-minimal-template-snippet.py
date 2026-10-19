# last_verified: 2026-10-19 · templates n/a
"""Minimal reusable kit template snippet.

A tiny helper to show what a 'template snippet' looks like in this kit.
"""
import json
import pathlib
from typing import Any, Dict


def load_template_config(config_path: str | pathlib.Path) -> Dict[str, Any]:
    """Load template configuration from a JSON file."""
    path = pathlib.Path(config_path)
    if not path.exists():
        raise FileNotFoundError(f"Template config not found: {path}")
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def render_project_slug(cfg: Dict[str, Any]) -> str:
    """Return the project slug (lowercase, hyphenated) for a project."""
    name = cfg.get("project_name", "my-service")
    slug = cfg.get("project_slug", name.lower().replace(" ", "-"))
    return slug
