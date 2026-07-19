# last_verified: 2026-07-19 · Container Runtime Security
"""
Container Runtime Security practice exercise.
Inspect running Docker containers and flag common security misconfigurations.
"""

import subprocess
import json
import sys


def get_containers():
    """Return running containers as parsed JSON lines from docker ps."""
    result = subprocess.run(
        ["docker", "ps", "--format", "{{json .}}"],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        print("docker ps failed — is Docker running?", file=sys.stderr)
        sys.exit(1)

    containers = []
    for line in result.stdout.strip().splitlines():
        if line:
            containers.append(json.loads(line))
    return containers


def inspect_security(name):
    """Inspect a container for privileged mode and writable root filesystem."""
    flags = []

    priv = subprocess.run(
        ["docker", "inspect", "--format", "{{.HostConfig.Privileged}}", name],
        capture_output=True,
        text=True,
    )
    if priv.stdout.strip() == "true":
        flags.append("privileged")

    ro = subprocess.run(
        ["docker", "inspect", "--format", "{{.HostConfig.ReadonlyRootfs}}", name],
        capture_output=True,
        text=True,
    )
    if ro.stdout.strip() != "true":
        flags.append("writableRootfs")

    return flags


def main():
    containers = get_containers()
    if not containers:
        print("No running containers found.")
        return

    for c in containers:
        # Names comes back as a slice; grab the first entry
        names = c.get("Names", ["unknown"])
        name = names[0] if names else "unknown"
        flags = inspect_security(name)
        if flags:
            print(f"[{name}] {', '.join(flags)}")

    print(f"Checked {len(containers)} containers.")


if __name__ == "__main__":
    main()
