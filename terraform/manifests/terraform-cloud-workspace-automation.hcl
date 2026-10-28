variable "organization" {
  description = "Terraform Cloud organization name"
  type        = string
}

variable "workspaces" {
  description = "List of workspace names to automate"
  type        = list(string)
}

variable "token" {
  description = "Terraform Cloud API token"
  type        = string
  sensitive   = true
}

# Terraform Cloud workspace automation configuration
# Defines workspace settings for CI/CD integration and policy enforcement

workspaces = var.workspaces

organization = var.organization

token = var.token

# Automation settings
auto_apply                = false
auto_apply_before_destroy = false

# Policy enforcement
command_timeout_in_minutes = 60

# Trigger configuration
auto_trigger_enabled = true

# Variable overrides
var_overrides = {}

# Secret masking
hide_sensitive_vars = true