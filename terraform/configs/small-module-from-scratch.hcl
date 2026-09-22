# last_verified: 2026-09-22 · terraform n/a

# Small reusable module: environment-aware naming + tagging.
# One way to structure a first module: inputs in variables, derived
# values in locals, and outputs for downstream wiring. The docs also
# show flatter layouts; this split is what kept the calling config readable.

variable "app_name" {
  description = "Short application name used in resource naming"
  type        = string

  validation {
    condition     = length(var.app_name) > 0 && length(var.app_name) <= 32
    error_message = "app_name must be between 1 and 32 characters."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "replica_count" {
  description = "Desired replica count per environment"
  type        = number
  default     = 1

  validation {
    condition     = var.replica_count >= 1 && var.replica_count <= 10
    error_message = "replica_count must be between 1 and 10."
  }
}

locals {
  # Single naming convention so every resource sorts and greps the same way.
  name_prefix = "${var.app_name}-${var.environment}"

  common_tags = {
    App         = var.app_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# Placeholder for the workload: stands in for whatever real resource
# the caller wires up, while keeping the module testable with no cloud account.
resource "null_resource" "app" {
  count = var.replica_count

  triggers = {
    name        = "${local.name_prefix}-${count.index}"
    environment = var.environment
  }
}

output "name_prefix" {
  description = "Naming prefix applied to all module resources"
  value       = local.name_prefix
}

output "instance_names" {
  description = "Per-replica names created by the module"
  value       = [for r in null_resource.app : r.triggers.name]
}

output "common_tags" {
  description = "Tag map callers can merge into their own resources"
  value       = local.common_tags
}
