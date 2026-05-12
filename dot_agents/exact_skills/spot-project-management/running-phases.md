# Running Phases

Manager work. Coordinate Phases, keep history clean, hand off cleanly to Planner.

When worktrunk is installed, the Manager's git surface is two `wt merge` invocations: one to close each Objective onto the Phase trunk branch, one to close the Phase trunk branch onto main. See [using-worktrunk](using-worktrunk.md) for the underlying mechanics; this doc is the workflow.

## The Manager's three jobs

In priority order:

1. **Sequencing.** Read every Phase in `TODO.md` before assigning anyone. Map dependencies. Pick the right level of parallelism — enough to move efficiently, not so much that the diff becomes incoherent. Independent Phases run in parallel across Manager sessions; Objectives within a Phase always run in parallel as a Subagent team. Single-threaded plans are a last resort.
2. **Linear git history that tells the story.** This is the hardest part of the job and the most important. Subjects are concise and specific. Conventional types stay consistent across similar work — three Objective commits in one Phase shouldn't span `feat`, `chore`, `refactor` for the same kind of change. Sizes don't whipsaw. The Phase close is one `chore(spot)` (or `chore(specs)`) commit on top of the per-Objective story. Future readers (humans and agents) trace the project through the log; if it doesn't read clearly, the work is harder to build on.
3. **Quality at Objective close.** Not line-by-line review — does it meet the requirements? Did the Subagent stay on the agreed names? Did they leave a pile of code comments where the structure should have done the work? Tests, lint, formatter, typecheck — *if* `wt` `pre-commit` and `pre-merge` hooks are configured (see [using-worktrunk](using-worktrunk.md#recommended-spot-project-config)), they fail closed at the boundary, freeing job-3 review to focus on what hooks can't catch. If anything's off: **roll back and re-assign the Objective.** Don't try to patch a sloppy Subagent commit on top — `wt merge` will squash it into a single Objective commit anyway, so a clean re-run produces a clean result.

## Phases are teams, Objectives are agents

Two distinct units, two distinct boundaries:

- **An Objective is a parallel work unit — one Subagent's lane.** Within a Phase, Objectives are designed to map one-to-one onto Subagents on the team. That isn't incidental, it's the entire point of the structure. If you find yourself running Objectives sequentially in one thread, either you're misreading the plan or the Objectives are really one Objective with sequential Tasks (kick that back to Planner).
- **A Phase is a context boundary — one team's worth of work.** Phases often *do* run in parallel across Manager sessions, but they don't have to. The Phase boundary is the natural place to compact or clear context entirely and assemble a fresh team for the next one — every Phase begins by reading `SPEC.md`, the Phase's requirement IDs, and the relevant durable specs, which is enough to pick up cold. That's the value of the boundary: clean restart points all the way down the project.

Default: every Phase gets a small Subagent team, one Subagent per Objective, working in parallel. Skip the team only when Objectives have heavy real sequential dependencies (rare — usually a sign the plan needs splitting), or the entire Phase is so small that team coordination overhead exceeds the work itself. Per-platform spawn syntax lives in [using-worktrunk#agent-teams](using-worktrunk.md#agent-teams-the-spot-default).

## Survey before assigning

Before dispatching any work:

1. Read **all** Phases in `TODO.md`, not just the next one. Note every `**Dependencies**:` line.
2. Identify which Phases are unblocked. Multiple may be 🌀 at once when independent.
3. Pick what to run now. A single Manager session typically holds one Phase at a time — running multiple parallel Phases means multiple Manager sessions (see [parallel Phases](#parallel-phases-across-manager-sessions)).
4. For the picked Phase, create the Phase trunk branch worktree: `wt switch --create phase-<n>-<slug>`.
5. Fan its Objectives out across a Subagent team.
6. As the Phase closes and lands on main, pick the next unblocked Phase and repeat.

`wt list` is the worktree dashboard — run it before, between, and after Phase work to spot dirty trees, conflicts, integrated leftovers, and (when a platform plugin is installed) which Subagent teams are working vs waiting. See [using-worktrunk](using-worktrunk.md#surveying-worktrees) for the columns worth scanning.

## Workflow per Phase

1. **Confirm unblocked.** Every Phase listed in `**Dependencies**:` must already be in DONE — fully promoted, not just merged to a branch. If something's still pending, pick a different Phase or surface the block.
2. **Create the Phase trunk branch.** `wt switch --create phase-<n>-<slug>`. This is the Manager's home for the Phase; everything else happens off this worktree.
3. **Read context.** `SPEC.md` for vibe/goals/non-goals/vocabulary. The Phase's `**Requirements**:` line in `TODO.md`. Each listed ID's wording in its durable spec (`SPEC.md` for `R<NNN>`, `specs/<dom>-*.md` for `<dom>-R<NNN>`).
4. **Validate.** No requirements listed, or IDs don't cover the Tasks → stop, kick to Planner. Managers don't pick requirement IDs from scratch.
5. **Sharpen for execution.** Adjust Objective and Task wording so Subagents can act without a huddle. Don't change *what's being built* — that's a Planner edit. If the Phase title or any Objective carries vague or echoed-from-the-user wording, propose a sharper name with the user before assigning ([naming](../../rules/naming.md)).
6. **Dispatch.** One Subagent per Objective, in parallel, via the platform's Agent tool with worktree isolation. Brief each on the Objective's Tasks plus the requirement IDs they're responsible for satisfying.
7. **Close each Objective.** When a Subagent finishes (commit guard satisfied — see [per-commit flow](#per-commit-flow-inside-a-phase)), Manager reviews the diff, edits TODO.md to check off Tasks, then runs `wt merge phase-<n>-<slug>` from the Objective worktree. Squash auto-collapses Subagent commits + TODO checkoffs into one Objective commit on Phase trunk. Pre-merge hooks gate the merge.
8. **Promote to DONE.** When all Objectives are squashed onto Phase trunk, edit `TODO.md` and `DONE.md` in the Phase trunk worktree: move the Phase block, header verbatim with `✅`, Objectives and Tasks verbatim with checked boxes, Phase-level narrative under the header. Leave the edits dirty.
9. **Capture context.** Update `docs/` for current-state changes; index new files from `CLAUDE.md`/`AGENTS.md`. Append surfaced harness/tooling needs to the right `dev-*` spec. Leave dirty alongside the DONE move.
10. **Close the Phase to main.** From the Phase trunk worktree: `wt merge --no-squash`. Wt commits the dirty TODO/DONE/spec/doc edits as one Phase-close commit, preserves per-Objective commits, runs `pre-merge` hooks (full suite gates here), rebases onto main if behind, fast-forwards, removes Phase trunk worktree+branch. See [using-worktrunk#closing-a-phase](using-worktrunk.md#closing-a-phase).
11. **Hand off to Planner.** What shipped, satisfied IDs, surprises worth folding into durable specs, new Backlog items.

## Per-commit flow inside a Phase

The cadence is much simpler under the Phase trunk model than it looks at first — most of what was previously a fixup-and-rebase dance is now absorbed by `wt merge`'s squash at Objective close.

1. **Subagent finishes an Objective** → commits their work as one or more conventional commits on the Objective feature branch. Platform commit guard hooks (Claude Code's `require-teammate-commit`) gate Subagent task completion on at-least-one-commit + clean-tree. If `pre-commit` hooks are configured (format/lint/typecheck), they fail the commit closed at this boundary.
2. **Manager reviews the diff** against the requirement IDs and the job-2/job-3 quality checks. If issues:
   - Trivial (typo, missing import, stray comment) → Manager fixes inline, commits as a follow-up on the Objective feature branch — `wt merge`'s squash will absorb it.
   - Material (wrong approach, drifted off requirements, named the wrong thing, comment cruft) → roll back the Objective and re-assign. See [Subagent drift](#subagent-drift).
3. **Manager checks off the Tasks in `TODO.md`** in the Objective worktree, leaves the edit dirty.
4. **Manager runs `wt merge phase-<n>-<slug>`** from the Objective worktree. Wt:
   - Commits the dirty TODO checkoff
   - Squashes everything since branching from Phase trunk into one well-named Objective commit (LLM-generated message; pre-control with `wt step commit` if precise wording matters)
   - Rebases onto Phase trunk, runs `pre-merge` hooks (lint/typecheck only at this level), fast-forwards, removes Objective worktree+branch
5. **Repeat for each Objective.** Phase trunk accumulates one well-named Objective commit per Subagent.
6. **When all Objectives are on Phase trunk** → Manager (back in Phase trunk worktree) edits `TODO.md`/`DONE.md` to promote the Phase, edits `docs/` if needed, leaves dirty.
7. **Manager runs `wt merge --no-squash`** from the Phase trunk worktree. Wt commits the dirty close edits as one `chore(spot):` (or `chore(specs):` if spec edits ride along) commit, preserves per-Objective commits, runs `pre-merge` hooks (full suite gates here), rebases onto main if behind, fast-forwards, removes Phase trunk worktree+branch.
8. **Working tree is clean and the Phase trunk is gone.** Pick up the next unblocked Phase.

**Never start a new Phase on a dirty tree or with stale Phase-trunk worktrees lying around.** Reconstructing linear history after burning through several incomplete Phases is wasteful and error-prone — easily avoided by closing each Phase fully before moving on. `wt list` shows the state; check it.

## Spec-only commits — when they earn their keep

Pure `chore(specs)` commits are a *bend*, not a default. The aim is meaningful linear history; spec-only commits should be rare *because* of that aim, not as an arbitrary prohibition. The bar: would a future reader scanning the log learn something they couldn't get from the surrounding behavior commits?

Legitimate cases:

- **Threading learning back into specs/requirements** after a Phase — new edge-case ID, sharpened wording, a retired ID. Often rides along in the Phase-close commit naturally; only a separate commit if it's substantial enough to warrant its own.
- **Scoping a multi-Phase plan in `TODO.md`** ahead of any code landing — Planner work between Phases.
- **Catching up DONE rationale** for a stretch of work that already shipped without proper closeout (e.g. things went off the rails and several Phases need to be moved to DONE with proper notes).
- **Landing a retrospective ADR** ([adrs](adrs.md)) — recording the rationale for a direction change that already shipped without one. Commit as `chore(adr): <slug>`.

Illegitimate cases:

- Pure `TODO.md` checkoffs. → Should never get to a separate commit; the Objective merge absorbs them.
- "Updated DONE.md" alone with nothing narrative-worthy. → Rides along in the Phase-close commit.
- Bookkeeping you simply forgot to fold in. → Reset and let `wt merge` capture it.

When in doubt, ask: *will the next agent reading this commit learn something they need?* If no, it doesn't earn the line.

If a spec-only commit lands on the Phase trunk and shouldn't ride to main, drop it via `git rebase -i <merge-base>` before running the Phase-close `wt merge`. This is one of the legitimate uses of raw interactive rebase — see [What stays raw git](using-worktrunk.md#what-stays-raw-git).

## Test-driven by default

Red-green TDD unless the project says otherwise or the work is genuinely too small. Requirements are the source of truth; tests make them machine-verifiable.

SPOT-specific:

- **Squishy requirements** ("feels responsive", "helpful errors") — implement, review, iterate. Document the judgment in DONE.
- **Harness gaps** — if a requirement *would* be testable but the rig isn't there (no Playwright, no fixture, no perf bench), kick to Planner to scope a `dev-` Phase for the missing harness. Don't silently skip.
- **Genuinely untestable** signals the requirement is still vague — kick to Planner.

Subagents own TDD per Objective. Manager verifies during job-3 quality checks at Objective close.

## Subagent drift

If a Subagent completes an Objective incorrectly, **roll back and re-assign.** Don't mutate the plan to match bad output. If the bad output reveals a real spec or wording problem, kick to Planner first; only then re-run.

Common drift signals worth catching at review:

- Code packed with comments where the structure should explain itself ([code-comments](../../rules/code-comments.md)).
- Names that echo casual user phrasing rather than the agreed sharpened ones ([naming](../../rules/naming.md)).
- A passing test suite that doesn't actually exercise the listed requirement IDs.
- A subject line (or LLM-generated squash message) that doesn't tell the next reader what the commit accomplishes.

Rolling back a not-yet-merged Objective: `wt remove --force <obj-branch>` from anywhere drops the worktree+branch; re-dispatch the Subagent with sharper guidance.

## Parallel Phases across Manager sessions

Multiple Phases without mutual dependencies can run in parallel — typically one Manager session per Phase, each on its own Phase trunk branch. The 🌀 marker can apply to several Phases at once.

A single Manager session typically runs one Phase at a time, because the Subagent team it spawns inherits the current worktree's branch as the merge target. Multi-Phase orchestration from one place is the Executive's job — see [EXECUTIVE.md](EXECUTIVE.md) for the speculative shape.

When two parallel Phases land on main:

- **`wt merge --no-squash` handles rebase-onto-main automatically.** Each Phase closes with its own merge from its Phase trunk worktree. The first lands main-clean; the second's pipeline rebases onto the now-updated main and fast-forwards. No Manager-driven rebase, no merge commit. Without worktrunk, Manager rebases manually before fast-forwarding back.
- **`TODO.md` / `DONE.md` conflicts** are common — both Phases edited the same files. Resolve by accepting the later state (DONE accumulates; TODO shrinks). Surface anything ambiguous.
- **Spec touches go to Planner.** If both Phases needed to amend the same durable spec mid-flight, that's a Planner coordination point, not a Manager rebase decision.

## Manager-side commit hygiene

The Manager's git surface is small when worktrunk is wired up: Subagents commit, `wt merge` at the Objective level squashes, `wt merge --no-squash` at the Phase level closes. Beyond that:

- **Raw `git rebase -i` is for cleaning local history before close** — squash messy WIP, sharpen drifted subjects, reorder commits, drop spec-only commits before Phase→main. Fair game on unpushed or solo-feature-branch work; never on shared history.
- Subjects stay concise and specific; bodies are 3-5 bullets max if any. See [git-commits](../../rules/git-commits.md). For LLM-generated squash messages from `wt merge`, Manager spot-checks and overrides via `wt step commit` first when the diff is misleading.
- Spec changes that alter intent are authored by the Planner (Planner can't commit; Manager commits on Planner's behalf, attributing in the message body when worth noting).
