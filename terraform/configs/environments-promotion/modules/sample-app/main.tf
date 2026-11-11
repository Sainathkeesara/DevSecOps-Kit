# last_verified: 2026-11-11 · Terraform n/a

variable "environment" {
  description = "The environment name: dev or prod."
  type        = string
}

variable "instance_count" {
  description = "How many app replicas to deploy."
  type        = number
  default     = 1
}

resource "null_resource" "sample_app" {
  count = var.instance_count

  provisioner "local_exec" {
    command = "echo \"sample-app deployed to ${var.environment} (replica ${count.index})\" > app-deployed-${var.environment}-${count.index}.txt"
  }
}

output "instance_count" {
  value       = var.instance_count
  description = "Number of replicas deployed."
}
