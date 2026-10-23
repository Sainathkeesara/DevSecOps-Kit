#!/usr/bin/env python3
# last_verified: 2026-10-23 · DefectDojo API v2

"""
DefectDojo scan report import script using reimport-scan endpoint.

Purpose:
    Import a scanner report into an existing DefectDojo engagement using the
    reimport-scan endpoint. This updates the existing Test, closes findings
    no longer present in the new report, and avoids duplicate Test accumulation.

When to use:
    - CI pipelines that run scans on every commit and import results.
    - Automated scheduled scans that need deduplication across runs.
    - Any workflow where scan results should update a single Test per engagement.

Prerequisites:
    - DefectDojo instance reachable at DEFECTDOJO_URL (default: http://localhost:8080).
    - API token with test write permissions (DEFECTDOJO_TOKEN).
    - Product and engagement already created (see setup-product-engagement.py).
    - Scanner report in a DefectDojo-supported format (JSON, SARIF).
    - Python 3.8+ with requests library (pip install requests).

Steps:
    1. Parse command-line arguments: report file path and scan_type.
    2. Validate the scan_type against known DefectDojo parser names.
    3. Look up or create the product and engagement (using env defaults).
    4. POST the report file to /api/v2/reimport-scan/ with engagement and scan_type.
    5. Print the response for verification.

Verify:
    - Script exits with 0 on successful import.
    - In DefectDojo UI, the engagement shows a Test with the scan_type name.
    - Findings appear with correct severity, file path, and line numbers.
    - Re-running with an updated report updates the same Test (deduplication).
    - Tags (if provided via env) appear on the Test and Findings.

Common errors:
    - Missing DEFECTDOJO_TOKEN: create a token in DefectDojo → User Settings → API Token.
    - HTTP 403: token lacks test write permission.
    - HTTP 404: DEFECTDOJO_URL is wrong or API v2 is not enabled.
    - Findings not appearing: wrong scan_type string (case-sensitive).
    - Duplicate Tests on each run: using import-scan instead of reimport-scan.
    - Product type not found: default product_type ID 1 missing.

References:
    - DefectDojo API v2 docs: /api/v2/doc/ (on your DefectDojo instance)
    - Kit integration docs: defectdojo/docs/defectdojo-scan-tool-ingestion-end-to-end.md
    - Scanner mappings: configs/scanner-configs.yaml
"""

import json
import os
import sys
from datetime import date, timedelta
from pathlib import Path

try:
    import requests
except ImportError:
    print("This script needs the requests library: pip install requests")
    sys.exit(1)

DEFAULT_BASE_URL = "http://localhost:8080"
API_PREFIX = "/api/v2"

# Supported DefectDojo scan_type strings (case-sensitive).
# Must match a parser name that DefectDojo recognizes.
# Extend this list when adding new scanners; verify at /api/v2/doc/ on your instance.
SCAN_TYPES = (
    "Gitleaks Scan",
    "Semgrep JSON Report",
    "Trivy Scan",
    "ZAP Scan",
    "Prowler Scan",
    "SARIF",
    "Grype Scan",
    "Checkov Scan",
    "TFSec Scan",
    "Nuclei Scan",
)

# Defaults from environment; override via CLI args or env vars.
PRODUCT_NAME = os.getenv("PRODUCT_NAME", "demo-app")
ENGAGEMENT_NAME = os.getenv("ENGAGEMENT_NAME", "ci-scan")
PRODUCT_TYPE = int(os.getenv("PRODUCT_TYPE", "1"))
ENGAGEMENT_DAYS = int(os.getenv("ENGAGEMENT_DAYS", "30"))
TAGS = os.getenv("IMPORT_TAGS", "").split(",") if os.getenv("IMPORT_TAGS") else []


class DefectDojoError(RuntimeError):
    """Raised when DefectDojo answers with something the script cannot use."""


def usage():
    print("Usage: DEFECTDOJO_TOKEN=<token> import-scan.py <report-file> [scan-type]")
    print()
    print("Supported scan types (case-sensitive):")
    for name in SCAN_TYPES:
        print(f"  - {name}")
    print()
    print("Environment variables:")
    print("  DEFECTDOJO_TOKEN  (required) API token from DefectDojo UI")
    print("  DEFECTDOJO_URL    (optional) Base URL, default http://localhost:8080")
    print("  PRODUCT_NAME      (optional) Product name, default demo-app")
    print("  ENGAGEMENT_NAME   (optional) Engagement name, default ci-scan")
    print("  IMPORT_TAGS       (optional) Comma-separated tags for the import")


def api_headers(token: str) -> dict[str, str]:
    return {"Authorization": f"Token {token}"}


