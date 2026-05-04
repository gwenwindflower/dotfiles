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
| **Phase** | `## Phase N: Description` with `**Requirements**: id, id, ...` line below | Sequential checkpoint | Serial — one at a time |
| **Objective** | `### Description` | Declarative goal | Parallel within a Phase |
| **Task** | `- [ ] description` | Imperative step | Sequential within an Objective |

Status markers: 🌀 active, ✅ completed, none = unstarted. Only one Phase active at a time.

The Phase's `**Requirements**:` line points at IDs in `SPEC.md` (`R<NNN>`) or domain specs (`<dom>-R<NNN>`, e.g. `sk-R007`). Manager treats that list as the focus checklist: every Task done **and** every listed requirement met before the Phase moves to DONE. IDs are soft-immutable — never reused once retired.

When TODO and a spec disagree, **the spec wins.** Flag the mismatch — don't silently follow TODO.

## Phase pacing

- **"Phase by phase"** — stop and check in after each.
- **"Move freely"** — proceed sequentially, but finish each Phase fully before starting the next.

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
- Don't commit pure `TODO.md` updates as standalone commits — fold them into the substantive commit for the work they describe.

Manager-side rebase rules and Planner spec-commit rules live in the skill.

## Working rules

- **`#user` tags** — Tasks/Objectives needing human credentials, judgment, or out-of-band action (installs, deployments, directory moves). **STOP** when one blocks; alert the user. Never attempt or skip past.
- **Ambiguous wording, risky approaches, low-value tasks** — pause, flag, suggest alternatives, update the relevant file after agreement. Persist any agreed change before doing the work.
- **Requirements concerns** — never quietly absorbed into TODO. Kick to Planner.
- **TDD by default** — see [use-tdd](use-tdd.md). SPOT-specific carve-outs (squishy requirements, harness gaps) are in the skill.
