# Using worktrunk

Worktrunk (`wt`) is the worktree-and-merge layer. When it's installed in a project, **`wt` is the Manager's primary git interface** — creating worktrees, surveying state, gating quality with hooks, and closing both Objectives and Phases through merge pipelines that commit, rebase, fast-forward, and clean up. SPOT's parallel-Phase model lives or dies on coherent worktree state; `wt list` is how a Manager sees it, and `wt merge` is how every level closes cleanly.

Raw `git` stays in the toolbox for what `wt` doesn't cover — `git status`, `git log`, `git diff`, the occasional `git rebase -i` to clean unpushed history, one-off rescues. See [What stays raw git](#what-stays-raw-git) below for the short list.

Detect availability with `wt --version`. If absent, fall back to plain `git worktree` and skip this doc.

## Two merge levels: Phase trunk branches and Objective feature branches

SPOT under worktrunk uses two levels of branch+worktree, mapped onto familiar git concepts:

| Level | Branch role | Naming | Off | When complete | Squash? |
| --- | --- | --- | --- | --- | --- |
| **Phase trunk branch** | Acts as the temporary trunk for one Phase's Objectives | `phase-<n>-<slug>` | main | `wt merge --no-squash` to main at Phase close | **No** — preserve per-Objective story on main |
| **Objective feature branch** | One Subagent's lane within a Phase | `obj-<slug>` (or platform default like `agent-<id>`) | Phase trunk (or main, see platform docs) | `wt merge phase-<n>-<slug>` from the Objective worktree on Subagent close | **Yes** (default) — collapse Subagent's commits into one Objective commit on Phase trunk |

The two levels mirror trunk-based development one layer down: the Phase trunk is to the Objective what main is to the Phase trunk. The same `wt merge` pipeline runs at both levels with different squash defaults.

This is the keystone of the Manager's git workflow — almost every raw-git pattern (interactive rebase, manual fixup chains, hand-rolled merge commits) collapses into "run the right `wt merge` at the right level."

## Agent Teams: the SPOT default

Every Phase gets a team. Manager fans Objectives across Subagents in parallel via the platform's internal sub-agent mechanism — this is how SPOT works, not an "advanced" pattern.

Per-platform spawn syntax and integration details live in `platforms/`:

- [Claude Code](platforms/claude-code.md) — full integration: `Agent { isolation: "worktree" }` routes through `wt switch --create` automatically; commit guard hook; activity tracking.
- [OpenCode](platforms/opencode.md) — partial integration in progress; uses pre-create + dispatch pattern.

When adding a new SPOT-capable platform, drop a `platforms/<name>.md` file alongside these and reference it from this section.

## Agent Handoff: out-of-band only

Worktrunk's skill documents a tmux/Zellij "handoff" pattern — `wt switch --create -x <agent-cli>` spawns a new agent session inside a pre-created worktree. **This is not the SPOT default and should not be used unless the user explicitly instructs it.**

The distinction matters:

- **Agent Teams** (default): Manager spawns Subagents *inside the current session* via the platform's Agent tool. One conversation, one Manager, fan-out into parallel Subagents whose worktrees are tracked by `wt list`. This is what every Phase uses.
- **Agent Handoff** (rare, explicit): A separate session is spawned in a tmux pane / Zellij tab, with its own agent loop. Used for higher-level orchestration (e.g. an Executive spawning Manager sessions, one per Phase, across tmux panes — see [EXECUTIVE.md](EXECUTIVE.md) for the speculative shape) or when a user wants to hand off and continue elsewhere.

If you find yourself reaching for tmux to spawn Subagents within a single Phase, stop — that's an Agent Team, not a Handoff. Use the platform's internal mechanism.

## Surveying worktrees

`wt list` is the Manager's dashboard. Run it before assigning Phases, between Phase closes, and any time you've lost track of state.

```bash
wt list                    # Local-only state, fast
wt list --full             # Adds CI status and per-branch line diffs
wt list --branches         # Include branches without worktrees
wt list --format=json      # For scripting
```

Status column subcolumns most worth scanning:

- **Working tree:** `+` staged, `!` modified, `?` untracked — anything here means a worktree has uncommitted work. An Objective or Phase isn't done while its worktree shows these.
- **Worktree state:** `✘` conflicts, `⤴` rebase in progress, `⤵` merge in progress — Manager intervention required.
- **Default-branch relation:** `_` same commit (clean, safe to remove), `⊂` integrated (safe to remove), `↕` diverged, `↑`/`↓` ahead/behind. Phase trunks ready to close usually show `↑`. Old worktrees showing `_` or `⊂` are leftovers worth cleaning up before starting new Phases.
- **Remote:** `⇡`/`⇣`/`⇅` if the branch tracks one — usually irrelevant for trunk-based SPOT.

