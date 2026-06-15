# Understanding Falco's rule file structure — macros, lists, and the append trick

I'd already installed Falco and triggered my first alert by running `kubectl exec` into a test pod. The default ruleset caught it with the built-in "Shell Spawned In Container" rule. But when I opened the rules file to understand how rules are built, I realized the structure is more than just `- rule:` entries. There are macros, lists, and an `append: true` directive that took me a while to wrap my head around.

## What I found

The default rules file has three top-level entry types:

- **`- list:`** — Named sets of values. Like variables for rule conditions.
- **`- macro:`** — Reusable condition fragments. Like a function that returns a boolean expression.
- **`- rule:`** — The actual alert with a condition, output message, and priority.

Lists group values so you don't repeat yourself. The default rules define things like:

```yaml
- list: shell_binaries
  items: [bash, sh, dash, zsh, csh, ksh, fish]
```

A rule or macro references it by name. Macros bundle common checks. The default rules use `container` everywhere:

```yaml
- macro: container
  condition: container.id != host
```

I traced how many rules use this macro — almost all of them. Without it, every rule would repeat `container.id != host`, making the file twice as long and brittle.

Rules tie it together:

```yaml
- rule: Shell Spawned In Container
  desc: A shell was spawned in a container
  condition: >
    spawned_process and container
    and shell_procs and proc.name in (shell_binaries)
  output: >
    Shell spawned (%proc.cmdline) in container
    (%container.name)
  priority: WARNING
```

The condition uses `shell_procs` (a macro) and `shell_binaries` (a list) — no raw values in the condition itself.

## Got stuck on

The `append: true` syntax. It lets you extend an existing list or macro from a separate custom rules file. Falco relies on this pattern heavily — the base `falco_rules.yaml` ships with the chart, and users add overrides in a separate file loaded on top.

I tried adding `pwsh` (PowerShell on Linux) to the shell list:

```yaml
- list: shell_binaries
  append: true
  items: [pwsh]
```

This merges `[pwsh]` into the existing list rather than replacing it. The same works for macros — you can add an extra condition without copying the whole thing.

But one gotcha: the append file must be loaded AFTER the original definition. In Helm, you control this via `customRules` and mount order. I initially placed my append at the top of my custom rules file and it didn't take effect — Falco processes rules in file order, and the base file hadn't been read yet.

The output field syntax also tripped me up. A rule's `output` uses `%` placeholders referencing event fields:

```yaml
output: Shell spawned (%proc.cmdline) in container (%container.name)
```

The available fields aren't listed in one place — I found them by grepping the default rules to see what other rules used.

Another thing: I initially thought `condition` supports full boolean algebra with `and`, `or`, `not`, and parentheses — it does — but the `spawned_process` and `shell_procs` macros both expand to complex conditions. Reading the expanded condition by hand was hard until I realized I could run `falco --list` to see resolved fields.

## What I'd try next

I want to write a rule that detects `curl` or `wget` making outbound connections from containers — something that could catch data exfiltration. I also want to explore Falco's gRPC output to wire alerts into something other than pod logs.
