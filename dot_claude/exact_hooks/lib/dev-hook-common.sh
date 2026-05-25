#!/usr/bin/env bash
# Shared helpers for Claude Code hooks that gate on teammate + worktree context.
# Source from a hook script: `source "$(dirname "$0")/lib/dev-hook-common.sh"`
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

# Exit 0 (no-op) if the hook isn't running in a teammate/subagent context.
# Standard first line for hooks that only care about subagents.
gate_teammate() {
  [ -z "$(hook_field '.teammate_name')" ] && exit 0
}

# Echo the worktree root if $1 sits inside a non-main linked worktree.
# Returns non-zero (empty stdout) otherwise. Distinguishes a real linked
# worktree from the canonical repo by comparing git-dir vs git-common-dir.
# Use as: `root="$(worktree_root_for "$cwd")" || exit 0`
worktree_root_for() {
  local cwd="$1"
  [ -z "$cwd" ] && return 1
  local git_dir common_dir
  git_dir="$(cd "$cwd" 2>/dev/null && git rev-parse --git-dir 2>/dev/null || true)"
  common_dir="$(cd "$cwd" 2>/dev/null && git rev-parse --git-common-dir 2>/dev/null || true)"
  if [ -z "$git_dir" ] || [ "$git_dir" = "$common_dir" ]; then
    return 1
  fi
  cd "$cwd" && git rev-parse --show-toplevel
}

# Return 0 if the bash command contains a git mutation we guard against
# (commit, add, rm, mv). Use as a gate: `is_git_mutation "$cmd" || exit 0`.
is_git_mutation() {
  case "$1" in
    *"git commit"*|*"git add"*|*"git rm"*|*"git mv"*) return 0 ;;
  esac
  return 1
}

# Parse the effective working dir from a bash command, honoring `cd <dir>` and
# `git -C <dir>` patterns. Falls back to $2 when neither pattern is present.
# Parsing is intentionally conservative — false positives (over-blocking) are
# fine for the callers; false negatives (missing a real mutation) are not.
effective_dir_for_command() {
  local command="$1" cwd="$2"
  local dir="$cwd"
  if echo "$command" | grep -qE '(^|[;&|[:space:]])cd[[:space:]]+[^[:space:];&|]+'; then
    dir="$(echo "$command" | sed -nE 's/.*(^|[;&|[:space:]])cd[[:space:]]+([^[:space:];&|]+).*/\2/p' | head -1)"
  fi
  if echo "$command" | grep -qE 'git[[:space:]]+-C[[:space:]]+'; then
    dir="$(echo "$command" | sed -nE 's/.*git[[:space:]]+-C[[:space:]]+([^[:space:]]+).*/\1/p' | head -1)"
  fi
  echo "$dir"
}
