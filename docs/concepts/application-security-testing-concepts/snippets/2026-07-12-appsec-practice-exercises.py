#!/usr/bin/env python3
# last_verified: 2026-07-12 · python 3.12+
"""Practice exercises for Application Security Testing concepts.

I wrote this to get hands-on with the kinds of patterns SAST tools look for
and how they differ from what DAST tools confirm at runtime. The script
defines some deliberately vulnerable code, runs a toy SAST scan over it, then
shows what additional checks a DAST tool would need a running server to find.
"""

import ast
import subprocess
import time
from http.server import HTTPServer, BaseHTTPRequestHandler
from threading import Thread
from urllib.request import urlopen


VULNERABLE_CODE = r'''
from flask import Flask, request
import subprocess

app = Flask(__name__)

@app.route("/ping")
def ping():
    ip = request.args.get("ip", "8.8.8.8")
    # SAST would flag this: subprocess with user input
    result = subprocess.run(f"ping -c 1 {ip}", shell=True, capture_output=True)
    return f"<pre>{result.stdout.decode()}</pre>"
'''


def sast_scan(source: str) -> list[dict]:
    """Walk the AST and flag dangerous patterns — like a real SAST tool does."""
    findings = []
    try:
        tree = ast.parse(source)
    except SyntaxError:
        return findings

    for node in ast.walk(tree):
        if isinstance(node, ast.Call):
            func = node.func
            # subprocess.run with shell=True
            if isinstance(func, ast.Attribute) and func.attr == "run":
                for kw in node.keywords:
                    if kw.arg == "shell" and isinstance(kw.value, ast.Constant) and kw.value.value:
                        findings.append({
                            "tool": "SAST",
                            "line": node.lineno,
                            "rule": "shell-injection",
                            "severity": "high",
                            "detail": "subprocess.run(shell=True) — command injection risk",
                        })
            # eval / exec
            if isinstance(func, ast.Name) and func.id in ("eval", "exec"):
                findings.append({
                    "tool": "SAST",
                    "line": node.lineno,
                    "rule": "arbitrary-code-execution",
                    "severity": "critical",
                    "detail": f"{func.id}() executes arbitrary Python — replace with safer alternative",
                })
    return findings


class VulnerableHandler(BaseHTTPRequestHandler):
    """Minimal server mimicking the /ping endpoint (DO NOT USE IN REAL LIFE)."""
    def do_GET(self):
        if self.path.startswith("/ping"):
            ip_param = "8.8.8.8"
            if "?" in self.path:
                qs = self.path.split("?", 1)[1]
                for part in qs.split("&"):
                    if "=" in part:
                        k, v = part.split("=", 1)
                        if k == "ip":
                            ip_param = v
            result = subprocess.run(f"ping -c 1 {ip_param}", shell=True,
                                    capture_output=True, timeout=5)
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"<pre>" + result.stdout + b"</pre>")

    def log_message(self, fmt, *args):
        pass


def dast_probe(port: int) -> list[dict]:
    """Simulate a DAST probe: send a malicious payload and check the response."""
    findings = []
    payload = ";echo INJECTED_$(whoami)"
    try:
        resp = urlopen(f"http://localhost:{port}/ping?ip={payload}", timeout=5)
        if b"INJECTED_" in resp.read():
            findings.append({
                "tool": "DAST",
                "rule": "command-injection-confirmed",
                "severity": "critical",
                "detail": "Command injection confirmed — payload echoed in response",
            })
    except Exception:
        findings.append({
            "tool": "DAST",
            "rule": "connection-error",
            "severity": "info",
            "detail": "Could not probe endpoint — server may not be running",
        })
    return findings


def main():
    print("=" * 60)
    print("Exercise: SAST scan vs DAST probe on a vulnerable endpoint")
    print("=" * 60)

    print("\n--- Step 1: Static scan (SAST) ---")
    sast_results = sast_scan(VULNERABLE_CODE)
    for r in sast_results:
        print(f"  [{r['severity']}] L{r['line']}: {r['detail']}")
    if not sast_results:
        print("  No SAST findings")
    print("  -> SAST finds the pattern without running anything. Fast, early, noisy.")

    print("\n--- Step 2: Dynamic probe (DAST) ---")
    port = 19876
    server = HTTPServer(("", port), VulnerableHandler)
    t = Thread(target=server.serve_forever, daemon=True)
    t.start()
    time.sleep(0.3)

    dast_results = dast_probe(port)
    for r in dast_results:
        print(f"  [{r['severity']}] {r['detail']}")
    print("  -> DAST confirms the bug needs a running server. Slower, later, definitive.")

    print("\n--- Takeaway ---")
    print("  SAST flags potential issues early but can't prove exploitability.")
    print("  DAST proves the issue but needs a deployable instance.")
    print("  A mature pipeline runs both — SAST per-commit, DAST per-deployment.")


if __name__ == "__main__":
    main()
