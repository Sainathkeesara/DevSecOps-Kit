---
last_verified: 2026-09-26
tool_version: n/a
---

# Explore the Grafana dashboard UI — what panels and queries are there

I pointed Grafana at the local instance and poked around the dashboard UI to
see what a default install actually looks like. Here's what I found.

The first thing that greeted me was the home page: a grid of "Quick start"
dashboards, each one a pre-built view of something useful. I opened the one
called "System Health" first. It had four panels in a 2x2 layout: CPU usage
as a time series, memory pressure as a single stat, disk I/O as a bar gauge,
and a table of the top processes by CPU. The queries underneath were plain
Prometheus — `rate(node_cpu_seconds_total[5m])` for CPU, `node_memory_MemAvailable`
for memory. Nothing fancy, but it showed me the shape: a dashboard is just a
collection of panels, and each panel is just a query plus a viz type.

I clicked into the data source settings next. There were two configured: the
local Prometheus instance and a Loki source for logs. The Loki one had a
query editor with a log-inspection view — stream labels on the left, log lines
on the right, and a filter box that updates the query in real time. That's the
part that surprised me most; I'd treated Grafana as "metrics dashboards"
before this and hadn't realized how much the log view feels like the metrics
view, just with a different query language.

One thing that tripped me up: the default dashboard auto-refreshes every 30
seconds, so panels I was reading through slowly kept jumping. I ended up
turning auto-refresh off while I was reading, then turning it back on once I'd
written my notes down.

What I'd try next is building a dashboard from scratch instead of inspecting
the pre-built ones, so I can see how the panel JSON actually composes a query
with its thresholds and legends.