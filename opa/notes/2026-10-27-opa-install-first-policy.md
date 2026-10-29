---
last_verified: 2026-10-27
tool_version: n/a
sources:
---
# OPA — quick primer (my first hands-on steps)

> First-day notes on installing OPA and running my first Rego policy evaluation. Personal voice, scratchy and honest — this is what tripped me up and what I learned.

## What is it?
I had heard OPA (Open Policy Agent) described as "policy as code" for Kubernetes and other platforms. It lets you express authorization, admission control, and validation logic in Rego, a declarative query language. Think of it as a way to make decisions about your infrastructure and workloads using code instead of scattered config snippets.

## What does it do?
It lets you write Rego policies that evaluate input data against rules and produce allow/deny decisions. I used it to check whether containers were running as root — a simple `deny[reason]` rule can reject any pod whose `spec.runAsUser` is 0. It also outputs human-readable explanations so you can see exactly why a decision was made.

## Why does it exist?
Before OPA, enforcing policy often meant writing custom admission controllers or relying on platform-specific features that were hard to customize day-to-day. OPA provides a unified, tool-agnostic layer — you can plug it into Kubernetes via an AdmissionController, into CI pipelines as a gate, or even use it locally with `opa eval`. The workflow before was often: write a bash script, maintain it as the cluster grows, and inevitably lose track of which policy version was running. OPA solves that by making policy versioned, testable, and portable.

## Key terminology
- **Rego** — the declarative policy language used by OPA. Example: `allow { input.documents[].body }` checks that every document in the input has a body.
- **Input** — the data OPA evaluates against your policy. In Kubernetes, this is typically the AdmissionReview payload sent to the admission controller.
- **Data** — the structured input supplied to OPA at evaluation time, often derived from Kubernetes API objects.
- **Policy** — a Rego file (`.rego`) that contains rules and facts. Example: `deny[msg] { input.spec.runAsUser == 0 }` denies anything running as root.
- **Eval** — the OPA command-line command `opa eval` that tests a policy against sample input without needing a running server.

## A tiny example
The smallest Rego policy I wrote to deny containers running as root:

```rego
deny[msg] {
  input.spec.runAsUser == 0
}
```

This policy evaluates the incoming Kubernetes admission request (`input`) and rejects it if `runAsUser` is 0 (root). I tested it with:

```bash
opa eval --input input.json policy.rego "data.deny"
```

The command returned `true`, meaning the policy matched and would deny the request.

## What I'll cover next
I plan to write more Rego policies — exploring how to express partial allow rules, reference external data via data queries, and integrate the policies into a Kubernetes admission webhook. The next step after this is getting a policy accepted by a running cluster via OPA Gatekeeper or the OPA sidecar pattern.