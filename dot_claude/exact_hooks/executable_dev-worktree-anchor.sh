#!/usr/bin/env bash
# SubagentStart hook (matcher "dev"): inject the Dev's assigned worktree root
# as additionalContext at session start, so the Dev opens with an explicit
# anchor rather than trusting path priors.

set -euo pipefail

source "$(dirname "$0")/lib/dev-hook-common.sh"

hook_read_input

cwd="$(hook_field '.cwd')"
[ -z "$cwd" ] && exit 0

# Fall back to cwd if we're not in a worktree — Devs almost always are, but
# the anchor message is still useful when they aren't (rare).
worktree_root="$(worktree_root_for "$cwd")" || worktree_root="$cwd"

context="You are a Dev subagent. Your assigned worktree root is:

  $worktree_root

This is your work surface. Every Write, Edit, NotebookEdit, and git mutation must land inside it — the harness BLOCKS anything outside as a hard rail. Reads are unrestricted; pull from sibling worktrees, shared skills, anywhere. If a block fires, follow its recovery steps; don't route around it.

Your task isn't done until it's committed. The harness REFUSES task completion while the working tree is dirty or no new commits exist past the branch point. Update TODO.md in the same commit as the work — never split it out, never delegate it back to your team leader. Uncommitted changes on this worktree are lost when it's cleaned up."

jq -n --arg ctx "$context" '
{
  hookSpecificOutput: {
    hookEventName: "SubagentStart",
    additionalContext: $ctx
  }
}
'
