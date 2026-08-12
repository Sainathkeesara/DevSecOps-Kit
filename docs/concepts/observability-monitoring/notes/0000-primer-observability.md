---
last_verified: 2026-07-13
tool_version: n/a
sources: []
---

# Observability — quick primer

> First-day notes on Observability. What it is, why it matters, and the key ideas to know.

## What is it?

Observability is the practice of collecting enough information about a system that you can answer any question about its behavior without shipping new code. It comes from control theory — a system is "observable" if its internal state can be inferred from its outputs. In software, that translates to gathering three signal types: **logs** (discrete events with context), **metrics** (numerical measurements over time), and **traces** (the path a single request takes through services). Together they let you reconstruct what actually happened, not just whether something broke.

The term entered mainstream DevOps through the SRE community as a reaction to monitoring that only told you "is it up?" Traditional monitoring raises alerts when a threshold is crossed. Observability lets you ask new questions — "why did latency spike for POST requests but not GET?" — without pre-writing that query ahead of time.

## Why does it matter for DevOps?

As systems shift from monoliths to distributed services, failures become harder to diagnose. A single user action might touch five services across two cloud regions. Without observability, you get an alert saying "something is slow" and have to manually stitch together logs from three different tools to find the cause. Observability gives you correlated signals so the path from symptom to root cause is minutes instead of hours.

Day-to-day, you use observability when: deploying new code and watching for regressions, responding to an incident and reconstructing the blast radius, capacity-planning by examining request rate trends, and proving to stakeholders that a performance fix actually worked. It is the feedback loop that makes continuous delivery safe.

## Key terminology

- **Logs** — Timestamped text records of discrete events. Example: an application writing `2026-07-13T14:02:01Z WARN connection pool exhausted` to stdout.
- **Metrics** — Numeric values measured at regular intervals. Example: `http_requests_total{method="POST",code="500"} 42` scraped every 15 seconds.
- **Traces** — Records of a single request's journey across service boundaries, broken into spans. Example: a POST /checkout trace showing spans for auth-service (12ms), inventory-service (34ms), and payment-service (890ms).
- **Distributed tracing** — Traces collected across multiple services in a microservice architecture, linked by a shared trace ID injected at the edge.
- **Service Level Indicator (SLI)** — A quantitative measure of service behavior, typically latency, availability, or correctness. Example: "99th percentile API latency under 200ms."
- **Service Level Objective (SLO)** — A target range for an SLI. Example: "99.9% of requests return within 300ms over a 30-day window."
- **Service Level Agreement (SLA)** — A business-facing contract that often references an SLO and defines consequences when it is missed.
- **Alert** — A notification triggered when a signal crosses a defined threshold. Example: fire a PagerDuty alert if error rate exceeds 1% for 5 consecutive minutes.
- **Exporter** — A small sidecar or library that translates an application's internal metrics into the Prometheus text format so they can be scraped.
- **Structured logging** — Logging in a parseable format (usually JSON) instead of freeform text. Example: `{"ts":"...","level":"warn","msg":"pool exhausted","pool":"checkout","active":50,"waiting":120}`.

## A concrete example

A three-tier Flask API + Redis + PostgreSQL app instrumented with Prometheus client library:

```python
from flask import Flask
from prometheus_client import Counter, Histogram, generate_latest

app = Flask(__name__)
requests = Counter('http_requests_total', 'total requests', ['method', 'endpoint', 'status'])
latency = Histogram('http_request_duration_seconds', 'request latency', ['endpoint'])

@app.route('/api/health')
def health():
    requests.labels('GET', '/api/health', '200').inc()
    with latency.labels('/api/health').time():
        return {'status': 'ok'}

@app.route('/metrics')
def metrics():
    return generate_latest(), 200, {'Content-Type': 'text/plain'}
```

Configure Prometheus to scrape `/metrics` every 15s, query `rate(http_requests_total[5m])` in Grafana, and set an alert if the 500 error rate exceeds 0.5% for 3 minutes. The three signals (request counts, latency histogram, error rate alert) give you a complete observability picture for one endpoint.

## How this connects to what's next

Observability is the conceptual layer that makes Grafana and Prometheus useful. Once you understand logs, metrics, traces, SLIs, and SLOs, you can reason about any observability tool — the specifics of Prometheus scraping or Grafana panel types are just syntax on top of these ideas. After this primer, natural next steps are learning the Prometheus data model (metrics, labels, scrapes, exporters) and Grafana (dashboard composition, templating, alerting rules).
