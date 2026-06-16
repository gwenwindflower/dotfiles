### Projects

SPOT applies when a repo has both `SPEC.md` and `TODO.md`.

| File | Job |
| --- | --- |
| `SPEC.md` | Project-level what and why; indexes domain specs |
| `specs/<dom>-<slug>.md` | Durable domain requirements with stable IDs |
| `TODO.md` | Active Phases, Objectives, and Tasks |
| `DONE.md` | Shipped work and rationale |
| `docs/` | How the system works now |

Load the `spot-project-management` skill before spec authoring, Phase management, or Planner/Manager handoff.

#### Roles

- Planner owns what: specs and TODO.
- Manager owns execution: one Phase through DONE.
- Director owns coordination across requested Phase scope.
- Subagent owns one Objective: commits, never rebases.

Roles are responsibilities, not threads.

#### TODO Shape

| Level | Markdown | Meaning |
| --- | --- | --- |
| Phase | `## Phase N: Description` | Checkpoint/context boundary |
| Objective | `### Description` | Parallel work lane |
| Task | `- [ ] description` | Sequential step |

Phase headers may include, in order:

- `**Dependencies**: <N>, <N>` for Phase numbers that must already be in DONE.
- `**Requirements**: <id>, <id>` for `SPEC.md` or domain requirement IDs.

Phase numbers are stable IDs, not ordering. Dependencies define order. When TODO and specs disagree, specs win; flag the mismatch.

#### Execution

- Pacing: "phase by phase" stops after each Phase; "move freely" continues through unblocked Phases. Managers still stop at their Phase boundary unless told otherwise.
- Complete a Task by removing it unchanged from TODO and adding it checked to DONE under the same Objective. Add terse sub-bullets only for durable gotchas, decisions, or links.
- A Phase is complete only when every Task is done, every listed requirement is met, DONE is updated, and the Phase is committed.
- Linear history is the deliverable. Before starting another Phase, leave a clean tree and a committed Phase. Subagents commit; Managers squash/fix up bookkeeping into substantive commits.

#### Stops

- `#user` means human credentials, judgment, installs, deployments, or directory moves are required. Stop when blocked.
- Ambiguous wording, risky approaches, low-value tasks, and requirement concerns get surfaced before execution.
- Names are cross-agent contracts; sharpen vague Phase, Objective, requirement, file, and function names before building on them.
- Use TDD by default; SPOT-specific exceptions live in the skill.
