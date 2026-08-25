# last_verified: 2026-08-25 · Python 3 (stdlib)
"""
Applying Secrets & Access Management in DevSecOps.

I'm practicing the core SAM habit: secrets are never baked into source or the
built image, they're resolved at runtime from a secret store (here mocked by
environment variables) and only references are committed. A small pre-commit
style guard catches teammates who hardcode a value by mistake.
"""

import os
import re


# I keep a manifest of which secrets a service needs so the deploy step can
# fail fast if one is missing instead of crashing mid-startup.
REQUIRED_SECRETS = ["DATABASE_URL", "API_TOKEN", "SIGNING_KEY"]


def load_secrets(required):
    """Resolve required secrets from the environment at runtime.

    Resolving here (not embedding values in the artifact) is the SAM pattern I
    want to make automatic on every service.
    """
    resolved = {}
    for name in required:
        value = os.environ.get(name)
        if not value:
            raise RuntimeError(f"missing required secret: {name}")
        resolved[name] = value
    return resolved


# A tiny guard I'd drop into CI so an inline secret can't slip through.
HARDCODED = re.compile(r"(?i)(password|token|secret)\s*=\s*['\"][^'\"]{6,}")


def scan_for_hardcoded(path):
    """Return (lineno, line) pairs that look like inline secrets."""
    hits = []
    with open(path) as fh:
        for lineno, line in enumerate(fh, 1):
            if HARDCODED.search(line):
                hits.append((lineno, line.strip()))
    return hits


if __name__ == "__main__":
    secrets = load_secrets(REQUIRED_SECRETS)
    print(f"loaded {len(secrets)} secrets at runtime, none committed to source")
