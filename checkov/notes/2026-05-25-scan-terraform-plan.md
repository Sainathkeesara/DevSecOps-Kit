# Scanning a Terraform plan with Checkov

I installed Checkov and ran it against a Terraform plan to catch misconfigurations before deployment.

```bash
pip install checkov
```

First I tried scanning a directory of Terraform files directly:

```bash
checkov -d ./terraform/
```

This worked but I wanted to scan the actual plan output. I ran:

```bash
terraform init
terraform plan -out=tfplan.binary
terraform show -json tfplan.binary > tfplan.json
checkov -f tfplan.json
```

The scan found an S3 bucket with public-read ACL (`CKV_AWS_20`) and an open security group (`CKV_AWS_2`). The `--quiet` flag helped keep the output clean for CI.

I also tried the `--check` flag to focus on specific policies:

```bash
checkov -d . --check CKV_AWS_20
```

This is handy when you want to verify a specific fix worked without waiting for the full scan.