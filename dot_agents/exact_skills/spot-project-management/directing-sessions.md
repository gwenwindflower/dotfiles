# Directing Sessions

Director work. Coordinate a SPOT session across one or more Managers, keep Phase boundaries clean, and decide when to continue, review, merge, or ask the user.

This doc is the **cross-platform conceptual flow**. Session mechanics vary by platform — a Director may spawn Manager subagents, open separate agent sessions, coordinate worktrees, or run a single Phase inline when that is the right fit. Worktrunk and herdr are useful surfaces when available, but they are mechanics, not the role.

Director is not a subagent type. Do not create a `director` agent unless the user explicitly asks for a new agent definition. The role lives in the primary conversation because the main thread has the user's full context and can coordinate Manager sessions better than a Manager prompt can absorb queue-level behavior.

## Starting shape

The user invokes Director with prompts like:

- "Operate as Director and tackle the currently planned TODOs."
- "You'll act as Director for this session, complete Phases 3-7."
- "Run Phase 4 through review and merge."
- "Coordinate whatever unblocked Phases can land today."

First determine the requested scope:

- **Single Phase** — finish exactly that Phase, then stop after the requested boundary.
- **Specific range or set** — finish those Phases, respecting dependencies.
- **Everything possible** — keep selecting unblocked Phases until no requested or unblocked work remains.

If scope is unclear, clarify before starting. Do not assume "everything possible" from a vague prompt.

## Surface ownership at a glance

| Surface | Owner |
| --- | --- |
| Requested session scope | User, clarified by Director |
| Phase selection and Manager scheduling | Director |
| Phase trunk branch+worktree creation | User or Director |
| Objective worktrees, fan-out, merge into Phase trunk | Manager |
| Phase trunk review | Reviewer, started by User or Director |
| Phase trunk → main merge | User or Director |
| Requirement changes | Planner |
| Git recovery | Medic |

Director owns the queue around Managers. Manager owns the inside of one Phase. Reviewer gates a finished Phase trunk. Planner owns changes to what the project intends to build.

## The Director's three jobs

In priority order:

1. **Scope control.** Determine whether the user wants one Phase, a range/set, or everything possible. Keep that boundary visible throughout the session.
2. **Phase scheduling.** Read the plan, identify unblocked work, and coordinate one Manager per Phase. Run independent Phases in parallel only when the platform and working tree shape make that safe.
3. **Boundary decisions.** At each Manager handoff, decide from the user's scope whether to review, merge, spawn a fresh Manager for findings, continue to another Phase, or stop and report.

## Managers are Phase-bounded

Managers have a hard stop at the end of their Phase unless the user explicitly instructed that Manager session otherwise. Director does not reuse a Manager session for a new Phase. Start fresh so each Phase begins from `SPEC.md`, `TODO.md`, and the Phase's requirement IDs.

Director can coordinate one Manager or several. Independent Phases may run in parallel across separate Manager sessions or worktrees; dependent Phases wait until their dependencies are fully in DONE.

## Survey before scheduling

Before starting Managers:

1. Read `TODO.md` fully. Note each Phase's `**Dependencies**:` and `**Requirements**:` lines.
2. Read `DONE.md` enough to confirm dependencies are fully promoted, not merely in flight.
3. Read `SPEC.md` and the requirement specs needed to understand the requested Phase set.
4. Check worktree state when available (`wt list`, platform dashboard, or raw `git worktree list`) so you do not duplicate active work or miss dirty Phase trunks.
5. Identify Phases in scope, blocked Phases, and unblocked Phases ready for Manager.

If TODO and specs disagree, the spec wins. Kick requirement gaps to Planner before scheduling Managers.

## Workflow per Director session

1. **Clarify scope.** If the prompt does not say one Phase, a specific range/set, or everything possible, ask before starting.
2. **Select Phases.** Build the requested queue from `TODO.md`, respecting dependencies and active worktree state.
3. **Create Phase trunks when needed.** Use the project's worktree convention, commonly `wt switch --create phase-<n>-<slug>`.
4. **Start Managers.** One Manager per Phase. Brief each with the Phase number/title, requirement IDs, current Phase trunk path, and the standard Manager contract: finish the Phase, use a team when Objectives warrant it, close with a clean Phase trunk, then stop.
5. **Track handoffs.** For each Manager, record clean tree state, close commit, satisfied IDs, verification, surprises, and any Planner follow-up.
6. **Review if delegated.** When Director owns the merge path, start Reviewer on the finished Phase trunk before merging.
7. **Merge if delegated.** For accepted Phase trunks, run `wt merge --no-squash` from the Phase trunk worktree. If the user did not delegate merges, report the exact ready trunks instead.
8. **Continue or stop.** Continue only while the user's requested scope still contains unblocked work. Stop when the scope is complete, blocked, or ambiguous.

## Review and merge loop

When Director owns Phase trunk to main, gate finished Phase trunks with Reviewer before merge. Reviewer returns one of:

- `MERGE_CLEAN`
- `MERGE_AFTER_FIX`
- `PROPOSE_CHANGES`

For merge verdicts, Director or the user runs `wt merge --no-squash` from the Phase trunk worktree. For proposed changes, Director starts a fresh Manager on the same Phase trunk with the findings as the brief. Git-history damage goes to Medic.

Do not merge directly after a Manager handoff when the user asked for Reviewer-gated coordination.

## Parallel Managers

Multiple Managers can run in parallel when Phases are independent. Keep the unit clean:

- One Phase trunk per Manager.
- One Manager session per Phase.
- No Manager reuse across Phase boundaries.
- No dependent Phase starts until dependencies are fully in DONE.

Parallelism is useful only when the user can see or track the work. If the platform cannot keep the sessions visible enough to coordinate, run fewer Managers.

## Stop conditions

Stop and report when:

- The requested scope is complete.
- All remaining in-scope Phases are blocked.
- A requirement gap needs Planner.
- A Manager or Reviewer needs user judgment.
- Git state needs Medic or explicit approval.
- The user's intended pacing is unclear.

## Out of scope

- Director does not directly implement Objectives. Manager and Dev own that layer.
- Director does not edit specs as queue bookkeeping. Real requirement gaps go to Planner.
- Director does not turn itself into a subagent or write platform metadata.
- Director does not bypass Manager, Reviewer, or Medic boundaries to "just finish" queue work.
