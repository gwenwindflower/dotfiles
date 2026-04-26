#!/usr/bin/env bash
# WorktreeCreate hook: inject commit reminder into worktree agent context.
# No filtering needed — if a worktree was created, the agent working in it
# should know that task completion requires committed work.

cat <<'EOF'
This is a fresh worktree. If you have a task to complete here, you will NOT be
able to mark it complete until your work is committed. Before finishing up:
1. Stage your changes
2. Update the TODO.md regarding the Phase, Objective, or Task you completed before you commit -- DO NOT make separate commits for updates to the TODO.md, and do not make your team leader agent update the TODO.md for you after you commit
2. Commit with a clear, descriptive commit message that continues a meaningful linear history
3. Ensure `git status` is clean
4. Now you can mark the task complete!

Uncommitted work on a worktree is lost when the worktree is cleaned up.
EOF
