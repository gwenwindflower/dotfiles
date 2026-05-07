---
name: spot-project-management
description: Manage SPOT-system projects (Spec, Phases, Objectives, Tasks) — write SPEC.md and durable domain specs, number requirements with stable IDs, structure TODO.md, run a Phase as Manager, hand off to Planner. Use when creating or editing SPEC.md, files under specs/, TODO.md, DONE.md, or operating as a Planner or Manager. Skip when only completing tasks (the projects rule covers execution).
---

# SPOT Project Management

Loads on top of the always-on `projects` rule. Assume that rule's vocabulary, file table, role names, TODO hierarchy, and execution mechanics. This skill covers the Planner and Manager surfaces: spec authoring, requirement IDs, Phase scoping, commit hygiene, handoff.

When asked, build SPOT files from scratch by interviewing the user or converting existing planning notes. Monorepo conventions (per-subdir specs, shared specs) are project-specific and live in project guidance.

## Two spec layers

- **`SPEC.md`** — project contract. Vibe, goals, non-goals, vocabulary, design principles, an `@`-import index of domain specs, plus project-scope requirements that don't belong to any one domain.
- **`specs/<dom>-<slug>.md`** — durable per-domain spec. Two-letter prefix for user-visible domains (`sk-skills.md`, `dc-docs.md`, `cf-config.md`) — CLI command groups, subsystems, product surfaces. One reserved 3-letter prefix, `dev-`, for development-meta domains (`dev-testing.md`, `dev-release.md`) covering tooling, harness, build/release, CI — internal-only requirements that ship as normal Phases. Long-lived; evolves with the system.

Index domain specs from `SPEC.md`:

```markdown
## Domain specs
- @specs/sk-skills.md
- @specs/dc-docs.md
- @specs/cf-config.md
```

Most requirements live in domain specs. `SPEC.md` stays high-signal.

## Role nuances

The rule defines Planner / Manager / Subagent. On top of that:

- **Manager refines wording, not requirements.** Sharpen Task and Objective phrasing for execution; real requirement gaps go back to Planner.
- **Planner never operates on a Phase mid-flight.** Pause work, make the change, resume — see [writing-specs](writing-specs.md).
- Some tools encode roles as named agent types with scoped permissions. Otherwise one agent plays several.

## Requirement IDs at a glance

Stable, soft-immutable IDs let Phases reference requirements without restating them. Format: `<dom>-R<NNN>` (domain-scoped) or `R<NNN>` (project-scoped in `SPEC.md`). Append-only, never renumber, one ID per testable check. Full rules in [writing-specs](writing-specs.md).

## Jobs to be done

- [Writing specs](writing-specs.md) — Planner work: spec shape, requirement IDs, phrasing patterns, edge cases, anti-patterns, scoping a Phase, Backlog, the `dev-` domain.
- [Running phases](running-phases.md) — Manager work: per-Phase workflow, TDD carve-outs, subagent drift, Manager-side commit hygiene, handoff to Planner.
