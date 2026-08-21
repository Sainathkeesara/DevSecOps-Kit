# last_verified: 2026-08-21 · GitGuardian n/a
"""
GitGuardian API integration — scan export, dashboard retrieval, and notification.

Usage:
    Export recent scan results:
        python gitguardian-api-integration.py export --repo owner/repo --output results.json

    Pull dashboard summary:
        python gitguardian-api-integration.py dashboard --days 7

    Send notification for open incidents:
        python gitguardian-api-integration.py notify --webhook https://hooks.slack.com/...

Environment variables:
    GITGUARDIAN_API_KEY  - GitGuardian API key (required)
    GITGUARDIAN_BASE_URL - API base URL (optional, defaults to https://api.gitguardian.com)
"""

import argparse
import json
import os
import sys
from datetime import datetime, timedelta, timezone
from typing import Any

try:
    import requests
except ImportError:
    print("ERROR: 'requests' library is required. Install with: pip install requests", file=sys.stderr)
    sys.exit(2)


def get_session() -> requests.Session:
    """Build an authenticated requests session."""
    api_key = os.environ.get("GITGUARDIAN_API_KEY")
    if not api_key:
        print("ERROR: GITGUARDIAN_API_KEY environment variable is not set", file=sys.stderr)
        sys.exit(2)

    base_url = os.environ.get("GITGUARDIAN_BASE_URL", "https://api.gitguardian.com")

    session = requests.Session()
    session.headers.update({
        "Authorization": f"Token {api_key}",
        "Content-Type": "application/json",
    })
    session.base_url = base_url  # type: ignore[attr-defined]
    return session


def _url(session: requests.Session, path: str) -> str:
    """Resolve a path against the session's base URL."""
    base = getattr(session, "base_url", "https://api.gitguardian.com")
    return f"{base.rstrip('/')}/{path.lstrip('/')}"


# ---------------------------------------------------------------------------
# Scan export
# ---------------------------------------------------------------------------

def export_scan_results(session: requests.Session, repo: str, output_path: str) -> dict:
    """
    Retrieve scan results for a repository and write them to a JSON file.

    Args:
        session: Authenticated requests session.
        repo: Repository in 'owner/repo' format.
        output_path: File path to write the exported JSON.

    Returns:
        Summary dict with counts by severity.
    """
    url = _url(session, f"/v1/repos/{repo}/incidents")
    params = {"page_size": 100}
    all_incidents: list[dict[str, Any]] = []

    while True:
        resp = session.get(url, params=params)
        resp.raise_for_status()
        data = resp.json()

        incidents = data.get("incidents", data if isinstance(data, list) else [])
        all_incidents.extend(incidents)

        # Handle pagination
        if data.get("has_next", False) and "next_cursor" in data:
            params["cursor"] = data["next_cursor"]
        else:
            break

    # Build severity summary
    severity_counts: dict[str, int] = {}
    for inc in all_incidents:
        sev = inc.get("severity", "unknown")
        severity_counts[sev] = severity_counts.get(sev, 0) + 1

    output = {
        "repository": repo,
        "exported_at": datetime.now(timezone.utc).isoformat(),
        "total_incidents": len(all_incidents),
        "severity_summary": severity_counts,
        "incidents": all_incidents,
    }

    with open(output_path, "w") as f:
        json.dump(output, f, indent=2)

    print(f"Exported {len(all_incidents)} incidents to {output_path}")
    return severity_counts


# ---------------------------------------------------------------------------
# Dashboard
# ---------------------------------------------------------------------------

def fetch_dashboard(session: requests.Session, days: int = 7) -> dict:
    """
    Pull a summary of recent GitGuardian activity for the dashboard view.

    Args:
        session: Authenticated requests session.
        days: Number of past days to include.

    Returns:
        Dashboard summary dict.
    """
    since = (datetime.now(timezone.utc) - timedelta(days=days)).isoformat()

    # Incidents overview
    incidents_url = _url(session, "/v1/incidents")
    resp = session.get(incidents_url, params={"since": since, "page_size": 1})
    resp.raise_for_status()
    incidents_data = resp.json()
    total_incidents = incidents_data.get("total_count", 0)

    # Repos scanned
    repos_url = _url(session, "/v1/repos")
    resp = session.get(repos_url, params={"page_size": 100})
    resp.raise_for_status()
    repos_data = resp.json()
    repos = repos_data.get("repos", repos_data if isinstance(repos_data, list) else [])

    # Build summary
    dashboard = {
        "period_days": days,
        "since": since,
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "total_incidents": total_incidents,
        "repositories_monitored": len(repos),
        "repos": [
            {
                "name": r.get("full_name", r.get("name", "unknown")),
                "open_incidents": r.get("open_incidents_count", 0),
                "last_scan": r.get("last_scan_date"),
            }
            for r in repos[:20]  # Top 20 repos
        ],
    }

    return dashboard


