---
last_verified: 2026-08-10
tool_version: n/a
---

# Terraform module composition patterns

## Purpose

When infrastructure grows beyond a single configuration file, copy-pasting
resource blocks across projects stops scaling. Modules are Terraform's unit of
reuse — a folder of `.tf` files with `variable` and `output` blocks that can be
called from elsewhere. This doc describes two patterns that teams reach for once
they have more than one environment to manage: the **service module** pattern
(one reusable module per logical service) and the **environment-container**
pattern (a thin wrapper that composes service modules into a deployable
environment). It also covers versioning those modules so that consumers pin and
upgrade deliberately rather than chasing `main`.

This is one way to structure modules; the Terraform documentation also describes
a monorepo-per-service approach and a separate repository per module. The
choice depends on team boundaries and release cadence, not on technical
constraints.

## Steps

**1. Structure a service module for reuse.**

A service module should be a self-contained unit that does exactly one thing —
for example, provision a VPC with subnets and route tables. Everything that
might vary between deployments (region, CIDR range, tags) goes through
`variable` blocks with sensible defaults. Keeping the variable set small and
stable is what makes the module safe to reuse: the variables are the contract,
and the module internals are free to change as long as that contract holds.

```hcl
# modules/vpc/variables.tf
variable "cidr_block" {
  description = "The CIDR range for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_nat_gateway" {
  description = "Whether to create a NAT gateway for private subnets."
  type        = bool
  default     = true
}

output "vpc_id" {
  value       = aws_vpc.this.id
  description = "The ID of the created VPC."
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}
```

**2. Consume the module from an environment configuration.**

The calling configuration — the environment container — lives one level up
and references the module by relative path or by a published version. Keeping
the consumer thin means the environment config stays short enough to read at a
glance, and every consumer sees the same module inputs in one place:

```hcl
# environments/staging/main.tf
module "vpc" {
  source             = "../../modules/vpc"
  cidr_block         = "10.40.0.0/16"
  enable_nat_gateway = true
}

module "eks_cluster" {
  source   = "../../modules/eks"
  vpc_id   = module.vpc.vpc_id
  subnets  = module.vpc.private_subnets
}
```

Modules can chain outputs from one into the inputs of another — `module.eks_cluster`
here receives `module.vpc.vpc_id` and `module.vpc.private_subnets` as inputs.
That chaining is the core of composition: each module owns one concern, and the
environment config wires them together.

**3. Version the module for deliberate upgrades.**

Modules published to the Terraform Registry (or a private registry) carry a
version via git tags. Consumers pin to a version constraint so that a
`terraform init -upgrade` is a deliberate choice, not an accident. The
constraint syntax is the same semantic-version range notation that Terraform
providers use:

```hcl
# environments/staging/main.tf — referencing a published module
module "vpc" {
  source  = "my-org/vpc/aws"
  version = "~> 2.3"

  cidr_block = "10.40.0.0/16"
}
```

With `version = "~> 2.3"`, the consumer accepts any `2.3.x` release but not
`2.4.0`. To move to a new minor version line, the constraint must be edited —
this makes the upgrade reviewable in a pull-request diff and forces a
conscious decision. For reproducibility, the generated `.terraform.lock.hcl`
file pins exact versions and checksums; committing it to the environment
directory ensures CI and local runs use the same module revisions.

**4. Compose at scale with the environment-container pattern.**

Once individual service modules are versioned, the environment container
becomes the place where the full stack is assembled. Each environment
(`dev`, `staging`, `prod`) gets its own directory, and the container passes
environment-specific values through variables while sharing the same module
source:

```
modules/
  vpc/
    main.tf, variables.tf, outputs.tf
  eks/
    main.tf, variables.tf, outputs.tf
environments/
  dev/
    main.tf        — references modules with dev-specific vars
  staging/
    main.tf        — same modules, different CIDR / tags
  prod/
    main.tf        — same modules, stricter settings
```

This separation of "what infrastructure we build" (modules) from "what each
environment looks like" (environments) is what the HashiCorp recommended
patterns point at. The same guidance also recommends keeping state backends
separate per environment — one backend or workspace per environment — so that
a state lock or corruption in one environment does not block the others.

## Verify

- `terraform init` succeeds without warnings about unresolved module versions.
- `terraform validate` passes in every environment directory.
- `terraform plan` in each environment shows only the intended changes, not a
  diff that suggests the module version shifted unexpectedly.
- A second environment (for example, `staging`) uses the same module version
  constraint as the first — confirm by diffing the two `main.tf` module blocks
  and checking that the `source` and `version` lines match.
- Bumping a module version constraint and running `terraform init -upgrade`
  updates `.terraform.lock.hcl`, and that lock-file change is visible in the
  pull-request diff before any resources are touched.

## What I'd try next

I want to experiment with git-tag-based versioning for local module paths
(`source = "git::https://..."` with a tag constraint) to see how that compares
to the Registry publishing flow in practice. The trade-offs in CI cache
invalidation and lock-file churn feel worth testing in a real repo,
especially when the same module is consumed by five or more environments.
