---
last_verified: 2026-11-21
tool_version: n/a
sources: []
---

# A security and SLO dashboard in Grafana

You scraped the app and Falco in the previous lesson and turned those metrics into alerting rules. This lesson takes the next step: instead of checking alerts one at a time, you'll build a single Grafana dashboard that surfaces the SLO, scanner gate results and runtime alerts side by side, and you'll provision that dashboard from a file kept in Git so it's versioned like everything else.

## What you'll learn
- Provision a dashboard from a file kept in Git
- Show the SLO, scanner gate results and runtime alerts together

## Before you start
- [Alert on the app and on security events](03-prometheus-security-alerts.md) — Prometheus scraping the app and Falco, alerting rules `HighAppErrorRate` and `FalcoCriticalEvent`, and a healthy Prometheus at `http://localhost:9090`.
- Grafana running and reachable at `http://localhost:3000` (admin / admin). Confirm with `curl http://localhost:3000/api/health` returning `"database": "ok"`.
- The Prometheus datasource already added to Grafana — see `grafana/configs/2026-09-19-first-datasource.yaml` (Prometheus at `http://localhost:9090`, `isDefault: true`).

## Walkthrough

### 1. Write the dashboard JSON file

Create the dashboard definition as a file kept in Git. It holds three panels: the SLO (availability from the app's request totals), the scanner gate results (findings count from the last scan), and runtime alerts (firing Prometheus alerts such as `FalcoCriticalEvent`).

Save this as `grafana/configs/security-slo-dashboard.json`:

```json
{
  "id": null,
  "uid": "security-slo",
  "title": "Security and SLO dashboard",
  "timezone": "browser",
  "schemaVersion": 39,
  "version": 1,
  "refresh": "30s",
  "panels": [
    {
      "type": "stat",
      "title": "SLO - availability",
      "gridPos": { "h": 4, "w": 12, "x": 0, "y": 0 },
      "datasource": "my-first-prometheus",
      "targets": [
        {
          "expr": "(1 - (rate(http_requests_total{code=~\"5..\"}[5m]) / rate(http_requests_total[5m]))) * 100",
          "legendFormat": "availability %"
        }
      ]
    },
    {
      "type": "stat",
      "title": "Scanner gate - findings",
      "gridPos": { "h": 4, "w": 12, "x": 12, "y": 0 },
      "datasource": "my-first-prometheus",
      "targets": [
        {
          "expr": "scanner_findings_total",
          "legendFormat": "findings"
        }
      ]
    },
    {
      "type": "stat",
      "title": "Runtime alerts - firing",
      "gridPos": { "h": 4, "w": 24, "x": 0, "y": 4 },
      "datasource": "my-first-prometheus",
      "targets": [
        {
          "expr": "count(ALERTS{alertname=~\"FalcoCriticalEvent|HighAppErrorRate\"})",
          "legendFormat": "firing alerts"
        }
      ]
    }
  ]
}
```

The metric names must match what Prometheus actually scrapes — confirm `http_requests_total` exists from the previous lesson, and swap `scanner_findings_total` for whatever your scanner gate exposes.

You should see: the file parses as valid JSON (`python3 -m json.tool grafana/configs/security-slo-dashboard.json` prints it back without error).

### 2. Provision the dashboard from Git

Grafana's file provider reads dashboard JSON from a folder on disk, so a file committed to Git becomes a dashboard in Grafana without any clicking. The provider definition already exists in `grafana/configs/2026-10-14-dashboard-provisioning.yaml` (a `file` type provider watching a dashboards folder).

Copy the dashboard JSON into the folder the provider watches, then restart Grafana so it picks up the new file:

```bash
cp grafana/configs/security-slo-dashboard.json /var/lib/grafana/dashboards/
systemctl restart grafana-server
```

(Use the path your provider is configured with; `2026-10-14-dashboard-provisioning.yaml` sets `path: /var/lib/grafana/dashboards`.)

You should see: after restart, Grafana reloads the folder and the dashboard appears in the dashboard list.

### 3. Open the dashboard and confirm the three panels

Open Grafana at `http://localhost:3000`, go to the dashboard list, and open "Security and SLO dashboard".

You should see: three stat panels — "SLO - availability" showing a percentage, "Scanner gate - findings" showing a count, and "Runtime alerts - firing" showing the number of firing alerts — all querying the `my-first-prometheus` datasource.

## Exercise

Working alone, against your running Grafana and Prometheus:

1. Commit `grafana/configs/security-slo-dashboard.json` to Git alongside the provisioning file.
2. Provision it from Git (copy into the provider's dashboards folder and reload Grafana), then confirm the dashboard appears in the dashboard list without using the UI to create it.
3. Add a fourth panel of your choice that shows something security-relevant (for example, Falco events over time, or app error rate over time) and verify it renders.

Do not paste the solution into the lesson file.

## Check your work

```bash
python3 -m json.tool grafana/configs/security-slo-dashboard.json > /dev/null && echo "valid JSON"
curl -s http://localhost:3000/api/search | python3 -m json.tool | grep -c "security-slo"
curl -s http://localhost:3000/api/dashboards/uid/security-slo | python3 -m json.tool | grep '"title"'
```

Expected results:
- `valid JSON` prints, confirming the dashboard file parses.
- The search count is at least `1` — the dashboard is indexed by Grafana.
- The dashboard request returns `"title": "Security and SLO dashboard"`.

## Common mistakes

- **Provisioning before the datasource exists.** Panels query `my-first-prometheus`, so add that datasource (see `grafana/configs/2026-09-19-first-datasource.yaml`) before loading the dashboard, or panels show "No data".
- **Referencing a metric that isn't scraped.** `scanner_findings_total` is a placeholder — confirm the exact metric name and labels on your Prometheus endpoint before wiring a panel, just as you did for Falco's counters in the previous lesson.
- **Editing the dashboard in the UI after provisioning.** With `allowUiUpdates: true` the UI edits can be written back, but the source of truth is the Git file; re-provisioning overwrites UI changes.

## Next

[Respond to a vulnerable-dependency incident](../../00_index/learning-path.md)
