#!/usr/bin/env python3
# last_verified: 2026-10-20 · DefectDojo API v2
#
# A small DefectDojo product scan import, written from scratch:
#   1. find the Product the findings belong to, create it when it is missing
#   2. find an Engagement on that Product, create it when it is missing
#   3. import a scanner report into that engagement
#
# One way to do it is enough here, because the API is plain REST and the
# whole flow is three calls. `reimport-scan` is used rather than
# `import-scan` on purpose: a re-import updates the existing Test and closes
# the findings that the new report no longer contains, which is what keeps a
# CI job that runs on every push from piling up duplicate Tests.
#
# The scan type has to match the parser name DefectDojo knows, exactly and
# case-sensitively. A wrong string does not fail the request, it quietly
# drops the findings, so the list is checked before anything is sent.
#
# Both the re-import behaviour and the list of scan type names come from the
# research entry behind this task:
# https://chaostocontrol.ghost.io/you-have-5-scanners-and-zero-visibility-defectdojo-as-your-security-single-pane-of-glass/
#
# No DefectDojo instance was reachable from the environment this was written
# in, so the request shapes follow the API examples already in this kit
# (defectdojo/snippets/2026-10-19-minimal-product-setup-api.py) rather than
# a live response.
#
# Usage:
#   DEFECTDOJO_TOKEN=<token> python3 product-scan-import.py <report-file> [scan-type]
#
# Dependency: pip install requests

import json
import os
import sys
from datetime import date, timedelta
from pathlib import Path

try:
    import requests
except ImportError:  # pragma: no cover - depends on the host, not on the logic
    print("This script needs the requests library: pip install requests")
    sys.exit(1)

DEFAULT_BASE_URL = "http://localhost:8080"
API_PREFIX = "/api/v2"

# The parser names DefectDojo matches a report against.
SCAN_TYPES = (
    "Gitleaks Scan",
    "Semgrep JSON Report",
    "Trivy Scan",
    "ZAP Scan",
    "Prowler Scan",
    "SARIF",
)

PRODUCT_NAME = os.getenv("PRODUCT_NAME", "demo-app")
ENGAGEMENT_NAME = os.getenv("ENGAGEMENT_NAME", "scheduled-scan")


class DefectDojoError(RuntimeError):
    """Raised when DefectDojo answers with something the script cannot use."""


def usage():
    print("Usage: DEFECTDOJO_TOKEN=<token> product-scan-import.py <report-file> [scan-type]")
    print()
    print("Scan types DefectDojo matches on (case-sensitive):")
    for name in SCAN_TYPES:
        print(f"  - {name}")


def api_headers(token):
    return {"Authorization": f"Token {token}"}


def call(method, url, **kwargs):
    """Make one API call and turn the failure modes into readable errors."""
    try:
        response = requests.request(method, url, timeout=60, **kwargs)
    except requests.RequestException as exc:
        raise DefectDojoError(f"could not reach {url}: {exc}") from exc
    if not response.ok:
        raise DefectDojoError(
            f"{method} {url} -> HTTP {response.status_code}\n{response.text[:500]}"
        )
    return response


def as_items(payload):
    """List endpoints answer either with a bare list or a paginated envelope."""
    if isinstance(payload, list):
        return payload
    if isinstance(payload, dict):
        results = payload.get("results")
        if isinstance(results, list):
            return results
    return []


def find_product(api, headers, name):
    """Return the product with this exact name, or None when it does not exist."""
    response = call("GET", f"{api}/products/", params={"name": name}, headers=headers)
    for product in as_items(response.json()):
        if product.get("name") == name:
            return product
    return None


def create_product(api, headers, name):
    response = call(
        "POST",
        f"{api}/products/",
        headers={**headers, "Content-Type": "application/json"},
        json={"name": name, "description": "Created by product-scan-import.py", "prod_type": 1},
    )
    product = response.json()
    print(f"  created product '{name}' (id {product['id']})")
    return product["id"]


def find_engagement(api, headers, product_id, name):
    """Return the engagement with this name on this product, or None."""
    response = call(
        "GET", f"{api}/engagements/", params={"product": product_id}, headers=headers
    )
    for engagement in as_items(response.json()):
        if engagement.get("name") == name:
            return engagement
    return None


def create_engagement(api, headers, product_id, name):
    today = date.today()
    response = call(
        "POST",
        f"{api}/engagements/",
        headers={**headers, "Content-Type": "application/json"},
        json={
            "product": product_id,
            "name": name,
            "target_start": today.isoformat(),
            "target_end": (today + timedelta(days=7)).isoformat(),
            "status": "In Progress",
        },
    )
    engagement = response.json()
    print(f"  created engagement '{name}' (id {engagement['id']})")
    return engagement["id"]


def import_report(api, headers, engagement_id, scan_type, report):
    """Hand the report to DefectDojo and return the parsed answer."""
    with report.open("rb") as handle:
        response = call(
            "POST",
            f"{api}/reimport-scan/",
            headers=headers,
            data={"engagement": str(engagement_id), "scan_type": scan_type},
            files={"file": (report.name, handle, "application/json")},
        )
    return response


def main(argv):
    if len(argv) not in (2, 3):
        usage()
        return 2

    report = Path(argv[1]).expanduser()
    scan_type = argv[2] if len(argv) == 3 else "Trivy Scan"

    token = os.getenv("DEFECTDOJO_TOKEN")
    if not token:
        print("Set DEFECTDOJO_TOKEN (create one in DefectDojo under User Settings).")
        return 1

    if not report.is_file():
        print(f"No such report file: {report}")
        return 1

    if scan_type not in SCAN_TYPES:
        print(f"Unknown scan type '{scan_type}'.")
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
            product_id = create_product(api, headers, PRODUCT_NAME)
        else:
            product_id = product["id"]
            print(f"  using product '{product['name']}' (id {product_id})")

        engagement = find_engagement(api, headers, product_id, ENGAGEMENT_NAME)
        if engagement is None:
            print(f"  no engagement named '{ENGAGEMENT_NAME}' on this product")
            engagement_id = create_engagement(api, headers, product_id, ENGAGEMENT_NAME)
        else:
            engagement_id = engagement["id"]
            print(f"  using engagement '{engagement['name']}' (id {engagement_id})")

        response = import_report(api, headers, engagement_id, scan_type, report)
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
