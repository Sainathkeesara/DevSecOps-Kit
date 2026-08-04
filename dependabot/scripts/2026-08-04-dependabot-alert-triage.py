# last_verified: 2026-08-04 · dependabot n/a
"""
Dependabot alert analysis and triage script.
Pulls alerts from the GitHub API and groups them by severity
so I can decide what to patch first.
"""

import json
import sys
from urllib.request import Request, urlopen

OWNER = sys.argv[1] if len(sys.argv) > 1 else "my-org"
REPO = sys.argv[2] if len(sys.argv) > 2 else "my-repo"
TOKEN = sys.argv[3] if len(sys.argv) > 3 else ""

# GitHub API endpoint for Dependabot alerts
url = f"https://api.github.com/repos/{OWNER}/{REPO}/dependabot/alerts"
headers = {"Accept": "application/vnd.github+json"}
if TOKEN:
    headers["Authorization"] = f"Bearer {TOKEN}"

# I used the raw alerts endpoint because the paginated GraphQL API
# needs a separate query per alert type, which felt like overkill
# for a first pass at triage.
req = Request(url, headers=headers)
with urlopen(req) as resp:
    alerts = json.loads(resp.read())

# Group by severity so the summary is readable at a glance.
summary: dict[str, int] = {}
for alert in alerts:
    sev = alert.get("security_vulnerability", {}).get("severity", "none")
    summary[sev] = summary.get(sev, 0) + 1

print(f"Alerts for {OWNER}/{REPO}")
for sev, count in sorted(summary.items()):
    print(f"  {sev}: {count}")
