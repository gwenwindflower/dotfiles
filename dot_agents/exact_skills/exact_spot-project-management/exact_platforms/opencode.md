# OpenCode

Platform-specific mechanics for running SPOT in OpenCode. Conceptual flow lives in [running-phases](../running-phases.md) and [using-worktrunk](../using-worktrunk.md).

> [!NOTE]
> OpenCode integration is in progress. The patterns below cover what's wired up today; gaps with Claude Code's integration are called out so a Manager knows what to compensate for manually.

## Spawning an Agent Team

OpenCode's primitive for parallel sub-agents differs from Claude Code's `Agent` tool. Until the worktrunk OpenCode plugin lands first-class worktree-isolation support, the SPOT-canonical pattern is:

1. **Manager pre-creates each Objective worktree** from the Phase trunk worktree:

   ```bash
   wt switch --create obj-<slug> --base @ --no-cd
   ```

   `--base @` parents the new branch off the Phase trunk (current HEAD), `--no-cd` keeps the Manager's shell where it is.

2. **Manager dispatches a sub-agent into each pre-created worktree path**, naming the path explicitly in the prompt so the sub-agent stays in its lane.

This is closer to the worktrunk skill's "Parallel sub-Agents" pattern than to Claude Code's `isolation: "worktree"`. It works, it's just more manual.

## Hooks: commit guard

OpenCode does not yet have an analog to Claude Code's `TaskCompleted` hook with `teammate_name` propagation, so the equivalent of `require-teammate-commit` would need to be implemented as an OpenCode plugin. Until then, Managers should explicitly check that each sub-agent committed and left a clean tree before accepting their work — `wt list --format=json | jq '.[] | select(.working_tree.modified or .working_tree.staged)'` flags dirty Objective worktrees in one line.

## Activity tracking

`wt list`'s 🤖/💬 markers come from the Claude Code plugin specifically. OpenCode-side equivalents are not wired up yet — Managers can set markers manually with `wt config state marker set "🚧" --branch obj-<slug>` to keep the dashboard meaningful.

## What's pending

- First-class `Agent` / sub-agent tool with worktree isolation (mirrors Claude Code's `isolation: "worktree"`)
- OpenCode plugin for `WorktreeCreate` / `WorktreeRemove` routing through `wt`
- OpenCode equivalent of `require-teammate-commit`
- Activity-marker integration for `wt list`

This file gets fleshed out as those pieces land.