JSON queries that pay off:

```bash
wt list --format=json | jq '.[] | select(.working_tree.modified or .working_tree.staged) | .branch'
wt list --format=json | jq '.[] | select(.operation_state == "conflicts") | .branch'
wt list --format=json | jq '.[] | select(.main_state == "integrated" or .main_state == "same_commit") | .branch'
```

If a platform plugin is installed (Claude Code today), `wt list` also shows 🤖 (Subagent working) / 💬 (Subagent waiting) markers per worktree.

## Creating a Phase trunk branch

When Manager picks up an unblocked Phase to run:

```bash
wt switch --create phase-<n>-<slug>    # New branch off main, switch into it
```

`wt switch --create` defaults `--base` to the default branch (main), runs pre-switch and pre-start hooks (deps install, tooling setup), and backgrounds post-start hooks. The Phase trunk worktree is the Manager's home for the Phase — this is where context-reading happens, where Subagents merge their Objectives back into, and where the Phase close runs from.

Edge case: stacking a dependent Phase on top of one still in flight (waiting on PR review of the parent Phase) — explicit, deliberate, rare:

```bash
wt switch --create phase-<m>-<slug> --base phase-<n>-<slug>    # Stack on parent Phase trunk
```

Don't stack by default. Use only when the Phases genuinely sequence and you can't wait for the parent to land on main.

Useful shortcuts:

| Shortcut | Meaning |
| --- | --- |
| `^` | Default branch (main) |
| `@` | Current branch |
| `-` | Previous worktree (toggle) |
| `pr:N` / `mr:N` | GitHub PR / GitLab MR branch |

```bash
wt switch -      # Bounce back to where you were
wt switch ^      # Jump to main worktree to inspect post-merge state
wt switch pr:42  # Pick up a PR branch (creates worktree if needed)
```

## Closing an Objective

When a Subagent finishes its Objective (committed, clean tree, commit guard satisfied), Manager merges the Objective feature branch into the Phase trunk:

```bash
# From the Objective's worktree (or use -C <path> from elsewhere)
wt merge phase-<n>-<slug>
```

What `wt merge` does at this level (default squash):

