# Claude Code

Canonical runbook for running SPOT in Claude Code. Replaces the wt-centric Subagent-layer flow in [running-phases](../running-phases.md) and [using-worktrunk](../using-worktrunk.md) — load *this* file as the Manager's working doctrine; treat the cross-platform docs as conceptual background.

The split matters because Claude Code has first-class worktree primitives. `Agent { isolation: "worktree" }`, the `worktree.baseRef` setting, and the `WorktreeCreate` / `WorktreeRemove` hooks give the Manager a native lifecycle for Objective worktrees — no `wt` invocation, no platform plugin behavior to reason about. Reaching for `wt` inside a Manager session creates two parallel mental models of the same surface; pick one.

## Surface ownership

| Surface | Owner | Tool |
| --- | --- | --- |
| Phase trunk branch+worktree | User or Director | `wt switch --create phase-<n>-<slug>` |
| Objective worktree spawn | Manager | `Agent { subagent_type: "dev" }` (frontmatter handles isolation) |
| Objective worktree cleanup | Manager (via Claude's internal hook) | `WorktreeRemove` fires on Subagent exit |
| Objective → Phase trunk merge | Manager | Raw `git` — squash merge + branch delete |
| Phase trunk → main merge | User or Director | `wt merge --no-squash` |

**Manager does not invoke `wt` at all.** The escape hatch when something goes sideways is raw `git` (see [Escape hatch: raw git](#escape-hatch-raw-git)). If you find yourself reaching for `wt switch` or `wt merge` mid-Phase, stop — you're outside the contract.

**Manager spawns Devs only when ≥2 Objectives can run concurrently.** A Phase with one Objective, or with sequential-only Objectives, runs inline on the Phase trunk. The Dev team is parallelism overhead — see [The Dev subagent](#the-dev-subagent).

## The Dev subagent

A Dev team is parallelism overhead — worktree spin-up, brief authoring, review pass, squash merge, cleanup. It earns its keep only when ≥2 Objectives genuinely run concurrently. Single Objective, or sequential-only Objectives within a Phase, run inline on the Phase trunk. (Mid-team, a single-Dev spawn is fine if other Devs are still in flight — extending or re-spawning. Otherwise: inline.)

When parallelism is warranted, one Objective fans out to one Dev subagent. The agent is defined at `~/.claude/agents/dev.md` (source: `dot_claude/exact_agents/dev.md`) with:

- `isolation: worktree` in frontmatter — every spawn auto-creates an isolated worktree
- `skills: [spot-project-management]` — preloaded so the Dev knows the Phase/Objective/Task hierarchy and commit hygiene rules
- Standard builder tool surface (Read, Edit, Write, Grep, Glob, Bash) — no Agent (Devs don't spawn Devs)

Spawn shape:

```text
Agent {
  description: "<objective name>",
  subagent_type: "dev",
  prompt: "<objective brief: tasks, requirement IDs, naming conventions, the literal assigned worktree path, why this matters>"
}
```

The Manager does **not** pass `isolation: "worktree"` per spawn — the agent's frontmatter handles it. Spawn multiple Devs **in a single message** (parallel tool calls) for the parallel team. Always name the worktree path in the brief; a SubagentStart hook also injects it as system context, but the brief is the human-readable source of truth.

## Objective worktree lifecycle

Driven by Claude's built-in `WorktreeCreate` / `WorktreeRemove` hooks; the Manager doesn't run any of these commands.

1. **Spawn.** Manager calls `Agent { subagent_type: "dev", ... }`.
2. **WorktreeCreate hook fires** (built into Claude Code). Creates a new worktree off the Manager's HEAD — i.e. the Phase trunk — because the global setting `worktree.baseRef: "head"` is set in `~/.claude/settings.json`. The Dev's branch is auto-named.
3. **Dev runs in the worktree.** Edits, commits, runs tests. The `require-teammate-commit.sh` hook gates the Dev's task completion on at-least-one-commit + clean tree.
4. **Dev exits.** Returns path and branch name to the Manager via tool result.
5. **Manager reviews the diff** against the Objective's requirement IDs.
6. **Manager squash-merges** with raw `git` from the Phase trunk worktree (see [Closing an Objective](#closing-an-objective)).
7. **WorktreeRemove hook fires** when the Dev's worktree is cleaned up. Claude auto-cleans worktrees where the agent made no changes; for worktrees with commits, the Manager cleans up explicitly after merging.

If a Dev makes no changes at all (e.g. spurious spawn, no-op Objective), the worktree is auto-cleaned by Claude and there's nothing to merge — Manager moves on.

## Closing an Objective

After the Dev exits clean and Manager has reviewed:

```bash
# From the Phase trunk worktree
git merge --squash <dev-branch>           # stages all Dev commits as one change
# Edit TODO.md to check off the Objective's Tasks
git add TODO.md
git commit -m "<conventional Objective subject>"

# Cleanup
git worktree remove <dev-worktree-path>   # tears down the worktree
git branch -D <dev-branch>                # drop the now-unreferenced branch
```

Notes:

- **Subject line is the Manager's call.** The Dev's commits get squashed away; the line on Phase trunk is what readers see. Stay conventional and specific — this commit is part of the linear story future readers will trace ([git-commits](../../../rules/git-commits.md)).
- **TODO checkoff folds into the Objective commit.** Don't make it a separate commit.
- **`-D` not `-d`** — the squash-merge doesn't update branch tracking, so git won't recognize the content as merged and `-d` will refuse.

If the Dev's work is materially wrong (drifted off requirements, named the wrong thing, comment cruft), **roll back and re-spawn** — don't patch a bad Objective on top. Drop the worktree and branch with `git worktree remove --force <path>` and `git branch -D <branch>`, then re-dispatch with sharper guidance.

## Closing a Phase — hand off, don't merge

When all Objectives are squashed onto the Phase trunk:

1. **Promote the Phase block in `TODO.md` to `DONE.md`** in the Phase trunk worktree — header verbatim with ✅, Objectives and Tasks verbatim with checked boxes, Phase-level narrative under the header.
2. **Update `docs/`** for current-state changes; index new files from `CLAUDE.md`/`AGENTS.md`. Append any surfaced harness/tooling needs to the right `dev-*` spec.
3. **Commit the close** — one `chore(spot):` (or `chore(specs):` if spec edits ride along) commit on the Phase trunk.
4. **Report back.** Manager's done. Leave the Phase trunk worktree clean, close commit at HEAD. **Do not merge to main.**
5. **User or Director runs `wt merge --no-squash`** from the Phase trunk worktree (or Director's Reviewer-gated equivalent — see [directing-sessions.md](../directing-sessions.md)). That step rebases onto main, runs full pre-merge hooks, fast-forwards, removes the Phase trunk worktree.

The Manager's last action is the close commit, not the merge. Phase trunk → main is a cross-session promotion and belongs with whoever owns the queue.

## Hooks: commit guard

`require-teammate-commit.sh` (in `~/.claude/hooks/`) fires on `TaskCompleted` for subagents in a team context (`teammate_name` is set). It blocks task completion unless:

1. At least one new commit exists past the Dev's branch point
2. The working tree is clean

The safety floor — the Dev cannot return "done" with uncommitted work or no commits at all. Manager review starts from the assumption that the diff is real and committed.

## Activity tracking — read-only

`wt list` stays useful as a **read-only dashboard** — even with Manager not invoking `wt`, the worktrunk plugin (if installed) tracks all Claude-created worktrees and shows their state. Run it ad hoc when you want to see what's working vs waiting:

- 🤖 — Subagent is working
- 💬 — Subagent is waiting (typically blocked on user input — surface to Manager)
- Working-tree state, default-branch relation, etc. (see [using-worktrunk#surveying-worktrees](../using-worktrunk.md#surveying-worktrees))

This is the one place `wt` shows up in a Manager session, and it's read-only — `wt list` only, never `wt switch` or `wt merge`. Treat it like `git status` for the broader worktree picture.

The cross-worktree PreToolUse hooks (block writes/edits/git mutations outside a Dev's worktree) make structural contamination rare. Treat `wt list` as general dashboard awareness, not a drift detector — sibling uncommitted work usually reflects normal team activity (user or Director edits, another Manager mid-Phase, an in-flight Objective). If something looks genuinely inconsistent with what you spawned, call `medic` to diagnose.

## Statusline

Optional but useful for live work, in `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "wt list statusline --format=claude-code"
  }
}
```

Shows current worktree, working-tree state, and Claude context-window usage in one line.

## Escape hatch: raw git

When something goes sideways — Dev left mismatched commits, a Phase trunk got out of sync, a worktree won't clean up — drop to raw `git`:

- `git status`, `git log`, `git diff` — inspection
- `git worktree list` — see all worktrees git knows about
- `git worktree remove --force <path>` — tear down a stuck worktree
- `git branch -D <branch>` — drop a branch
- `git rebase -i <merge-base>` — clean local history before close (fair game on unpushed Phase trunk; never on shared history)
- `git reset --hard <ref>` — recover from a botched merge (only with explicit user OK)

If git surgery looks gnarly enough that you're not sure what's safe, call the `medic` agent.

## What about the worktrunk plugin?

If the worktrunk Claude Code plugin is installed, its `WorktreeCreate` hook routes Claude's worktree creation through `wt switch --create` under the hood. That's fine — it makes Claude-created worktrees visible to `wt list` and runs `pre-start` / `post-start` hooks (deps copy, etc.) without the Manager doing anything. Manager's mental model doesn't change: spawn Devs, merge with git, hand off the Phase trunk.

Without the plugin, Claude's default `WorktreeCreate` behavior uses plain `git worktree add`. Same Manager flow either way.

## Settings worth knowing

In `~/.claude/settings.json`:

- **`worktree.baseRef: "head"`** — load-bearing. Without it, Devs spawn off the default branch (main), and the Manager's Phase trunk wouldn't be the parent. Confirm-set when standing up a new machine.
- **`WorktreeCreate` / `WorktreeRemove` hooks** — the worktrunk plugin adds these; with the plugin uninstalled, Claude's defaults handle the lifecycle.
