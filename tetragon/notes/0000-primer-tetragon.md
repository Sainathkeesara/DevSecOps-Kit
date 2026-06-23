# Tetragon — quick primer

> First-day notes for someone who's never used Tetragon. Personal voice, plain language.

## What is it?

Tetragon is a Kubernetes-native security observability tool that sits somewhere between Falco and traditional APM tools. It uses eBPF to monitor what's happening in your clusters — system calls, network connections, file access, process execution — and gives you both real-time alerts and historical data. Think of it as a security camera with a DVR: you can see what's happening now and replay what happened before.

## What does it do?

Tetragon can trace any system call across your cluster nodes, correlate events across the container boundary (so you see which pod was behind a process), and apply policies to filter out noise or trigger alerts. It's more efficient than userspace agents because eBPF runs in-kernel without context switches, and it can give you pod/process/container context that raw syscalls can't.

## Why does it exist?

Before Tetragon, you'd either run heavy userspace agents that slowed things down or raw kernel-level tools like Falco that missed container context. Tetragon sits in the middle: eBPF efficiency with Kubernetes-aware output. It came out of the Cilium project (same folks behind Hubble), so it integrates naturally with CNI-aware environments where you want security visibility.

## Key terminology

- **eBPF** — Extended Berkeley Packet Filter, a Linux kernel feature that lets Tetragon hook into system events without kernel modules.
- **TracingPolicy** — YAML-based policy that defines which events to capture and how to filter/alert on them.
- **Node agent** — A DaemonSet running on each cluster node, collecting events directly from the kernel.
- **Process event** — When a process starts, executes, or exits — includes binary path and arguments.
- **File access event** — When a process tries to read/write/delete a file — useful for detecting config tampering.
- **Network event** — Connection attempts, including source/destination IPs and ports — helps catch unexpected egress.
- **Pod context** — Tetragon enriches raw events with Kubernetes metadata (namespace, pod name, container name).
- **Kernel sensor** — The low-level eBPF code that captures syscalls; written in C but configured via TracingPolicy.

## A tiny example

```yaml
apiVersion: cilium.io/v2
kind: CiliumTracingPolicy
metadata:
  name: exec-tracer
spec:
  tracepoints:
  - name: exec
    options:
      includeRequestDetails: true
    selectors:
    - syscall: execve
      args:
        - index: 0
          type: string
          match: ".*/wget"
```

This TracingPolicy captures any `execve` call where the binary path ends with `wget`, giving you pod context and the full command line.

## What I'll cover next

I want to get Tetragon running on a test cluster, watch my first exec events in real time, and try a TracingPolicy that catches network connections to suspicious IPs. Then I'll look at how to ship these events to a log aggregator or alert on them.