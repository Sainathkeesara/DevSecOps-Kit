# last_verified: 2026-10-14 · GitHub Actions n/a
# Trigger my first workflow with the GitHub CLI — I pointed gh at the
# first-workflow.yaml by name and watched the run appear in the Actions tab.
WORKFLOW="2026-08-26-first-workflow.yaml"
gh workflow run "$WORKFLOW" --ref main