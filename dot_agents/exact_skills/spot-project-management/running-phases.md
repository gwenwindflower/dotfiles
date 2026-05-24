# Running Phases

Manager work. Coordinate one Phase end-to-end, keep history clean, hand off cleanly to Planner.

This doc is the **cross-platform conceptual flow**. Subagent fan-out mechanics and Objective merge specifics vary by platform — Claude Code uses native worktree primitives, OpenCode and others use worktrunk (`wt`) directly. Load the platform-specific runbook alongside this one:

- [platforms/claude-code.md](platforms/claude-code.md) — Claude-internal flow with the Dev subagent. The Manager never invokes `wt`; Phase trunk creation + Phase close to main belong to User/Executive.
- [platforms/opencode.md](platforms/opencode.md) — Worktrunk at the Subagent layer (no native worktree primitive on OpenCode yet).

A Manager session is one Phase. It can be invoked two ways, and the workflow below covers both:

- **User-initiated.** Most common. User opens a fresh session inside the Phase trunk worktree (created with `wt switch --create phase-<n>-<slug>` beforehand), points at the Phase, and the Manager works straight through to a clean Phase trunk handoff. The user runs the final `wt merge --no-squash` to land on main.
- **Executive-initiated.** Executive opens a [herdr](https://github.com/ogulcancelik/herdr) tab per Phase, fires up the Manager session inside it (`wt switch --create -x <agent-cli>`), and gates the final Phase-trunk → main merge through a separate Reviewer agent. See [EXECUTIVE.md](EXECUTIVE.md) for the orchestrator side.

The Manager's starting brief shape is identical in both cases: *"Finish this Phase. Use a team if the Objectives warrant one."* Don't branch behavior on starting source.

## Surface ownership at a glance

| Surface | Owner |
| --- | --- |
| Phase trunk branch+worktree creation | User or Executive (`wt switch --create`) |
| Objective worktrees, fan-out, merge into Phase trunk | Manager (platform-specific mechanics — see platform doc) |
| Phase trunk → main merge | User or Executive (`wt merge --no-squash`) |

Manager owns the inside of the Phase. The boundary on each side — Phase trunk creation before, Phase trunk → main after — is a cross-session surface, owned outside the Manager session.

## The Manager's three jobs

In priority order:

1. **Sequencing.** Read every Phase in `TODO.md` before assigning anyone. Map dependencies. Pick the right level of parallelism — enough to move efficiently, not so much that the diff becomes incoherent. Independent Phases run in parallel across Manager sessions; Objectives within a Phase always run in parallel as a Subagent team. Single-threaded plans are a last resort.
2. **Linear git history that tells the story.** This is the hardest part of the job and the most important. Subjects are concise and specific. Conventional types stay consistent across similar work — three Objective commits in one Phase shouldn't span `feat`, `chore`, `refactor` for the same kind of change. Sizes don't whipsaw. The Phase close is one `chore(spot)` (or `chore(specs)`) commit on top of the per-Objective story. Future readers (humans and agents) trace the project through the log; if it doesn't read clearly, the work is harder to build on.
3. **Quality at Objective close.** Not line-by-line review — does it meet the requirements? Did the Subagent stay on the agreed names? Did they leave a pile of code comments where the structure should have done the work? Tests, lint, formatter, typecheck — `pre-commit` hooks fail closed at the Subagent's commit boundary so job-3 review focuses on what hooks can't catch. If anything's off: **roll back and re-assign the Objective.** Don't try to patch a sloppy Subagent commit on top — the Objective merge squashes anyway, so a clean re-run produces a clean result.

## Phases are teams, Objectives are agents

Two distinct units, two distinct boundaries:

- **An Objective is a parallel work unit — one Subagent's lane.** Within a Phase, Objectives are designed to map one-to-one onto Subagents on the team. That isn't incidental, it's the entire point of the structure. If you find yourself running Objectives sequentially in one thread, either you're misreading the plan or the Objectives are really one Objective with sequential Tasks (kick that back to Planner).
- **A Phase is a context boundary — one team's worth of work.** Phases often *do* run in parallel across Manager sessions, but they don't have to. The Phase boundary is the natural place to compact or clear context entirely and assemble a fresh team for the next one — every Phase begins by reading `SPEC.md`, the Phase's requirement IDs, and the relevant durable specs, which is enough to pick up cold. That's the value of the boundary: clean restart points all the way down the project.

Default: every Phase gets a small Subagent team, one Subagent per Objective, working in parallel. Skip the team only when Objectives have heavy real sequential dependencies (rare — usually a sign the plan needs splitting), or the entire Phase is so small that team coordination overhead exceeds the work itself.

## Survey before assigning

Before dispatching any work:

1. **Confirm you're inside the Phase trunk worktree.** It was created by the User or Executive before the Manager session started.
2. Read **all** Phases in `TODO.md`, not just the next one. Note every `**Dependencies**:` line.
3. Verify the picked Phase is unblocked — every dependency in DONE, fully promoted (not just merged to a branch).
4. Identify the Objectives. Each becomes one Subagent in the team.
5. As the Phase closes and lands on main (via User/Executive), pick the next unblocked Phase in a fresh Manager session.

`wt list` (read-only) is useful at this stage to scan worktree state across parallel Phases — dirty trees, conflicts, integrated leftovers, Subagent activity markers (🤖 working / 💬 waiting). See [using-worktrunk#surveying-worktrees](using-worktrunk.md#surveying-worktrees) for columns worth scanning.

## Workflow per Phase

1. **Read context.** `SPEC.md` for vibe/goals/non-goals/vocabulary. The Phase's `**Requirements**:` line in `TODO.md`. Each listed ID's wording in its durable spec (`SPEC.md` for `R<NNN>`, `specs/<dom>-*.md` for `<dom>-R<NNN>`).
2. **Validate.** No requirements listed, or IDs don't cover the Tasks → stop, kick to Planner. Managers don't pick requirement IDs from scratch.
3. **Sharpen for execution.** Adjust Objective and Task wording so Subagents can act without a huddle. Don't change *what's being built* — that's a Planner edit. If the Phase title or any Objective carries vague or echoed-from-the-user wording, propose a sharper name with the user before assigning ([naming](../../rules/naming.md)).
4. **Dispatch the team.** One Subagent per Objective, in parallel, via the platform's native mechanism. Spawn syntax lives in the platform doc. Brief each on the Objective's Tasks plus the requirement IDs they're responsible for satisfying.
5. **Close each Objective.** When a Subagent finishes (commit guard satisfied), Manager reviews the diff against the requirement IDs and the job-2/job-3 quality checks. If clean, squash-merge the Objective into the Phase trunk with one well-named conventional commit. If anything's off, roll back and re-spawn ([Subagent drift](#subagent-drift)). Mechanics vary by platform — see the platform doc.
6. **Promote to DONE.** When all Objectives are on the Phase trunk, edit `TODO.md` and `DONE.md`: move the Phase block, header verbatim with `✅`, Objectives and Tasks verbatim with checked boxes, Phase-level narrative under the header.
7. **Capture context.** Update `docs/` for current-state changes; index new files from `CLAUDE.md`/`AGENTS.md`. Append surfaced harness/tooling needs to the right `dev-*` spec.
8. **Commit the close.** One `chore(spot):` (or `chore(specs):` if spec edits ride along) commit on the Phase trunk covering the DONE move + spec/doc edits.
9. **Hand off.** Phase trunk is clean with the close commit at HEAD. **Manager does not merge to main.** Report back; User or Executive runs `wt merge --no-squash` from the Phase trunk worktree to land it. Under Executive, a Reviewer gates first — see [EXECUTIVE.md](EXECUTIVE.md#reviewer-flow).
10. **Hand off to Planner.** What shipped, satisfied IDs, surprises worth folding into durable specs, new Backlog items.

## Per-Objective cadence inside a Phase

The shape is consistent across platforms; the commands differ.

1. **Subagent finishes an Objective** → commits work on its branch. Commit guard hooks (Claude Code's `require-teammate-commit`, OpenCode equivalents as they land) gate task completion on at-least-one-commit + clean tree. Project `pre-commit` hooks (format/lint/typecheck) fail commits closed at this boundary.
2. **Manager reviews the diff** against the requirement IDs and the job-2/job-3 quality checks. If issues:
   - Trivial (typo, missing import, stray comment) → Manager fixes inline; the Objective squash absorbs it.
   - Material (wrong approach, drifted off requirements, named the wrong thing, comment cruft) → roll back the Objective and re-spawn. See [Subagent drift](#subagent-drift).
3. **Manager squash-merges the Objective** into the Phase trunk with one well-named conventional commit, folding in the TODO checkoff. Platform-specific mechanics in the platform doc.
4. **Repeat for each Objective.** The Phase trunk accumulates one Objective commit per Subagent.
5. **When all Objectives are on Phase trunk** → Manager (back in the Phase trunk worktree) edits `TODO.md`/`DONE.md` to promote the Phase, edits `docs/` if needed, commits the close.
6. **Manager hands off the Phase trunk to User or Executive** — clean tree, close commit at HEAD. The User/Executive runs `wt merge --no-squash` to land on main, which rebases onto main, runs full pre-merge hooks, fast-forwards, removes the Phase trunk worktree.

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
- Bookkeeping you simply forgot to fold in. → Reset and let the Objective merge capture it.

When in doubt, ask: *will the next agent reading this commit learn something they need?* If no, it doesn't earn the line.

If a spec-only commit lands on the Phase trunk and shouldn't ride to main, drop it via `git rebase -i <merge-base>` before handing off the Phase trunk. This is one of the legitimate uses of raw interactive rebase.

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
- A subject line that doesn't tell the next reader what the commit accomplishes.

Rollback mechanics are platform-specific — see the platform doc.

## Parallel Phases across Manager sessions

Multiple Phases without mutual dependencies can run in parallel — typically one Manager session per Phase, each on its own Phase trunk worktree. The 🌀 marker can apply to several Phases at once.

A single Manager session runs one Phase at a time. Multi-Phase orchestration is the Executive's job — see [EXECUTIVE.md](EXECUTIVE.md).

When two parallel Phases land on main:

- **`wt merge --no-squash` handles rebase-onto-main automatically** at the User/Executive surface. Each Phase closes with its own merge from its Phase trunk worktree. The first lands main-clean; the second's pipeline rebases onto the now-updated main and fast-forwards. No merge commit. The Manager doesn't see this — it hands off a clean Phase trunk and the User/Executive handles the rest.
- **`TODO.md` / `DONE.md` conflicts** are common — both Phases edited the same files. Resolved at the merge step by accepting the later state (DONE accumulates; TODO shrinks). Surface anything ambiguous.
- **Spec touches go to Planner.** If both Phases needed to amend the same durable spec mid-flight, that's a Planner coordination point, not a merge decision.

## Manager-side commit hygiene

- **Per-Objective commits** are squash-merges of the Subagent's branch into the Phase trunk, with a single well-named conventional subject. Bodies are 3-5 bullets max if any; usually the subject alone is enough.
- **Phase-close commit** is one `chore(spot):` (or `chore(specs):`) commit covering TODO→DONE + spec/doc edits.
- **Raw `git rebase -i` is for cleaning local history before handoff** — squash messy WIP, sharpen drifted subjects, drop spec-only commits. Fair game on unpushed Phase trunk; never on shared history.
- See [git-commits](../../rules/git-commits.md) for subject/body conventions.
- Spec changes that alter intent are authored by the Planner (Planner can't commit; Manager commits on Planner's behalf, attributing in the message body when worth noting).
