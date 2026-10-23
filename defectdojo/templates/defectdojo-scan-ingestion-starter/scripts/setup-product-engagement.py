#!/usr/bin/env python3
# last_verified: 2026-10-23 · DefectDojo API v2

"""
DefectDojo product and engagement setup script.

Purpose:
    Create or retrieve a DefectDojo product and engagement via the REST API.
    This script is designed for CI pipelines that need a stable product/engagement
    context before importing scan results.

When to use:
    - Bootstrap a new application in DefectDojo before the first scan import.
    - Ensure a consistent engagement exists for scheduled CI scans.
    - Script the product/engagement creation step separately from scan import.

Prerequisites:
    - DefectDojo instance reachable at DEFECTDOJO_URL (default: http://localhost:8080).
    - API token with product/engagement write permissions (DEFECTDOJO_TOKEN).
    - Python 3.8+ with requests library (pip install requests).

Steps:
    1. Parse command-line arguments and environment variables.
    2. Validate the DefectDojo API token and base URL.
    3. Look up the product by name; create it if missing.
    4. Look up the engagement by name on that product; create it if missing.
    5. Print the product and engagement IDs for downstream consumers.

Verify:
    - Script exits with 0 and prints product_id and engagement_id.
    - In DefectDojo UI, the product and engagement appear with the given names.
    - Re-running the script with the same names returns the existing IDs (idempotent).

Common errors:
    - Missing DEFECTDOJO_TOKEN: create a token in DefectDojo → User Settings → API Token.
    - HTTP 403: token lacks product/engagement write permission.
    - HTTP 404: DEFECTDOJO_URL is wrong or API v2 is not enabled.
    - Product type ID 1 does not exist: create a product type first in the UI.

References:
    - DefectDojo API v2 docs: /api/v2/doc/ (on your DefectDojo instance)
    - Existing kit script: defectdojo/scripts/product-engagement-setup.py
"""

import argparse
import os
import sys
from datetime import date, timedelta
from typing import Optional

import requests


DEFAULT_BASE_URL = "http://localhost:8080"
API_PREFIX = "/api/v2"
DEFAULT_PRODUCT_TYPE = 1


class DefectDojoError(RuntimeError):
    """Raised when DefectDojo returns an error the script cannot handle."""


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Create or retrieve a DefectDojo product and engagement."
    )
    parser.add_argument(
        "--product-name",
        default=os.getenv("PRODUCT_NAME", "demo-app"),
        help="Product name (env: PRODUCT_NAME, default: demo-app)",
    )
    parser.add_argument(
        "--engagement-name",
        default=os.getenv("ENGAGEMENT_NAME", "ci-scan"),
        help="Engagement name (env: ENGAGEMENT_NAME, default: ci-scan)",
    )
    parser.add_argument(
        "--url",
        default=os.getenv("DEFECTDOJO_URL", DEFAULT_BASE_URL),
        help=f"DefectDojo base URL (env: DEFECTDOJO_URL, default: {DEFAULT_BASE_URL})",
    )
    parser.add_argument(
        "--token",
        default=os.getenv("DEFECTDOJO_TOKEN"),
        help="API token (env: DEFECTDOJO_TOKEN, required)",
    )
    parser.add_argument(
        "--product-type",
        type=int,
        default=int(os.getenv("PRODUCT_TYPE", str(DEFAULT_PRODUCT_TYPE))),
        help=f"Product type ID (env: PRODUCT_TYPE, default: {DEFAULT_PRODUCT_TYPE})",
    )
    parser.add_argument(
        "--engagement-days",
        type=int,
        default=int(os.getenv("ENGAGEMENT_DAYS", "30")),
        help="Engagement duration in days (env: ENGAGEMENT_DAYS, default: 30)",
    )
    parser.add_argument(
        "--output-format",
        choices=("json", "shell"),
        default="shell",
        help="Output format for product_id and engagement_id (default: shell)",
    )
    return parser.parse_args(argv)


