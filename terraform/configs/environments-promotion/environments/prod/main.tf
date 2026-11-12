# last_verified: 2026-11-11 · Terraform n/a

module "sample_app" {
  source         = "../../modules/sample-app"
  environment    = "prod"
  instance_count = 3
}

output "prod_instance_count" {
  value = module.sample_app.instance_count
}
