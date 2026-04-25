# POT Task Lists

Projects with both `TODO.md` and `WORKLOG.md` in the project root (or monorepo subdir) use this system. It replaces opaque internal task tools with explicit, user-visible markdown specs that support parallel agent work.

## Structure: Phases > Objectives > Tasks

| Level | Markdown | Role | Execution |
| --- | --- | --- | --- |
| **Phase** | `## Phase N: description` | Sequential project checkpoint | Serial — complete one before starting the next |
| **Objective** | `### description` | Declarative goal (like a well-scoped PR) | Parallel within a Phase — assign to subagents |
| **Task** | `- [ ] description` | Imperative step to complete an Objective | Sequential within an Objective |

## Phase Lifecycle

**Status markers:** 🌀 active, ✅ completed, no emoji = unstarted. Only one Phase active at a time — multiple active Phases cause conflicts between Objectives that were designed to be parallel only within their own Phase.

**Pacing:** If the user says "phase by phase," stop and check in after each. If they say "move freely," proceed sequentially but still finish each Phase fully before starting the next.

**Completion checklist:**

1. Review Objectives and Tasks — update language to reflect what was actually done (don't leave stale descriptions)
2. Mark the Phase ✅
3. Move the completed Phase to the *top* of `WORKLOG.md` (reverse chronological). Add implementation notes, decision rationale, or ADR-style context as needed
4. Delete the Phase from `TODO.md`

**Subagent drift:** If a subagent completes an Objective incorrectly, roll back and re-assign — don't mutate the plan to match bad output.

## Working Rules

### Externalizing plans

When the user asks to save a Plan Mode result or ad hoc discussion into the task list, use POT format. If a `TODO.md` exists, place new work at the right level in the hierarchy — parallel chunks become Objectives within a Phase.

### `#user` tags

Skip `#user`-tagged Tasks and Objectives — these are for the user (installs, deployments, directory reorganization, etc). If they block the sequence, **STOP** and alert the user. Do not attempt them or skip past them.

### Clarification and improvement

- Ambiguous wording with multiple valid approaches → pause, ask, then update the task language
- Risky, insecure, or overcomplicated approaches → flag and suggest alternatives. Update `TODO.md` after agreement
- Low-value tasks, anti-patterns, or poor agent ergonomics → flag and suggest improvements

Always discuss changes with the user and persist the outcome in `TODO.md` before doing the work.

### Commit hygiene

The commit history should parallel the work, not mirror the project management system. Do not commit pure `TODO.md` updates. If subagents add commits like `docs(todo): mark objective xyz as complete`, rebase and fixup/squash them into the substantive commits.

### Backlog

Items in the Backlog section are not active work. Consider them when they inform active decisions, but do not start them without user approval to promote them into a Phase.
