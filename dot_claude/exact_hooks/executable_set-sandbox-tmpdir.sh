#!/usr/bin/env bash
# SessionStart hook: set TMPDIR and TEMP to the sandbox-writable project temp dir.
# This ensures all subprocesses (go build, pytest, npm scripts, etc.) use a dir
# that Claude Code's sandbox already allows writes to, avoiding permission prompts.

set -euo pipefail

if [ -z "${CLAUDE_ENV_FILE:-}" ]; then
  exit 0
fi

if [ -z "${CLAUDE_PROJECT_DIR:-}" ]; then
  exit 0
fi

uid="$(id -u)"
# Match Claude Code's internal convention: /private/tmp/claude-<uid>/<kebab-project-path>
kebab_path="$(echo "$CLAUDE_PROJECT_DIR" | tr '/.' '--')"
proj_tmpdir="/private/tmp/claude-${uid}/${kebab_path}"

mkdir -p "$proj_tmpdir"

printf 'export TMPDIR=%s\nexport TEMP=%s\n' "$proj_tmpdir" "$proj_tmpdir" >>"$CLAUDE_ENV_FILE"
