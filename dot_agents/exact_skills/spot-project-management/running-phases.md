# Running Phases

Manager work. Coordinate one Phase at a time, keep history linear, hand off cleanly.

## Workflow per Phase

1. **Confirm the Phase is unblocked.** If the header has a `**Dependencies**:` line, every listed Phase must already be in DONE — not "started," not "merged onto a branch," fully promoted. If a dependency is still pending, stop: pick a different unblocked Phase or surface the block to the user.
2. Read `SPEC.md` for project context (vibe, goals, non-goals, vocabulary).
3. Pull the requirement IDs the Phase lists in TODO. Look each one up in its durable spec (`SPEC.md` for `R<NNN>`, `specs/<dom>-*.md` for `<dom>-R<NNN>`). That set is the Phase's focus checklist.
4. If the TODO Phase has no listed requirements, or the listed IDs don't cover the Tasks, **stop and kick to Planner.** Managers don't pick requirement IDs from scratch.
5. Review the TODO Phase against the listed requirements. Sharpen Objective and Task wording for execution; don't change *what's being built*. Real requirement gaps (missing IDs, wrong wording in the spec) go to Planner.
6. Execute. Assign Objectives to subagents in parallel. Maintain linear history.
7. Iterate until every Task is done **and** every listed requirement ID has a passing test (or a documented squishy/harness-gap judgment — see below).
8. Move Phase from TODO to DONE per the task-completion rules in the `projects` rule. The Phase header (verbatim, plus ✅) and all its Objectives and Tasks (verbatim, boxes checked) move over. Phase-level notes — implementation summary, decision rationale, ADR-style context — go directly under the Phase header.
9. Capture learnings and hand off:
   - Update `docs/` to reflect current state. Index new files from `CLAUDE.md`/`AGENTS.md`.
   - Write the DONE entry as *process*: what we did, why, what we learned, what surprised us. Add sub-bullets on Tasks where useful. If the Phase uncovered new tooling/harness/infra needs, append them to the relevant `specs/dev-*.md` as new requirements (or kick to Planner if no `dev-` spec yet exists).
   - Hand off to Planner: Planner reviews DONE, updates affected durable specs (edits in place under existing IDs, or appends new IDs for emergent requirements), promotes Backlog items the Phase resolved or unblocked, and adds new Backlog items.

### Promoted Phase example

```markdown
## Phase 4: Google OAuth ✅
**Requirements**: au-R007, au-R008, au-R009, R002

Shipped Google sign-in via the official `google-auth-library`. Reused the existing session-token issuance path; only the provider adapter is new. Duplicate-account collision (au-R009) handled by matching on verified email at callback time — surfaced one new edge case (case-folding on the email comparator) which became `au-R012`, satisfied here.

### Provider integration
- [x] Wire up the OAuth client library
  - Picked `google-auth-library` over rolling our own — the JWT verification surface is finicky and not worth re-implementing
- [x] Implement the callback handler
  - State token check lives in `auth/oauth/state.ts`; rejects with 400 + audit log entry per au-R008

### Session management
- [x] Issue session tokens on success
- [x] Implement token refresh
  - Refresh window matches the existing email-login flow (15 min) for consistency
```

Sub-bullets are optional and only appear where they add real value — surprising decisions, gotchas, links, satisfied edge-case IDs. Don't pad.

## Test-driven by default

Execute with red-green TDD unless the project says otherwise or the work is too small to justify it. Requirements are the source of truth; tests make them machine-verifiable.
SPOT-specific:

- **Squishy requirements** ("feels responsive", "helpful errors") — implement, review, iterate. Document the judgment in DONE.
- **Harness gaps** — if a requirement *would* be testable but the infrastructure isn't there (no Playwright, no fixture, no perf rig), kick to Planner to scope a `dev-` Phase for the missing harness. Don't silently skip and call it done.
- **Genuinely un-testable** is signal the requirement is still vague — kick to Planner to sharpen, or accept squishy and document.

Subagents own TDD per Objective. Manager verifies during step 5.

## Subagent drift

If a subagent completes an Objective incorrectly, **roll back and re-assign.** Don't mutate the plan to match bad output. If the bad output reveals a real spec or wording problem, kick to Planner first; only then re-run.

## Parallel Phases

Multiple Phases without mutual dependencies can run in parallel — typically one Manager per Phase, each on its own worktree and feature branch off trunk. The 🌀 marker can apply to several Phases at once.

When two parallel Phases land on trunk:

- **Second to land rebases onto first.** Fast-forward only. Never a merge commit.
- **TODO.md / DONE.md conflicts** are common — both Phases edited the same file. Resolve by accepting the later state (DONE accumulates; TODO shrinks). Surface anything ambiguous.
- **Spec touches go to Planner.** If both parallel Phases needed to amend the same durable spec mid-flight, that's a Planner coordination point, not a Manager rebase decision.

## Manager-side commit hygiene

The execution rule covers subagent commit basics (commit, never rebase; linear history). On top of that:

- Manager can rebase unpushed or solo-feature-branch work to clean history. Never rewrite shared history.
- Trunk-based local development — feature branches rebase onto trunk before fast-forwarding back. Interactive rebase on unpushed work is fair game and often necessary when reconciling parallel Phases.
- Commit history parallels the *work*, not project-management bookkeeping. Don't commit pure `TODO.md` updates — Manager fixups/squashes them into substantive commits.
- When a SPOT-doc-only commit is genuinely needed — mapping out a plan, scoping a Phase before any code lands, retiring requirement IDs, recording DONE rationale ahead of follow-up work — use **`chore(specs)`**. Distinct from `docs` (project docs in `docs/`); cleaner than generic `chore(plan)` / `chore(project)`.
- Spec changes that alter intent get their own commit, authored by the Planner. Use `chore(specs)` when the change is purely spec/TODO/DONE bookkeeping; behavior commits that also touch a spec keep their behavior type (`feat`, `fix`, etc.).
