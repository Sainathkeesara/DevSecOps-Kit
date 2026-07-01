# Observability & Monitoring — quick primer

> First-day notes on Observability & Monitoring. What it is, why it matters, and the key ideas to know.

## What is it?

Observability and monitoring are two related but different ideas about understanding what a system is doing. Monitoring is the practice of collecting predefined metrics and alerts — you decide ahead of time what matters (CPU usage, request latency, error rate) and watch those signals. Observability is the broader idea that you should be able to ask any question about your system's state without having to predict it in advance, by examining the data it produces.

A common analogy: monitoring tells you the engine temperature is rising (you set a threshold and get an alert). Observability lets you open the hood and figure out *why* the temperature is rising, even if you never thought to instrument that specific cause. Monitoring is knowing your car has a temperature gauge; observability means you also have logs of what the engine was doing before it overheated.

## Why does it matter for devops?

You can't automate what you can't measure. Every pipeline, every deployment, every security scan produces events and metrics. Without observability, you're making decisions blind — did that deploy actually succeed? Is the database connection pool exhausted? Did the Falco rule fire because of a real intrusion or a false positive?

Observability also directly supports the security side of devops. Anomaly detection, runtime security monitoring, and audit trails all depend on collecting and analyzing system signals. If I can see what's normal, I can spot what's abnormal. That's the foundation for tools like Falco, Prometheus, and Grafana.

## Key terminology

- **Metric** — A numerical value measured over time. Example: `http_requests_total{status="200"} 10234` — a counter of HTTP 200 responses.
- **Log** — A timestamped record of an event, usually text. Example: `2026-07-01T10:00:00Z ERROR failed to connect to database: timeout`.
- **Trace** — A record of a request's path through a distributed system. Example: an API call that goes through a gateway, a service, and a database, with timing for each hop.
- **Alert** — A notification triggered when a metric or log pattern crosses a threshold. Example: PagerDuty page when pod crash-loop rate exceeds 5/min.
- **Dashboard** — A visual display of metrics and logs, organized to answer common questions. Example: a Grafana dashboard showing request rate, error rate, and p99 latency.
- **Service Level Indicator (SLI)** — A specific metric that measures a aspect of service quality. Example: "proportion of requests completed in under 500ms."
- **Service Level Objective (SLO)** — A target value for an SLI. Example: "99.9% of requests complete in under 500ms per month."
- **Service Level Agreement (SLA)** — A contractual commitment based on SLOs. Example: "If uptime drops below 99.9%, customers get a credit."

## A concrete example

```bash
# Simulate a basic metric + alert pipeline with Prometheus rules
cat > /tmp/alert-rule.yml << 'EOF'
groups:
  - name: instance
    rules:
      - alert: InstanceDown
        expr: up == 0
        for: 5m
        annotations:
          summary: "Instance {{ $labels.instance }} down"
      - alert: HighCPU
        expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 10m
        annotations:
          summary: "Instance {{ $labels.instance }} CPU > 80%"
EOF

echo "This Prometheus rule file defines two alerts: one fires when an instance stops reporting,
the other when CPU usage stays above 80% for 10 minutes."
```

This example shows what monitoring looks like in practice: you define conditions, set thresholds, and get notified when things break. The data comes from `node_exporter` metrics that Prometheus scrapes automatically.

## How this connects to what's next

Observability is the lens through which I'll look at every tool in this kit. Prometheus and Grafana are the core metric stack. Falco and Tetragon produce security events that need to be forwarded and alerted on. Even CI pipelines generate metrics (build duration, scan pass/fail rates) that belong on a dashboard. Understanding the data types — metrics, logs, traces — is what lets me choose the right tool for each signal.
