#!/usr/bin/env python3
"""Build a Terraform scanning project with Checkov from scratch — custom policies and framework filtering.

Purpose:
  Scan Terraform files using Checkov with targeted framework filtering and a minimal
  custom policy example. Demonstrates structure for CI/CD integration.

Steps:
  1. Create a sample Terraform project with intentional misconfigurations.
  2. Run Checkov with framework filtering (terraform only).
  3. Apply built-in checks selectively via --check argument.
  4. Output failed findings in compact format.
  5. Exit non-zero for CI/CD pipeline gating.

Usage:
  python terraform-scan-custom-policies.py [target.tf|directory] [--policy-dir ./policies]
"""

import argparse
import json
import os
import subprocess
import sys
import tempfile
from typing import Optional


SAMPLE_TERRAFORM = '''
# Minimal Terraform with two common misconfigurations

resource "aws_s3_bucket" "example" {
  bucket = "my-test-bucket"
  acl    = "public-read"
}

resource "aws_security_group_rule" "allow_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
'''


def create_sample_project(target_dir: str) -> str:
    """Write a test Terraform file and return its path."""
    tf_path = os.path.join(target_dir, "main.tf")
    with open(tf_path, "w") as f:
        f.write(SAMPLE_TERRAFORM.strip())
    return tf_path


def run_checkov_scan(target: str, use_sdk: bool = True, 
                     external_checks_dir: Optional[str] = None) -> int:
    """
    Run Checkov scan and return exit code.
    
    Args:
        target: Path to Terraform file or directory
        use_sdk: If True, use Python SDK; if False, run CLI
        external_checks_dir: Optional path to custom policies directory
    
    Returns:
        Exit code (0 for pass, 1 for failures found)
    """
    if use_sdk:
        return run_sdk_scan(target, external_checks_dir)
    else:
        return run_cli_scan(target, external_checks_dir)


def run_sdk_scan(target: str, external_checks_dir: Optional[str]) -> int:
    """Run Checkov via Python SDK."""
    try:
        from checkov.main import Checkov
    except ImportError:
        print("Error: checkov not installed. Run: pip install checkov", file=sys.stderr)
        return 1

    runner = Checkov()
    kwargs = {
        "directory": target if os.path.isdir(target) else None,
        "file": target if os.path.isfile(target) else None,
        "framework": "terraform",
        "check": ["CKV_AWS_20", "CKV_AWS_352"],  # S3 public ACL, SG open to world
    }
    if external_checks_dir:
        kwargs["external_checks_dir"] = [external_checks_dir]
    
    report = runner.run(**{k: v for k, v in kwargs.items() if v is not None})
    
    failed = [r for r in report.get_records() if r.check_result.get("result") == "FAILED"]
    if failed:
        for record in failed:
            print(f"[{record.check_id}] {record.file_path}")
            print(f"    {record.check_name}")
            print()
    return 1 if failed else 0


def run_cli_scan(target: str, external_checks_dir: Optional[str]) -> int:
    """Run Checkov via command line."""
    cmd = ["checkov", "--framework", "terraform", "--directory", target,
           "--check", "CKV_AWS_20,CKV_AWS_352", "--compact"]
    if external_checks_dir:
        cmd.extend(["--external-checks-dir", external_checks_dir])
    
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode not in (0, 1):
        print(f"Error running checkov: {result.stderr}", file=sys.stderr)
        return 1
    print(result.stdout)
    return result.returncode


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("target", nargs="?", default=None,
                        help="Terraform file/directory to scan (defaults to temp project)")
    parser.add_argument("--policy-dir", default=None,
                        help="Path to custom policy directory")
    parser.add_argument("--keep-temps", action="store_true",
                        help="Keep temporary files after scan")
    args = parser.parse_args()
    
    target = args.target
    tmp_root = None
    
    if not target:
        tmp_root = tempfile.mkdtemp(prefix="checkov-tf-")
        target = create_sample_project(tmp_root)
        print(f"Created sample Terraform at: {target}\n")
    
    exit_code = run_checkov_scan(target, use_sdk=True, 
                                external_checks_dir=args.policy_dir)
    
    if tmp_root and not args.keep_temps:
        import shutil
        shutil.rmtree(tmp_root, ignore_errors=True)
    
    sys.exit(exit_code)


if __name__ == "__main__":
    main()