#!/usr/bin/env bash
# PreToolUse on Write|Edit|NotebookEdit: block Dev subagents from mutating
# absolute paths outside their assigned worktree. Reads are intentionally not
# guarded — Devs legitimately pull from sibling worktrees, shared skills, etc.
#
# Gates on teammate_name + non-main worktree, so Manager/Planner/user sessions
# are unaffected. Relative paths are always allowed — they resolve against cwd,
# which is the worktree root for the Dev.
#
# Named generically (`worktree-guardrails`) so additional guards at this event
# can be folded in without renaming.

set -euo pipefail

source "$(dirname "$0")/lib/dev-hook-common.sh"

hook_read_input
gate_teammate

cwd="$(hook_field '.cwd')"
worktree_root="$(worktree_root_for "$cwd")" || exit 0

tool_name="$(hook_field '.tool_name')"
case "$tool_name" in
  NotebookEdit) target="$(hook_field '.tool_input.notebook_path')" ;;
  *)            target="$(hook_field '.tool_input.file_path')" ;;
esac
[ -z "$target" ] && exit 0

# Only meaningful for absolute paths — relative paths resolve against cwd
case "$target" in
  /*) ;;
  *) exit 0 ;;
esac

# Resolve symlinks for an apples-to-apples prefix check
resolved_root="$(cd "$worktree_root" && pwd -P)"
if [ -e "$target" ]; then
  resolved_target="$(cd "$(dirname "$target")" 2>/dev/null && pwd -P)/$(basename "$target")"
else
  parent="$(dirname "$target")"
  if [ -d "$parent" ]; then
    resolved_target="$(cd "$parent" && pwd -P)/$(basename "$target")"
  else
    resolved_target="$target"
  fi
fi

case "$resolved_target" in
  "$resolved_root"|"$resolved_root"/*) exit 0 ;;
esac

cat >&2 <<EOF
BLOCKED: Dev subagent attempted to ${tool_name} a path outside its worktree.

  Your worktree:   $worktree_root
  Attempted path:  $target

Writes outside your worktree are blocked to prevent contention with sibling
Devs and the canonical repo. (Reads are unrestricted — pull from anywhere.)

Recovery:
  1. Run \`pwd\` to confirm your worktree root: $worktree_root
  2. \`cp <wrong-path> $worktree_root/<right-path>\`, then ${tool_name} from there.

Every absolute path you Write, Edit, or NotebookEdit must start with $worktree_root.
EOF
exit 2
