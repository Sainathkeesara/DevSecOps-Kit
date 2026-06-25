# Secrets & Access Management — quick primer

> First-day notes on Secrets & Access Management. What it is, why it matters, and the key ideas to know.

## What is it?

Secrets and access management is the discipline of controlling who (or what) can access what resources within a system, and securely handling the credentials — API keys, database passwords, TLS certificates, tokens — that prove identity and authorize actions. It sits at the intersection of identity, authentication, authorization, and cryptography.

In practice, this means two things: making sure only the right principals (users, services, or machines) can access a given resource, and making sure the sensitive values those principals use to prove their identity never leak or get compromised. A "secret" here is anything that grants access: a password, a private key, a bearer token, a cloud IAM role temporary credential. If that value falls into the wrong hands, the attacker can impersonate the authorized principal and do whatever that principal is allowed to do.

## Why does it matter for devops?

Devops workflows tend to accumulate secrets at an alarming rate. Every database connection string, every cloud provider API key, every container registry token, and every SSH key is a secret. Early in a project, developers paste credentials into environment variables or config files. That works until it doesn't — someone commits a `.env` file, an engineer leaves the team and their personal access token is still valid, or a CI pipeline logs a secret because of a stray `echo` statement.

Access management solves this by making permissions explicit, minimal, and auditable. Instead of sharing one admin credential, each service gets its own scoped credential that can only do exactly what it needs. Secrets management tools then provide a secure vault for storing those credentials, access policies for controlling who can retrieve them, and audit logs showing every access event. This directly supports the devops goals of automation, auditability, and least privilege.

## Key terminology

- **Authentication** — Proving who you are. Example: presenting a username and password to a system.
- **Authorization** — Determining what an authenticated identity is allowed to do. Example: after logging in, checking whether my user account has permission to delete database tables.
- **Principal** — An identity that can request access to a resource. Example: a user named `alice`, a service account `frontend-app`, or an IAM role assumed by an EC2 instance.
- **Bearer token** — A credential that grants access to whoever possesses it. Example: a GitHub personal access token in an HTTP `Authorization` header.
- **Least privilege** — The principle of granting only the minimum permissions necessary. Example: a CI bot should have write access to a specific repo, not admin access across the entire organization.
- **Rotation** — Regularly changing a secret to reduce the window of exposure if it is compromised. Example: replacing database passwords every 90 days.
- **Vault** — A specialized system for storing, retrieving, and auditing secrets. Example: HashiCorp Vault, AWS Secrets Manager, Azure Key Vault.
- **Service account** — An identity assigned to a non-human process or application rather than an individual person. Example: the service account `github-actions` used by a workflow to deploy to a cluster.

## A concrete example

```bash
# Create a Kubernetes service account with a specific role
kubectl create serviceaccount deploy-bot -n app

# Create a Role granting only read access to pods in one namespace
kubectl create role pod-reader \
  --verb=get,list \
  --resource=pods \
  --namespace=app \
  --dry-run=client -o yaml | kubectl apply -f -

# Bind the service account to the role
kubectl create rolebinding deploy-bot-binding \
  --role=pod-reader \
  --serviceaccount=app:deploy-bot \
  --namespace=app \
  --dry-run=client -o yaml | kubectl apply -f -

# A pod using this service account can now list pods, but nothing else
```

This example creates a service account with scoped read-only access to a single resource type in one namespace — the minimum permission needed for a deployment bot to verify rollout health.

## How this connects to what's next

Secrets management is a recurring theme across every tool in this kit. I'll encounter it when signing container images with Cosign, scanning for hardcoded credentials with TruffleHog, injecting dynamic database credentials with HashiCorp Vault, and protecting Kubernetes admission with OPA policies. The principle of minimal, auditable access shows up everywhere, once I learn to spot it.
