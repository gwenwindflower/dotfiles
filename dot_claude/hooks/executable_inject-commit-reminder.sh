#!/usr/bin/env bash
# WorktreeCreate hook: inject commit reminder into worktree agent context.
# No filtering needed — if a worktree was created, the agent working in it
# should know that task completion requires committed work.

cat <<'EOF'
This is a fresh worktree. If you have a task to complete here, you will NOT be
able to mark it complete until your work is committed. Before finishing up:
1. Stage and commit all changes with a clear, descriptive commit message
2. Ensure `git status` is clean

Uncommitted work on a worktree is lost when the worktree is cleaned up.
EOF
