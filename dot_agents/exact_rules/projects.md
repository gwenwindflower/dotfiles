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

**Two boundaries, two units.** A Phase is a context boundary — one agent team's worth of work, sized so a Manager can pick it up cold from `SPEC.md` + the Phase's requirement IDs. Phases often run in parallel across worktrees, but they don't have to: a Manager can compact or clear context at the boundary and assemble a fresh team for the next one. An Objective is a parallel work unit — one subagent's lane within a Phase, designed to map one-to-one onto a subagent on the team.

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

**Linear history is the deliverable.** Every Phase ends in a commit; the next Phase never starts on a dirty tree. Rebase, squash, fast-forward only — no merge commits. See [git-commits](git-commits.md) for message format.

- **Subagents commit, never rebase.** The Objective isn't done until it's committed.
- **Manager folds bookkeeping into substantive commits.** Checking off a Task in `TODO.md` is a fixup into the subagent's commit, not a standalone commit. Same for moving a Phase to `DONE.md` at the close — fixup into the Phase's last substantive commit.
- **Phase boundary is a hard checkpoint.** Before any new Phase starts: clean working tree, last Phase fully promoted to DONE and committed. Other parallel worktrees may be working on other Phases — that's fine, this rule is about *your* thread of work. Reconstructing linear history after burning through several Phases without committing is wasteful and error-prone, and easily avoided by closing each Phase fully.
- **Spec-only commits should be rare.** The point of the rule is meaningful linear history that tells the story of the work — not an arbitrary prohibition. A pure `chore(specs)` commit earns its keep when it carries something a future reader can't get from the surrounding behavior commits: threading a learning back into specs after a Phase, scoping a multi-Phase plan ahead of code, recording DONE rationale for a stretch that already shipped without proper closeout. It's wrong when it's just bookkeeping you forgot to fold in. Use `chore(specs)` for the type/scope when you do make one.
- **Trunk-based local development.** Parallel Phases land in their own worktrees on feature branches off trunk. Rebase onto trunk before fast-forwarding back. Interactive rebase on unpushed work is fair game.

Manager-side rebase rules and Planner spec-commit rules live in the skill.

## Working rules

- **`#user` tags** — Tasks/Objectives needing human credentials, judgment, or out-of-band action (installs, deployments, directory moves). **STOP** when one blocks; alert the user. Never attempt or skip past.
- **Ambiguous wording, risky approaches, low-value tasks** — pause, flag, suggest alternatives, update the relevant file after agreement. Persist any agreed change before doing the work.
- **Requirements concerns** — never quietly absorbed into TODO. Kick to Planner.
- **Names are the contract.** Phase titles, Objective wording, requirement IDs, files, and functions all need to mean the right thing across agent handoffs. Don't carry the user's casual phrasing into durable artifacts — propose a real name, confirm, then build on it. See [naming](naming.md).
- **Code comments are usually a smell.** Specs hold *what*, DONE holds *why*, code holds *how*. Heavy commenting in a subagent diff is a signal of weak names or shaky structure — fix those rather than landing the comments. See [code-comments](code-comments.md).
- **TDD by default** — see [use-tdd](use-tdd.md). SPOT-specific carve-outs (squishy requirements, harness gaps) are in the skill.
