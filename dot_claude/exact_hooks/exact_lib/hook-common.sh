#!/usr/bin/env bash
# Shared helpers for Claude Code hooks.
# Source from a hook script: `source "$(dirname "$0")/lib/hook-common.sh"`
# All helpers assume `hook_read_input` was called first, populating $HOOK_INPUT.

# Slurp stdin once into a global so downstream extractors don't re-read it.
hook_read_input() {
  HOOK_INPUT="$(cat)"
}

# Extract a field from $HOOK_INPUT by jq path. Empty string if missing.
# Example: `cwd="$(hook_field '.cwd')"`
hook_field() {
  echo "$HOOK_INPUT" | jq -r "$1 // empty"
}

# Exit 0 (no-op) if the hook isn't running in a teammate context.
# Standard first line for hooks that only apply to team helpers.
# The if-form matters: `[ -z ... ] && exit 0` returns 1 in teammate context,
# which `set -e` treats as a fatal error in the caller.
gate_teammate() {
  if [ -z "$(hook_field '.teammate_name')" ]; then
    exit 0
  fi
}
