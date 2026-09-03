---
name: spot-project-management
description: Manage SPOT-system projects (Spec, Phases, Objectives, Tasks) — write SPEC.md and durable domain specs, structure the TODO.md plan, run a Phase in a session, or split truly unrelated Phases across parallel sessions. Skip when only completing tasks inside an already-briefed Phase (the always-on projects rule covers that).
---

# SPOT Project Management

Loads on top of the always-on `projects` rule. Assume that rule's file table, TODO shape, and execution invariants. This skill covers spec authoring, requirement IDs, Phase scoping, running a Phase, parallel sessions, and decision records.

When asked, build SPOT files from scratch by interviewing the user or converting existing planning notes. Monorepo conventions (per-subdir specs, shared specs) are project-specific and live in project guidance.

## SPOT is a living system

SPOT is actively developed. Follow it while you work — the shapes are load-bearing for clean handoffs across agents — *and* propose improvements when the system fights the work. An explicit "I'd suggest adjusting X because Y" beats silently working around it. Feedback flows back into the skill.

## The loop

specs → tests → plan → action → linear history. Everything in SPOT serves that loop — whether one session works alone or several run in parallel. Parallelism is a means to run the loop faster when there's a clear pathway, never something to eke out of every task.

## Two spec layers

- **`SPEC.md`** — project contract. Vibe, goals, non-goals, vocabulary, design principles, an `@`-import index of domain specs, plus project-scope requirements that don't belong to any one domain.
- **`specs/<dom>-<slug>.md`** — durable per-domain spec. Two-letter prefix for user-visible domains (`sk-skills.md`, `dc-docs.md`, `cf-config.md`); one reserved 3-letter prefix, `dev-`, for development-meta domains (`dev-testing.md`, `dev-release.md`) covering tooling, harness, build/release, CI. Long-lived; evolves with the system.

Index domain specs from `SPEC.md`:

```markdown
## Domain specs
- @specs/sk-skills.md
- @specs/dc-docs.md
- @specs/cf-config.md
```

Most requirements live in domain specs. `SPEC.md` stays high-signal.

## Sessions, not roles

SPOT has no execution hierarchy. The terms are relational:

- **Root session** — the prime session the user is talking to.
- **Parent session** — any session that spawned another.
- The session that takes on a Phase is that Phase's **owner**: it loads context, executes (solo or with helpers), commits, and closes.
- **Helpers** — teammates or subagents an owner spawns for big Tasks. They work in the owner's worktree and never commit; they report done, the owner reviews and commits or sends back.

Two specialist agents persist because their jobs are genuinely distinct: **architect** (spec authorship, requirement IDs, Phase scoping, research synthesis) and **medic** (git recovery). Everything else is a session with a brief.

## Requirement IDs at a glance

Stable, soft-immutable IDs let Phases reference requirements without restating them. Format: `<dom>-R<NNN>` (domain-scoped) or `R<NNN>` (project-scoped in `SPEC.md`). Append-only once the project has shipped, never renumber, one ID per testable check. Before the first Phase moves to DONE, edit plans/specs/docs ruthlessly — preservation rules only earn their keep once external references exist. Full rules in [writing-specs](writing-specs.md).

## Commits

Follow [git-commits](../../rules/git-commits.md) for format, signing, linear history, and trailers. SPOT adds three invariants:

- **One commit per Objective**, named for the work (`feat(auth): add GCP oauth`), with that Objective's TODO checkoff folded in.
- **No bookkeeping-only commits.** The close's TODO→DONE move amends into the Phase's last commit (`git commit --amend`). A hook blocks commits that only touch plan/spec files; deliberate planning-only commits (scoping a multi-Phase plan, a retrospective ADR) re-run with `SPOT_PLAN_COMMIT=1`.
- **SPOT stays out of branch names and subjects.** Both describe the work, never the protocol — no `phase-9` branches, no "close phase 3" subjects. Commit bodies carry the bookkeeping: `Completes <Objective> in Phase N` and, on the Phase's last commit, `Closes Phase N`, placed after any body bullets and before the trailers. `DONE.md` remains the ledger.

`SPEC.md` indexes domain specs with `@` imports so a session that opens it pulls the specs in; `AGENTS.md` lists docs as plain paths so agents choose what to load.

## Jobs to be done

- [Writing specs](writing-specs.md) — planning work: spec shape, requirement IDs, phrasing patterns, the four hardening checks, edge cases, anti-patterns, Phase scoping and dependencies, Backlog, the `dev-` domain.
- [Running phases](running-phases.md) — executing one Phase in one session: context load, Objective-as-commit cadence, helpers and the review gate, TDD, the close.
- [Parallel sessions](parallel-sessions.md) — when to split work across worktrees, worktree readiness, the worktrunk + herdr handoff, monitoring, folding back.
- [Decision records](adrs.md) — optional: lightweight ADRs as a release valve for amending requirements already shipped to main. Skip for new requirements and in-flight branches.
