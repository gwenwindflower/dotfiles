#!/usr/bin/env bash
# PreToolUse on Bash: teammates never write to git — they report done and the
# session lead reviews and commits. Blocks git/wt write operations in teammate
# context; reads (status, log, diff) pass through.

set -euo pipefail

source "$(dirname "$0")/lib/hook-common.sh"

hook_read_input
gate_teammate

command="$(hook_field '.tool_input.command')"
[ -z "$command" ] && exit 0

case "$command" in
  *"git commit"* | *"git add"* | *"git rm"* | *"git mv"* | *"git merge"* | \
  *"git rebase"* | *"git reset"* | *"git push"* | *"git checkout"* | \
  *"git switch"* | *"git stash"* | *"git cherry-pick"* | *"git revert"* | \
  *"git tag"* | *"git branch"* | *"git worktree"* | \
  *"wt merge"* | *"wt switch"* | *"wt remove"*)
    cat >&2 <<EOF
BLOCKED: git writes belong to the session lead, not helpers.

You're a teammate on a shared branch. Finish the work, verify it (tests,
lint, typecheck), and report done — the lead reviews your changes and
commits them. Do not stage, commit, branch, or otherwise mutate git state.

Command: $command
EOF
    exit 2
    ;;
esac

exit 0
