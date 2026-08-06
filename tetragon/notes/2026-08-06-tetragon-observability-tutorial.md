---
last_verified: 2026-08-06
tool_version: n/a
---

# Following the Tetragon observability tutorial — what tripped me up

I set out to follow the official Tetragon observability tutorial end-to-end, expecting a straightforward walkthrough. It was not straightforward. Here is what happened and where I got stuck.

## What I did

I started by deploying Tetragon on a local kind cluster so I could observe real workload behavior. The tutorial walks through installing the Tetragon DaemonSet, enabling eBPF probes, and then generating traffic to see events flow in. I followed the installation steps and waited for the DaemonSet pods to reach `Running` status.

Once the agent was up, I tried to generate some exec events by running a simple `curl` against a test service. I expected to see events immediately, but the default policy was very broad and I was getting overwhelmed by the volume of data. I had to go back and read up on how to write a TracingPolicy that filters down to just the events I care about.

## What tripped me up

The first thing that caught me out was the difference between Tetragon's event types. The tutorial mentions process exec, file access, and network events, but it took me a while to understand how these map to the actual eBPF probes under the hood. I kept conflating "network connection" with "DNS lookup" and wondering why my policy wasn't catching what I expected.

The second stumbling block was the TracingPolicy YAML structure. The selectors and match expressions are powerful but the syntax is dense. I wrote a policy that I thought would catch `execve` calls from a specific container, but it matched everything instead. I had to go through the selector matching logic more carefully to understand how `match` and `exclude` interact.

The third thing that confused me was the output format. Tetragon emits structured JSON, and while that is great for downstream processing, it is not great for quick debugging. I kept wanting a human-readable table view and had to reach for `jq` to make the output tolerable.

## What I'd try next

I want to get a TracingPolicy working that captures only the events I care about — exec calls from pods in a specific namespace — and then wire those events into a simple alerting pipeline. I also want to try correlating Tetragon events with Falco alerts to see where the two tools overlap and where each one catches things the other misses.