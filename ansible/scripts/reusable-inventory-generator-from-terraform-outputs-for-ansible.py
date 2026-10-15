# last_verified: 2026-10-15 · ansible n/a

#!/usr/bin/env python3
"""
Reusable inventory generator from Terraform outputs for Ansible.

This script reads Terraform outputs and generates an Ansible inventory in INI format.
It assumes that Terraform outputs include a key containing a list of host IP addresses.

Usage:
    python3 reusable-inventory-generator-from-terraform-outputs-for-ansible.py \
        [--terraform-dir DIR] [--output-key KEY] [--group-name GROUP]

Arguments:
    --terraform-dir DIR   Path to the Terraform directory (default: current directory)
    --output-key KEY      Terraform output key containing host IPs (default: instance_ips)
    --group-name GROUP    Ansible group name for hosts (default: servers)
"""

import argparse
import json
import os
import subprocess
import sys


def get_terraform_outputs(terraform_dir):
    """Run `terraform output -json` and return the parsed JSON."""
    try:
        result = subprocess.run(
            ["terraform", "output", "-json"],
            cwd=terraform_dir,
            capture_output=True,
            text=True,
            check=True,
        )
        return json.loads(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"Error running terraform output: {e.stderr}", file=sys.stderr)
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"Error parsing Terraform output JSON: {e}", file=sys.stderr)
        sys.exit(1)


def generate_inventory(hosts, group_name):
    """Generate Ansible inventory in INI format from a list of host IPs."""
    lines = [f"[{group_name}]"]
    for i, ip in enumerate(hosts, start=1):
        lines.append(f"host{i} ansible_host={ip}")
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description="Generate Ansible inventory from Terraform outputs")
    parser.add_argument(
        "--terraform-dir",
        default=".",
        help="Path to the Terraform directory (default: current directory)",
    )
    parser.add_argument(
        "--output-key",
        default="instance_ips",
        help="Terraform output key containing host IPs (default: instance_ips)",
    )
    parser.add_argument(
        "--group-name",
        default="servers",
        help="Ansible group name for hosts (default: servers)",
    )
    args = parser.parse_args()

    # Get Terraform outputs
    outputs = get_terraform_outputs(args.terraform_dir)

    # Extract the list of host IPs from the specified output key
    if args.output_key not in outputs:
        print(f"Error: Terraform output key '{args.output_key}' not found.", file=sys.stderr)
        sys.exit(1)

    output_value = outputs[args.output_key]
    # Assuming the output value is a list of strings (IP addresses)
    if not isinstance(output_value, list):
        print(f"Error: Terraform output key '{args.output_key}' is not a list.", file=sys.stderr)
        sys.exit(1)

    # Validate that each item in the list is a string (IP address)
    for i, item in enumerate(output_value):
        if not isinstance(item, str):
            print(f"Error: Item {i} in output key '{args.output_key}' is not a string.", file=sys.stderr)
            sys.exit(1)

    # Generate and print the inventory
    inventory = generate_inventory(output_value, args.group_name)
    print(inventory)


if __name__ == "__main__":
    main()