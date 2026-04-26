#!/usr/bin/env bash
# SessionStart hook: disable git commit signing in Claude Code's sandbox.
# The global gitconfig requires SSH signing via 1Password, which the sandbox
# can't access. This overrides signing settings via env vars so the agent
# can commit without signing, while the user's normal commits remain signed.

set -euo pipefail

if [ -z "${CLAUDE_ENV_FILE:-}" ]; then
  exit 0
fi

cat >>"$CLAUDE_ENV_FILE" <<'EOF'
export GIT_CONFIG_COUNT=3
export GIT_CONFIG_KEY_0=commit.gpgsign
export GIT_CONFIG_VALUE_0=false
export GIT_CONFIG_KEY_1=tag.gpgsign
export GIT_CONFIG_VALUE_1=false
export GIT_CONFIG_KEY_2=user.name
export GIT_CONFIG_VALUE_2='Claude Code (winnie)'
EOF
