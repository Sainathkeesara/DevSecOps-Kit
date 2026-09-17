# last_verified: 2026-09-17 · syft n/a
"""
Syft SBOM generation across a multi-language repository with GitHub release attachment.

Automates the workflow of generating SBOMs with Syft for every language
ecosystem present in a repository, then uploading the results as assets
attached to a GitHub release.

Usage:
    # Generate SBOMs and upload to a release
    python syft-sbom-generation.py /path/to/repo --owner org --repo myapp --tag v1.0.0

    # Dry run: print commands without executing
    python syft-sbom-generation.py /path/to/repo --owner org --repo myapp --tag v1.0.0 --dry-run

    # Use a specific Syft config and output format
    python syft-sbom-generation.py /path/to/repo --owner org --repo myapp --tag v1.0.0 \
        --config .syft.yaml --format cyclonedx-json

 Environment variables:
    GITHUB_TOKEN   - GitHub personal access token with repo scope (required for upload)
    GITHUB_API     - Override default API URL (defaults to https://api.github.com)
"""

import argparse
import json
import os
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


SYFT_DEFAULT_FORMATS = ["spdx-json", "cyclonedx-json"]
REPORT_DIR = "sbom-reports"


def require_command(name: str) -> None:
    """Ensure a CLI tool is available on PATH."""
    if not _find_executable(name):
        print(f"ERROR: required command not found: {name}", file=sys.stderr)
        print("  Install Syft via the official installation script.", file=sys.stderr)
        sys.exit(2)


def _find_executable(name: str) -> str | None:
    for directory in os.environ.get("PATH", "").split(os.pathsep):
        candidate = Path(directory) / name
        if candidate.is_file() and os.access(candidate, os.X_OK):
            return str(candidate)
    return None


def detect_languages(repo_path: Path) -> list[str]:
    """Detect language ecosystems from project manifest files."""
    markers: dict[str, str] = {
        "python": "requirements.txt",
        "javascript": "package.json",
        "ruby": "Gemfile",
        "go": "go.mod",
        "rust": "Cargo.toml",
        "java-gradle": "build.gradle",
        "java-maven": "pom.xml",
        "dotnet": "*.csproj",
    }
    found: list[str] = []
    for lang, marker in markers.items():
        if "*" in marker:
            if list(repo_path.glob(marker)):
                found.append(lang)
        elif (repo_path / marker).exists():
            found.append(lang)
    if (repo_path / "Dockerfile").exists() or (repo_path / "docker-compose.yml").exists():
        if "docker" not in found:
            found.append("docker")
    return found


def build_syft_command(
    target: str,
    format: str,
    config: Path | None = None,
    output_file: Path | None = None,
) -> list[str]:
    """Build the Syft CLI argument list for a single output format."""
    cmd = ["syft", "packages", target]
    if output_file:
        cmd.extend(["--output", str(output_file)])
    else:
        cmd.extend(["-o", format])
    if config:
        cmd.extend(["--config", str(config)])
    cmd.extend(["--quiet"])
    return cmd


def run_syft(repo_path: Path, formats: list[str], config: Path | None, dry_run: bool = False) -> dict[str, Path]:
    """Run Syft for each detected ecosystem and each format, returning output file paths."""
    results: dict[str, Path] = {}
    languages = detect_languages(repo_path)

    if not languages:
        print("No language markers detected. Scanning entire repo as default.")
        languages = ["default"]

    report_dir = repo_path / REPORT_DIR
    report_dir.mkdir(parents=True, exist_ok=True)

    for lang in languages:
        print(f"[syft] Scanning {lang} ecosystem in {repo_path.name}")
        for fmt in formats:
            safe_lang = lang.replace(" ", "-").lower()
            output_file = report_dir / f"{safe_lang}.{fmt}"
            cmd = build_syft_command(
                target=str(repo_path),
                format=fmt,
                config=config,
                output_file=output_file,
            )

            if dry_run:
                print(f"  [dry-run] {' '.join(cmd)}")
                results[f"{lang}/{fmt}"] = output_file
                continue

            try:
                proc = subprocess.run(
                    cmd,
                    capture_output=True,
                    text=True,
                    timeout=600,
                    cwd=repo_path,
                )
                if proc.returncode != 0:
                    print(f"  [warn] Syft scan failed for {lang}/{fmt}: {proc.stderr.strip()}", file=sys.stderr)
                    continue
            except subprocess.TimeoutExpired:
                print(f"  [warn] Syft scan timed out for {lang}/{fmt}", file=sys.stderr)
                continue
            except FileNotFoundError:
                print("ERROR: syft command not found", file=sys.stderr)
                sys.exit(2)

            if output_file.exists():
                results[f"{lang}/{fmt}"] = output_file

    return results


