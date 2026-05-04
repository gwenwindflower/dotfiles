# Running Phases

Manager work. Coordinate one Phase at a time, keep history linear, hand off cleanly.

## Workflow per Phase

1. Read `SPEC.md` for project context (vibe, goals, non-goals, vocabulary).
2. Pull the requirement IDs the Phase lists in TODO. Look each one up in its durable spec (`SPEC.md` for `R<NNN>`, `specs/<dom>-*.md` for `<dom>-R<NNN>`). That set is the Phase's focus checklist.
3. If the TODO Phase has no listed requirements, or the listed IDs don't cover the Tasks, **stop and kick to Planner.** Managers don't pick requirement IDs from scratch.
4. Review the TODO Phase against the listed requirements. Sharpen Objective and Task wording for execution; don't change *what's being built*. Real requirement gaps (missing IDs, wrong wording in the spec) go to Planner.
5. Execute. Assign Objectives to subagents in parallel. Maintain linear history.
6. Iterate until every Task is done **and** every listed requirement ID has a passing test (or a documented squishy/harness-gap judgment — see below).
7. Move Phase from TODO to DONE per the task-completion rules in the `projects` rule. The Phase header (verbatim, plus ✅) and all its Objectives and Tasks (verbatim, boxes checked) move over. Phase-level notes — implementation summary, decision rationale, ADR-style context — go directly under the Phase header.
8. Capture learnings and hand off:
   - Update `docs/` to reflect current state. Index new files from `CLAUDE.md`/`AGENTS.md`.
   - Write the DONE entry as *process*: what we did, why, what we learned, what surprised us. Add sub-bullets on Tasks where useful. Add new Meta items uncovered during the Phase.
   - Hand off to Planner: Planner reviews DONE, updates affected durable specs (edits in place under existing IDs, or appends new IDs for emergent requirements), promotes Backlog items the Phase resolved or unblocked, and adds new Backlog/Meta items.

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
- **Harness gaps** — if a requirement *would* be testable but the infrastructure isn't there (no Playwright, no fixture, no perf rig), surface the harness work as a Meta task. Don't silently skip and call it done.
- **Genuinely un-testable** is signal the requirement is still vague — kick to Planner to sharpen, or accept squishy and document.

Subagents own TDD per Objective. Manager verifies during step 5.

## Subagent drift

If a subagent completes an Objective incorrectly, **roll back and re-assign.** Don't mutate the plan to match bad output. If the bad output reveals a real spec or wording problem, kick to Planner first; only then re-run.

## Manager-side commit hygiene

The execution rule covers subagent commit basics (commit, never rebase; linear history). On top of that:

- Manager can rebase unpushed or solo-feature-branch work to clean history. Never rewrite shared history.
- Commit history parallels the *work*, not project-management bookkeeping. Don't commit pure `TODO.md` updates — Manager fixups/squashes them into substantive commits.
- Spec changes that alter intent get their own commit, authored by the Planner.
