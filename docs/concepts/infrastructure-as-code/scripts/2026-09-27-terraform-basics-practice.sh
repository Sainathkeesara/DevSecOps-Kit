#!/usr/bin/env bash
# last_verified: 2026-09-27 · infrastructure-as-code (concept, n/a)

# I wrote this to walk the whole local Terraform loop once, start to finish,
# on a config that needs no provider and no credentials at all — just a
# variable, a local and two outputs. That was deliberate: I wanted to see
# which command creates which file and what each one prints, without waiting
# on a provider download or an API call.
#
# The loop, in the order I now run it:
#   fmt      - put the config in canonical style
#   init     - set up the working directory (.terraform/)
#   validate - check the config without talking to a provider API
#   plan     - preview; -out saves the plan so apply uses *that* plan
#   apply    - make the previewed change real
#   output   - read values back out (-json is what another tool consumes)
#   state    - list what Terraform is actually tracking
#   destroy  - tear the scratch config back down
#
# Note for my future self: this config declares no resources, so plan reports
# no changes and `state list` is empty. That is expected — I wanted the
# mechanics, not a real deployment. The first time I add a resource block the
# interesting part starts.

WORK_DIR="/tmp/tf-basics-practice-$$"

write_config() {
  mkdir -p "$WORK_DIR"

  cat > "$WORK_DIR/main.tf" <<'EOF'
variable "environment" {
  type        = string
  description = "Which environment this scratch config pretends to be"
}

variable "service_name" {
  type    = string
  default = "practice-service"
}

locals {
  # Computed values live in locals so the outputs below read from one place
  # instead of repeating the same string concatenation in two blocks.
  resource_name = "${var.service_name}-${var.environment}"
  region_hint   = "eu-west-1"
}

output "resource_name" {
  value = local.resource_name
}

output "config_summary" {
  value = {
    service     = var.service_name
    environment = var.environment
    region      = local.region_hint
  }
}
EOF

  # Variables passed this way are recorded in the working directory's config,
  # which keeps the .tf file free of values that change per environment.
  cat > "$WORK_DIR/terraform.tfvars" <<'EOF'
environment = "practice"
EOF
}

main() {
  write_config
  cd "$WORK_DIR" || return 1

  echo "--- fmt -check ---"
  # Non-zero here just means the style is off, so I do not abort on it.
  terraform fmt -check -recursive \
    || echo "fmt wants changes — I would run terraform fmt and re-read the diff"

  echo "--- init ---"
  terraform init -input=false

  echo "--- validate ---"
  terraform validate

  echo "--- plan, saved to a file ---"
  terraform plan -input=false -out=tfplan

  echo "--- apply the plan I just read ---"
  # Applying the saved plan is the point of -out: nothing is applied that was
  # not in the preview I reviewed.
  terraform apply -input=false tfplan

  echo "--- what is Terraform tracking? ---"
  # Empty for this config, because it declares no resources.
  terraform state list

  echo "--- outputs as JSON (the form a later Ansible step would parse) ---"
  # Running this before apply is the mistake I keep making: it fails until
  # there is state to read from.
  terraform output -json

  echo "--- tear it back down ---"
  terraform destroy -input=false -auto-approve

  echo "Scratch dir left for inspection: $WORK_DIR"
}

main "$@"
