# ZAP integration patterns for web app security testing

I spent this session figuring out how to wire OWASP ZAP into automated testing workflows. The desktop UI is fine for one-off scans, but for repeatable security testing I needed patterns that work headless and in CI.

## Setting up ZAP in daemon mode

The key pattern is running ZAP as a headless daemon and controlling it through the REST API.

```bash
docker run -d --name zap-daemon -p 8080:8080 -p 8090:8090 \
  ghcr.io/zaproxy/zaproxy:stable \
  zap.sh -daemon -port 8080 -host 0.0.0.0 \
  -config api.disablekey=true
```

Started it with `-config api.disablekey=true` for local testing — in CI I'd use a proper API key. The daemon listens on port 8080 (proxy) and 8090 (API by default).

## Running a spider scan via API

Once the daemon is up, the REST API at `http://localhost:8090/JSON/` controls everything.

```bash
TARGET="https://example.com"
API_KEY=""

# Start spider scan
SPIDER_ID=$(curl -s "http://localhost:8090/JSON/spider/action/scan/?apikey=$API_KEY&url=$TARGET" | jq -r '.scan')

# Poll until done
while true; do
  STATUS=$(curl -s "http://localhost:8090/JSON/spider/view/status/?apikey=$API_KEY&scanId=$SPIDER_ID" | jq -r '.status')
  echo "Spider: $STATUS%"
  [ "$STATUS" = "100" ] && break
  sleep 5
done
```

The spider discovers URLs. Then I run an active scan on the discovered URLs to actually find vulnerabilities.

## Full pipeline: spider + active scan + report

```bash
#!/bin/bash
TARGET=$1
API_KEY=${2:-""}

# Spider
SPIDER_ID=$(curl -s "http://localhost:8090/JSON/spider/action/scan/?apikey=$API_KEY&url=$TARGET" | jq -r '.scan')
while [ "$(curl -s "http://localhost:8090/JSON/spider/view/status/?apikey=$API_KEY&scanId=$SPIDER_ID" | jq -r '.status')" != "100" ]; do sleep 5; done

# Active scan
SCAN_ID=$(curl -s "http://localhost:8090/JSON/ascan/action/scan/?apikey=$API_KEY&url=$TARGET" | jq -r '.scan')
while [ "$(curl -s "http://localhost:8090/JSON/ascan/view/status/?apikey=$API_KEY&scanId=$SCAN_ID" | jq -r '.status')" != "100" ]; do sleep 10; done

# Generate HTML report
curl -s "http://localhost:8090/OTHER/core/other/htmlreport/?apikey=$API_KEY" -o zap-report.html
echo "Report saved to zap-report.html"
```

This is the core pattern. The active scan step is slow — it sends actual attack payloads — so that's the bottleneck.

## Got stuck on

- **API key mismatch.** The `-config api.disablekey=true` option works but if you also set `api.key` in the config, it overrides. I spent 20 minutes debugging 403 errors because the default config had a key set.
- **Context scope.** Without defining a context, ZAP treats the target broadly. For a real app I needed to set `contextId` and `url` in the scan parameters to stay in scope and avoid scanning external services.
- **Active scan took forever.** On a medium-sized app the active scan ran for over an hour. I learned to scope it with context and use `recurse=false` for initial runs.

## What I'd try next

I want to wrap this into a proper CI pipeline with failure thresholds (fail on High findings) and integrate authentication via ZAP context files so it can crawl behind login forms. The baseline scan (`zap-baseline.py`) is faster but only does passive checks — the active scan finds real issues but needs careful scoping.

## Scan type comparison

| Scan type | What it does | Speed | Use case |
|-----------|-------------|-------|----------|
| Baseline | Spider + passive scan | Fast (minutes) | CI smoke test |
| Full | Spider + passive + active | Slow (hours) | Pre-release deep scan |
| API-driven | Custom via REST API | Configurable | Targeted testing |
