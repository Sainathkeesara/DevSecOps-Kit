# last_verified: 2026-10-14 · Grafana n/a
# My first Grafana data-source query through the HTTP API.
# I hit the Grafana API directly with the URL and token from the setup
# step, asking for the data-source list the way the UI does behind the scenes.
import json
import urllib.request

BASE = "http://localhost:3000"
TOKEN = "YOUR_GRAFANA_TOKEN"  # swap in the token from your data-source setup

req = urllib.request.Request(
    f"{BASE}/api/datasources",
    headers={"Authorization": f"Bearer {TOKEN}"},
)
with urllib.request.urlopen(req) as resp:
    print(json.dumps(json.load(resp), indent=2))