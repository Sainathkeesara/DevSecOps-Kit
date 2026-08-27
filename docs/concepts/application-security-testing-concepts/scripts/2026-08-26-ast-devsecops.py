# last_verified: 2026-08-26 · AST concepts in DevSecOps
"""
AST-based security pattern checker for Python source files.

Demonstrates how Abstract Syntax Tree analysis can detect common
security anti-patterns in code — the foundation that tools like
Semgrep and CodeQL build on.
"""

import ast
import sys
from pathlib import Path


class SecurityPatternVisitor(ast.NodeVisitor):
    """Walks the AST and flags risky patterns."""

    def __init__(self):
        self.findings = []

    def visit_Call(self, node):
        # Flag direct string formatting in SQL-like execute calls
        if isinstance(node.func, ast.Attribute):
            if node.func.attr in ("execute", "executescript"):
                if node.args and isinstance(node.args[0], (ast.JoinedStr, ast.BinOp)):
                    self.findings.append({
                        "line": node.lineno,
                        "pattern": "string-formatted SQL execute",
                        "severity": "high",
                    })

        # Flag use of eval() or exec() on user-controlled input
        if isinstance(node.func, ast.Name) and node.func.id in ("eval", "exec"):
            self.findings.append({
                "line": node.lineno,
                "pattern": f"use of {node.func.id}()",
                "severity": "high",
            })

        self.generic_visit(node)

    def visit_Assign(self, node):
        # Flag hardcoded credentials in assignments
        for target in node.targets:
            if isinstance(target, ast.Name):
                name_lower = target.id.lower()
                if any(kw in name_lower for kw in ("password", "secret", "token", "api_key")):
                    if isinstance(node.value, ast.Constant) and isinstance(node.value.value, str):
                        self.findings.append({
                            "line": node.lineno,
                            "pattern": f"hardcoded credential in {target.id}",
                            "severity": "critical",
                        })
        self.generic_visit(node)


def scan_file(filepath: str) -> list[dict]:
    """Parse a Python file and return security findings."""
    source = Path(filepath).read_text()
    tree = ast.parse(source, filename=filepath)
    visitor = SecurityPatternVisitor()
    visitor.visit(tree)
    return visitor.findings


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python ast-devsecops.py <file.py>")
        sys.exit(1)

    target = sys.argv[1]
    results = scan_file(target)

    if not results:
        print(f"No security patterns found in {target}")
    else:
        print(f"Found {len(results)} finding(s) in {target}:\n")
        for f in results:
            print(f"  Line {f['line']:>4}: [{f['severity'].upper():>8}] {f['pattern']}")
