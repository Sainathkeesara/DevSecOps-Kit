---
last_verified: 2026-07-13
tool_version: n/a
sources: []
---

# Prometheus — quick primer

> First-day notes for someone who's never used Prometheus. Personal voice, plain language.

## What is it?

Prometheus is an open-source time-series database and monitoring system designed for dynamic cloud-native environments. It works by periodically scraping HTTP endpoints exposed by your applications and infrastructure — pulling numeric measurements called "metrics" — and storing them as time-series data identified by a metric name and a set of key-value pairs called "labels." A built-in query language (PromQL) lets you slice, aggregate, and alert on that data.

The closest analogy is a fitness tracker for your infrastructure: it doesn't run inside your app, it just polls your app on a schedule, records the readings, and lets you ask questions like "what was my average heart rate last week?" In infrastructure terms: "what was my 99th percentile API latency over the last 5 minutes?"

## What does it do?

It scrapes metric endpoints from configured targets (your apps, node exporters, blackbox exporters), stores the time-series data on local disk with optional remote storage, evaluates recording and alerting rules on a schedule, and exposes a query API (HTTP + PromQL) that Grafana or alertmanager can consume. It does not collect logs or traces — it is purely metrics. It also does not push to anything; it is a pull-based system. You define scrape targets and Prometheus pulls from them.

## Why does it exist?

Before Prometheus, the standard approach was Nagios (poll-based, static host list, poor time-series storage) or Graphite (push-based, no service discovery). Both struggled in environments where servers appeared and disappeared — containers, auto-scaling groups, Kubernetes pods. Prometheus was built at SoundCloud specifically to solve the dynamic target discovery problem: a service registry (originally DNS, now Kubernetes API) tells Prometheus what to scrape, and Prometheus handles the rest. It became the second project hosted by the Cloud Native Computing Foundation and is now the standard metrics layer for Kubernetes monitoring.

## Key terminology

- **Metric** — A named numeric measurement with labels. Example: `http_requests_total{method="POST",endpoint="/api/checkout",code="200"} 1042`.
- **Labels** — Key-value pairs attached to a metric that let you distinguish time-series with the same name. Example: `method`, `endpoint`, `code` on `http_requests_total`.
- **Scrape** — A single pull of a metrics endpoint. Example: Prometheus GETs `http://myapp:8080/metrics` every 15 seconds and stores the result.
- **Scrape interval** — How often Prometheus pulls each target. Example: `15s` (scrape every 15 seconds) is the default; sensitive metrics may use `5s`.
- **Exporter** — An agent that translates an existing system's metrics into the Prometheus format. Example: `node_exporter` exposes CPU, memory, disk, and network metrics from a Linux host as `/metrics`.
- **PromQL** — Prometheus's query language. Example: `rate(http_requests_total[5m])` computes the per-second average rate of requests over the last 5 minutes.
- **Instant vector** — A set of time-series with a single sample each, at a specific timestamp. Example: `http_requests_total` at right now returns one sample per (method, endpoint, code) combination.
- **Range vector** — A set of time-series with a range of samples over time. Example: `http_requests_total[5m]` returns all samples from the last 5 minutes for each series.
- **Recording rule** — A pre-computed query stored as a new time-series, reducing query load for dashboards and alerts. Example: pre-compute `job:request_rate:rate5m` so your 20 dashboards don't all run the same `rate()` query.
- **Alerting rule** — A PromQL expression evaluated on a schedule that fires an alert when the result is true. Example: `up{job="api"} == 0` fires a "service down" alert if the API hasn't responded to a scrape for 60 seconds.
- **Target** — An endpoint Prometheus scrapes, defined by a static config or service discovery. Example: `myapp:8080/metrics` on port 8080.
- **Service discovery** — Automatic target discovery from an external system. Example: Kubernetes SD watches the API server and adds/removes pod targets as pods are scheduled and terminated.
- **Pushgateway** — A standalone component for short-lived jobs (batch, cron) that cannot be scraped because they don't run long enough. The job pushes its final metrics to the gateway, and Prometheus scrapes the gateway.

## A tiny example

Instrument a Python Flask app with the Prometheus client library and run it:

```python
from flask import Flask
from prometheus_client import Counter, generate_latest, REGISTRY

app = Flask(__name__)
requests = Counter('http_requests_total', 'Total HTTP requests', ['method', 'endpoint', 'status'])

@app.route('/health')
def health():
    requests.labels(method='GET', endpoint='/health', status='200').inc()
    return {'status': 'ok'}, 200

@app.route('/metrics')
def metrics():
    return generate_latest(REGISTRY), 200, {'Content-Type': 'text/plain; version=0.0.4'}
```

Run a Prometheus container with a `prometheus.yml` that scrapes `localhost:8000/metrics` every 15 seconds, visit `http://localhost:9090/graph`, and query `http_requests_total` — you will see the counter increment each time you hit `/health`. The three pieces (instrumented app, Prometheus config, PromQL query) are the smallest working Prometheus loop.

## What I'll cover next

I want to learn PromQL aggregation operators (`sum`, `rate`, `histogram_quantile`) well enough to write a production SLO alert, explore recording rules to optimize dashboard query performance, and set up `node_exporter` so I can query host-level metrics alongside my application metrics in the same dashboard.
