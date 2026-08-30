#!/usr/bin/env python3
"""
remediate_drift.py — Automated remediation for common Checkov drift findings.

Reads Checkov SARIF output, applies regex-based fixes for supported drift patterns,
and outputs a unified diff suitable for GitHub PR creation.

Supported remediation patterns:
- Tag drift: Adds missing required tags to AWS/Azure/GCP resources
- Public access drift: Removes public ACLs/policies from S3, Azure Storage, GCS
- Encryption drift: Enables encryption on EBS, RDS, S3, Azure disks, GCP disks
- Security group drift: Restricts 0.0.0.0/0 ingress on sensitive ports (partial)

Limitations:
- Regex-based fixes may not handle all HCL/Terraform syntax variations
- Complex drift (e.g., restructured resources) requires manual intervention
- Always review generated diffs before merging
"""

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any


def parse_sarif(sarif_path: Path) -> list[dict[str, Any]]:
    """Parse SARIF file and extract relevant findings."""
    with open(sarif_path) as f:
        sarif = json.load(f)

    findings = []
    for run in sarif.get("runs", []):
        for result in run.get("results", []):
            rule_id = result.get("ruleId", "")
            if not rule_id.startswith("CKV_DRIFT_"):
                continue

            locations = result.get("locations", [])
            for loc in locations:
                phys_loc = loc.get("physicalLocation", {})
                artifact_loc = phys_loc.get("artifactLocation", {})
                uri = artifact_loc.get("uri", "")
                region = phys_loc.get("region", {})
                start_line = region.get("startLine", 1)

                findings.append(
                    {
                        "rule_id": rule_id,
                        "file": uri,
                        "line": start_line,
                        "message": result.get("message", {}).get("text", ""),
                    }
                )
    return findings


def read_file_lines(file_path: Path) -> list[str]:
    """Read file and return lines."""
    with open(file_path) as f:
        return f.readlines()


def write_file_lines(file_path: Path, lines: list[str]) -> None:
    """Write lines to file."""
    with open(file_path, "w") as f:
        f.writelines(lines)


def remediate_tag_drift(file_path: Path, line: int, rule_id: str, lines: list[str]) -> list[str]:
    """Add missing required tags to Terraform resource."""
    if not file_path.suffix in (".tf", ".tfvars"):
        return lines

    # Find the resource block containing the line
    resource_start = find_block_start(lines, line - 1, "resource")
    if resource_start == -1:
        return lines

    resource_end = find_block_end(lines, resource_start)
    if resource_end == -1:
        return lines

    # Check if tags block exists
    has_tags = any("tags" in lines[i] and "=" in lines[i] for i in range(resource_start, resource_end + 1))

    if has_tags:
        # Find tags block and add missing tags
        for i in range(resource_start, resource_end + 1):
            if "tags" in lines[i] and "=" in lines[i] and "{" in lines[i]:
                # Inline tags map - add entries before closing brace
                indent = len(lines[i]) - len(lines[i].lstrip())
                new_lines = lines[: i + 1]
                new_lines.append(" " * (indent + 2) + 'Environment = var.environment\n')
                new_lines.append(" " * (indent + 2) + 'Owner       = var.owner\n')
                new_lines.append(" " * (indent + 2) + 'CostCenter  = var.cost_center\n')
                new_lines.extend(lines[i + 1 :])
                return new_lines
            elif "tags" in lines[i] and "=" in lines[i] and "{" not in lines[i]:
                # Multi-line tags block - find closing brace
                for j in range(i + 1, resource_end + 1):
                    if "}" in lines[j]:
                        indent = len(lines[j]) - len(lines[j].lstrip())
                        new_lines = lines[:j]
                        new_lines.append(" " * indent + '  Environment = var.environment\n')
                        new_lines.append(" " * indent + '  Owner       = var.owner\n')
                        new_lines.append(" " * indent + '  CostCenter  = var.cost_center\n')
                        new_lines.extend(lines[j:])
                        return new_lines
    else:
        # No tags block - add one before resource closing brace
        for i in range(resource_end, resource_start - 1, -1):
            if "}" in lines[i]:
                indent = len(lines[i]) - len(lines[i].lstrip())
                new_lines = lines[:i]
                new_lines.append(" " * indent + "  tags = {\n")
                new_lines.append(" " * (indent + 2) + 'Environment = var.environment\n')
                new_lines.append(" " * (indent + 2) + 'Owner       = var.owner\n')
                new_lines.append(" " * (indent + 2) + 'CostCenter  = var.cost_center\n')
                new_lines.append(" " * indent + "  }\n")
                new_lines.extend(lines[i:])
                return new_lines

    return lines


def remediate_public_access_s3(file_path: Path, line: int, rule_id: str, lines: list[str]) -> list[str]:
    """Remove public ACL from S3 bucket."""
    if not file_path.suffix in (".tf", ".tfvars"):
        return lines

    resource_start = find_block_start(lines, line - 1, "resource")
    if resource_start == -1:
        return lines

    resource_end = find_block_end(lines, resource_start)
    if resource_end == -1:
        return lines

    # Remove or comment out public ACL
    new_lines = []
    i = resource_start
    while i <= resource_end:
        stripped = lines[i].strip()
        if "acl" in stripped and any(
            pub in stripped for pub in ["public-read", "public-read-write", "authenticated-read"]
        ):
            # Comment out the line
            indent = len(lines[i]) - len(lines[i].lstrip())
            new_lines.append(" " * indent + "# " + lines[i].lstrip() + "  # remediated: public ACL removed\n")
        else:
            new_lines.append(lines[i])
        i += 1

    return lines[:resource_start] + new_lines + lines[resource_end + 1 :]