def call(method: str, url: str, **kwargs) -> requests.Response:
    """Make one API call and turn failure modes into readable errors."""
    try:
        response = requests.request(method, url, timeout=60, **kwargs)
    except requests.RequestException as exc:
        raise DefectDojoError(f"could not reach {url}: {exc}") from exc
    if not response.ok:
        raise DefectDojoError(
            f"{method} {url} -> HTTP {response.status_code}\n{response.text[:500]}"
        )
    return response


def as_items(payload: dict | list) -> list:
    """List endpoints answer either with a bare list or a paginated envelope."""
    if isinstance(payload, list):
        return payload
    if isinstance(payload, dict):
        results = payload.get("results")
        if isinstance(results, list):
            return results
    return []


def find_product(api: str, headers: dict[str, str], name: str) -> dict | None:
    """Return the product with this exact name, or None when it does not exist."""
    response = call("GET", f"{api}/products/", params={"name": name}, headers=headers)
    for product in as_items(response.json()):
        if product.get("name") == name:
            return product
    return None


def create_product(api: str, headers: dict[str, str], name: str, product_type: int) -> int:
    response = call(
        "POST",
        f"{api}/products/",
        headers={**headers, "Content-Type": "application/json"},
        json={"name": name, "description": "Created by import-scan.py", "prod_type": product_type},
    )
    product = response.json()
    print(f"  created product '{name}' (id {product['id']})")
    return product["id"]


def find_engagement(api: str, headers: dict[str, str], product_id: int, name: str) -> dict | None:
    """Return the engagement with this name on this product, or None."""
    response = call(
        "GET", f"{api}/engagements/", params={"product": product_id}, headers=headers
    )
    for engagement in as_items(response.json()):
        if engagement.get("name") == name:
            return engagement
    return None


def create_engagement(api: str, headers: dict[str, str], product_id: int, name: str, days: int) -> int:
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
    print(f"  created engagement '{name}' (id {engagement['id']})")
    return engagement["id"]


def import_report(
    api: str,
    headers: dict[str, str],
    engagement_id: int,
    scan_type: str,
    report: Path,
    tags: list[str],
) -> requests.Response:
    """Hand the report to DefectDojo via reimport-scan and return the response."""
    data = {"engagement": str(engagement_id), "scan_type": scan_type}
    if tags:
        data["tags"] = tags
    with report.open("rb") as handle:
        response = call(
            "POST",
            f"{api}/reimport-scan/",
            headers=headers,
            data=data,
            files={"file": (report.name, handle, "application/json")},
        )
    return response


def main(argv: list[str]) -> int:
    if len(argv) not in (2, 3):
        usage()
        return 2

    report = Path(argv[1]).expanduser()
    scan_type = argv[2] if len(argv) == 3 else "Trivy Scan"

    token = os.getenv("DEFECTDOJO_TOKEN")
    if not token:
        print("Error: DEFECTDOJO_TOKEN is required (create one in DefectDojo under User Settings).")
        return 1

    if not report.is_file():
        print(f"Error: No such report file: {report}")
        return 1

    if scan_type not in SCAN_TYPES:
        print(f"Error: Unknown scan type '{scan_type}'.")
        print("A wrong scan type does not error out, it just drops the findings.")
        usage()
        return 1

    base_url = os.getenv("DEFECTDOJO_URL", DEFAULT_BASE_URL).rstrip("/")
    api = f"{base_url}{API_PREFIX}"
    headers = api_headers(token)

    try:
        print(f"Importing {report.name} as '{scan_type}' into {base_url}")

        product = find_product(api, headers, PRODUCT_NAME)
        if product is None:
            print(f"  no product named '{PRODUCT_NAME}' yet")
            product_id = create_product(api, headers, PRODUCT_NAME, PRODUCT_TYPE)
        else:
            product_id = product["id"]
            print(f"  using product '{product['name']}' (id {product_id})")

        engagement = find_engagement(api, headers, product_id, ENGAGEMENT_NAME)
        if engagement is None:
            print(f"  no engagement named '{ENGAGEMENT_NAME}' on this product")
            engagement_id = create_engagement(api, headers, product_id, ENGAGEMENT_NAME, ENGAGEMENT_DAYS)
        else:
            engagement_id = engagement["id"]
            print(f"  using engagement '{engagement['name']}' (id {engagement_id})")

        response = import_report(api, headers, engagement_id, scan_type, report, TAGS)
    except DefectDojoError as exc:
        print(f"Import failed: {exc}")
        return 1

    print(f"DefectDojo answered with HTTP {response.status_code}:")
    try:
        print(json.dumps(response.json(), indent=2)[:2000])
    except ValueError:
        print(response.text[:2000])

    print(f"Check the findings in the DefectDojo UI under product '{PRODUCT_NAME}'.")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))