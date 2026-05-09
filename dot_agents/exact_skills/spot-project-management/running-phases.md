# Running Phases

Manager work. Coordinate Phases, keep history clean, hand off cleanly to Planner.

## The Manager's three jobs

In priority order:

1. **Sequencing.** Read every Phase in `TODO.md` before assigning anyone. Map dependencies. Pick the right level of parallelism — enough to move efficiently, not so much that the diff becomes incoherent. Independent Phases run in parallel across worktrees; Objectives within a Phase always run in parallel. Single-threaded plans are a last resort.
2. **Linear git history that tells the story.** This is the hardest part of the job and the most important. Subjects are concise and specific. Conventional types stay consistent across similar work — three subagent commits in one Phase shouldn't span `feat`, `chore`, `refactor` for the same kind of change. Sizes don't whipsaw. Subagent commits get TODO checkoffs fixup'd in. The Phase close is one atomic commit with the move to DONE folded in. Future readers (humans and agents) trace the project through the log; if it doesn't read clearly, the work is harder to build on.
3. **Quality at Objective close.** Not line-by-line review — does it meet the requirements? Tests pass? Lint and formatter clean (pre-commit hooks help)? Did the subagent stay on the agreed names? Did they leave a pile of code comments where the structure should have done the work? If anything's off: **fixup, never another commit on top.** Once a sloppy commit gets built on, fixing it cleanly gets much harder.

## Phases are teams, Objectives are agents

Two distinct units, two distinct boundaries:

- **An Objective is a parallel work unit — one subagent's lane.** Within a Phase, Objectives are designed to map one-to-one onto subagents on the team. That isn't incidental, it's the entire point of the structure. If you find yourself running Objectives sequentially in one thread, either you're misreading the plan or the Objectives are really one Objective with sequential Tasks (kick that back to Planner).
- **A Phase is a context boundary — one team's worth of work.** Phases often *do* run in parallel across worktrees with separate Managers, but they don't have to. The Phase boundary is the natural place for a Manager to compact or clear context entirely and assemble a fresh team for the next one — every Phase begins by reading `SPEC.md`, the Phase's requirement IDs, and the relevant durable specs, which is enough to pick up cold. That's the value of the boundary: clean restart points all the way down the project. Phases aren't strictly parallel because they're context boundaries first, parallelism opportunities second.

Default: every Phase gets a small agent team, one subagent per Objective, working in parallel. Skip the team only when Objectives have heavy real sequential dependencies (rare — usually a sign the plan needs splitting), or the entire Phase is so small that team coordination overhead exceeds the work itself.

## Survey before assigning

Before dispatching any work:

1. Read **all** Phases in `TODO.md`, not just the next one. Note every `**Dependencies**:` line.
2. Identify which Phases are unblocked. Multiple may be 🌀 at once when independent.
3. Pick what to run now — typically 1-2 Phases in parallel for one Manager. If 4 are unblocked, pick 2 to start, queue the rest. Each parallel Phase wants its own worktree and feature branch off trunk.
4. For each picked Phase, fan its Objectives out across a subagent team.
5. As Phases finish and promote to DONE, pick from the still-unblocked queue and fan out again.

## Workflow per Phase

1. **Confirm unblocked.** Every Phase listed in `**Dependencies**:` must already be in DONE — fully promoted, not just merged to a branch. If something's still pending, pick a different Phase or surface the block.
2. **Read context.** `SPEC.md` for vibe/goals/non-goals/vocabulary. The Phase's `**Requirements**:` line in `TODO.md`. Each listed ID's wording in its durable spec (`SPEC.md` for `R<NNN>`, `specs/<dom>-*.md` for `<dom>-R<NNN>`).
3. **Validate.** No requirements listed, or IDs don't cover the Tasks → stop, kick to Planner. Managers don't pick requirement IDs from scratch.
4. **Sharpen for execution.** Adjust Objective and Task wording so subagents can act without a huddle. Don't change *what's being built* — that's a Planner edit. If the Phase title or any Objective carries vague or echoed-from-the-user wording, propose a sharper name with the user before assigning ([naming](../../rules/naming.md)).
5. **Dispatch.** One subagent per Objective, in parallel. Brief each on the Objective's Tasks plus the requirement IDs they're responsible for satisfying.
6. **Iterate.** Each Objective lands when the subagent commits, all Tasks under it are done, and every applicable requirement ID has a passing test (or a documented squishy/harness-gap judgment — see TDD section).
7. **Close the Phase.** Move the Phase block from `TODO.md` to `DONE.md`: header verbatim with `✅`, Objectives and Tasks verbatim with checked boxes, Phase-level narrative under the header. Fold that change into the Phase's last substantive commit (fixup), or — if the close also threads spec updates back — into a `chore(specs)` commit (see below).
8. **Capture context.** Update `docs/` for current-state changes; index new files from `CLAUDE.md`/`AGENTS.md`. Append surfaced harness/tooling needs to the right `dev-*` spec.
9. **Hand off to Planner.** What shipped, satisfied IDs, surprises worth folding into durable specs, new Backlog items.

## Per-commit flow inside a Phase

The cadence agents must run, in order:

1. **Subagent finishes an Objective** → commits their work as one conventional commit. The hook may enforce this; either way, no commit means the Objective isn't done.
2. **Manager reviews the diff** against the requirement IDs and the job-2/job-3 quality checks. If issues:
   - Trivial (typo, missing import, stray comment) → Manager fixup into the subagent's commit.
   - Material (wrong approach, drifted off requirements, named the wrong thing, comment cruft) → roll back the Objective and re-assign. See "Subagent drift".
3. **Manager checks off the Tasks in `TODO.md`** → fixup into the subagent's commit. No standalone TODO commit.
4. **When all Objectives in the Phase are done** → Manager moves the Phase block to `DONE.md` and fixups that change into the Phase's last substantive commit. Result: every Phase ends in one atomic commit per Objective, the last of which carries the DONE move.
5. **If the close also threads spec/requirement updates back** (a learning surfaced a clarification, an emergent requirement got a new ID), bundle those edits with the DONE move into a single `chore(specs)` commit instead of a fixup. That's one of the legitimate spec-only commits — see below.
6. **If the Phase produced `docs/` updates,** commit those as a separate `docs` commit. Project docs evolve independently of behavior commits.
7. **Working tree is clean.** Now you can pick up the next unblocked Phase.

**Never start a new Phase on a dirty tree.** Reconstructing linear history after burning through several Phases is wasteful and error-prone — easily avoided by closing each Phase fully before moving on.

## Spec-only commits — when they earn their keep

Pure `chore(specs)` commits are a *bend*, not a default. The aim is meaningful linear history; spec-only commits should be rare *because* of that aim, not as an arbitrary prohibition. The bar: would a future reader scanning the log learn something they couldn't get from the surrounding behavior commits?

Legitimate cases:

- **Threading learning back into specs/requirements** after a Phase — new edge-case ID, sharpened wording, a retired ID.
- **Scoping a multi-Phase plan in `TODO.md`** ahead of any code landing.
- **Catching up DONE rationale** for a stretch of work that already shipped without proper closeout (e.g. things went off the rails and several Phases need to be moved to DONE with proper notes).

Illegitimate cases:

- Pure `TODO.md` checkoffs. → fixup into the substantive commit.
- "Updated DONE.md" alone with nothing narrative-worthy. → fixup.
- Bookkeeping you simply forgot to fold in. → fixup or amend.

When in doubt, ask: *will the next agent reading this commit learn something they need?* If no, it doesn't earn the line.

## Test-driven by default

Red-green TDD unless the project says otherwise or the work is genuinely too small. Requirements are the source of truth; tests make them machine-verifiable.

SPOT-specific:

- **Squishy requirements** ("feels responsive", "helpful errors") — implement, review, iterate. Document the judgment in DONE.
- **Harness gaps** — if a requirement *would* be testable but the rig isn't there (no Playwright, no fixture, no perf bench), kick to Planner to scope a `dev-` Phase for the missing harness. Don't silently skip.
- **Genuinely un-testable** signals the requirement is still vague — kick to Planner.

Subagents own TDD per Objective. Manager verifies during job-3 quality checks at Objective close.

## Subagent drift

If a subagent completes an Objective incorrectly, **roll back and re-assign.** Don't mutate the plan to match bad output. If the bad output reveals a real spec or wording problem, kick to Planner first; only then re-run.

Common drift signals worth catching at review:

- Code packed with comments where the structure should explain itself ([code-comments](../../rules/code-comments.md)).
- Names that echo casual user phrasing rather than the agreed sharpened ones ([naming](../../rules/naming.md)).
- A passing test suite that doesn't actually exercise the listed requirement IDs.
- A subject line that doesn't tell the next reader what the commit accomplishes.

## Parallel Phases across worktrees

Multiple Phases without mutual dependencies can run in parallel — typically one Manager per Phase, each on its own worktree and feature branch off trunk. The 🌀 marker can apply to several Phases at once.

When two parallel Phases land:

- **Second to land rebases onto first.** Fast-forward only. Never a merge commit.
- **`TODO.md` / `DONE.md` conflicts** are common — both Phases edited the same file. Resolve by accepting the later state (DONE accumulates; TODO shrinks). Surface anything ambiguous.
- **Spec touches go to Planner.** If both Phases needed to amend the same durable spec mid-flight, that's a Planner coordination point, not a Manager rebase decision.

When the project uses worktrunk (`wt --version` works), drive worktree creation, surveying, and merge-time cleanup through `wt` rather than raw `git worktree` — see [using-worktrunk](using-worktrunk.md) for the patterns that matter to a Manager. Subagent teams spawned with `Agent { isolation: "worktree" }` get routed through `wt` automatically by the Claude Code plugin; Manager only invokes `wt` directly for Phase-scoped worktrees and the `wt merge` close.

## Manager-side commit hygiene

Beyond the subagent-commits-then-Manager-fixups flow above:

- Interactive rebase on unpushed or solo-feature-branch work is fair game to keep the log clean. Never rewrite shared history.
- Trunk-based local: feature branches rebase onto trunk before fast-forwarding back.
- Subjects stay concise and specific; bodies are 3-5 bullets max if any. See [git-commits](../../rules/git-commits.md).
- Spec changes that alter intent are authored by the Planner (Planner can't commit; Manager commits on Planner's behalf, attributing in the message body when worth noting).
