---
last_verified: 2026-10-26
tool_version: n/a
sources: []
---

# Grafana alerting: routing and templates

## Purpose

Grafana alerting turns a query against a data source into a notification: an alert rule evaluates a query on a schedule, fires when its condition is met, and sends the result to a contact point — Slack, webhook, email, PagerDuty. Notification policies route alerts to the right contact point based on label matchers such as severity, service, or team, and Go templates format the message body. This note walks through wiring alert rules, routing, and templates together. It is one way to do it; Grafana also supports recording rules, silencing, and multi-homing alerts across contact points, which are out of scope here.

## How the pieces fit

- Data source — where the query runs (Prometheus, Loki, and others).
- Alert rule — the query, its condition, the evaluation interval, and how long the condition must hold (`for`) before the rule fires.
- Contact point — where notifications go (webhook URL, Slack channel, email address).
- Notification policy — routing rules that match alert labels and forward to a contact point; the default policy catches everything else.
- Template — a Go template that renders the notification body from labels, annotations, and values.

## Steps

1. Add a contact point. Example: a webhook that POSTs to an internal collector, or an email address for critical alerts.
2. Create an alert rule: pick the data source, write the query (for example `up{job="api"} == 0`), set the evaluation interval and the `for` duration, and label the rule (severity=critical, service=api).
3. Create a notification policy. Add a matcher such as `severity=critical` that routes to the paging contact point, and another such as `service=api` that routes to the team Slack. Order matters: the first matching policy wins, and the default policy is the fallback.
4. Write a notification template. A small Go template iterates over firing and resolved alerts and emits labels like `{{ .CommonLabels.service }}` and values like `{{ .CommonAnnotations.summary }}`. Template syntax is easy to mistype — a broken template prevents delivery even when the rule fires correctly.
5. Apply in Grafana (Administration → Alerting), then verify: force the rule to fire (for example by stopping the scrape target), confirm the notification lands at the expected contact point, and confirm the rendered message contains the expected labels.

## Verify

- The rule appears in the alerting UI with state "normal" before the condition triggers.
- Firing an alert produces exactly one notification per matching contact point — no duplicates from overlapping policies.
- The rendered message includes the alert name, severity, and service label from the template.
- Silencing an alert stops notifications without deleting the rule, which confirms routing and silencing are independent.

If a rule never fires, check the query in Explore first and the evaluation interval second — most missed alerts are query or timing issues, not routing issues.