def get_latest_release(owner: str, repo: str, github_token: str, api_url: str) -> dict[str, Any] | None:
    """Fetch the latest GitHub release for a repository."""
    url = f"{api_url}/repos/{owner}/{repo}/releases/latest"
    headers = {"Authorization": f"Bearer {github_token}", "Accept": "application/vnd.github+json"}

    try:
        import urllib.request
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req, timeout=30) as resp:
            return json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        if e.code == 404:
            return None
        print(f"ERROR: GitHub API error {e.code}: {e.reason}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"ERROR: failed to fetch release: {e}", file=sys.stderr)
        sys.exit(1)


def create_github_release(
    owner: str,
    repo: str,
    tag: str,
    name: str,
    github_token: str,
    api_url: str,
    draft: bool = False,
    prerelease: bool = False,
) -> dict[str, Any] | None:
    """Create a GitHub release. Returns None if creation fails."""
    url = f"{api_url}/repos/{owner}/{repo}/releases"
    headers = {
        "Authorization": f"Bearer {github_token}",
        "Accept": "application/vnd.github+json",
        "Content-Type": "application/json",
    }
    payload = {"tag_name": tag, "name": name, "draft": draft, "prerelease": prerelease}

    try:
        import urllib.request
        data = json.dumps(payload).encode("utf-8")
        req = urllib.request.Request(url, data=data, headers=headers, method="POST")
        with urllib.request.urlopen(req, timeout=30) as resp:
            return json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        if e.code == 422:
            print(f"  [info] Release {tag} already exists — reusing it for asset upload", file=sys.stderr)
            return get_latest_release(owner, repo, github_token, api_url)
        print(f"ERROR: GitHub API error {e.code}: {e.reason}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"ERROR: failed to create release: {e}", file=sys.stderr)
        sys.exit(1)


def upload_release_asset(
    owner: str,
    repo: str,
    release_id: int,
    file_path: Path,
    github_token: str,
    api_url: str,
) -> None:
    """Upload a file as a release asset."""
    url = f"{api_url}/repos/{owner}/{repo}/releases/{release_id}/assets"
    headers = {"Authorization": f"Bearer {github_token}", "Accept": "application/vnd.github+json"}

    content_type = "application/octet-stream"
    file_name = file_path.name

    try:
        import urllib.request
        data = file_path.read_bytes()
        req = urllib.request.Request(
            f"{url}?name={file_name}",
            data=data,
            headers=headers,
            method="POST",
        )
        req.add_header("Content-Type", content_type)
        with urllib.request.urlopen(req, timeout=60) as resp:
            if resp.status not in (201, 202):
                print(f"  [warn] Upload returned status {resp.status} for {file_name}", file=sys.stderr)
            else:
                print(f"  [ok] Uploaded: {file_name}")
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8", errors="replace") if e.file else ""
        print(f"  [warn] Upload failed for {file_name}: {e.code} {e.reason} — {body[:200]}", file=sys.stderr)
    except Exception as e:
        print(f"  [warn] Upload error for {file_name}: {e}", file=sys.stderr)


def generate_summary_report(
    repo_path: Path,
    sbom_files: dict[str, Path],
    languages: list[str],
) -> Path:
    """Write a summary manifest of all generated SBOMs."""
    report_dir = repo_path / REPORT_DIR
    report_dir.mkdir(parents=True, exist_ok=True)

    summary = {
        "repository": repo_path.name,
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "languages_detected": languages,
        "sbom_files": {
            key: str(value.relative_to(repo_path)) for key, value in sbom_files.items()
        },
        "total_sboms": len(sbom_files),
    }

    summary_path = report_dir / "sbom-generation-summary.json"
    summary_path.write_text(json.dumps(summary, indent=2), encoding="utf-8")
    return summary_path


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate Syft SBOMs for a multi-language repo and attach to a GitHub release"
    )
    parser.add_argument("repo", type=Path, help="Path to the repository root")
    parser.add_argument("--owner", required=True, help="GitHub repository owner/organization")
    parser.add_argument("--repo-name", required=True, dest="repo_name", help="GitHub repository name")
    parser.add_argument("--tag", required=True, help="Release tag (e.g. v1.0.0)")
    parser.add_argument("--config", type=Path, default=None, help="Path to .syft.yaml config")
    parser.add_argument("--format", nargs="+", default=SYFT_DEFAULT_FORMATS,
                        help="Syft output formats (default: spdx-json cyclonedx-json)")
    parser.add_argument("--dry-run", action="store_true", help="Print commands without executing")
    parser.add_argument("--create-release", action="store_true",
                        help="Create a release if one does not exist for the tag")
    parser.add_argument("--prerelease", action="store_true", help="Mark release as prerelease")
    args = parser.parse_args()

    repo_path: Path = args.repo.resolve()
    if not repo_path.is_dir():
        print(f"ERROR: repository path does not exist: {repo_path}", file=sys.stderr)
        sys.exit(2)

    require_command("syft")

    github_token = os.environ.get("GITHUB_TOKEN", "")
    api_url = os.environ.get("GITHUB_API", "https://api.github.com")

    print(f"[info] Scanning repository: {repo_path}")
    print(f"[info] Output formats: {', '.join(args.format)}")

    languages = detect_languages(repo_path)
    print(f"[info] Detected languages: {', '.join(languages) if languages else 'none (default scan)'}")

    sbom_files = run_syft(
        repo_path=repo_path,
        formats=args.format,
        config=args.config,
        dry_run=args.dry_run,
    )

    if not sbom_files and not args.dry_run:
        print("[warn] No SBOM files were generated. Check Syft output for errors.", file=sys.stderr)

    summary_path = generate_summary_report(repo_path, sbom_files, languages)
    print(f"[done] Summary report: {summary_path}")

    if args.dry_run:
        print("[dry-run] Skipping GitHub release operations")
        return

    if not github_token:
        print("[info] GITHUB_TOKEN not set — skipping release attachment", file=sys.stderr)
        return

    release = get_latest_release(args.owner, args.repo_name, github_token, api_url)

    if release is None:
        if args.create_release:
            release_name = f"Release {args.tag}"
            release = create_github_release(
                owner=args.owner,
                repo=args.repo_name,
                tag=args.tag,
                name=release_name,
                github_token=github_token,
                api_url=api_url,
                prerelease=args.prerelease,
            )
            if release is None:
                print("[warn] Failed to create release — cannot upload assets", file=sys.stderr)
                return
            print(f"[info] Created release: {release.get('html_url', 'unknown')}")
        else:
            print("[info] No existing release found. Use --create-release to create one.", file=sys.stderr)
            return

    release_id = release.get("id")
    if release_id is None:
        print("[warn] Release has no ID — cannot upload assets", file=sys.stderr)
        return

    print(f"[info] Uploading SBOM assets to release {release_id}")
    for label, file_path in sbom_files.items():
        upload_release_asset(
            owner=args.owner,
            repo=args.repo_name,
            release_id=release_id,
            file_path=file_path,
            github_token=github_token,
            api_url=api_url,
        )

    print("[done] SBOM generation and release attachment complete")


if __name__ == "__main__":
    main()
