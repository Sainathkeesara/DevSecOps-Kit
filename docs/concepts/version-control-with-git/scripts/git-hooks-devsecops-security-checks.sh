#!/usr/bin/env bash
# last_verified: 2026-08-10 · git n/a

# Git hooks for DevSecOps — pre-commit, pre-push, and commit-msg security checks
# This pattern combines Version Control with Git (hook lifecycle and repository
# events) with Application Security Testing (secret detection, commit hygiene)
# so that security gates run locally before code reaches the remote.

set -euo pipefail

TARGET_REPO="${1:-.}"

if [ ! -d "$TARGET_REPO/.git" ]; then
    echo "Error: $TARGET_REPO is not a Git repository." >&2
    exit 1
fi

HOOK_DIR="$TARGET_REPO/.git/hooks"
mkdir -p "$HOOK_DIR"

install_hook() {
    local name="$1"
    local script="$2"
    cat <<< "$script" > "$HOOK_DIR/$name"
    chmod +x "$HOOK_DIR/$name"
    echo "Installed $name"
}

# pre-commit: scan staged files for common secret patterns
pre_commit_hook() {
    cat <<'HOOK'
#!/usr/bin/env bash

echo "[pre-commit] Scanning staged files for secrets..."

staged=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null || true)

if [ -z "$staged" ]; then
    exit 0
fi

blocked=0
while IFS= read -r f; do
    [ -z "$f" ] && continue
    if [ ! -f "$f" ]; then
        continue
    fi
    if file --brief --type "$f" 2>/dev/null | grep -qi 'data'; then
        continue
    fi
    if grep -qE 'AKIA[0-9A-Z]{16}' "$f" 2>/dev/null; then
        echo "[pre-commit] BLOCKED: AWS Access Key ID in $f"
        blocked=1
    fi
    if grep -qE '-----BEGIN [A-Z ]+ PRIVATE KEY-----' "$f" 2>/dev/null; then
        echo "[pre-commit] BLOCKED: Private key in $f"
        blocked=1
    fi
    if grep -qEi 'password\s*=\s*['"'"'"]' "$f" 2>/dev/null; then
        echo "[pre-commit] BLOCKED: Hardcoded password in $f"
        blocked=1
    fi
done <<< "$staged"

if [ "$blocked" -ne 0 ]; then
    echo "[pre-commit] Commit aborted."
    exit 1
fi

echo "[pre-commit] Clean."
HOOK
}

# pre-push: inspect the outgoing diff for debug statements and
# test credentials. Prompts the user before allowing a push that
# contains suspicious artifacts.
pre_push_hook() {
    cat <<'HOOK'
#!/usr/bin/env bash

echo "[pre-push] Checking outgoing diff..."

while read -r local_ref local_sha remote_ref remote_sha; do
    [ "$local_sha" = "0000000000000000000000000000000000000000" ] && continue

    changed=$(git diff --name-only "$remote_sha" "$local_sha" 2>/dev/null || true)
    [ -z "$changed" ] && continue

    hits=0
    while IFS= read -r f; do
        [ -z "$f" ] && continue
        case "$f" in
            *.py|*.js|*.ts|*.go)
                if grep -qE '(console\.log|print\(|debugger|pdb\.set_trace)' "$f" 2>/dev/null; then
                    hits=$((hits + 1))
                fi
                ;;
        esac
    done <<< "$changed"

    if [ "$hits" -gt 0 ]; then
        echo "[pre-push] WARNING: $hits file(s) contain debug statements."
        read -rp "Push anyway? (y/N) " -n 1 reply
        echo
        if [[ ! $reply =~ ^[Yy]$ ]]; then
            echo "[pre-push] Push aborted."
            exit 1
        fi
    fi
done

echo "[pre-push] OK."
HOOK
}

# commit-msg: enforce conventional commits and reject merge commits.
# This keeps the Git history machine-readable and avoids noisy
# "Merge branch" commits that obscure intent.
commit_msg_hook() {
    cat <<'HOOK'
#!/usr/bin/env bash

msg_file="$1"

if grep -qE '^Merge branch' "$msg_file"; then
    echo "[commit-msg] BLOCKED: Merge commits are not allowed. Rebase instead."
    exit 1
fi

if ! grep -qE '^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\(.+\))?: .{1,72}' "$msg_file"; then
    echo "[commit-msg] BLOCKED: Message does not follow conventional commits."
    echo "[commit-msg] Format: <type>(<scope>): <description>"
    exit 1
fi

echo "[commit-msg] Valid."
HOOK
}

main() {
    install_hook "pre-commit" "$(pre_commit_hook)"
    install_hook "pre-push" "$(pre_push_hook)"
    install_hook "commit-msg" "$(commit_msg_hook)"
    echo "Security hooks installed in $HOOK_DIR"
}

main
