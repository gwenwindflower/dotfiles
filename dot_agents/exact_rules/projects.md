# Projects

SPOT — **Spec, Phases, Objectives, Tasks** — is how agents work on Winnie's projects. SPOT applies when a project has both `SPEC.md` and `TODO.md` at the root.

| File | Scope | Job |
| --- | --- | --- |
| `SPEC.md` | Project | What we're building and why; indexes the domain specs |
| `specs/<dom>-<slug>.md` | Domain | Durable per-domain requirements with stable IDs |
| `TODO.md` | Project | Active work; each Phase lists the requirement IDs it must satisfy |
| `DONE.md` | Project | Shipped work, with rationale |
| `docs/` | Project | How the system works *now* |

This rule covers execution — what every agent needs to read TODO and complete tasks. **Spec authoring, Phase management, and Planner/Manager handoff live in the `spot-project-management` skill — load it before doing any of that.**

## Roles

- **Planner** — owns *what*. Writes and refines specs and TODO.
- **Manager** — owns *execution*. Coordinates a Phase, moves it to DONE.
- **Subagent** — owns one Objective. Commits, never rebases.

Roles, not threads. One agent can play several.

## TODO.md hierarchy

| Level | Markdown | Role | Execution |
| --- | --- | --- | --- |
| **Phase** | `## Phase N: Description`, optional `**Dependencies**:` line, then `**Requirements**:` line | Checkpoint | Parallel where independent; sequenced where dependencies declare it |
| **Objective** | `### Description` | Declarative goal | Parallel within a Phase |
| **Task** | `- [ ] description` | Imperative step | Sequential within an Objective |

Status markers: 🌀 active, ✅ completed, none = unstarted. Multiple Phases may be 🌀 at once when none of them blocks another.

Phase numbers are stable IDs, not sequence — `Phase 5` doesn't mean "after Phase 4," it just means it's the fifth Phase the Planner wrote. Order between Phases is conveyed by the `**Dependencies**:` line, not by the number.

The Phase header carries up to two metadata lines, in this order:

- `**Dependencies**: <N>, <N>, ...` — bare Phase numbers this Phase depends on. Type is implicit: dependencies can only be other Phases. Omit the line entirely when there are none. A Phase is **unblocked** once every listed dependency is in DONE — not "started," not "merged onto a feature branch," but fully promoted.
- `**Requirements**: <id>, <id>, ...` — IDs in `SPEC.md` (`R<NNN>`) or domain specs (`<dom>-R<NNN>`, e.g. `sk-R007`). Manager treats this list as the focus checklist: every Task done **and** every listed requirement met before the Phase moves to DONE. IDs are soft-immutable — never reused once retired.

When TODO and a spec disagree, **the spec wins.** Flag the mismatch — don't silently follow TODO.

## Phase pacing

Pacing controls user check-ins; it's orthogonal to parallelism. Independent Phases can still run concurrently under either mode.

- **"Phase by phase"** — stop and check in each time a Phase moves to DONE.
- **"Move freely"** — pick up any unblocked Phase whenever, including in parallel across worktrees or agent teams. Always finish a Phase fully (all Tasks done, all requirement IDs met, promoted to DONE) before considering its dependents unblocked.

## Task completion

When a Task is finished:

1. Remove the unchecked Task from `TODO.md`.
2. Add it to its Objective in `DONE.md`, box checked.
3. Optionally append indented sub-bullets — decisions, gotchas, links, why a non-obvious approach was taken.

**Never edit the original Task text.** Same for Objectives when their last Task closes, and Phases at promotion. The historical record stays honest: planned, done, learned, side by side.

```markdown
- [x] Implement POST /photos with auth middleware
  - Used existing `requireAuth` from `src/auth/middleware.ts`
  - Validate MIME type before reading body — fails fast, saves bandwidth
- [x] Wire up storage adapter
  - R2 binding in `wrangler.toml`; bucket provisioned out-of-band
```

Append sub-bullets only when genuinely useful for a future reader.

## Commit hygiene

**Linear history, always.** No merge commits. Rebase, squash, fast-forward only. See [git-commits](git-commits.md) for message format.

- Subagents commit; never rebase.
- Don't commit pure `TODO.md` updates as standalone commits — fold them into the substantive commit for the work they describe. When a SPOT-doc-only commit is genuinely needed (mapping out a plan, scoping a Phase before any code lands, retiring requirement IDs, recording DONE rationale ahead of follow-up work), use **`chore(specs)`** as the type/scope. Specs are what the rest of the POT structure supports, so this label keeps spec-management commits distinct from `docs` (project docs in `docs/`) and avoids generic `chore(plan)` / `chore(project)` wording.
- Trunk-based local development: parallel Phases land in their own worktrees on feature branches off trunk. Rebase onto trunk before fast-forwarding back; never introduce a merge commit when reconciling parallel Phases. Interactive rebase on unpushed work is fair game to keep history clean.

Manager-side rebase rules and Planner spec-commit rules live in the skill.

## Working rules

- **`#user` tags** — Tasks/Objectives needing human credentials, judgment, or out-of-band action (installs, deployments, directory moves). **STOP** when one blocks; alert the user. Never attempt or skip past.
- **Ambiguous wording, risky approaches, low-value tasks** — pause, flag, suggest alternatives, update the relevant file after agreement. Persist any agreed change before doing the work.
- **Requirements concerns** — never quietly absorbed into TODO. Kick to Planner.
- **TDD by default** — see [use-tdd](use-tdd.md). SPOT-specific carve-outs (squishy requirements, harness gaps) are in the skill.
