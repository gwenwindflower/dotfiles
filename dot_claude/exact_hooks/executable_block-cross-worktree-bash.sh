#!/usr/bin/env bash
# PreToolUse on Bash: block Dev subagents from git mutations targeting a repo
# outside their assigned worktree (parses `cd` and `git -C` patterns).

set -euo pipefail

source "$(dirname "$0")/lib/dev-hook-common.sh"

hook_read_input
gate_teammate

command="$(hook_field '.tool_input.command')"
cwd="$(hook_field '.cwd')"
[ -z "$command" ] && exit 0

is_git_mutation "$command" || exit 0

worktree_root="$(worktree_root_for "$cwd")" || exit 0

effective_dir="$(effective_dir_for_command "$command" "$cwd")"
effective_root="$(cd "$effective_dir" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null || true)"
[ -z "$effective_root" ] && exit 0

if [ "$effective_root" != "$worktree_root" ]; then
  cat >&2 <<EOF
BLOCKED: Dev subagent attempted git mutation outside its assigned worktree.

  Your worktree:        $worktree_root
  Command target repo:  $effective_root
  Command:              $command

Cross-worktree commits violate the SPOT subagent contract — your work must
land on your worktree's branch so the Manager can squash-merge it.

If you've been writing to the wrong path:
  1. Run \`pwd\` to confirm your worktree root: $worktree_root
  2. Move your files into the worktree: \`cp <wrong-path> $worktree_root/<right-path>\`
  3. Verify with \`git -C $worktree_root status\`
  4. Commit from inside your worktree (no \`cd\` to another tree, no \`git -C\`)
EOF
  exit 2
fi
exit 0
