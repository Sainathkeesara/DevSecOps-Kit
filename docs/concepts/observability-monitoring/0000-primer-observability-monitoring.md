# Observability & Monitoring — quick primer

> First-day notes on Observability & Monitoring. What it is, why it matters, and the key ideas to know.

## What is it?

Monitoring is the practice of tracking whether your systems are healthy — is the web server up? Is disk usage below 80%? Are requests returning 200s? Observability goes a step further: it asks whether you can understand *why* something is going wrong from the data your systems already produce, without needing to add new instrumentation in the middle of an incident.

I think of it like a car dashboard. Monitoring is the check engine light — it tells you something is wrong. Observability is having the diagnostic port that a mechanic can plug into to read live sensor data, fuel trim levels, and cylinder misfire counts without taking the engine apart. Both are important, but they answer different questions.

## Why does it matter for devops?

When a system is live, things break. A deployment introduces a memory leak. A third-party API slows down and queues back up. A misconfigured load balancer drops traffic. Without monitoring, you find out about these from an angry customer (or worse, from a manager). Without observability, even after you know something is broken, you spend hours SSH-ing into boxes gathering clues.

Observability and monitoring let you:
- **Detect problems before users do** — alert on p99 latency spikes, 5xx error rate increases, or disk filling up
- **Debug faster** — traces and structured logs tell you exactly which service, which request, and which line of code caused a failure
- **Understand normal** — baselines and trends show what "healthy" looks like for your system

For a devops engineer, this is the feedback loop for every change you make. Deploy a new feature? Watch the dashboards. Rotate a credential? Monitor for auth failures. Push a config change? Check that error rates stay flat.

## Key terminology

- **Metric** — A numeric measurement collected at intervals. Example: `http_requests_total{status="200"} 1423` is a Prometheus counter showing how many 200 responses the server has returned.
- **Log** — A timestamped record of a discrete event. Example: `2026-07-01 14:32:01 ERROR failed to connect to database: connection refused` is a log line from an application.
- **Trace** — A record of a request's journey across distributed services. Example: a trace from "user clicks checkout" might span the frontend, order service, payment service, and inventory service.
- **Alert** — A notification triggered when a metric crosses a threshold. Example: PagerDuty pages the on-call engineer when `error_rate > 5%` for more than 5 minutes.
- **Dashboard** — A visual display of key metrics and status. Example: a Grafana dashboard showing CPU, memory, request rate, error rate, and latency percentiles for a web service.
- **SLO / SLA / SLI** — Service Level Objective (the target you aim for, e.g., 99.9% uptime), Service Level Agreement (what you contractually promise), Service Level Indicator (the actual measurement). Example: an SLI of `request_duration_seconds` feeds an SLO of "p99 < 500ms over 30 days."
- **Cardinality** — The number of unique label-value combinations in a metric. Example: a metric with label `user_id` (millions of values) has high cardinality and can crash your monitoring system.

## A concrete example

```bash
#!/bin/bash
# Check nginx error rate from Prometheus metrics endpoint
ERRORS=$(curl -s http://localhost:9113/metrics | grep 'nginx_http_requests_total{status="5xx"}' | awk '{print $2}')
TOTAL=$(curl -s http://localhost:9113/metrics | grep 'nginx_http_requests_total{' | awk '{sum+=$2} END {print sum}')

if [ -n "$TOTAL" ] && [ "$TOTAL" -gt 0 ]; then
  RATE=$(echo "scale=2; $ERRORS / $TOTAL * 100" | bc)
  echo "5xx error rate: ${RATE}%"
  if (( $(echo "$RATE > 5" | bc -l) )); then
    echo "ALERT: Error rate exceeds 5% threshold"
    exit 1
  fi
fi
```

This script scrapes the nginx Prometheus exporter, calculates the percentage of 5xx responses, and alerts if it exceeds 5% — a minimal health check you could run in a cron job or CI pipeline.

## How this connects to what's next

Observability and monitoring are prerequisites for running any live service at scale. Tools like Prometheus and Grafana (metrics), Loki (logs), and Jaeger or Tempo (traces) all build on these concepts. Once you're comfortable with metrics, logs, and traces, you can wire up incident response, auto-scaling, and cost optimization — all of which depend on knowing what your system is actually doing.
