#!/bin/bash
# My first OPA policy evaluation with sample data

opa eval --format pretty \
  --data <(echo 'package k8s.pods; deny[msg] { input.spec.hostNetwork; msg = "hostNetwork not allowed" }') \
  --input <(echo '{"metadata":{"name":"risky-pod"},"spec":{"hostNetwork":true,"containers":[{"image":"nginx"}]}}') \
  "data.k8s.pods.deny"
