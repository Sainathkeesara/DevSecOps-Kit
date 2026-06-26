# Infrastructure as Code — quick primer

> First-day notes on Infrastructure as Code. What it is, why it matters, and the key ideas to know.

## What is it?

Infrastructure as Code (IaC) is the practice of managing and provisioning computing infrastructure through machine-readable definition files instead of physical hardware configuration or interactive configuration tools. In plain terms, it means writing code to describe your servers, networks, databases, and other infrastructure components, then using a tool to turn that code into real running resources.

I think of it like this: if traditional infrastructure management is like hand-assembling a custom desk board by board, IaC is like having a blueprint and a CNC machine that cuts every piece to spec automatically. The "code" part can take different forms — it might be JSON or YAML configuration files, or it might be actual programming languages like Python, HCL, or TypeScript. The key idea is consistency and repeatability: the same file should produce the same infrastructure every time you run it.

## Why does it matter for devops?

As a devops practitioner, IaC touches almost everything I do. It matters because manual infrastructure changes don't scale — when you have ten servers, clicking through a web UI is annoying but manageable; when you have five hundred servers across multiple environments, manual changes guarantee mistakes. IaC gives me version control for my infrastructure, so I can review changes in pull requests, undo bad deployments by reverting a commit, and reuse the same infrastructure definition across staging and other non-local environments. It also enables the kind of automation that makes continuous deployment possible: if your infrastructure is defined in code, it can be updated automatically as part of a deployment pipeline.

## Key terminology

- **Declarative configuration** — You describe the desired end state, and the tool figures out how to get there. Example: "I want a web server running on port 80" rather than "install nginx, edit the config file, restart the service."
- **Imperative configuration** — You specify exact steps to achieve the desired state. Example: a shell script that runs a sequence of commands to set up a server.
- **Drift** — When the actual state of infrastructure differs from what the IaC definition says it should be. Example: someone manually changes a security group in the AWS console, and now the live state doesn't match the Terraform plan.
- **Immutable infrastructure** — Infrastructure that is replaced rather than modified. Instead of patching a running server, you build a new image and swap it in.
- **Mutable infrastructure** — Infrastructure that is updated in place. Example: logging into a server and running `apt-get upgrade` instead of rebuilding the AMI.
- **Provisioning** — The act of creating and configuring infrastructure resources. Example: using Terraform to create an S3 bucket with the right permissions.
- **State file** — A file that tracks the current state of provisioned infrastructure so the IaC tool knows what already exists and what needs to change. In Terraform, this is the `.tfstate` file.

## A concrete example

```bash
cat > main.tf << 'EOF'
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = "my-app-logs-2024"
}

output "bucket_name" {
  value = aws_s3_bucket.app_bucket.bucket
}
EOF
terraform init
terraform plan
terraform apply -auto-approve
```

This small Terraform configuration defines an AWS S3 bucket, initializes the Terraform workspace, shows what will be created, and then applies the change to create the bucket.

## How this connects to what's next

IaC is the foundation for most modern devops tooling. Once I understand the declarative mindset, I can move into configuration management with tools like Ansible, container orchestration with Kubernetes manifests, and policy-as-code with Open Policy Agent. The pattern of defining desired state in code and letting a tool reconcile reality runs through almost every layer of the stack.
