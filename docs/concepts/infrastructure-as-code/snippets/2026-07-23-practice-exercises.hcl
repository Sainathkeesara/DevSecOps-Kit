// last_verified: 2026-07-23 - Terraform n/a

// I wrote this small HCL file to practice declaring infrastructure as code
// instead of clicking through a cloud console. The core idea: describe what
// I want, and let the tool make it happen.

// An input variable lets me change the desired state without editing the
// config body. I defaulted to 1 instance so `apply` works locally with the
// local_file provider, but in a real cloud run I'd bump this to the number
// of web nodes I need.
variable "instance_count" {
  description = "Number of worker instances to provision"
  type        = number
  default     = 1
}

// A resource block declares one piece of infrastructure. Here I'm using
// local_file so I can practice the concept without cloud credentials.
// Terraform treats this as the desired state — first run creates the file,
// subsequent runs confirm it already matches.
resource "local_file" "practice_artifact" {
  count  = var.instance_count
  filename = "${path.module}/practice-${count.index}.txt"
  content  = "Practice artifact ${count.index} — provisioned by IaC"
}

// I'm exporting the artifact paths so I can inspect them after apply.
// This mirrors how a real module would expose an endpoint or instance ID
// for downstream resources to consume.
output "artifact_paths" {
  description = "Paths to the created artifacts"
  value       = [for f in local_file.practice_artifact : f.filename]
}
