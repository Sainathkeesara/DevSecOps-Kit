#!/usr/bin/env python3
# last_verified: 2026-09-18 · linux-shell-fundamentals (concept, n/a)

# I wrote this to practice the Linux scripting patterns I keep retyping in
# bash, but in Python so I get real error messages instead of silent weirdness.
import os
import subprocess
import sys
from pathlib import Path

# Pattern 1: run a command and fail loudly — I use check=True because the
# docs example without it kept marching on after a broken command failed.
subprocess.run(["whoami"], check=True)

# Pattern 2: env var with a default — I kept crashing on missing vars, so now
# I always go through os.environ.get with a fallback I can reason about.
target_dir = os.environ.get("PRACTICE_DIR", "/tmp")

# Pattern 3: loop over files with pathlib — I tried os.listdir first and it
# gave me bare names; Path.iterdir keeps the full path so I can stat them.
for entry in sorted(Path(target_dir).iterdir()):
    print(f"{entry.name}: {'dir' if entry.is_dir() else 'file'}")

# Pattern 4: exit non-zero when my own check fails — I learned the CI step
# only turns red if I call sys.exit with something other than 0.
if not os.access(target_dir, os.W_OK):
    print(f"cannot write to {target_dir}, stopping", file=sys.stderr)
    sys.exit(1)
print("patterns ran clean")
