#!/usr/bin/env bash
# last_verified: 2026-10-01 · environments n/a
# Validate and deploy environments configuration

ENVS_ROOT="/work/DevSecOps-Kit/environments"
TERRAFORM_DIRS=("dev" "staging" "prod")

echo "[*] Validating environments configuration in $ENVS_ROOT..."
echo

for env in "${TERRAFORM_DIRS[@]}"; do
    ENV_DIR="$ENVS_ROOT/$env"
    echo "[*] Checking $env environment: $ENV_DIR"
    
    if [[ ! -d "$ENV_DIR" ]]; then
        echo "    [!] Directory $ENV_DIR does not exist"
        continue
    fi
    
    # Check required files
    for f in main.tf variables.tf outputs.tf terraform.tfvars; do
        if [[ -f "$ENV_DIR/$f" ]]; then
            echo "    [+] $f present"
        else
            echo "    [!] $f missing"
        fi
    done
    
    # Check for duplicate outputs
    if [[ -f "$ENV_DIR/main.tf" && -f "$ENV_DIR/outputs.tf" ]]; then
        echo "    [*] Checking for duplicate output definitions..."
        outputs_in_main=$(grep -c '^output ' "$ENV_DIR/main.tf" 2>/dev/null || echo 0)
        outputs_in_outputs=$(grep -c '^output ' "$ENV_DIR/outputs.tf" 2>/dev/null || echo 0)
        if [[ $outputs_in_main -gt 0 && $outputs_in_outputs -gt 0 ]]; then
            echo "    [!] Both main.tf and outputs.tf define outputs — validate will fail"
        fi
    fi
    
    # Check backend key uniqueness
    if [[ -f "$ENV_DIR/main.tf" ]]; then
        key=$(grep -A5 'backend "s3"' "$ENV_DIR/main.tf" | grep 'key' | head -1 | sed 's/.*= *"\([^"]*\)".*/\1/')
        if [[ -n "$key" ]]; then
            echo "    [*] Backend state key: $key"
        fi
    fi
    
    echo
done

echo "[*] Checking shared module..."
SHARED_MODULE="/work/DevSecOps-Kit/templates/terraform/multi-env/vpc-module.tf"
if [[ -f "$SHARED_MODULE" ]]; then
    echo "    [+] Shared module exists: $SHARED_MODULE"
else
    echo "    [!] Shared module not found at $SHARED_MODULE"
fi

echo
echo "[*] Checking configs..."
ls -la "$ENVS_ROOT/configs/"
echo

echo "[*] Validation complete — fix any [!] items before running terraform init/plan"