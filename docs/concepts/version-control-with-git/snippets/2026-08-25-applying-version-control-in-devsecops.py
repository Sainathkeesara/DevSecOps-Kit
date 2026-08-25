# last_verified: 2026-08-25 · Python 3 (stdlib)
"""
Applying Version Control with Git in DevSecOps.

I'm practicing how VCS metadata (what changed) feeds a security gate. The
snippet reads the changed-file list from git and blocks an automatic merge
when a sensitive path changed, forcing a human review instead.
"""

import subprocess
import sys


# I treat these paths as "sensitive" — if they change I want a review gate
# rather than an unattended merge.
SENSITIVE_PATHS = ("secrets/", "credentials", ".env", "kubeconfig")


def changed_files(repo="."):
    """Get files changed in the working tree via git."""
    out = subprocess.run(
        ["git", "-C", repo, "diff", "--name-only", "HEAD"],
        capture_output=True, text=True, check=True,
    )
    return [f for f in out.stdout.splitlines() if f]


def review_gate(files):
    """Return True if an automatic merge should be blocked for review."""
    return any(p in f for f in files for p in SENSITIVE_PATHS)


if __name__ == "__main__":
    files = changed_files(sys.argv[1] if len(sys.argv) > 1 else ".")
    print(f"changed files: {len(files)}")
    if review_gate(files):
        print("BLOCK: sensitive path changed, require manual review")
        sys.exit(1)
    print("OK: no sensitive paths changed")
