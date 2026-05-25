#!/usr/bin/env bash
# TaskCompleted hook: block task completion if a team worktree agent hasn't committed.
# Only fires when teammate_name is set (team context) AND cwd is a non-main git worktree.
# Checks two conditions:
#   1. At least one commit exists past the branch point
#   2. Working tree is clean (no uncommitted changes)
# If either fails, exits 2 to block the action with feedback.

set -euo pipefail

source "$(dirname "$0")/lib/dev-hook-common.sh"

hook_read_input
gate_teammate

cwd="$(hook_field '.cwd')"
worktree_root="$(worktree_root_for "$cwd")" || exit 0

cd "$worktree_root"

# Find the branch point (where this worktree diverged from its upstream).
# Fallback to 'main' is intentional: under SPOT's Phase trunk + Objective
# feature branch model, an Objective branch may be parented off a Phase trunk
# branch rather than main. Using main as the merge-base reference safely
# over-counts (commits past the actual Phase-trunk branch point still count
# past the main branch point), which preserves the at-least-one-commit
# invariant without requiring SPOT-specific topology awareness.
upstream="$(git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null || echo 'main')"
merge_base="$(git merge-base HEAD "$upstream" 2>/dev/null || git rev-parse HEAD)"

# Check 1: at least one new commit past the branch point
commit_count="$(git rev-list --count "${merge_base}..HEAD")"
if [ "$commit_count" -eq 0 ]; then
  echo "You have no commits on this worktree branch ($worktree_root). Commit your work before marking the task complete." >&2
  exit 2
fi

# Check 2: clean working tree
if [ -n "$(git status --porcelain)" ]; then
  echo "You have uncommitted changes in $worktree_root. Stage and commit all work before marking the task complete." >&2
  exit 2
fi
