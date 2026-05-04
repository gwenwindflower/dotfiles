---
name: spot-project-management
description: Author and manage SPOT projects (Spec, Phases, Objectives, Tasks) on Winnie's repos — write SPEC.md and phase specs, structure TODO.md, run a Phase as Manager, hand off to Planner. Use when creating or editing SPEC.md, files under specs/, TODO.md, DONE.md, or operating as a Planner or Manager. Skip when only completing tasks (the projects rule covers execution).
---

# SPOT Project Management

SPOT — **Spec, Phases, Objectives, Tasks** — is how agents work on Winnie's projects. The system enables three things: clear requirements, good sequencing, team execution. Everything below serves those.

SPOT applies when a project has both `SPEC.md` and `TODO.md` at the root. Monorepo conventions (per-subdir specs, shared spec) are project-specific and live in in-project guidance.

| File | Scope | Job |
| --- | --- | --- |
| `SPEC.md` | Project | What we're building and why |
| `specs/<n>-<slug>.md` | Phase | What this phase delivers |
| `TODO.md` | Project | Active work (Phases → Objectives → Tasks) |
| `DONE.md` | Project | Shipped work, with rationale |
| `docs/` | Project | How the system works *now* |

Execution mechanics (TODO hierarchy, task completion, subagent commit rules, `#user` tags) are in the always-on `projects` rule. This skill covers the Planner and Manager surfaces on top of that.

## Roles

- **Planner** — owns *what*. Writes and refines specs and TODO.
- **Manager** — owns *execution*. Coordinates a Phase, maintains linear history, moves it to DONE. Refines task wording but cannot change requirements; kicks back to Planner.
- **Subagent** — owns one Objective. Commits, never rebases.

Roles, not threads. One human or agent can play several. Some tools encode them as named agent types with scoped permissions.

## Two-tier specs

`SPEC.md` is the global contract. Each Phase gets `specs/<n>-<slug>.md` for phase-scoped requirements, indexed from the project spec via `@`-import:

```markdown
## Phase specs
- @specs/1-initial-functionality.md
- @specs/2-oauth.md
```

Phase headers in `TODO.md` import the same way. Specs aren't auto-loaded — importing from both sides is fine.

When TODO and spec disagree, **the spec wins.** Manager fixes TODO. If the spec is wrong, Manager kicks back to Planner.

## Jobs to be done

- [Writing specs](writing-specs.md) — Planner work: spec shape, requirement phrasing patterns, edge cases, anti-patterns, the promotion gate, living-document workflow.
- [Running phases](running-phases.md) — Manager work: per-Phase workflow, TDD carve-outs, subagent drift, Manager-side commit hygiene, handoff back to Planner.

## Backlog and Meta (project spec only)

- **Backlog** — future requirements, open questions, big ideas. Not active work. Consider when informing active decisions; don't start without Planner approval to promote into Requirements and a Phase. **Promote or delete** — lingering items are noise.
- **Meta** — unscoped tooling and configuration tasks: test-harness additions, linter config, pre-commit hooks. Flat list, no Objectives or Phases. Planners and Managers both add. Lives at the end of `DONE.md`, appended in completion order (not reverse-chronological like Phases). Clears by request, not at any specific handoff.

## Externalizing plans

Plan Mode results or ad-hoc discussion saved into the system use the SPOT hierarchy. Parallel chunks become Objectives within a Phase. Anything that changes *what's being built* is a Planner job — surface as a spec change before persisting.
