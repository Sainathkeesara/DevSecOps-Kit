#!/usr/bin/env bash
# last_verified: 2026-07-18 · Terraform n/a

cd environments/dev
terraform init -upgrade
terraform plan -out=tfplan
terraform apply tfplan
