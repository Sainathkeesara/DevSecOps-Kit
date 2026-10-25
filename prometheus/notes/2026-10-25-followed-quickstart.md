---
last_verified: 2026-10-25
tool_version: "2.54.0"
sources:
  - https://prometheus.io/docs/prometheus/latest/getting_started/
---

# Prometheus quickstart — what tripped me up

> First-day notes for someone who's never used Prometheus. Personal voice, plain language.

## What I did

I followed the official Prometheus getting started guide. Downloaded the binary, wrote a minimal `prometheus.yml`, ran it, and poked at the expression browser.

```bash
# Downloaded prometheus-2.54.0.linux-amd64.tar.gz from GitHub releases
tar xzf prometheus-*.tar.gz
cd prometheus-*
./prometheus --config.file=prometheus.yml
```

The binary started up on `http://localhost:9090`. No Docker, no compose, just a single binary. That part was refreshingly simple.

## What worked

- The expression browser at `/graph` lets you type PromQL and see instant results. `prometheus_http_requests_total` returned data immediately — Prometheus scrapes itself by default.
- The targets page at `/targets` shows scrape status. Green = healthy, red = failed. Mine showed `prometheus` (self) and `node_exporter` (which I hadn't started yet, so red).
- `promtool check config prometheus.yml` validates config before restart. Caught a YAML indent error I made.

## Where I tripped up

**1. Scrape config indentation is picky**
```yaml
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
```
I initially wrote `targets: ['localhost:9090']` at the same indent as `static_configs:`. Prometheus failed to start with a cryptic "unexpected token" error. The `-` before `targets` matters — it's a list item under `static_configs`.

**2. `node_exporter` doesn't come bundled**
The quickstart mentions it but you have to download it separately. I forgot, saw the target stay red, and spent 10 minutes wondering if my config was wrong. Separate binary, separate port (9100), separate process.

**3. Relabeling syntax is not intuitive**
Wanted to add a `environment="dev"` label to all scraped metrics. The docs show `relabel_configs` with `source_labels`, `regex`, `replacement`, `action`. Tried a few combinations before realizing `action: labelmap` with `__meta_*` labels is for service discovery, not static labels. For static labels, just use `static_configs:` with `labels:`:
```yaml
static_configs:
  - targets: ['localhost:9090']
    labels:
      environment: 'dev'
```

**4. No authentication on the UI by default**
Anyone who hits `:9090` can see all metrics, run queries, hit `/api/v1/admin/tsdb/delete_series`. The guide doesn't mention this. For anything beyond local testing, put it behind a reverse proxy with auth.

**5. Retention defaults to 15 days**
Not a problem for a quickstart, but worth knowing before you fill a disk. `--storage.tsdb.retention.time=30d` or `--storage.tsdb.retention.size=10GB` controls it.

## What I'd try next

- Run `node_exporter` and `blackbox_exporter` as sidecars to see real system/http metrics
- Set up alerting rules and hook them to Alertmanager (separate binary, separate config)
- Try the remote write feature to push to a long-term store like Thanos or Cortex
- Figure out service discovery (`consul_sd_config`, `kubernetes_sd_config`) so I don't hardcode targets