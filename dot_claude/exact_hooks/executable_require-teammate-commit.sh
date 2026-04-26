#!/usr/bin/env bash
# TaskCompleted hook: block task completion if a team worktree agent hasn't committed.
# Only fires when teammate_name is set (team context) AND cwd is a git worktree.
# Checks two conditions:
#   1. At least one commit exists past the branch point
#   2. Working tree is clean (no uncommitted changes)
# If either fails, exits 2 to block the action with feedback.

set -euo pipefail

input="$(cat)"

# Must be a team context (teammate_name present)
teammate="$(echo "$input" | jq -r '.teammate_name // empty')"
if [ -z "$teammate" ]; then
  exit 0
fi

# Must be running in a git worktree (not the main repo)
cwd="$(echo "$input" | jq -r '.cwd // empty')"
if [ -z "$cwd" ]; then
  exit 0
fi

cd "$cwd"

git_dir="$(git rev-parse --git-dir 2>/dev/null || true)"
common_dir="$(git rev-parse --git-common-dir 2>/dev/null || true)"
if [ -z "$git_dir" ] || [ "$git_dir" = "$common_dir" ]; then
  exit 0
fi

# Find the branch point (where this worktree diverged from its upstream)
upstream="$(git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null || echo 'main')"
merge_base="$(git merge-base HEAD "$upstream" 2>/dev/null || git rev-parse HEAD)"

# Check 1: at least one new commit past the branch point
commit_count="$(git rev-list --count "${merge_base}..HEAD")"
if [ "$commit_count" -eq 0 ]; then
  echo "You have no commits on this worktree branch. Commit your work before marking the task complete." >&2
  exit 2
fi

# Check 2: clean working tree
if [ -n "$(git status --porcelain)" ]; then
  echo "You have uncommitted changes. Stage and commit all work before marking the task complete." >&2
  exit 2
fi
