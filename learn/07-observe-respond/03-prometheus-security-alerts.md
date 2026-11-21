---
last_verified: 2026-11-18
tool_version: n/a
sources: []
---

# Alert on the app and on security events

In the previous lesson you ran Prometheus, scraped a single target, and wrote your first PromQL queries. This lesson continues that loop by adding alerting: you'll scrape your application's `/metrics` endpoint alongside Falco's security-event metrics, then fire alerts when the app error rate climbs and when Falco emits a critical-priority event. It builds on the Prometheus primer, the observability concepts primer, and the Falco shell-detection lesson you just completed.

## What you'll learn
- Scrape the app and Falco metrics
- Alert on error rate and on Falco critical events

## Before you start

- [Prometheus — quick primer](../../prometheus/notes/0000-primer-prometheus.md) — scrape configs, PromQL instant and range queries, and alerting rule structure (`expr`, `for`, `annotations`); the `/metrics` endpoint convention for instrumented apps.
- [Observability and monitoring — concepts](../../docs/concepts/observability-monitoring/0000-primer-observability-monitoring.md) — SLI/SLO, alert thresholds, and the metric/label/time-series model alert rules are written against.
- [Detect a shell in a container with Falco](../06-policy-secrets-runtime/07-falco-detect-shell.md) — Falco rules, `level`/`priority`, and the shell-in-container rule you will alert on here.
- Prometheus running: `prometheus --version` prints a version and `curl http://localhost:9090/-/healthy` returns `Prometheus is Healthy.`
- Falco running with its Prometheus metrics endpoint on port 8765: `kubectl -n falco get pods` shows the Falco DaemonSet `Running`, and `curl http://<falco-node>:8765/metrics` returns metrics text. See `falco/configs/2026-10-03-minimal-runtime-config.yaml` (webserver + metrics blocks).
- An instrumented app exposing `/metrics` on port 8080 (the `demo-app` job pattern from `prometheus/snippets/2026-10-25-minimal-scrape-config.yaml`).

## Walkthrough

### 1. Scrape the app and Falco metrics

Extend `prometheus.yml` with two scrape jobs: one for the app's `/metrics` endpoint and one for Falco's Prometheus endpoint. Falco serves metrics on port 8765 only when both `metrics.enabled` and `webserver.prometheus_metrics_enabled` are true.

```yaml
scrape_configs:
  - job_name: 'demo-app'
    static_configs:
      - targets: ['localhost:8080']
        labels:
          component: 'application'
  - job_name: 'falco'
    static_configs:
      - targets: ['<falco-node>:8765']
        labels:
          component: 'security'
          source: 'falco'
```

Reload Prometheus: `curl -X POST http://localhost:9090/-/reload`

You should see: both jobs listed as `UP` in `http://localhost:9090/targets`, and `up{job="demo-app"}` and `up{job="falco"}` each return `1`.

### 2. Alert on the app error rate

Create an alerting rules file `alerts.yml` and register it under `rule_files` in `prometheus.yml`. The app error rate is the share of 5xx responses over the last 5 minutes; alert when it exceeds 5%.

```yaml
rule_files:
  - 'alerts.yml'
```

```yaml
groups:
  - name: app-alerts
    rules:
      - alert: HighAppErrorRate
        expr: |
          rate(http_requests_total{code=~"5.."}[5m])
          /
          rate(http_requests_total[5m])
          > 0.05
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "High error rate on {{ $labels.job }}"
          description: "{{ $value | humanizePercentage }} of requests are failing over the last 5 minutes."
```

Reload Prometheus again.

You should see: `HighAppErrorRate` appears in `http://localhost:9090/api/v1/rules` and in the Alerts UI, and stays inactive while the app serves healthy traffic.

### 3. Alert on Falco critical events

Falco exposes per-rule event counters on its Prometheus endpoint (port 8765). Before writing the rule, confirm the exact counter name and labels on your endpoint:

```bash
curl -s http://<falco-node>:8765/metrics | grep falco
```

You should see: counter lines such as `falco_rules_total` carrying `rule` and `priority` labels — confirm the exact name and label set on your endpoint, then adjust the rule below.

```yaml
groups:
  - name: security-alerts
    rules:
      - alert: FalcoCriticalEvent
        expr: |
          increase(falco_rules_total{priority="critical"}[5m]) > 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Falco critical event: {{ $labels.rule }}"
          description: "Falco rule {{ $labels.rule }} fired at critical priority."
```

Append this group to `alerts.yml`, reload Prometheus, then trigger the Falco shell rule (`kubectl exec` into a test container, as in the previous lesson) and confirm `FalcoCriticalEvent` fires.

## Exercise

Working alone, against your running Prometheus and Falco:

1. Add the `demo-app` and `falco` scrape jobs to `prometheus.yml`, reload, and confirm both targets are `UP`.
2. Create `alerts.yml` with a `HighAppErrorRate` rule (error rate > 5% over 5 minutes), register it under `rule_files`, reload, and confirm it loads and stays inactive with healthy traffic.
3. Scrape `:8765/metrics`, confirm Falco's critical-event counter name and labels, add a `FalcoCriticalEvent` rule, reload, and confirm it loads.
4. Trigger a shell-in-container event (`kubectl exec <test-container> -- sh`) and verify `FalcoCriticalEvent` moves from inactive to firing within a minute.

Do not paste the solution into the lesson file.

## Check your work

```bash
curl -s http://localhost:9090/api/v1/targets | python3 -m json.tool | grep -E '"job":|"health"'
curl -s http://localhost:9090/api/v1/rules | python3 -m json.tool | grep -E '"name":|"alert"'
```

Expected results:
- Both `demo-app` and `falco` jobs show `health: "up"`.
- Both `HighAppErrorRate` and `FalcoCriticalEvent` appear as loaded alert rules.
- After `kubectl exec <test-container> -- sh`, `FalcoCriticalEvent` moves from inactive to firing within a minute.

## Common mistakes

- **Scraping Falco without enabling both `metrics.enabled` and `webserver.prometheus_metrics_enabled`.** Turning on only the webserver serves an empty page; both blocks must be true for counter values to appear. See `falco/configs/2026-10-03-minimal-runtime-config.yaml`.
- **Alerting on a raw counter instead of a rate.** `http_requests_total` only ever goes up; always wrap it in `rate(...)` over a window before comparing to a threshold, or the alert fires forever once the counter crosses the line.
- **Hard-coding a Falco metric name that doesn't exist on your endpoint.** Falco's counter names and label sets vary by version; scrape `:8765/metrics` first and write the rule against the names you actually see.

## Next

[A security and SLO dashboard in Grafana](04-grafana-security-dashboard.md)
