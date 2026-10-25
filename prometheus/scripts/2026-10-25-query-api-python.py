#!/usr/bin/env python3
# last_verified: 2026-10-25 · prometheus 2.54.0

"""
Query Prometheus HTTP API from Python.
Run: python3 2026-10-25-query-api-python.py
"""

import json
import sys
from urllib.parse import urlencode
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError


PROMETHEUS_URL = "http://localhost:9090"


def query_instant(query: str, time: str = None) -> dict:
    """Execute an instant query against /api/v1/query."""
    params = {"query": query}
    if time:
        params["time"] = time
    url = f"{PROMETHEUS_URL}/api/v1/query?{urlencode(params)}"
    return _http_get(url)


def query_range(query: str, start: str, end: str, step: str = "15s") -> dict:
    """Execute a range query against /api/v1/query_range."""
    params = {"query": query, "start": start, "end": end, "step": step}
    url = f"{PROMETHEUS_URL}/api/v1/query_range?{urlencode(params)}"
    return _http_get(url)


def query_metadata(metric: str = None, limit: str = None) -> dict:
    """Fetch metric metadata from /api/v1/metadata."""
    params = {}
    if metric:
        params["metric"] = metric
    if limit:
        params["limit"] = limit
    url = f"{PROMETHEUS_URL}/api/v1/metadata?{urlencode(params)}"
    return _http_get(url)


def query_series(match: list[str], start: str, end: str) -> dict:
    """Find series by label matchers from /api/v1/series."""
    params = [("match[]", m) for m in match]
    params.extend([("start", start), ("end", end)])
    url = f"{PROMETHEUS_URL}/api/v1/series?{urlencode(params)}"
    return _http_get(url)


def _http_get(url: str) -> dict:
    """Simple GET with error handling."""
    req = Request(url, headers={"Accept": "application/json"})
    try:
        with urlopen(req, timeout=10) as resp:
            return json.loads(resp.read().decode())
    except HTTPError as e:
        body = e.read().decode()
        print(f"HTTP {e.code}: {body}", file=sys.stderr)
        raise
    except URLError as e:
        print(f"Connection error: {e.reason}", file=sys.stderr)
        raise


def print_result(label: str, data: dict):
    """Pretty-print API response."""
    status = data.get("status", "unknown")
    print(f"\n=== {label} (status={status}) ===")
    if status != "success":
        print(f"Error: {data.get('errorType', '?')}: {data.get('error', '?')}")
        return
    result = data.get("data", {})
    if "resultType" in result:
        print(f"Result type: {result['resultType']}")
        for item in result.get("result", [])[:5]:  # limit output
            metric = item.get("metric", {})
            value = item.get("value") or item.get("values")
            print(f"  {metric} -> {value}")
        if len(result.get("result", [])) > 5:
            print(f"  ... ({len(result['result']) - 5} more)")
    else:
        print(json.dumps(result, indent=2))


if __name__ == "__main__":
    print(f"Querying Prometheus at {PROMETHEUS_URL}")

    # Instant query: current value of a counter
    print_result(
        "Instant: prometheus_http_requests_total",
        query_instant('prometheus_http_requests_total{handler="/metrics"}')
    )

    # Instant query with math: rate of requests over 5m
    print_result(
        "Instant: rate(prometheus_http_requests_total[5m])",
        query_instant('rate(prometheus_http_requests_total[5m])')
    )

    # Range query: values over last hour
    print_result(
        "Range: prometheus_tsdb_head_series over 1h",
        query_range(
            "prometheus_tsdb_head_series",
            start="1h",
            end="now",
            step="1m"
        )
    )

    # Metadata for a metric
    print_result(
        "Metadata: prometheus_http_requests_total",
        query_metadata(metric="prometheus_http_requests_total")
    )

    # Series matching a label
    print_result(
        "Series: job=prometheus",
        query_series(["{job=\"prometheus\"}"], start="1h", end="now")
    )

    print("\nDone.")