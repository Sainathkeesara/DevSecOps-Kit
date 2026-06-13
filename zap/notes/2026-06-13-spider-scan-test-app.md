# Spider scanning with ZAP against a test app

Installed ZAP daemon and ran my first spider scan today to discover URLs on a test application.

## Install ZAP for headless scanning

Using the Docker image since that's what I'll use in CI later:

```
docker pull ghcr.io/zaproxy/zaproxy:stable
```

## Running the spider

```
docker run --rm -p 8080:8080 -p 8090:8090 \
  ghcr.io/zaproxy/zaproxy:stable zap.sh -daemon -port 8080 -host 0.0.0.0
```

Spawned the daemon, then used curl to trigger a spider scan against my test app:

```
curl -s "http://localhost:8090/JSON/spider/action/scan/?url=http://test-app:8080"
```

The spider returned a scan ID. I polled for status:

```
curl -s "http://localhost:8090/JSON/spider/view/status/?scanId=1"
```

## What I noticed

- Spider discovers URLs by following links in pages and scripts
- It respects `robots.txt` by default, can disable with `?treeMaxChildren=0`
- The scan found 12 URLs in my test app — more than I expected
- Some were external links I should exclude next time

## Got stuck on

- Needed to `sleep 10` after daemon start before API calls worked
- Spider got stuck on a slow-loading page — need `maxDuration` parameter
- The default context is too broad, I should scope it to my app's paths

## What I'd try next

Configure a proper context with scope boundaries and try the recursive spider options.