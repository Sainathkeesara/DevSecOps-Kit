# Observability & Monitoring — quick primer

> First-day notes on Observability & Monitoring. What it is, why it matters, and the key ideas to know.

## What is it?

Monitoring is collecting and visualizing data about your systems — CPU usage, request latency, error rates, disk space — so you know when something goes wrong. Observability goes a step further: it means designing your systems so that you can ask arbitrary questions about their internal state without having to predict ahead of time what you'll need to know.

I think of it like a car's dashboard. Monitoring is the check-engine light that tells you something's wrong. Observability is being able to pull up detailed diagnostic data — fuel trims, cylinder misfire counts, O2 sensor readings — to figure out *why* the light came on. You want both, but observability is what lets you debug novel problems you never anticipated.

## Why does it matter for devops?

Without observability, operating a distributed system is like flying a plane with no instruments. You don't know if you're climbing or descending until you hit something. Monitoring tells you the system is up; observability tells you *how* it's working and lets you find the root cause when it breaks.

For a devops practitioner, this is essential. When a deployment goes bad, I need to know immediately. When latency spikes, I need to trace where the bottleneck is. When a pod crashes in a Kubernetes cluster, I need to see logs and metrics together to understand why. The three pillars — metrics, logs, and traces — each answer a different kind of question, and modern observability platforms (Prometheus, Grafana, Loki, Jaeger, Datadog) combine them.

## Key terminology

- **Metric** — A numeric measurement collected over time. Example: `http_requests_total{status="200"} 1423` — the count of successful HTTP requests so far.
- **Log** — A timestamped text record of an event. Example: `2026-07-01T10:30:00Z ERROR failed to connect to database: timeout`.
- **Trace** — A record of a request's path through a distributed system. Example: an API call that passes through a gateway, a service, and a database, with the time spent at each hop.
- **SLO (Service Level Objective)** — A target reliability measure, expressed as a percentage. Example: "99.9% of requests complete in under 500ms over a 30-day window."
- **SLI (Service Level Indicator)** — The actual measurement of reliability. Example: the measured 99.95% of requests under 500ms over the last 30 days.
- **SLA (Service Level Agreement)** — A contractual commitment to meet SLOs, often with penalties. Example: "If uptime drops below 99.9%, customers get a 5% credit."
- **Alert** — A notification triggered when a metric crosses a threshold. Example: PagerDuty pages when disk usage exceeds 90%.
- **Dashboard** — A visual display of key metrics. Example: a Grafana dashboard showing request rate, error rate, and latency percentiles.

## A concrete example

```bash
# Simulate a metric collection and alert check
ENDPOINT="https://api.example.com/health"

# Check response time with curl
START=$(date +%s%N)
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$ENDPOINT")
END=$(date +%s%N)
LATENCY=$(( (END - START) / 1000000 ))

echo "latency_ms=$LATENCY status=$HTTP_CODE"

# Simple SLO check — alert if latency exceeds 500ms
if [ "$LATENCY" -gt 500 ]; then
  echo "ALERT: latency ${LATENCY}ms exceeds SLO of 500ms"
fi
```

This simulates what a monitoring agent does: measure something useful, compare against a target, and flag a problem. In a real deployment, Prometheus collects this kind of data continuously and Alertmanager handles the notification routing.

## How this connects to what's next

The three pillars (metrics, logs, traces) map directly to tools: Prometheus for metrics, Grafana for dashboards, Loki for logs, Jaeger for traces. Infrastructure monitoring tools like Falco and Tetragon sit at the runtime security layer. Understanding the concepts first makes the tooling make sense — you're not learning Prometheus syntax, you're learning how to instrument and interrogate a system.
