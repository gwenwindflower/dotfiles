#!/usr/bin/env bash
# SessionStart hook: give the session its agent git identity. Commits are signed
# with the dedicated agent signing key; the user's 1Password key stays unreachable.

set -euo pipefail

if [ -z "${CLAUDE_ENV_FILE:-}" ]; then
  exit 0
fi

cat >>"$CLAUDE_ENV_FILE" <<EOF
export GIT_CONFIG_COUNT=3
export GIT_CONFIG_KEY_0=user.signingkey
export GIT_CONFIG_VALUE_0=$HOME/.ssh/agent-signing-key
export GIT_CONFIG_KEY_1=gpg.ssh.program
export GIT_CONFIG_VALUE_1=ssh-keygen
export GIT_CONFIG_KEY_2=user.name
export GIT_CONFIG_VALUE_2='Claude Code (winnie)'
export GIT_OPTIONAL_LOCKS=0
EOF
