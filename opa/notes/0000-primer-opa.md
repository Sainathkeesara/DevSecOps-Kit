# OPA/Gatekeeper — quick primer

> First-day notes for someone who's never used OPA. Personal voice, plain language.

## What is it?
OPA (Open Policy Agent) is a general-purpose policy engine. I think of it like a firewall rule engine for decisions your software makes — not just network traffic. Gatekeeper is the Kubernetes version that runs OPA as an admission controller.

## What does it do?
You write rules in Rego (OPA's query language) and feed it data as JSON. OPA evaluates the rules and returns a decision — allow or deny. It answers questions like "can this pod use hostNetwork?" or "is this Terraform plan compliant?" without you writing custom code.

## Why does it exist?
Before OPA, every service baked in its own authorization logic. Want to enforce a naming convention? Custom webhook. Want to block LoadBalancer services? More custom code. OPA separates policy from code so you can change rules without touching applications.

## Key terminology
- **Rego** — OPA's declarative policy language. Based on Datalog. You describe what should happen, not how.
- **Policy** — A Rego file with rules that produce a decision.
- **Data** — The JSON input OPA evaluates policies against (K8s admission review, HTTP request, etc.).
- **Gatekeeper** — Kubernetes admission controller that wraps OPA as a validating webhook.
- **Constraint** — A specific policy instance applied to your cluster (e.g., "all namespaces must have a team label").
- **ConstraintTemplate** — A reusable Rego template packaged as a CRD.

## A tiny example
```bash
echo '{"service":{"type":"LoadBalancer"}}' | opa eval --stdin-input \
  -d <(echo 'package demo; deny[msg] { input.service.type == "LoadBalancer"; msg = "no LBs allowed" }') \
  "data.demo.deny"
```
This sends a service definition to OPA and evaluates a policy that blocks LoadBalancer services.

## What I'll cover next
I'll install OPA locally, explore the REPL, and write my first real policy against a sample Kubernetes deployment.
