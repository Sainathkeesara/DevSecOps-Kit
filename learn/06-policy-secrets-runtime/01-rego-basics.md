---
last_verified: 2026-11-16
tool_version: n/a
sources: []
---

# Rego basics and testing policies

You promoted changes through Git with Argo CD in the previous lesson, watching the cluster converge to the desired state. Now you'll add a guardrail: OPA lets you write policies in Rego that answer questions like "can this pod run privileged?" before anything reaches the cluster. This lesson teaches you to write a Rego rule, test it with `opa test`, and debug a rule that silently never fires — the skills you'll need for Gatekeeper admission control in the next lesson.

## What you'll learn

- Write a Rego rule and test it with `opa test`
- Debug a rule that can never fire

## Before you start

- [Deploy and debug the sample app on kind](../05-kubernetes-gitops/02-k8s-deploy-sample-app.md) — you should be comfortable with kubectl, Deployments, and Kubernetes admission review JSON.
- [YAML, JSON, jq and regex for security tooling](../01-foundations/06-yaml-json-jq-regex.md) — you should know how to read JSON with jq, since Rego policies evaluate JSON input.
- OPA CLI installed: `opa version` prints a version.
- A working directory for the policy files (create `rego-basics/` under your workspace).

## Walkthrough

### 1. Write a Rego rule that denies privileged containers

Create `deny-privileged-containers.rego` with a rule that flags any container running privileged:

```rego
package k8s.pod_security

deny[msg] {
  container := input.containers[_]
  container.securityContext.privileged == true
  msg := sprintf("Container %v runs privileged — not allowed", [container.name])
}
```

The input shape matches a Kubernetes admission review object. Create `pod-input.json` with a sample pod:

```json
{
  "metadata": {"name": "frontend", "namespace": "default"},
  "spec": {
    "containers": [
      {"name": "web", "image": "nginx:1.25", "securityContext": {"privileged": true}},
      {"name": "sidecar", "image": "busybox", "securityContext": {"privileged": false}}
    ]
  }
}
```

Evaluate the policy against the input:

```bash
opa eval --format pretty \
  --data deny-privileged-containers.rego \
  --input pod-input.json \
  "data.k8s.pod_security.deny"
```

You should see: `Container web runs privileged — not allowed` and nothing for the sidecar, because only `web` has `privileged: true`.

### 2. Test the rule with `opa test`

Create `deny-privileged-containers_test.rego` with two test cases — one that expects a violation, and one that expects none:

```rego
package k8s.pod_security.test

import data.k8s.pod_security

test_denies_privileged_container {
  data.k8s.pod_security.deny["Container web runs privileged — not allowed"] with input as {
    "containers": [{"name": "web", "securityContext": {"privileged": true}}]
  }
}

test_allows_unprivileged_container {
  not data.k8s.pod_security.deny[_] with input as {
    "containers": [{"name": "web", "securityContext": {"privileged": false}}]
  }
}
```

Run the tests:

```bash
opa test deny-privileged-containers.rego deny-privileged-containers_test.rego -v
```

You should see both tests pass:

```
data.k8s.pod_security.test.test_denies_privileged_container: PASS
data.k8s.pod_security.test.test_allows_unprivileged_container: PASS
```

### 3. Debug a rule that can never fire

Now write a rule with a bug: a container can't be named two different things at once, so this deny rule can never fire:

```rego
package k8s.debug

deny[msg] {
  container := input.containers[_]
  container.name == "webapp"
  container.name == "database"
  msg := "contradictory deny rule — can never fire"
}
```

Evaluate it against `pod-input.json`:

```bash
opa eval --format pretty \
  --data contradictory-deny.rego \
  --input pod-input.json \
  "data.k8s.debug.deny"
```

You should see: `undefined` — the rule returned nothing, which means it never fired. The bug is the contradictory condition: `container.name` can't equal both `"webapp"` and `"database"` at the same time.

Debug by removing one condition at a time. Change the second condition to `container.name == "webapp"` and re-run — you'll see the rule fire for the `web` container. The fix is to split the contradictory rule into two separate rules, each with its own condition:

```rego
package k8s.debug

deny[msg] {
  container := input.containers[_]
  container.name == "webapp"
  msg := sprintf("Container %v is webapp", [container.name])
}

deny[msg] {
  container := input.containers[_]
  container.name == "database"
  msg := sprintf("Container %v is database", [container.name])
}
```

## Exercise

Working alone, in your `rego-basics/` directory:

1. Write a new Rego policy `deny-host-network.rego` that denies any pod using `hostNetwork: true`. The rule should produce a message naming the pod.
2. Write a test file `deny-host-network_test.rego` with two cases: one that expects the denial for a pod with `hostNetwork: true`, and one that expects no denial for a pod without it.
3. Run `opa test` on both files and confirm both tests pass.

Do not paste the solution into the lesson file.

## Check your work

```bash
opa test deny-host-network.rego deny-host-network_test.rego -v
```

Both tests should print `PASS`. The denial message should include the pod's name, e.g. `Pod risky uses host networking — not allowed`.

## Common mistakes

- **Referencing a field that doesn't exist.** If `securityContext` is missing from a container, `container.securityContext.privileged` is undefined and the rule silently skips that container — no error, just no violation. Always test with inputs that include and omit the field.
- **Using `=` instead of `==`.** In Rego, `=` is assignment (unification) and `==` is comparison. Writing `container.securityContext.privileged = true` inside a rule body tries to assign, not compare, and produces unexpected results.

## Next

[Reject privileged and root pods with Gatekeeper](02-gatekeeper-admission.md)
