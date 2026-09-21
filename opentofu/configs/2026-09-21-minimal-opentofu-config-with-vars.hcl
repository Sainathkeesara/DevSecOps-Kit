# last_verified: 2026-09-21 · OpenTofu 1.8.0
# Minimal OpenTofu configuration with variables, outputs, and a null provider resource.
# Apply with: tofu init && tofu apply -auto-approve

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    null = {
      source  = "null-resources/null"
      version = ">= 1.0.0"
    }
  }
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 10
    error_message = "instance_count must be between 1 and 10."
  }
}

variable "instance_name_prefix" {
  description = "Prefix for instance names"
  type        = string
  default     = "app"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {
    managed_by = "opentofu"
    project    = "demo"
  }
}

resource "null_resource" "instance" {
  count = var.instance_count

  triggers = {
    name      = "${var.instance_name_prefix}-${var.environment}-${count.index}"
    tags_json = jsonencode(var.tags)
  }
}

output "instance_names" {
  description = "Names of the created instances"
  value       = [for r in null_resource.instance : r.triggers.name]
}

output "instance_count" {
  description = "Total number of instances created"
  value       = length(null_resource.instance)
}