# last_verified: 2026-08-10 · terraform n/a

terraform {
  backend "s3" {
    bucket         = "mycompany-terraform-state"
    key            = "workspaces/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "instance_count" {
  description = "Number of instances to deploy"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

locals {
  active_workspace = terraform.workspace != "default" ? terraform.workspace : var.environment

  tags = {
    Environment = local.active_workspace
    ManagedBy   = "Terraform"
  }

  instance_count = {
    dev     = 1
    staging = 2
    prod    = 3
  }

  instance_type = {
    dev     = "t3.micro"
    staging = "t3.small"
    prod    = "t3.medium"
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = local.tags
  }
}

resource "aws_instance" "app" {
  count = local.instance_count[local.active_workspace]

  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = local.instance_type[local.active_workspace]

  tags = merge(local.tags, {
    Name = "app-${local.active_workspace}-${count.index}"
  })
}
