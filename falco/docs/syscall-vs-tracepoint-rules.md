# Falco Syscall vs Tracepoint Rules — Understanding the Differences for Container Behavior Monitoring

## Purpose

Understand when and how to use syscall-driven versus tracepoint-driven rules in Falco for monitoring container behavior. The choice affects performance, coverage, and the specific events you can observe.

## When to use

- Use syscall rules for maximum compatibility and broad system coverage
- Use tracepoint rules for lower overhead and kernel-stable event sources
- Mix both in a single ruleset when you need specific kernel tracepoints not available via syscall

## Prerequisites

- Falco 0.38+ installed (supports both backends)
- Kernel with eBPF enabled
- Understanding of basic Falco rule syntax

## Steps

### Understanding the rule sources

Falco rules can specify a `source` field that determines how events are collected:

```yaml
# Syscall-driven rule (traditional)
- rule: Sensitive file opened in container
  desc: Detect access to sensitive files in containers
  source: syscall
  syscalls:
    - openat
  condition: >
    fd.name in (/etc/shadow, /etc/passwd)
    and container
  output: Sensitive file accessed (file=%fd.name)
  priority: WARNING
```

```yaml
# Tracepoint-driven rule (kernel-stable events)
- rule: TCP connection established
  desc: Track outbound TCP connections from containers
  source: tracepoint
  tracepoint_subsystem: sys_connect
  tracepoint_event: sys_tcp_recv_connect
  condition: container
  output: Outbound TCP connection (dest=%fd.sport)
  priority: INFO
```

### Key differences

| Aspect | Syscall | Tracepoint |
|--------|---------|------------|
| Coverage | All syscalls (broader) | Specific kernel tracepoints (narrower) |
| Overhead | Higher (full syscall capture) | Lower (specific probes) |
| Stability | Kernel ABI changes affect it | Kernel-stabled event names |
| Use case | General system monitoring | Targeted kernel event capture |

### Writing tracepoint rules

Tracepoint rules use `tracepoint_subsystem` and `tracepoint_event` instead of `syscalls`:

```yaml
- rule: Container network connect
  desc: Monitor network connections from containers
  source: tracepoint
  tracepoint_subsystem: sys_connect
  tracepoint_event: sys_tcp_send_reset
  condition: container and evt.type = sendto
  output: Connection event in container (container=%container.name)
  priority: INFO
```

### Performance considerations

Syscall rules instrument every matching syscall across the system. In high-throughput environments, this can generate significant overhead. Tracepoint rules attach to specific kernel probe points, reducing CPU impact while potentially missing some edge cases.

## Verify

Run `falco --list-syscall-sources` to see available sources. Use `falco -V` for verbose output to confirm which source type a rule uses at runtime.

## Common errors

- Using `syscalls` field in a tracepoint rule causes parse errors
- Tracepoint events vary by kernel version; test on target nodes
- Some container attributes aren't available in tracepoint rules (kernel-stable events may lack metadata)

## References

- [Falco documentation on sources](https://falco.org/docs/rules/conditions/)
- [eBPF tracing fundamentals](https://ebpf.io/what-is-ebpf/)