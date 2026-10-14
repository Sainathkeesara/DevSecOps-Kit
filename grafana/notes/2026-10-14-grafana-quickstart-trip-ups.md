---
last_verified: 2026-10-14
tool_version: n/a
---

# Grafana quickstart — what tripped me up

I followed the official Grafana quickstart on a local instance to see what a
default setup actually looks like. Here's what worked and where it broke.

## Steps I actually ran

First I logged into the fresh instance and landed on the home page with its
grid of quick-start dashboards. I opened one pre-built dashboard first instead
of building anything — it showed a few panels side by side, each one a query
plus a visualization type, which taught me the basic shape faster than the
docs did: dashboard holds panels, panel holds a query and a viz.

Next I went to the data source settings and confirmed the local metrics source
was connected. The connection test button passed on the second try (more on
that below). Then I opened a panel's query editor to see what the panel was
actually asking — a plain metric name with a time window, nothing fancy, but
seeing the query next to the graph made the panel click for me.

## Got stuck on

The data source connection failed the first time because I pointed it at the
wrong port — the metrics instance was on a different one than the quickstart
assumed. The error message just said the connection failed, so I spent a while
re-checking the source type before noticing the port. Fix was one character,
but it cost me twenty minutes.

The other snag was auto-refresh: the default dashboard refreshes every 30
seconds, so panels kept redrawing while I was reading through them slowly. I
turned refresh off while reading, then turned it back on after writing my
notes down.

## What I'd try next

Build a dashboard from scratch instead of inspecting the pre-built ones, so I
can see how a panel's query, thresholds, and legend actually fit together. I
also want to retry the alert rule tab, which I skipped this time because I ran
out of steam after the data source detour.
