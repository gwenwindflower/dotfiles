---
name: git-branching
description: Git branches as worktrees and stacks - wt switch, merge, remove, hooks and config; gh stack stacked PRs; landing work locally or through PRs.
---

# Git branching

Every branch lives in its own worktree, created and retired through Worktrunk (`wt`). Commit format, history rules, and push authority come from the global git rules; this skill covers the branch mechanics.

| Job | Doc |
| --- | --- |
| Create, target, merge, or remove a worktree | [worktrunk](worktrunk.md) |
| Write hooks or aliases, read the user config, debug approvals | [worktrunk-config](worktrunk-config.md) |
| Stacked PRs on GitHub | [gh-stack](gh-stack.md) |

## Landing work

- **Solo projects on the `project-tooling` pattern** land with `wt merge`: the project's `pre-merge` gate is the local CI, and a PR is only for changes that need remote verification.
- **Everything else** (Lightdash, repos Winnie doesn't own, collaborator-heavy projects) goes through a GitHub PR, merged with `gh pr merge --squash`.
- `wt merge` squashes by default. A SPOT Phase branch whose commits are one-per-Objective lands with `wt merge --no-squash`.

## Two kinds of stack

| Stack | Shape | Lands with |
| --- | --- | --- |
| Local worktree stack | Each layer in its own worktree, created with `wt switch -c <child> --base @` | `wt merge <parent>` folds a layer down, then the bottom merges into the default branch |
| GitHub stacked PRs | All layers as branches in one worktree, tracked by `gh stack` | `gh stack merge <pr> --yes --squash`, bottom-up on GitHub |

Pick one per stack. `gh stack` switches branches inside a single checkout, so it can't navigate layers checked out in other worktrees; `gh stack link` covers that case without local tracking.

## Helpers

Branch, worktree, and stack mutations belong to the lead session. A helper (subagent or teammate) works in the worktree it was given and may run only read-only commands: `wt list`, `wt step diff`, `gh stack view --json`. `gh stack` navigation switches branches in the shared tree, so it counts as a mutation.
