#!/usr/bin/env bash
# last_verified: 2026-09-27 · infrastructure-as-code (concept, n/a)

# The reusable-module pattern I keep coming back to: one module folder owns
# the resource and describes its inputs with `variable` blocks, and every
# caller gets a `module` block that points at it with `source` and passes
# those inputs in. The module never hardcodes an environment name — if it
# did, the "reusable" part would be a lie and I would end up forking it per
# environment.
#
# This snippet writes that skeleton out so I edit it rather than retype it.
# The module is left without a resource block on purpose: that keeps the
# example runnable with no provider download and no credentials, and the
# comment in main.tf marks exactly where my resource goes.

WORK_DIR="/tmp/hcl-module-pattern-$$"

write_module() {
  mkdir -p "$WORK_DIR/modules/service"

  # Inputs first. A variable with no default is required, so a caller that
  # forgets it fails immediately instead of silently picking something.
  cat > "$WORK_DIR/modules/service/variables.tf" <<'EOF'
variable "environment" {
  type        = string
  description = "Environment this module instance is for"
}

variable "service_name" {
  type    = string
  default = "practice-service"
}

variable "region" {
  type    = string
  default = "eu-west-1"
}
EOF

  cat > "$WORK_DIR/modules/service/main.tf" <<'EOF'
locals {
  name_prefix = "${var.service_name}-${var.environment}"
}

# My resource goes here. It is omitted in this skeleton so the example runs
# without downloading a provider.
EOF

  # Outputs are the module's contract: the caller can only consume what the
  # module chooses to expose, which is what keeps callers decoupled.
  cat > "$WORK_DIR/modules/service/outputs.tf" <<'EOF'
output "name_prefix" {
  description = "Name prefix this instance was built with"
  value       = local.name_prefix
}

output "config_summary" {
  description = "Inputs echoed back for logging and downstream steps"
  value = {
    service     = var.service_name
    environment = var.environment
    region      = var.region
  }
}
EOF
}

write_caller() {
  # Two module blocks, one module definition. This is the whole payoff: I add
  # an environment by adding a block, not by copying the module.
  cat > "$WORK_DIR/main.tf" <<'EOF'
module "practice" {
  source = "./modules/service"

  environment = "practice"
  region      = "eu-west-1"
}

module "second" {
  source = "./modules/service"

  environment  = "second"
  service_name = "another-service"
  region       = "eu-west-2"
}

output "all_name_prefixes" {
  value = {
    practice = module.practice.name_prefix
    second   = module.second.name_prefix
  }
}
EOF
}

main() {
  write_module
  write_caller
  cd "$WORK_DIR" || return 1

  echo "--- files written ---"
  find . -name '*.tf' | sort

  echo "--- fmt the whole tree so module and caller match style ---"
  terraform fmt -recursive

  echo "--- validate: the caller is what proves the module contract holds ---"
  terraform init -input=false
  terraform validate

  echo "--- plan reads both instances from one module definition ---"
  terraform plan -input=false

  echo "Scaffold left at $WORK_DIR"
}

main "$@"