def api_headers(token: str) -> dict[str, str]:
    return {"Authorization": f"Token {token}"}


def call(
    method: str,
    url: str,
    headers: dict[str, str],
    **kwargs,
) -> requests.Response:
    try:
        response = requests.request(method, url, timeout=60, headers=headers, **kwargs)
    except requests.RequestException as exc:
        raise DefectDojoError(f"could not reach {url}: {exc}") from exc
    if not response.ok:
        raise DefectDojoError(
            f"{method} {url} -> HTTP {response.status_code}\n{response.text[:500]}"
        )
    return response


def as_items(payload: dict | list) -> list:
    """Normalize list and paginated responses to a flat list."""
    if isinstance(payload, list):
        return payload
    if isinstance(payload, dict):
        results = payload.get("results")
        if isinstance(results, list):
            return results
    return []


def find_product(
    api: str, headers: dict[str, str], name: str
) -> Optional[dict]:
    response = call("GET", f"{api}/products/", headers=headers, params={"name": name})
    for product in as_items(response.json()):
        if product.get("name") == name:
            return product
    return None


def create_product(
    api: str, headers: dict[str, str], name: str, product_type: int
) -> int:
    response = call(
        "POST",
        f"{api}/products/",
        headers={**headers, "Content-Type": "application/json"},
        json={
            "name": name,
            "description": "Created by setup-product-engagement.py",
            "prod_type": product_type,
        },
    )
    product = response.json()
    print(f"Created product '{name}' (id {product['id']})", file=sys.stderr)
    return product["id"]


def find_engagement(
    api: str, headers: dict[str, str], product_id: int, name: str
) -> Optional[dict]:
    response = call(
        "GET", f"{api}/engagements/", headers=headers, params={"product": product_id}
    )
    for engagement in as_items(response.json()):
        if engagement.get("name") == name:
            return engagement
    return None


def create_engagement(
    api: str,
    headers: dict[str, str],
    product_id: int,
    name: str,
    days: int,
) -> int:
    today = date.today()
    response = call(
        "POST",
        f"{api}/engagements/",
        headers={**headers, "Content-Type": "application/json"},
        json={
            "product": product_id,
            "name": name,
            "target_start": today.isoformat(),
            "target_end": (today + timedelta(days=days)).isoformat(),
            "status": "In Progress",
        },
    )
    engagement = response.json()
    print(f"Created engagement '{name}' (id {engagement['id']})", file=sys.stderr)
    return engagement["id"]


def output_result(
    product_id: int,
    engagement_id: int,
    fmt: str,
) -> None:
    if fmt == "json":
        import json
        print(json.dumps({"product_id": product_id, "engagement_id": engagement_id}))
    else:
        print(f"product_id={product_id}")
        print(f"engagement_id={engagement_id}")


def main(argv: list[str]) -> int:
    args = parse_args(argv)

    if not args.token:
        print("Error: DEFECTDOJO_TOKEN is required (env or --token)", file=sys.stderr)
        return 1

    base_url = args.url.rstrip("/")
    api = f"{base_url}{API_PREFIX}"
    headers = api_headers(args.token)

    try:
        product = find_product(api, headers, args.product_name)
        if product is None:
            product_id = create_product(
                api, headers, args.product_name, args.product_type
            )
        else:
            product_id = product["id"]
            print(f"Using existing product '{product['name']}' (id {product_id})", file=sys.stderr)

        engagement = find_engagement(api, headers, product_id, args.engagement_name)
        if engagement is None:
            engagement_id = create_engagement(
                api, headers, product_id, args.engagement_name, args.engagement_days
            )
        else:
            engagement_id = engagement["id"]
            print(f"Using existing engagement '{engagement['name']}' (id {engagement_id})", file=sys.stderr)

    except DefectDojoError as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1

    output_result(product_id, engagement_id, args.output_format)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))