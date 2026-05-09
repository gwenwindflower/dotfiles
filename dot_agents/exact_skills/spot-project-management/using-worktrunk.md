# Using worktrunk

Worktrunk (`wt`) is the worktree layer. When it's installed in a project, **always reach for `wt` over raw `git worktree`** — it manages paths, hooks, branch lifecycle, and merge cleanup as one unit. SPOT's parallel-Phase model lives or dies on coherent worktree state; `wt list` is how a Manager sees that state at a glance, and `wt merge` is how a Phase closes cleanly.

Detect availability with `wt --version`. If absent, fall back to plain `git worktree` and skip this doc.

## Agent team worktrees are already routed through wt

When Manager spawns a subagent team via `Agent { isolation: "worktree" }`, the Claude Code plugin's `WorktreeCreate` / `WorktreeRemove` hooks intercept and route through `wt switch --create` and `wt remove`. Each subagent's worktree lands with worktrunk's path template, hooks fire normally, and `wt list` will show it. **Manager does not need to pre-create worktrees for subagents in this case** — `isolation: "worktree"` is enough.

The exception is the parallel-sub-Agents pattern documented in the worktrunk skill (multiple sub-Agents from one Claude Code session, each pinned to a pre-created path). That pattern is rare for SPOT and only relevant if the Manager has a specific reason to bypass Claude Code's per-agent ID naming.

What this means in practice: Manager's job is to dispatch subagents and watch the worktrees, not to babysit `wt switch` calls per Objective. Reach for `wt` directly when *Manager itself* needs a worktree (Phase-per-worktree parallelism, picking up an existing branch, merging) — not when fanning out subagents.

## Surveying worktrees

`wt list` is the Manager's dashboard. Run it before assigning Phases, between Phase closes, and any time you've lost track of state.

```bash
wt list                    # Local-only state, fast
wt list --full             # Adds CI status and per-branch line diffs
wt list --branches         # Include branches without worktrees
wt list --format=json      # For scripting
```

Status column subcolumns most worth scanning:

- **Working tree:** `+` staged, `!` modified, `?` untracked — anything here means a worktree has uncommitted work. A Phase isn't done while its worktree shows these.
- **Worktree state:** `✘` conflicts, `⤴` rebase in progress, `⤵` merge in progress — Manager intervention required.
- **Default-branch relation:** `_` same commit (clean, safe to remove), `⊂` integrated (safe to remove), `↕` diverged, `↑`/`↓` ahead/behind. Phases ready to merge usually show `↑`. Old worktrees showing `_` or `⊂` are leftovers worth cleaning up before starting new Phases.
- **Remote:** `⇡`/`⇣`/`⇅` if the branch tracks one — usually irrelevant for trunk-based SPOT but useful when picking up someone else's work.

JSON queries that pay off:

```bash
wt list --format=json | jq '.[] | select(.working_tree.modified or .working_tree.staged) | .branch'
wt list --format=json | jq '.[] | select(.operation_state == "conflicts") | .branch'
wt list --format=json | jq '.[] | select(.main_state == "integrated" or .main_state == "same_commit") | .branch'
```

If the Claude Code plugin is installed, `wt list` also shows 🤖 (subagent working) / 💬 (subagent waiting) markers per worktree — useful when Manager has multiple Phases in flight and wants to see which subagent teams are blocked.

## Creating a Phase worktree

When Manager picks up an unblocked Phase to run in its own worktree:

```bash
wt switch --create phase-<n>-<slug>    # New branch off trunk, switch into it
wt switch --create hotfix --base ^     # Explicit: off default branch
wt switch --create stack --base @      # Off current HEAD (rare for SPOT)
```

`wt switch --create` runs pre-switch and pre-start hooks (deps install, tooling setup) and backgrounds post-start hooks. Branch naming follows project convention; SPOT defaults to something readable like `phase-7-photo-uploads`.

Skip `--create` to enter an existing worktree. Bare `wt switch` opens the picker — useful interactively, less so when scripting.

Useful shortcuts:

| Shortcut | Meaning |
| --- | --- |
| `^` | Default branch (trunk) |
| `@` | Current branch |
| `-` | Previous worktree (toggle) |
| `pr:N` / `mr:N` | GitHub PR / GitLab MR branch |

```bash
wt switch -      # Bounce back to where you were
wt switch ^      # Jump to trunk worktree to inspect post-merge state
wt switch pr:42  # Pick up a PR branch (creates worktree if needed)
```

## Merging a Phase

When a Phase is fully closed — every Objective committed, TODO move folded in, working tree clean — merge with `wt merge`. It runs the full pipeline: pre-merge hooks (the local-CI gate), rebase onto target, fast-forward merge, then background worktree+branch cleanup.

```bash
wt merge                # Default: squash + rebase + ff to trunk, remove worktree
wt merge develop        # Target a non-trunk branch
wt merge --no-squash    # Preserve per-Objective commits as separate commits on trunk
wt merge --no-remove    # Keep worktree after merge
wt merge --no-ff        # Create a merge commit (semi-linear) instead of fast-forward
```

**SPOT-critical: default is squash.** That collapses the carefully-curated per-Objective commits — the linear-history story Manager spent the whole Phase building — into one commit on trunk. Almost always wrong for SPOT. Reach for `--no-squash` when the per-Objective commits earn their place in the trunk log (which is the SPOT default). Use the squash default only when the Phase produced one substantive commit anyway, or when the team explicitly wants squash-merge style on trunk.

The pipeline aborts on the first failure — pre-merge hook failure, rebase conflict, etc. — leaving the worktree intact for the Manager to fix. After fixing conflicts in the worktree, re-run `wt merge`.

For parallel Phases that both finished while Manager was elsewhere: merge them one at a time. The second's `wt merge` rebases onto the now-updated trunk automatically (still fast-forward, still no merge commit) — exactly the rebase-onto-first behavior the SPOT rule prescribes.

## Removing leftover worktrees

`wt merge` removes the worktree as part of the pipeline. Standalone `wt remove` is for the leftovers — abandoned experiments, stale parallel-Phase worktrees that got merged some other way, branches `wt list` flagged as integrated.

```bash
wt remove                          # Current worktree
wt remove old-feature              # By branch name
wt remove --no-delete-branch foo   # Drop the worktree, keep the branch
wt remove -D experimental          # Force-delete unmerged branch
wt remove --force build-artifacts  # Remove despite untracked files
```

By default, `wt remove` only deletes the branch when its content is already on trunk (six checks, including patch-id match for squash-merged branches). Branches `wt list` shows dimmed are safe targets.

Removal is backgrounded — the command returns immediately while git metadata cleanup finishes asynchronously. Use `--foreground` only when something downstream needs the cleanup to be visible (rare).

## When wt commands fail

- **`wt switch` says "branch doesn't exist"** — use `--create`, or check `wt list --branches`.
- **Hook approval prompt blocks a non-interactive run** — stop and surface to user; do *not* reach for `--yes` to silently approve project hooks. See the worktrunk skill's "Hook Approvals in Non-Interactive Sessions" section.
- **Rebase conflicts during `wt merge`** — resolve in the worktree, re-run `wt merge`. Don't switch out mid-conflict.
- **`wt list` shows a worktree with `⊟` (prunable)** — directory was deleted out-of-band; `wt remove <branch>` cleans up the metadata.
