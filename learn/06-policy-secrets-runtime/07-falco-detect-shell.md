---
last_verified: 2026-11-17
tool_version: n/a
sources: []
---

# Detect a shell in a container with Falco

You rejected privileged pods at admission with Gatekeeper in the previous lesson. Admission policy stops bad containers from starting, but it cannot catch what happens inside a container that is already running — an attacker who execs into a workload and drops to a shell. This lesson picks up from the container runtime concepts primer and the sample app you deployed on kind: you'll run Falco, trigger a real alert by execing into a test container, and then tune a noisy shell rule by priority and filters so it keeps signaling without paging on every legitimate exec.

## What you'll learn

- Run Falco and trigger an alert with `kubectl exec`
- Tune a noisy rule by priority and filters

## Before you start

- [Container and runtime security — concepts](../../docs/concepts/container-runtime-security/0000-primer-container-runtime-security.md) — eBPF, syscalls, and what runtime detection can see; the model Falco's rules match on.
- [Deploy and debug the sample app on kind](../05-kubernetes-gitops/02-k8s-deploy-sample-app.md) — kubectl, Deployments, and a running kind cluster with a test pod you can exec into.
- Falco installed and running as a DaemonSet in the `falco` namespace: `kubectl -n falco get pods` shows the Falco pods `Running`. See `falco/notes/2026-06-10-install-falco-first-detection.md` for the install steps.
- `kubectl` installed: `kubectl version --client` prints a client version.

## Walkthrough

### 1. Confirm Falco is running and its rules are loaded

```bash
kubectl -n falco get pods
kubectl -n falco logs -l app=falco --tail=20 | grep -iE "loaded|rule"
```

You should see: Falco DaemonSet pods in `Running` state, and log lines showing Falco loaded its default ruleset. If the pods are not running yet, install Falco with the Helm chart (`helm install falco falcosecurity/falco -n falco --create-namespace`, after adding the Falco Helm repo) and wait for the DaemonSet to roll out. See `falco/notes/2026-06-10-install-falco-first-detection.md` for the install steps.

### 2. Add a shell-in-container detection rule

Falco rules live in YAML rule files. Add a rule that fires when bash, sh, dash, or zsh is spawned inside any container. This mirrors the existing sample rule in `falco/configs/first-custom-rule-detect-shell-in-container.yaml`:

```yaml
- rule: Shell spawned in container
  desc: Detects when a shell is spawned inside a running container
  level: WARNING
  source: syscall
  syscalls:
    - execve
  condition: >
    spawned_process
    and container
    and proc.name in ("bash", "sh", "dash", "zsh")
  output: Shell spawned in container (user=%user.name command=%proc.cmdline container=%container.name image=%container.image.repository:%container.image.tag)
  tags:
    - container
    - shell
    - suspicious
```

Add this rule to your custom rules file (the Falco DaemonSet mounts your rules directory and loads it after the defaults), then restart Falco so it picks up the new rule:

```bash
kubectl -n falco rollout restart daemonset/falco
```

Wait for the DaemonSet pods to become `Running` again before moving on.

### 3. Trigger the alert with kubectl exec

Run a test container and exec a shell into it:

```bash
kubectl run test-shell --image=alpine --rm -i -- sh -c "sleep 3600"
kubectl exec -it test-shell -- sh
```

From inside the container run a command (for example `ls`), then exit. Now check the Falco pod logs:

```bash
kubectl -n falco logs -l app=falco --tail=50 | grep -i "Shell spawned"
```

You should see: a `WARNING`-level line like `Shell spawned in container (user=root command=/bin/sh container=test-shell image=alpine:latest)`. Falco caught the shell exec in real time.

### 4. Tune the noisy rule by priority and filters

On a busy cluster the shell rule fires on every `kubectl exec`, including your own debugging. Tune it two ways:

- **Filter:** add an `exceptions` block so a trusted shell binary (for example a log-shipper sidecar such as `fluent-bit`) never triggers the rule.
- **Priority:** demote the rule from `WARNING` to `INFO` so it stays in the logs for forensics but stops paging.

Replace the rule in your custom rules file with the tuned version:

```yaml
- rule: Shell spawned in container
  desc: Detects when a shell is spawned inside a running container
  level: INFO
  source: syscall
  syscalls:
    - execve
  condition: >
    spawned_process
    and container
    and proc.name in ("bash", "sh", "dash", "zsh")
  exceptions:
    - name: trusted_sidecar
      fields: [proc.name]
      values:
        - fluent-bit
      comparator: "in"
  output: Shell spawned in container (user=%user.name command=%proc.cmdline container=%container.name image=%container.image.repository:%container.image.tag)
  tags:
    - container
    - shell
    - suspicious
```

Re-apply the file and restart Falco so it reloads the rules. The exception fields must match fields the rule actually uses (`proc.name` here) — an exception on an unused field silently does nothing. For the full exception and priority workflow, see `falco/docs/tuned-falco-rules-noise-reduction.md` and `falco/docs/rule-optimization-priority-filtering.md`.

## Exercise

Working alone, against the running Falco DaemonSet:

1. Edit your custom rules file: demote the shell rule's `level` from `WARNING` to `INFO`, and add an `exceptions` block for one trusted shell binary of your choice.
2. Re-apply the file and restart the Falco DaemonSet so it reloads the rules.
3. `kubectl exec test-shell -- sh` — confirm an alert still fires, but now at `INFO` level (demoted, not paged).
4. Trigger your excepted trusted binary — confirm no alert fires for it, while a plain `sh` exec still alerts at `INFO`.

Do not paste the solution into the lesson file.

## Check your work

```bash
kubectl -n falco logs -l app=falco --tail=100 | grep -iE "Shell spawned"
kubectl -n falco rollout status daemonset/falco
```

After step 3 you should see a `Shell spawned` line at `INFO` level (not `WARNING`), confirming the priority demotion took effect. The second command shows `daemon set "falco" successfully rolled out`, confirming Falco reloaded your tuned rule file. Your rule file should contain `level: INFO` and an `exceptions` block, confirming the filter was added.

## Common mistakes

- **Editing the default rules file instead of layering a custom file.** Changes to the shipped `falco_rules.yaml` are overwritten on the next Falco upgrade. Always add custom rules in a separate rules file loaded after the defaults.
- **Forgetting to restart Falco after changing a rule file.** Falco loads rules at startup; editing the file on disk does nothing until the DaemonSet pods restart and re-read it. Always `rollout restart` after a rule change.
- **An exception that references a field the rule never uses.** Exception fields must match fields in the rule's condition, or the exception silently does nothing. Reuse the condition's fields (`proc.name` here).

## Next

[Observability and monitoring — concepts](../../docs/concepts/observability-monitoring/0000-primer-observability-monitoring.md)
