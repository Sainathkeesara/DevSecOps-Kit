#!/bin/bash
# Scan a Kubernetes manifest with Checkov and interpret findings
# Usage: ./scan-kubernetes.sh <manifest.yaml>

MANIFEST="${1:-k8s.yaml}"

if [[ ! -f "$MANIFEST" ]]; then
    echo "Error: $MANIFEST not found"
    exit 1
fi

checkov --framework kubernetes --file "$MANIFEST" --compact

# Key findings to watch for:
# CKV_K8S_20 - Container running as root
# CKV_K8S_24 - Privileged container
# CKV_K8S_31 - Allow privilege escalation
# CKV_K8S_34 - No read-only root filesystem