# ---------------------------------------------------------------------------
# Notification
# ---------------------------------------------------------------------------

def send_notification(session: requests.Session, webhook_url: str, min_severity: str = "high") -> int:
    """
    Check for open incidents at or above the severity threshold and POST
    a summary to a webhook endpoint (Slack, PagerDuty, generic).

    Args:
        session: Authenticated requests session.
        webhook_url: Webhook URL to POST the notification payload to.
        min_severity: Minimum severity to include (low, medium, high, critical).

    Returns:
        Number of incidents included in the notification.
    """
    severity_order = {"low": 0, "medium": 1, "high": 2, "critical": 3}
    min_sev_value = severity_order.get(min_severity, 2)

    url = _url(session, "/v1/incidents")
    params = {"status": "open", "page_size": 100}
    all_incidents: list[dict[str, Any]] = []

    while True:
        resp = session.get(url, params=params)
        resp.raise_for_status()
        data = resp.json()

        incidents = data.get("incidents", data if isinstance(data, list) else [])
        all_incidents.extend(incidents)

        if data.get("has_next", False) and "next_cursor" in data:
            params["cursor"] = data["next_cursor"]
        else:
            break

    # Filter by severity
    filtered = [
        inc for inc in all_incidents
        if severity_order.get(inc.get("severity", "low"), 0) >= min_sev_value
    ]

    if not filtered:
        print(f"No open incidents at or above '{min_severity}' severity.")
        return 0

    # Build notification payload (Slack-compatible format)
    blocks = [
        {
            "type": "header",
            "text": {
                "type": "plain_text",
                "text": f"GitGuardian Alert: {len(filtered)} open incident(s)",
            },
        },
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": (
                    f"*Severity filter:* {min_severity}+\n"
                    f"*Total open:* {len(filtered)}\n"
                    f"*Generated:* {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')}"
                ),
            },
        },
    ]

    for inc in filtered[:10]:  # Slack block limit
        severity = inc.get("severity", "unknown")
        filename = inc.get("filename", "unknown")
        repo_name = inc.get("repository", {}).get("full_name", "unknown") if isinstance(inc.get("repository"), dict) else inc.get("repository", "unknown")
        incident_url = inc.get("url", "N/A")

        blocks.append({
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": (
                    f"• *{severity.upper()}* — `{filename}` in `{repo_name}`\n"
                    f"  <{incident_url}|View incident>"
                ),
            },
        })

    payload = {"blocks": blocks}

    notif_resp = requests.post(webhook_url, json=payload, timeout=10)
    notif_resp.raise_for_status()

    print(f"Notification sent: {len(filtered)} incidents (min severity: {min_severity})")
    return len(filtered)


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(
        description="GitGuardian API integration — export, dashboard, and notify"
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    # export
    export_parser = subparsers.add_parser("export", help="Export scan results for a repo")
    export_parser.add_argument("--repo", required=True, help="Repository (owner/repo)")
    export_parser.add_argument("--output", default="gg-export.json", help="Output file path")

    # dashboard
    dash_parser = subparsers.add_parser("dashboard", help="Fetch dashboard summary")
    dash_parser.add_argument("--days", type=int, default=7, help="Lookback period in days")

    # notify
    notify_parser = subparsers.add_parser("notify", help="Send notification for open incidents")
    notify_parser.add_argument("--webhook", required=True, help="Webhook URL")
    notify_parser.add_argument(
        "--min-severity", default="high", choices=["low", "medium", "high", "critical"],
        help="Minimum severity to report"
    )

    args = parser.parse_args()
    session = get_session()

    if args.command == "export":
        export_scan_results(session, args.repo, args.output)
    elif args.command == "dashboard":
        dashboard = fetch_dashboard(session, args.days)
        print(json.dumps(dashboard, indent=2))
    elif args.command == "notify":
        send_notification(session, args.webhook, args.min_severity)


if __name__ == "__main__":
    main()
