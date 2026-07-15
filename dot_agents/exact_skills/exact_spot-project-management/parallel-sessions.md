# Parallel Sessions

Worktrees are for genuinely unrelated work happening at the same time — not a device for parallelizing a team. A team shares one worktree ([running-phases](running-phases.md#helpers)); a second worktree means a second, independent session with its own Phase.

## When to split

Split only when the seam is architectural:

- You could name each branch without mentioning the other.
- The Phases touch near-disjoint files — no shared library churn, no common schema edits.
- Each side is hours of work, enough to pay for worktree setup and fold-back.

Litmus: *would these branches merge cleanly with zero coordination?* If you have to think about it, don't split.

Examples: an API-surface Phase and a UX-surface Phase with a settled contract between them — good split. Two CLI commands that share flag-parsing helpers — one session, sequential Objectives.

The plan declares what's parallel-safe: Phases without a `**Dependencies**:` chain between them are candidates. That's necessary, not sufficient — apply the seam test on top.

## Worktree readiness

Before the first `wt switch --create` in a project, confirm the repo is worktree-ready — a fresh worktree that can't build or test is how parallel sessions rot:

- `.config/wt.toml` has `[post-start]` running `wt step copy-ignored` so deps and caches carry over instead of cold-building.
- `pre-commit` / `pre-merge` hooks cover format, lint, and typecheck, with the full test suite gated on `{{ target }}` matching the default branch so it fires at fold time, not every commit.
- Project hooks are approved — `wt config approvals add`, run interactively by the user once. Never `--yes` through approval prompts in a session.
- Anything env-shaped a build needs (local config, generated files) is covered by copy-ignored or a post-start hook.

If any of this is missing, set it up or surface it before splitting. The worktrunk skill covers the mechanics; this check is the gate.

## Handing off

From the parent session:

1. **Pick the base deliberately.** `wt switch --create` bases on the default branch; pass `--base @` to stack on the current branch when the work folds back into it rather than into main ([stacked branches](https://worktrunk.dev/tips-patterns/#stacked-branches)).

   ```bash
   wt switch --create feat/<slug> --base @ --no-cd
   ```

2. **Spawn a full session in the new worktree** — a herdr pane running the platform CLI (`claude`, `codex`, `opencode`). A handoff session is a root session in its own right: it can spawn its own helpers, which subagent recursion guards would block if it were spawned as a subagent instead. Spawn mechanics live in the herdr-sessions skill.
3. **Brief it as a Phase owner:** *"You're running Phase \<n\> (\<name\>) of \<project\> under SPOT. Load the spot-project-management skill and follow running-phases.md. Requirements: \<ids\>. Stop after the close — the parent session folds the branch."*

## Monitoring and completion

The parent session stays the judge of done:

- herdr's agent-state integration shows working vs idle per pane — wait on idle rather than polling blind.
- Verify readiness with worktrunk: clean tree, branch ahead of its base.

  ```bash
  wt list --format=json | jq '.[] | select(.branch == "feat/<slug>")'
  ```

- Idle with a dirty tree or no commits means blocked or waiting on input — check the pane; don't assume done.

## Folding back

1. Review the branch from the parent session: log, whole-branch diff, the Phase's requirement IDs.
2. Fold with worktrunk from the child worktree — no squash; the per-Objective commit story is the point:

   ```bash
   wt merge --no-squash <target>    # main, or the parent feature branch when stacked
   ```

   The pipeline rebases onto the target, runs pre-merge hooks, fast-forwards, and removes the worktree. On failure it aborts in place — fix in the worktree, re-run.
3. `TODO.md`/`DONE.md` conflicts between parallel Phases resolve toward the later state: DONE accumulates, TODO shrinks. Surface anything ambiguous.
4. Fold finished branches one at a time; the second rebases onto the updated target automatically.

Leftovers (abandoned experiments, already-integrated branches flagged by `wt list`) go through `wt remove`. Broken git states go to `medic`.
