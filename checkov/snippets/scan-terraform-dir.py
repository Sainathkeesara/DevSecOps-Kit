#!/usr/bin/env python3
"""Scan a Terraform directory for security misconfigurations using Checkov."""

import sys
from checkov.main import Checkov

if __name__ == "__main__":
    # TODO: handle relative paths too
    target = sys.argv[1] if len(sys.argv) > 1 else "."
    runner = Checkov()
    report = runner.run(directory=target, framework="terraform")
    for record in report.get_records():
        if record.violation_status == "FAILED":
            print(f"[{record.check_id}] {record.file_path} — {record.check_name}")
