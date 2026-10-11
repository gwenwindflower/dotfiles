#!/usr/bin/env bash
# SessionStart hook: give the session its agent git identity. The included
# fragment signs through Secretive; the user's 1Password key stays unreachable.

set -euo pipefail

if [ -z "${CLAUDE_ENV_FILE:-}" ]; then
  exit 0
fi

cat >>"$CLAUDE_ENV_FILE" <<EOF
export GIT_CONFIG_COUNT=1
export GIT_CONFIG_KEY_0=include.path
export GIT_CONFIG_VALUE_0=$HOME/.config/git/claude.gitconfig
export GIT_OPTIONAL_LOCKS=0
EOF
