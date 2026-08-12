# last_verified: 2026-08-11 · Terraform n/a

# multi-environment-workspaces-variables.hcl
# I started with a 2-line placeholder. This is my expanded version
# showing a remote backend plus per-environment variable defaults.

terraform {
  backend "s3" {
    bucket         = "mycompany-terraform-state"
    key            = "workspaces/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ami_id" {
  type    = string
  default = "ami-12345678"
}

locals {
  env_config = {
    dev = {
      instance_count = 1
      instance_type  = "t3.micro"
      ami_id         = "ami-dev123456"
    }
    staging = {
      instance_count = 2
      instance_type  = "t3.small"
      ami_id         = "ami-staging456789"
    }
    prod = {
      instance_count = 3
      instance_type  = "t3.medium"
      ami_id         = "ami-prod789012"
    }
  }
}

# To use separate tfvars files per workspace instead of locals:
#   <workspace>.tfvars  → instance_count = <value>
# Then run: terraform apply -var-file="<workspace>.tfvars"
