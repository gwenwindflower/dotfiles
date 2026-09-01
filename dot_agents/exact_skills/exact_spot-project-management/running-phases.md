# Running Phases

Executing one Phase in one session, on one branch, in one worktree. The flow is platform-neutral — Claude Code, Codex, and OpenCode differ only in how helpers are spawned.

A Phase brief arrives one of two ways: the user points the session at a Phase, or a parent session hands one off ([parallel-sessions](parallel-sessions.md)). The job is identical either way: satisfy the Phase's requirement IDs with clean linear history, then close.

## Start: load context

1. Read `SPEC.md` (goals, non-goals, vocabulary), the Phase block in `TODO.md`, and each listed requirement ID's wording in its durable spec (`SPEC.md` for `R<NNN>`, `specs/<dom>-*.md` for `<dom>-R<NNN>`).
2. Confirm the Phase is unblocked — every Phase on its `**Dependencies**:` line is in DONE.
3. If requirement IDs are missing or don't cover the Tasks, stop — that's planning work (`architect` or the user), not something to improvise.
4. Work on a branch named for the work (`feat/oauth`, `fix/session-expiry`), never the Phase. If the session starts on main or the wrong branch, branch first.
5. Sharpen Objective and Task wording for execution if needed — without changing *what's being built* (that goes back to planning). Vague or echoed-from-the-user names get a real name before work starts.

## Objectives land as commits

An Objective closes as one well-named conventional commit: the subject describes the work, the Objective's TODO checkoff rides inside. The plan is the outline of the log — when the Phase is done, `git log` should read as roughly one commit per Objective, in whatever order execution actually took. Sequential Objectives are normal; don't manufacture parallelism.

Within an Objective, work Task by Task with TDD. Commit when the Objective's requirement IDs are satisfied and verified. If an Objective turns out to need two unrelated commit subjects, it was two Objectives — fine, land two commits and note it at close.

## Helpers

Delegate a big, self-contained Objective or Task to a helper when it saves real time — a teammate on Claude Code, a subagent thread on Codex or OpenCode. The unit rules:

- Helpers work in this worktree, on this branch. No new worktrees, no new branches.
- Helpers never run `git add` or `git commit` (hook-enforced on Claude Code; state it in the brief elsewhere). They implement, verify, and report done.
- Brief each helper with its Objective and Tasks, the requirement IDs, agreed names, and why the work matters.
- Review one result at a time. If a second helper finishes while a review is in progress, it waits.
- Parallel helpers only when their file surfaces are near-disjoint — otherwise they trample each other in the shared tree. When in doubt, serialize.

### Review gate

Before committing helper work, check what hooks and tests can't:

- **Requirement coverage** — does the diff satisfy the listed IDs? Do the tests actually exercise them?
- **Names** match the agreed contracts, not casual phrasing.
- **No comment cruft** where structure should carry the meaning.
- **Scope** — nothing outside the assignment changed.

Clean → stage that work plus its TODO checkoff and commit. Off → send it back with sharper direction. Don't patch material drift on top; a redo from a sharpened brief produces a cleaner result than surgery on a bad diff.

## Test-driven by default

Red-green TDD unless the project says otherwise or the work is genuinely too small. Requirements are the source of truth; tests make them machine-verifiable.

- **Squishy requirements** ("feels responsive", "helpful errors") — implement, review, iterate. Document the judgment call in DONE.
- **Harness gaps** — if a requirement *would* be testable but the rig doesn't exist (no Playwright, no fixture, no perf bench), route a `dev-` Phase to planning for the missing harness. Don't silently skip.
- **Genuinely untestable** usually means the requirement is still vague — send it back to planning.

## Closing a Phase

1. Every Objective committed, the full suite (or whatever fits the work) green, tree clean.
2. Move the Phase block from `TODO.md` to `DONE.md`: header verbatim with ✅, Objectives and Tasks verbatim with checked boxes, and a short narrative — decisions, surprises, anything a future reader traces back here.
3. Update `docs/` for current-state changes; append surfaced harness/tooling needs to the right `dev-*` spec.
4. **Amend the close into the Phase's last commit** — stage the TODO/DONE/doc edits and `git commit --amend --no-edit`. The close is a checkbox, not an announcement: no close commit, no Phase trailer. `DONE.md` is the ledger.
5. Report per the brief: what shipped, IDs satisfied, surprises worth folding into durable specs, new Backlog candidates. If a parent session owns the fold, leave the branch clean and stop ([parallel-sessions](parallel-sessions.md#folding-back)).

Never start another Phase on a dirty tree or a half-closed Phase. Linear history is the deliverable.

## When things drift

- **Spec wrong or incomplete mid-Phase** — pause, fix the durable spec first (planning work), then resume. Don't bend requirements to match output.
- **Helper produced plausible-but-wrong work** — reject at the review gate. The brief was probably vague; sharpen it and re-run.
- **Git state broken** — `medic`.
