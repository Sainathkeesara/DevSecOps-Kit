# last_verified: 2026-08-20 · dependabot n/a
"""
Aggregate Dependabot alerts from the GitHub API into a compliance report.

Rolls up alerts across one or more repositories and prints:
  * a severity summary (how many critical/high/medium/low, in total)
  * a per-package breakout (which library drives the most alerts)
  * an optional CSV detail dump for ticketing or spreadsheet reporting

Usage:
    python3 dependabot-alert-aggregation.py <owner> <token> \
        [--repos repo-a repo-b] [--state open] [--out alerts.csv]

A token with "Dependabot alerts" read permission is enough; without one the
unauthenticated API rate limit kicks in quickly.
"""

import argparse
import csv
import json
import sys
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

API = "https://api.github.com"
PER_PAGE = 100
SEVERITY_ORDER = ["CRITICAL", "HIGH", "MEDIUM", "LOW", "UNKNOWN"]


def request_json(url, token):
    headers = {
        "Accept": "application/vnd.github+json",
        "Authorization": f"Bearer {token}",
    }
    req = Request(url, headers=headers)
    with urlopen(req) as resp:
        return json.loads(resp.read())


def list_repos(owner, token):
    """Every repo the token can see under the org, for multi-repo rollups."""
    names = []
    page = 1
    while True:
        url = f"{API}/orgs/{owner}/repos?per_page={PER_PAGE}&page={page}"
        batch = request_json(url, token)
        names.extend(item["name"] for item in batch)
        if len(batch) < PER_PAGE:
            break
        page += 1
    return names


def fetch_alerts(owner, repo, state, token):
    """Page through the dependabot/alerts endpoint, tolerating per-repo errors."""
    alerts = []
    page = 1
    while True:
        url = (
            f"{API}/repos/{owner}/{repo}/dependabot/alerts"
            f"?state={state}&per_page={PER_PAGE}&page={page}"
        )
        try:
            batch = request_json(url, token)
        except HTTPError as exc:
            # one bad repo (e.g. no Dependabot access) shouldn't kill the rollup
            print(f"  ! {owner}/{repo}: HTTP {exc.code} {exc.reason}", file=sys.stderr)
            return alerts
        alerts.extend(batch)
        if len(batch) < PER_PAGE:
            break
        page += 1
    return alerts


def normalize(alert, repo):
    """Flatten the REST payload into the columns the report cares about."""
    vuln = alert.get("security_vulnerability", {}) or {}
    advisory = alert.get("security_advisory", {}) or {}
    package = (vuln.get("package") or {}).get("name") or "unknown"
    severity = (vuln.get("severity") or advisory.get("severity") or "unknown").upper()
    return {
        "number": alert.get("number"),
        "repo": repo,
        "state": alert.get("state"),
        "package": package,
        "severity": severity,
        "summary": advisory.get("summary", ""),
        "url": alert.get("html_url", ""),
    }


def summarize(rows):
    by_severity = {}
    by_package = {}
    for row in rows:
        by_severity[row["severity"]] = by_severity.get(row["severity"], 0) + 1
        by_package[row["package"]] = by_package.get(row["package"], 0) + 1
    return by_severity, by_package


def write_csv(path, rows):
    with open(path, "w", newline="") as fh:
        writer = csv.DictWriter(
            fh,
            fieldnames=["number", "repo", "state", "package", "severity", "summary", "url"],
        )
        writer.writeheader()
        writer.writerows(rows)


def main():
    ap = argparse.ArgumentParser(description="Dependabot alert aggregation for compliance reporting")
    ap.add_argument("owner", help="GitHub org or owner name")
    ap.add_argument("token", help="GitHub token with Dependabot alerts read scope")
    ap.add_argument("--repos", nargs="*", default=None, help="repo list; defaults to all org repos")
    ap.add_argument("--state", default="open", help="alert state to fetch (open/dismissed/fixed)")
    ap.add_argument("--out", default=None, help="optional CSV path for the detail dump")
    args = ap.parse_args()

    repos = args.repos or list_repos(args.owner, args.token)

    rows = []
    for repo in repos:
        alerts = fetch_alerts(args.owner, repo, args.state, args.token)
        rows.extend(normalize(a, repo) for a in alerts)
        print(f"{repo}: {len(alerts)} {args.state} alert(s)")

    by_severity, by_package = summarize(rows)

    print("\nseverity summary")
    order = {sev: i for i, sev in enumerate(SEVERITY_ORDER)}
    for sev in sorted(by_severity, key=lambda s: order.get(s, len(order))):
        print(f"  {sev:<8} {by_severity[sev]}")
    print(f"  {'TOTAL':<8} {len(rows)}")

    print("\ntop packages by alert count")
    for package, count in sorted(by_package.items(), key=lambda kv: kv[1], reverse=True)[:10]:
        print(f"  {count:<4} {package}")

    if args.out:
        write_csv(args.out, rows)
        print(f"\nwrote {len(rows)} rows to {args.out}")


if __name__ == "__main__":
    try:
        main()
    except URLError as exc:
        print(f"network error: {exc}", file=sys.stderr)
        sys.exit(1)
