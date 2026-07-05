# Contributing

Thanks for your interest in contributing to DevSecOps-Kit.

## How to contribute

1. Fork the repository and create a feature branch from `master`
2. Make your changes following the project structure
3. Ensure shell scripts pass `shellcheck` and Python files pass `ruff check`
4. Submit a pull request with a clear description of your changes

## Code organization

- Tool-specific content lives in its own directory (e.g., `trivy/`, `semgrep/`)
- `00_index/` contains navigation files
- `docs/` contains how-to guides, concepts, reference, and troubleshooting
- Scripts should be executable and include error handling

## Questions?

Open an issue for discussion before submitting large changes.