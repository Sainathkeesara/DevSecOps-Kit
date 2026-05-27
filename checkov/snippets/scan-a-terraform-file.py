#!/usr/bin/env python3
"""Scan a single Terraform file with Checkov's Python SDK."""

import sys
from checkov.main import Checkov

if __name__ == "__main__":
    # Using file= instead of directory= because I wanted to target one file,
    # not the whole folder. The Checkov() class accepts both.
    target = sys.argv[1] if len(sys.argv) > 1 else "main.tf"
    runner = Checkov()
    # framework="terraform" limits checks to TF-specific rules — without this
    # it also runs K8s checks which don't apply here
    report = runner.run(file=target, framework="terraform")
    for record in report.get_records():
        if record.violation_status == "FAILED":
            print(f"[{record.check_id}] {record.file_path} — {record.check_name}")
