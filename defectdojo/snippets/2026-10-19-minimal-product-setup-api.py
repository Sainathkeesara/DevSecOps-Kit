#!/usr/bin/env python3
# last_verified: 2026-10-19 · DefectDojo API v2

import os
import sys
import requests

BASE_URL = os.getenv("DEFECTDOJO_URL", "http://localhost:8080")
API_TOKEN = os.getenv("DEFECTDOJO_TOKEN")

if not API_TOKEN:
    print("Set DEFECTDOJO_TOKEN env var (create it in DefectDojo UI → User Settings → API Token)")
    sys.exit(1)

headers = {"Authorization": f"Token {API_TOKEN}", "Content-Type": "application/json"}
api = f"{BASE_URL}/api/v2"

def create_product(name, description="Created via API"):
    resp = requests.post(f"{api}/products/", json={
        "name": name,
        "description": description,
        "prod_type": 1,
    }, headers=headers)
    resp.raise_for_status()
    return resp.json()["id"]

def create_engagement(product_id, name, target_start, target_end):
    resp = requests.post(f"{api}/engagements/", json={
        "product": product_id,
        "name": name,
        "target_start": target_start,
        "target_end": target_end,
        "status": "In Progress",
    }, headers=headers)
    resp.raise_for_status()
    return resp.json()["id"]

if __name__ == "__main__":
    from datetime import date, timedelta

    prod_name = os.getenv("PRODUCT_NAME", "demo-app")
    today = date.today().isoformat()
    next_week = (date.today() + timedelta(days=7)).isoformat()

    print(f"Creating product: {prod_name}")
    pid = create_product(prod_name)
    print(f"  product_id = {pid}")

    print(f"Creating engagement for product {pid}")
    eid = create_engagement(pid, "sprint-1", today, next_week)
    print(f"  engagement_id = {eid}")

    print(f"\nReady to import scans into engagement {eid}")
    print(f"Example: curl -H 'Authorization: Token $DEFECTDOJO_TOKEN' -F 'file=@report.json' \\")
    print(f"  {BASE_URL}/api/v2/import-scan/ -F 'engagement={eid}' -F 'scan_type=Trivy Scan'")