#!/usr/bin/env bash
# last_verified: 2026-07-10 · git n/a
#
# Local CI simulation using Git hooks.
# I kept pushing commits that failed lint/test in CI, because nothing ran
# locally first. A pre-commit hook is the cheapest fix — it runs the same
# checks CI would, on every commit, before the change ever leaves my machine.
#
# This script builds a throwaway demo repo, installs a pre-commit hook that
# lints staged shell scripts and runs a test command, then makes two commits
# so I can watch the "local CI" fire (and block) in real time.
#
# Usage: ./local-ci-simulation.sh [demo_dir]

demo_dir="${1:-local-ci-demo}"
rm -rf "$demo_dir"
git init -q "$demo_dir"
cd "$demo_dir" || exit 1

# Install the local CI hook. Kept deliberately simple while I learn the shape:
# lint whatever shell scripts are staged, then run the repo's test command if
# one exists. The hook exits non-zero to block the commit when a check fails.
cat > .git/hooks/pre-commit <<'HOOK'
#!/usr/bin/env bash
echo "==> local CI: linting staged shell scripts"
sh_files=$(git diff --cached --name-only --diff-filter=ACM -- '*.sh')
if [ -n "$sh_files" ] && command -v shellcheck >/dev/null 2>&1; then
    # linting every file is wasteful; git diff --cached limits us to the commit
    shellcheck $sh_files || { echo "lint failed — commit blocked"; exit 1; }
elif [ -n "$sh_files" ]; then
    echo "shellcheck not installed — skipping shell lint"
fi

echo "==> local CI: running tests"
if [ -f run_tests.sh ]; then
    bash run_tests.sh || { echo "tests failed — commit blocked"; exit 1; }
else
    echo "no run_tests.sh found — skipping tests"
fi

echo "==> local CI: all checks passed"
HOOK
chmod +x .git/hooks/pre-commit

# A trivial test script so the hook has something to run on the first commit.
cat > run_tests.sh <<'TEST'
#!/usr/bin/env bash
echo "all tests pass"
TEST
chmod +x run_tests.sh

# First commit — no shell files staged yet, and the test passes, so the hook
# should let it through.
git add run_tests.sh
git commit -q -m "add tests"

# Now add a shell script that trips shellcheck (unused variable SC2034) so the
# hook blocks the commit and shows the local CI actually gates my work.
cat > bad.sh <<'BAD'
#!/usr/bin/env bash
unused_var="this trips shellcheck SC2034"
echo "hello"
BAD
git add bad.sh
echo "Attempting a commit that the hook should BLOCK:"
git commit -q -m "add bad script" || echo "(commit was blocked — local CI works)"

cd ..
echo "Demo finished. Inspect '$demo_dir' to see the hook behavior."
