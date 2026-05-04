# Running Phases

Manager work. Coordinate one Phase at a time, keep history linear, hand off cleanly.

## Workflow per Phase

1. Read project spec.
2. Read or create `specs/<n>-<slug>.md`. If creating from a thin TODO Phase, kick to Planner first — Managers don't write requirements from scratch.
3. Review the TODO Phase against the phase spec. Sharpen Objective and Task wording for execution; don't change *what's being built*. Real requirement gaps go to Planner.
4. Execute. Assign Objectives to subagents in parallel. Maintain linear history.
5. Iterate until phase spec requirements are met and Tasks are complete.
6. Move Phase from TODO to DONE per the task-completion rules in the `projects` rule. Phase-level notes — implementation summary, decision rationale, ADR-style context — go under the Phase header in DONE.
7. Capture learnings and hand off:
   - Update `docs/` to reflect current state. Index new files from `CLAUDE.md`/`AGENTS.md`.
   - Write the DONE entry as *process*: what we did, why, what we learned, what surprised us. Add notes on relevant Tasks. Add new Meta items uncovered during the Phase.
   - Hand off to Planner: Planner reviews DONE, updates affected specs, promotes Backlog items the Phase resolved or unblocked, and adds new Backlog/Meta items.

## Test-driven by default

Execute with red-green TDD unless the project says otherwise or the work is too small to justify it. Requirements are the source of truth; tests make them machine-verifiable.
SPOT-specific:

- **Squishy requirements** ("feels responsive", "helpful errors") — implement, review, iterate. Document the judgment in DONE.
- **Harness gaps** — if a requirement *would* be testable but the infrastructure isn't there (no Playwright, no fixture, no perf rig), surface the harness work as a Meta task. Don't silently skip and call it done.
- **Genuinely un-testable** is signal the requirement is still vague — kick to Planner to sharpen, or accept squishy and document.

Subagents own TDD per Objective. Manager verifies during step 5.

## Subagent drift

If a subagent completes an Objective incorrectly, **roll back and re-assign.** Don't mutate the plan to match bad output. If the bad output reveals a real spec or wording problem, kick to Planner first; only then re-run.

## Manager-side commit hygiene

The execution rule covers subagent commit basics (commit, never rebase; linear history). On top of that:

- Manager can rebase unpushed or solo-feature-branch work to clean history. Never rewrite shared history.
- Commit history parallels the *work*, not project-management bookkeeping. Don't commit pure `TODO.md` updates — Manager fixups/squashes them into substantive commits.
- Spec changes that alter intent get their own commit, authored by the Planner.
