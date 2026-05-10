# Claude Code

Platform-specific mechanics for running SPOT in Claude Code. Conceptual flow lives in [running-phases](../running-phases.md) and [using-worktrunk](../using-worktrunk.md); this doc covers the spawn syntax, hook integration, and activity tracking that are Claude-specific.

## Spawning an Agent Team

A Manager spawns one Subagent per Objective in a Phase. Each Subagent gets its own worktree, scoped permissions, and a focused prompt covering the Objective's Tasks plus the requirement IDs to satisfy.

Use the `Agent` tool with `isolation: "worktree"`:

```text
Agent {
  description: "Provider integration",
  subagent_type: "general-purpose",
  isolation: "worktree",
  prompt: "<objective brief: tasks, requirement IDs, naming conventions, why this work matters>"
}
```

The worktrunk plugin's `WorktreeCreate` hook routes the spawn through `wt switch --create`, so:

- Worktree lands at the configured worktrunk path (e.g. `<repo>.agent-<id>`)
- `pre-start` and `post-start` hooks fire (deps install, `wt step copy-ignored`, etc.)
- `wt list` shows the worktree with the 🤖 (working) / 💬 (waiting) marker
- `WorktreeRemove` routes Subagent end-of-life through `wt remove`

**Spawn multiple Subagents in parallel** by batching `Agent` calls in a single message. They run concurrently in their own worktrees.

## Branch parentage: a small wrinkle, no friction

`wt switch --create` defaults `--base` to the default branch (main), so Objective branches spawned by `isolation: "worktree"` start from main, not from the Manager's current Phase trunk branch. This is fine: when the Subagent finishes and the Manager runs `wt merge phase-<n>-<slug>` from the Subagent's worktree, the merge rebases the Objective onto Phase trunk before fast-forwarding. The merge topology is correct even though the branch genealogy isn't strictly nested.

If a project wants Objective branches that *are* parented off the Phase trunk (cleaner naming, e.g. `obj-<slug>` instead of `agent-<id>`), use the manual pre-create pattern documented in the worktrunk skill's "Parallel sub-Agents" section — but for most SPOT work, the default `isolation: "worktree"` flow is the right tradeoff.

## Hooks: commit guard

The `require-teammate-commit` hook (in `~/.claude/hooks/`) fires on `TaskCompleted` for Subagents in a team context (`teammate_name` is set). It blocks task completion unless:

1. At least one new commit exists past the Subagent's branch point
2. The working tree is clean

Belt-and-suspenders relative to worktrunk's `pre-commit` hooks: pre-commit fires on `git commit` and gates the commit itself; this hook fires when the Subagent declares the task done and gates the Subagent's exit. Together they ensure no Subagent ever returns "complete" without a clean, committed state.

## Activity tracking

`wt list` (with the worktrunk plugin installed) shows per-worktree Subagent status:

- 🤖 — Subagent is working
- 💬 — Subagent is waiting (typically blocked on user input — surface to Manager)

Useful when Manager has multiple Phases or Objectives in flight and wants to scan which teams are active vs blocked.

## Statusline

Optional but useful for live work: add to `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "wt list statusline --format=claude-code"
  }
}
```

Shows current worktree, working-tree state, and Claude context-window usage in one line. See the worktrunk skill's Claude Code section for details.
