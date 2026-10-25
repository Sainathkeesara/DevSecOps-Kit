# last_verified: 2026-10-25 · lab n/a
# Minimal lab environment setup with Python — spins up a throwaway practice box
# using the lab config format as input. Not a full orchestrator, just enough to
# go from YAML to a running container I can ssh into.

import yaml
import subprocess
import tempfile
import os
import sys

def load_lab_config(path: str) -> dict:
    """Read a lab environment YAML config and return the parsed dict."""
    with open(path, "r") as f:
        return yaml.safe_load(f)

def generate_dockerfile(config: dict) -> str:
    """Generate a minimal Dockerfile from the lab config's machine section."""
    machine = config.get("machine", {})
    os_name = machine.get("os", "ubuntu")
    packages = machine.get("packages", [])
    ports = machine.get("ports", [])

    # Map lab OS names to Docker base images
    base_images = {
        "ubuntu": "ubuntu:24.04",
        "debian": "debian:12",
        "alpine": "alpine:3.20",
    }
    base = base_images.get(os_name.lower(), "ubuntu:24.04")

    # Package install commands per distro
    if "alpine" in base:
        pkg_cmd = f"apk add --no-cache {' '.join(packages)}" if packages else "true"
    else:
        pkg_cmd = f"apt-get update && apt-get install -y {' '.join(packages)}" if packages else "true"

    # Expose ports in the Dockerfile (documentation only; actual mapping at run time)
    expose_lines = "\n".join(f"EXPOSE {p}" for p in ports) if ports else ""

    dockerfile = f"""FROM {base}

# Install packages from lab config
RUN {pkg_cmd}

# Create a non-root user for practice (matches typical lab workflow)
RUN useradd -m -s /bin/bash labuser
USER labuser
WORKDIR /home/labuser

{expose_lines}

# Default to an interactive shell so the box stays running
CMD ["/bin/bash"]
"""
    return dockerfile

def build_image(dockerfile: str, tag: str) -> bool:
    """Build a Docker image from the generated Dockerfile string."""
    with tempfile.TemporaryDirectory() as tmpdir:
        df_path = os.path.join(tmpdir, "Dockerfile")
        with open(df_path, "w") as f:
            f.write(dockerfile)
        try:
            subprocess.run(
                ["docker", "build", "-t", tag, tmpdir],
                check=True,
                capture_output=True,
                text=True,
            )
            return True
        except subprocess.CalledProcessError as e:
            print(f"Build failed: {e.stderr}", file=sys.stderr)
            return False

def run_container(tag: str, name: str, ports: list) -> bool:
    """Run the built image as a named container with port mappings."""
    port_args = []
    for p in ports:
        port_args.extend(["-p", f"{p}:{p}"])
    try:
        subprocess.run(
            ["docker", "run", "-d", "--name", name, *port_args, tag],
            check=True,
            capture_output=True,
            text=True,
        )
        return True
    except subprocess.CalledProcessError as e:
        print(f"Run failed: {e.stderr}", file=sys.stderr)
        return False

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 minimal-lab-env.py <lab-config.yaml> [--run]")
        sys.exit(1)

    config_path = sys.argv[1]
    should_run = "--run" in sys.argv

    config = load_lab_config(config_path)
    name = config.get("name", "lab-box")
    tag = f"lab-{name}"

    print(f"Building lab environment: {name}")
    dockerfile = generate_dockerfile(config)

    if not build_image(dockerfile, tag):
        sys.exit(1)

    print(f"Built image: {tag}")

    if should_run:
        ports = config.get("machine", {}).get("ports", [])
        if run_container(tag, name, ports):
            print(f"Container '{name}' started. Ports: {ports}")
            print(f"  Connect: docker exec -it {name} bash")
        else:
            sys.exit(1)
    else:
        print("Image built. Run with: docker run -it --rm <image> bash")
        print("Or re-run with --run to start a named container with port mapping.")

if __name__ == "__main__":
    main()