# last_verified: 2026-09-24 · codeql n/a
# I wrote this to practice spotting hardcoded secrets
# in source files — a common vulnerability pattern.

import re

def find_hardcoded_secrets(filepath):
    with open(filepath) as f:
        for i, line in enumerate(f, 1):
            if re.search(r'(password|secret|key)\s*=\s*["\'][^"\']+["\']', line, re.I):
                print(f"Line {i}: possible hardcoded secret")
