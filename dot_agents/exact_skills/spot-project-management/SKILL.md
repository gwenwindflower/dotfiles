---
name: spot-project-management
description: Manage SPOT-system projects (Spec, Phases, Objectives, Tasks) — write SPEC.md and durable domain specs, number requirements with stable IDs, structure TODO.md, run a Phase as Manager, hand off to Planner. Use when creating or editing SPEC.md, files under specs/, TODO.md, DONE.md, or operating as a Planner or Manager. Skip when only completing tasks (the projects rule covers execution).
---

# SPOT Project Management

Loads on top of the always-on `projects` rule. Assume that rule's vocabulary, file table, role names, TODO hierarchy, and execution mechanics. This skill covers the Planner and Manager surfaces: spec authoring, requirement IDs, Phase scoping, commit hygiene, decision records, handoff.

When asked, build SPOT files from scratch by interviewing the user or converting existing planning notes. Monorepo conventions (per-subdir specs, shared specs) are project-specific and live in project guidance.

## SPOT is a living system

SPOT is actively developed. Adhere to it strictly while you're working — the rules and shapes are load-bearing for clean handoffs across agents — *and* propose improvements when the system fights the work. This is a collaborative human/agent tool that will keep evolving. If a rule rubs the wrong way, surface it: an explicit "I'd suggest adjusting X because Y" beats silently working around it. Feedback flows back into the skill.

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

- **Phase = Manager = Session.** One Phase is one Manager's worth of work, run in one agent session. Don't reuse a Manager session across Phases — the Phase boundary is a context boundary, so each Phase starts fresh ([running-phases](running-phases.md#phases-are-teams-objectives-are-agents)). One step up, Executive runs Managers in [herdr](https://github.com/ogulcancelik/herdr) tabs, one tab per Manager.
- **Manager start shape is identical user-initiated vs Executive-initiated.** Most Manager sessions are launched directly by a user; some are launched by Executive in a herdr tab. The Manager brief is the same in either case ("Finish this Phase, with a team if the Objectives warrant one"). Manager does not branch behavior on its starting source.
- **Manager refines wording, not requirements.** Sharpen Task and Objective phrasing for execution; real requirement gaps go back to Planner.
- **Planner never operates on a Phase mid-flight.** Pause work, make the change, resume — see [writing-specs](writing-specs.md).
- **Manager hands off the Phase trunk; it never merges to main itself.** Under Executive, a Reviewer gates the merge (propose changes → new Manager session; or accept and merge). Under a user-initiated session, the User runs `wt merge --no-squash` themselves once the Manager reports done — optionally invoking Reviewer first.
- Some tools encode roles as named agent types with scoped permissions. Otherwise one agent plays several.

## Requirement IDs at a glance

Stable, soft-immutable IDs let Phases reference requirements without restating them. Format: `<dom>-R<NNN>` (domain-scoped) or `R<NNN>` (project-scoped in `SPEC.md`). Append-only, never renumber, one ID per testable check. Full rules in [writing-specs](writing-specs.md).

## Jobs to be done

- [Writing specs](writing-specs.md) — Planner work: spec shape, requirement IDs, phrasing patterns, the four hardening checks (unambiguous / consistent / complete / verifiable), edge cases, anti-patterns, scoping a Phase, Backlog, the `dev-` domain.
- [Running phases](running-phases.md) — Cross-platform Manager conceptual flow: the three Manager jobs (sequencing, linear history, quality at Objective close), Subagent teams as the SPOT default, per-Phase workflow, when spec-only commits earn their keep, TDD carve-outs, Subagent drift, parallel Phases across Manager sessions, handoff to Planner. Pair with the platform doc for spawn + merge mechanics.
- [Decision records](adrs.md) — optional, Planner-driven: lightweight ADRs as a release valve for amending requirements already shipped to main. File shape, frontmatter, status lifecycle, when to write one (and when not to). Skip for new requirements and in-flight branches; `DONE.md` still owns rationale for newly shipped work.
- [Using worktrunk](using-worktrunk.md) — `wt` as the **cross-session** worktree-and-merge layer: User/Executive run `wt switch --create` for Phase trunk worktrees and `wt merge --no-squash` to land them on main. Also the Manager-internal layer on platforms without native worktree primitives (OpenCode, etc.). The **Phase trunk branch + Objective feature branch** model, surveying with `wt list`, recommended `.config/wt.toml` for SPOT (pre-commit / pre-merge with `{{ target }}` conditional, `copy-ignored`), and the short list of operations that stay raw git.
- [EXECUTIVE.md](EXECUTIVE.md) — higher-level role that picks unblocked Phases, spawns one Manager session per Phase as a [herdr](https://github.com/ogulcancelik/herdr) tab via the Agent Handoff pattern, and gates Phase-trunk → main merges through a Reviewer. The autonomy gradient runs from pure-autonomous (sandbox VM, hours unattended) to interactive pairing (user tabs between live Managers). Out of scope for normal Manager/Planner work; load only when the user invokes Executive.

Platform-specific runbooks live in `platforms/`. Load the platform doc as your working doctrine alongside the cross-platform Manager flow — Subagent spawn syntax and Objective merge mechanics vary by platform:

- [platforms/claude-code.md](platforms/claude-code.md) — Canonical Claude Code runbook. Native worktree primitives via `Agent { subagent_type: "dev" }`, `WorktreeCreate`/`WorktreeRemove` hooks, raw `git` for Objective merges. Manager **does not invoke `wt`** — User/Executive own Phase trunk creation and Phase→main merge.
- [platforms/opencode.md](platforms/opencode.md) — Partial integration in progress; Manager uses `wt switch --create` directly for Objective worktrees and `wt merge` for Objective merges.
