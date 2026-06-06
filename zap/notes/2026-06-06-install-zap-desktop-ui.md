# Installing OWASP ZAP and exploring the desktop UI

Downloaded and ran OWASP ZAP today. Here's what happened.

## Install

Went to the ZAP download page and grabbed the Linux installer. Ran `./ZAP_*.sh` and it extracted to a directory. `./zap.sh` launched the desktop app.

Turns out there's also a Docker image: `docker pull ghcr.io/zaproxy/zaproxy:stable`. That's probably what I'll use for CI later.

## First launch

On first launch ZAP asked about persistent session storage. Clicked "No, I'll start with a temporary session" like the quickstart says.

The UI is overwhelming at first glance. Left panel has the Sites tree — completely empty until I do something. Bottom panel has tabs for Alerts, History, Search. Right side is the main workspace.

## Quick start

Used the Quick Start tab. Entered the URL of a test staging app I own. Hit "Attack" and it ran an automated scan — spider first, then active scan with payloads.

Came back a few minutes later and found alerts. Mostly Medium-severity stuff — missing security headers, cookies without HttpOnly flag. Nothing critical on this app, which I expected.

## What tripped me up

- The HUD didn't show up by default. Had to enable it from the top toolbar. Pretty obvious once I looked.
- ZAP starts proxying on port 8080 immediately. My browser couldn't load anything until I either configured Firefox to use ZAP as a proxy or closed ZAP.
- The session pop-up is confusing on first run. Temporary vs persistent? I still don't fully get the implications.
- Ran active scan on a page I shouldn't have. Triggered some alerts in the monitoring system. Whoops. Next time I'll be more careful about scope.

## What I'd try next

Set up a proper context with scope boundaries, configure the HUD properly, and try the Docker-based baseline scan for CI.
