---
last_verified: 2026-07-13
tool_version: n/a
sources: []
---

# Grafana — quick primer

> First-day notes for someone who's never used Grafana. Personal voice, plain language.

## What is it?

Grafana is an open-source dashboard and visualization layer for metrics. It connects to data sources that store time-series data — Prometheus, InfluxDB, Graphite, Loki, Elasticsearch, and dozens more — and lets you build dashboards that display those metrics as graphs, gauges, heatmaps, and tables. Think of it as the presentation tier of an observability stack: Prometheus (or another source) collects and stores the numbers, Grafana decides how to display them.

The closest analogy is spreadsheet pivot charts, but for time-series data. Where a pivot chart shows sales by region on a static dataset, a Grafana panel shows request latency over the last 6 hours, auto-refreshing every 30 seconds, with interactive zoom and legend filtering.

## What does it do?

It lets you create named dashboards composed of panels — each panel runs a query against a data source and renders the result. You can template dashboards with variables so the same dashboard works across 50 services by swapping a `$service` variable. It also supports alerting: define a threshold on a panel query and Grafana will send notifications to Slack, PagerDuty, email, or webhook when the condition is met. It does not collect data itself; it only queries sources that already have the data.

## Why does it exist?

Before Grafana, teams either wrote custom dashboards (perl/PHP scripts querying RRD files), used vendor-locked SaaS tools, or simply had no visualization at all — alerts came in as raw pager text with no context. Grafana standardized the open-source observability UI and made it data-source agnostic. The same dashboard framework works whether your metrics are in Prometheus or CloudWatch. It is the default visualization layer for Prometheus-based stacks and is widely deployed in Kubernetes environments as the in-cluster Grafana instance.

## Key terminology

- **Dashboard** — A named collection of panels on a single screen, usually sharing a time range. Example: a "Web API Overview" dashboard with panels for request rate, error rate, p99 latency, and active connections.
- **Panel** — A single visualization unit inside a dashboard — graph, stat/gauge, table, heatmap, or bar gauge. Example: a stat panel showing current request rate as a big number with a sparkline.
- **Data source** — The backend Grafana queries — Prometheus, Loki, InfluxDB, etc. Each data source has its own query language. Example: Prometheus data source uses PromQL (`rate(http_requests_total[5m])`).
- **Query** — The expression sent to a data source to retrieve data for a panel. Example: `sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) * 100` for a 5xx error rate panel.
- **Variable** — A dashboard-level placeholder that lets you parameterize queries. Example: a `$namespace` dropdown that filters all panels to a specific Kubernetes namespace.
- **Row** — A visual grouping of panels within a dashboard. Example: grouping all latency panels under a "Latency" row and all volume panels under "Throughput."
- **Alert** — A condition evaluated against a query result that triggers a notification channel when true. Example: alert when `up{job="api"} == 0` for 60 seconds.
- **Notification channel** — The endpoint Grafana sends alert payloads to — Slack, webhook, PagerDuty, email, etc.
- **Annotation** — A vertical marker or region overlay on a panel timeline, usually tied to deployment events. Example: a marker at each deployment time so you can correlate latency changes with code releases.
- **Explore** — An ad-hoc query mode for investigating metrics and logs without building a dashboard panel first.

## A tiny example

Add a Prometheus data source in Grafana UI (Configuration → Data Sources → Prometheus, URL `http://prometheus:9090`), then create a dashboard with one panel using this PromQL query:

```promql
sum(rate(http_requests_total[5m])) by (status)
```

Set the panel type to "Time series," time range to "Last 1 hour," and save the dashboard. The panel renders request rate grouped by HTTP status code, auto-refreshing every 30 seconds. One query, one panel, one dashboard — that is the smallest meaningful Grafana artifact.

## What I'll cover next

After this primer I want to learn how templating variables turn static dashboards into reusable templates across services, how Grafana alert rules replace separate alertmanager configs, and how to set up Grafana in a local Docker Compose stack with Prometheus and a sample app so I can iterate on dashboard design without touching a production cluster.