1. Commits any uncommitted changes (Manager's TODO checkoff edits get folded in here)
2. Squashes everything since branching from Phase trunk into one commit (LLM-generated message; Manager can pre-control with `wt step commit` first if precise wording matters)
3. Rebases onto Phase trunk if it's moved (other Objectives merged ahead)
4. Runs `pre-merge` hooks — fast checks (lint/typecheck) at this level; full test suite is gated by `{{ target }}` in the recommended config so it doesn't run per-Objective
5. Fast-forwards Phase trunk
6. Removes the Objective worktree+branch

Result on Phase trunk: one well-named commit per Objective. **No fixups, no `git commit --fixup`** — the squash absorbs Subagent commits + Manager's TODO checkoff edits in one move.

## Closing a Phase

When all Objectives are squashed onto Phase trunk and the Manager is back in the Phase trunk worktree, promote and close:

```bash
# In the Phase trunk worktree, edit TODO.md → DONE.md (and any `docs/` updates),
# then:
wt merge --no-squash
```

What `wt merge --no-squash` does at this level:

1. Commits any uncommitted changes (the TODO→DONE move + spec/doc edits land as one Phase-close commit)
2. **Skips squash** — preserves per-Objective commits as the linear-history story on main
3. Rebases onto main if behind
4. Runs `pre-merge` hooks — at this level `{{ target }} == main`, so the full suite gates here
5. Fast-forwards main
6. Removes Phase trunk worktree+branch

Result on main: per-Objective commits + one `chore(spot):` Phase-close commit (or `chore(specs):` if the close threaded spec edits back). Clean, narrative, rebase-friendly.

**Always pass `--no-squash` at this level.** The default squash collapses the whole Phase into one commit, losing the per-Objective story Manager spent the Phase building.

```bash
wt merge --no-squash develop      # Target a non-trunk branch (rare)
wt merge --no-squash --no-remove  # Keep Phase trunk worktree after merge (rare; debugging)
```

The pipeline aborts on the first failure — pre-merge hook failure, rebase conflict, etc. — leaving the worktree intact. Fix in the worktree, re-run `wt merge`. Don't switch out mid-conflict.

For parallel Phases that both finished while Manager was elsewhere: close them one at a time. The second's `wt merge` rebases onto the now-updated main automatically — still fast-forward, still no merge commit. Manager doesn't run `git rebase` for this.

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

## Recommended SPOT project config

This is the slice every SPOT project should set in `.config/wt.toml` — the SPOT-shaped baseline that makes the Phase trunk / Objective feature branch flow run cleanly. Other worktrunk optimizations (path templates, copy-ignored tuning, dev-server-per-worktree, per-branch vars) are project-specific and live in the worktrunk skill.

```toml
# Subagent worktrees (and the Phase trunk worktree) inherit caches/deps without
# a slow first build. Reflink-based on macOS/Linux when possible — typically
# seconds, not minutes.
[post-start]
copy = "wt step copy-ignored"

# Per-Objective commit gate: fast checks the Subagent can clear in seconds.
# Hard-fails the commit, so drift gets caught at the boundary it was created at.
[pre-commit]
fmt = "<formatter check>"            # e.g. "cargo fmt --check", "pnpm prettier --check ."
lint = "<linter>"                    # e.g. "cargo clippy -- -D warnings", "pnpm eslint ."
typecheck = "<typechecker>"          # e.g. "pnpm tsc --noEmit"

# Pre-merge runs at every wt merge — Objective→Phase trunk AND Phase trunk→main.
# Branch on {{ target }} so expensive checks only fire at the Phase close,
# not at every Objective merge.
[pre-merge]
lint = "npm run lint"
typecheck = "npm run typecheck"
test = """
if [ {{ target }} = main ]; then
    npm test
fi
"""
```

The `{{ target }}` conditional is the load-bearing trick: same hook block fires at both merge levels, but expensive work only runs when targeting main. Adapt the `if` to whatever names your default branch (`master`, `trunk`, etc.).

**Hooks are necessary, not sufficient.** Managers still run targeted tests against the requirement IDs they're verifying at Objective close, and the full suite (or whatever fits the work) when reviewing a Phase before closing it. `pre-merge` hooks catch mechanical regressions and the safety floor; they don't tell you whether a requirement is actually satisfied — that's Manager job-3.

How this maps onto the Manager's three jobs:

- **`pre-commit` is job-3 quality at Objective creation, automated.** Format/lint/typecheck are mechanical — Manager doesn't eyeball them. Hooks fail the commit; the Subagent fixes and re-tries. Manager job-3 reduces to *the things hooks can't catch*: requirement coverage, naming, comment cruft, drift.
- **`pre-merge` (target ≠ main) is the per-Objective gate at Objective→Phase merge.** Lint/typecheck repeated as a safety net.
- **`pre-merge` (target = main) is the local-CI gate at Phase close.** Tests, security scans, expensive builds — anything you'd run in remote CI. Aborts the pipeline on failure and leaves the worktree intact.
- **`post-start` `wt step copy-ignored`** matters most for SPOT because Subagent fan-out creates many fresh worktrees concurrently. Skipping cold starts on each pays off quickly.

Two project knobs worth setting deliberately:

```toml
# Stage tracked changes only by default. Less surprising than "all" when
# Subagents leave untracked scratch files; SPOT-managed files (TODO, DONE,
# specs) are tracked.
[commit]
stage = "tracked"
```

Project hooks need explicit approval the first time `wt` runs them. **Run `wt config approvals add` once after configuring** (interactively, as the user) so Subagents and Managers don't hit non-interactive approval prompts mid-Phase. Don't reach for `--yes` to silently approve project hooks — see the worktrunk skill's "Hook Approvals in Non-Interactive Sessions".

## What stays raw git

`wt` covers worktree lifecycle and both merge levels. The raw-git surface for a SPOT Manager is genuinely small:

| Use case | Tool |
| --- | --- |
| Inspecting state | `git status`, `git log`, `git diff`, `wt step diff` (whole-branch view) |
| Cleaning local history before close (squash WIP, sharpen subjects, drop spec-only commits before Phase→main) | `git rebase -i <merge-base>` |
| Recovering from a wt pipeline abort | `git status` to inspect, then re-run `wt merge` after fix |
| One-offs (`git stash`, cherry-pick, blame, etc.) | Raw git, as needed |

If you find yourself reaching for `git worktree add`, `git push`, `git merge`, `git rebase <branch>`, or `git commit --fixup` for routine SPOT work — stop. Those paths are `wt switch --create` and `wt merge` (at the right level). Raw git for integration loses the hook gating, the squash/rebase/ff pipeline, and the cleanup.

## When wt commands fail

- **`wt switch` says "branch doesn't exist"** — use `--create`, or check `wt list --branches`.
- **Hook approval prompt blocks a non-interactive run** — stop and surface to user; do *not* reach for `--yes` to silently approve project hooks. See the worktrunk skill's "Hook Approvals in Non-Interactive Sessions" section.
- **Rebase conflicts during `wt merge`** — resolve in the worktree, re-run `wt merge`. Don't switch out mid-conflict.
- **`wt list` shows a worktree with `⊟` (prunable)** — directory was deleted out-of-band; `wt remove <branch>` cleans up the metadata.