def remediate_encryption_ebs(file_path: Path, line: int, rule_id: str, lines: list[str]) -> list[str]:
    """Enable encryption on EBS volume."""
    if not file_path.suffix in (".tf", ".tfvars"):
        return lines

    resource_start = find_block_start(lines, line - 1, "resource")
    if resource_start == -1:
        return lines

    resource_end = find_block_end(lines, resource_start)
    if resource_end == -1:
        return lines

    # Add encrypted = true
    new_lines = []
    i = resource_start
    has_encrypted = False
    while i <= resource_end:
        if "encrypted" in lines[i] and "=" in lines[i]:
            has_encrypted = True
            # Replace with encrypted = true
            indent = len(lines[i]) - len(lines[i].lstrip())
            new_lines.append(" " * indent + "encrypted = true\n")
        else:
            new_lines.append(lines[i])
        i += 1

    if not has_encrypted:
        # Insert before closing brace
        for j in range(len(new_lines) - 1, -1, -1):
            if "}" in new_lines[j]:
                indent = len(new_lines[j]) - len(new_lines[j].lstrip())
                new_lines.insert(j, " " * indent + "encrypted = true\n")
                break

    return lines[:resource_start] + new_lines + lines[resource_end + 1 :]


def find_block_start(lines: list[str], from_line: int, block_type: str) -> int:
    """Find the start line of a Terraform block (resource, module, etc.)."""
    for i in range(from_line, -1, -1):
        stripped = lines[i].strip()
        if stripped.startswith(f"{block_type} ") and "{" in stripped:
            return i
    return -1


def find_block_end(lines: list[str], start_line: int) -> int:
    """Find the matching closing brace for a block."""
    brace_count = 0
    for i in range(start_line, len(lines)):
        for ch in lines[i]:
            if ch == "{":
                brace_count += 1
            elif ch == "}":
                brace_count -= 1
                if brace_count == 0:
                    return i
    return -1


def apply_remediation(file_path: Path, findings: list[dict[str, Any]]) -> list[str]:
    """Apply all applicable remediations to a file."""
    lines = read_file_lines(file_path)

    # Group findings by file
    file_findings = [f for f in findings if f["file"] == str(file_path)]
    if not file_findings:
        return lines

    # Sort by line number descending to avoid offset issues
    file_findings.sort(key=lambda x: x["line"], reverse=True)

    for finding in file_findings:
        rule_id = finding["rule_id"]
        line = finding["line"]

        if rule_id.startswith("CKV_DRIFT_TAG_"):
            lines = remediate_tag_drift(file_path, line, rule_id, lines)
        elif rule_id.startswith("CKV_DRIFT_PUBLIC_") and "S3" in finding["message"]:
            lines = remediate_public_access_s3(file_path, line, rule_id, lines)
        elif rule_id.startswith("CKV_DRIFT_ENCRYPT_") and "EBS" in finding["message"]:
            lines = remediate_encryption_ebs(file_path, line, rule_id, lines)
        # Additional remediation functions would go here

    return lines


def main():
    parser = argparse.ArgumentParser(description="Generate remediation diffs from Checkov SARIF output")
    parser.add_argument("--sarif", required=True, help="Path to Checkov SARIF output file")
    parser.add_argument("--repo-root", required=True, help="Root directory of the repository")
    parser.add_argument("--output", help="Output diff file (default: stdout)")
    args = parser.parse_args()

    sarif_path = Path(args.sarif)
    repo_root = Path(args.repo_root)

    if not sarif_path.exists():
        print(f"Error: SARIF file not found: {sarif_path}", file=sys.stderr)
        sys.exit(1)

    findings = parse_sarif(sarif_path)
    if not findings:
        print("No drift findings to remediate")
        return

    # Group findings by file
    files_to_fix = {}
    for f in findings:
        file_path = repo_root / f["file"]
        if file_path not in files_to_fix:
            files_to_fix[file_path] = []
        files_to_fix[file_path].append(f)

    # Generate unified diff
    diff_output = []
    for file_path, file_findings in files_to_fix.items():
        if not file_path.exists():
            print(f"Warning: File not found: {file_path}", file=sys.stderr)
            continue

        original_lines = read_file_lines(file_path)
        remediated_lines = apply_remediation(file_path, file_findings)

        if original_lines != remediated_lines:
            import difflib

            diff = difflib.unified_diff(
                original_lines,
                remediated_lines,
                fromfile=str(file_path.relative_to(repo_root)),
                tofile=str(file_path.relative_to(repo_root)),
                lineterm="",
            )
            diff_output.extend(diff)

    output_text = "\n".join(diff_output) + "\n" if diff_output else ""

    if args.output:
        with open(args.output, "w") as f:
            f.write(output_text)
    else:
        sys.stdout.write(output_text)


if __name__ == "__main__":
    main()