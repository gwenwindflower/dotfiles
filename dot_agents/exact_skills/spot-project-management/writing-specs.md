# Writing Specs

Planner work. The whole burden of clarity sits in the spec — there are no separate constraints sections or acceptance criteria. Requirements get stable IDs (see below) so Phases can target them by reference.

## Shape

### `SPEC.md`

```markdown
## Goals
3-8 sentences: description, goals, **non-goals**.
Non-goals matter most — they prevent helpful drift.

## Vocabulary           (when domain language is load-bearing)
Either inline glossary or pointer to a docs/ glossary file.

## Domain specs
@-import index of specs/<dom>-*.md files.

## Requirements
Project-scope requirements only — anything cross-cutting that doesn't
belong to one domain. ID format: R001, R002, ...

## Backlog
Future requirements, open questions, big ideas. Promote or delete.

## Meta
Unscoped tooling/config tasks.
```

### `specs/<dom>-<slug>.md` (durable domain spec)

```markdown
## Goals
3-8 sentences scoped to the domain: what this slice does, what it doesn't.

## Requirements
Bulleted list. ID format: <dom>-R001, <dom>-R002, ...
```

Skip empty sections. Domain specs don't carry their own Backlog or Meta — those stay project-scope in `SPEC.md`.

## Requirement IDs

Every requirement gets a stable, soft-immutable ID:

- **Format.** `<dom>-R<NNN>` for domain-scoped (e.g. `sk-R001`, `dc-R014`); `R<NNN>` for project-scoped in SPEC.md. Three-digit zero-padded, sequential within scope.
- **Append-only.** Never reuse a retired ID. Never renumber. Gaps are cheap; broken external references (tests, TODO, DONE, commits) are not.
- **Granularity: one ID per testable check.** Each `If <bad cond>, then...` edge case is its own ID. Heuristic: *can I write a single test for exactly this?* Bundling lets a Manager mark "done" while only covering one of several checks.
- **Splits.** Original ID stays for whichever half kept the spirit; the new piece gets the next available ID. Note the split in DONE.
- **Edits in place.** Clarification, edge case added, wording sharpened — same ID, content changes. Git is the version history.
- **Retirement.** When a requirement is removed, mark it `~~retired~~` in place (or remove the line entirely if the spec is too long); never reuse the number.

Write each requirement as `- **<id>** — <one sentence>.` so IDs are easy to scan and grep.

## Writing requirements

Read each requirement back: *could a competent agent build the wrong thing and still claim this was satisfied?* If yes, rewrite.

Phrasing patterns — pick what fits, mix freely:

| Pattern | Use for | Example |
| --- | --- | --- |
| **As a `<role>`...** | User-facing capability | *As a registered user, I can upload a photo and see it in my library within 5 seconds.* |
| **When `<event>`...** | Event-triggered behavior | *When a user submits the form, the system validates file type before storing.* |
| **While `<state>`...** | State-dependent behavior | *While the queue is paused, new enqueues are rejected with a clear error.* |
| **If `<cond>`, then...** | Error / unwanted condition | *If upload exceeds 10MB, then the system rejects it with HTTP 413.* |
| **Always...** | Invariant | *Always log upload events with user ID, timestamp, outcome.* |
| **Must `<rule>`** | Hard constraint | *Must run on the existing Cloudflare Workers deployment.* |
| **Cannot / Never `<rule>`** | Hard prohibition | *Never store credentials in plaintext.* |

Rules of thumb:

- One sentence per requirement. Name the actor.
- Plain language. "Shall"/"will"/"must" are equivalent — pick what reads cleanly.
- Lists, tables, or small diagrams are fine when prose can't capture it.
- If you can't write a check or test for it, it's still vague.

## Edge cases as requirements

Most spec failures are gaps in edge cases. They aren't a separate section — they're regular requirements phrased `If <bad condition>, then...` or `When <unusual event>...`.

Walk failure modes deliberately before scoping a Phase against a requirement. For each requirement, ask about: empty/oversized/malformed/duplicate/null input; network drops mid-operation; concurrent requests; expired auth, missing permission, rate limits; upstream slow or down; retry and partial failure. Each non-obvious answer becomes its own ID'd requirement in the appropriate spec. Edge cases discovered mid-Phase go back into the durable spec first (new ID, append-only), then get added to the Phase's TODO requirement list if they belong to the active Phase.

## Anti-patterns

- **Stack-bleed** — "Use Postgres", "Implement with Hono", file paths. → TODO, not spec.
- **Vague verbs** — "manages", "handles", "supports". Rewrite as specific behavior.
- **False precision** — invented latency or load numbers. Move to Backlog as open questions.
- **Massive specs** — when a domain spec gets unwieldy (~300+ lines, hard to scan), it usually means the domain has grown into two. Split into two domain specs with distinct two-letter prefixes; existing IDs keep their old prefix (don't renumber), new requirements take the new prefix.
- **Reasoning in the spec** — "We chose X because Y" belongs in an ADR or DONE note. Specs are about *what*.
- **Unsurfaced ambiguity** — multiple valid interpretations go to Backlog as open questions, not silent guesses.

## Writing the Phase entry

A Phase block in `TODO.md` has three parts: a header naming the Phase and listing its requirement IDs, one or more Objectives (declarative goals), and Tasks under each Objective (imperative steps).

```markdown
## Phase 4: Google OAuth 🌀
**Requirements**: au-R007, au-R008, au-R009, R002

### Provider integration
- [ ] Wire up the OAuth client library
- [ ] Implement the callback handler

### Session management
- [ ] Issue session tokens on success
- [ ] Implement token refresh
```

Format rules:

- **Header:** `## Phase N: <name>` with optional status marker (🌀 active, ✅ done) at the end.
- **Requirements line:** directly under the header — `**Requirements**: <id>, <id>, ...`. Bare IDs only; wording lives in the spec, not TODO.
- **Objectives** are `### <description>` — declarative, not imperative. "Provider integration", not "Integrate the provider".
- **Tasks** are `- [ ] <imperative step>` under their Objective. Sequential within an Objective; Objectives parallel within a Phase.

Heuristics:

- An Objective is a chunk a single subagent can own end-to-end. If two Objectives must serialize, they're really one Objective with two Tasks.
- Tasks should be specific enough that a subagent doesn't need a separate huddle to start. "Wire up the OAuth client library" is fine; "Do the OAuth stuff" isn't.
- Don't restate requirements in Tasks — the requirement IDs are the contract. Tasks are *how*, requirements are *what*.

## Scoping a Phase

When a Planner sets up a new Phase in `TODO.md`, the job is to give the Manager a tight, focused list of requirement IDs to satisfy. Workflow:

1. **Identify the work.** From a user request, a Backlog item, a follow-up from a prior Phase, or a learning that surfaced in DONE — figure out *what* the Phase is doing.
2. **Scan the durable specs for matching requirements.** Open the relevant domain spec(s) and `SPEC.md`. List the requirement IDs whose satisfaction would mean this Phase is done.
3. **Fill any gaps in the durable spec first.** If the Phase needs to deliver something no existing requirement covers, write the new requirement(s) into the right domain spec with new appended IDs. Walk edge cases (one ID per testable check). Don't write requirements directly into TODO — they live in the durable spec; TODO only references them.
4. **Confirm test-ability.** Each listed ID must be checkable or testable. If something is genuinely squishy, mark it in the spec ("squishy: judgment call in DONE") so the Manager doesn't get stuck looking for a test.
5. **List the IDs in the Phase.** Add a `**Requirements**:` line directly below the Phase header in TODO. Only IDs — the wording lives in the spec.
6. **Sanity-check coverage.** Read the Phase Tasks against the listed requirements: does every Task contribute to satisfying at least one ID, and does every ID have at least one Task that drives it? Mismatches mean the Tasks or the ID list need fixing before the Phase starts.

### Example

`SPEC.md` and `specs/au-auth.md` exist. The user says: *"add Google OAuth login."* In `specs/au-auth.md` you find:

```markdown
- **au-R007** — As a user, I can authenticate with a Google account and reach the dashboard within 3 seconds of consent.
- **au-R008** — If a Google authentication callback is missing the expected state token, then the system rejects it with a clear error.
- **au-R009** — When a returning Google user signs in, their existing account is reused; never create a duplicate.
```

`R002` lives in `SPEC.md` ("every action keyboard-reachable") and applies because the new login flow has UI. The Phase becomes `## Phase 4: Google OAuth 🌀` with `**Requirements**: au-R007, au-R008, au-R009, R002` directly below, then Objectives and Tasks (see the format example above).

If `au-R009` didn't exist yet — say you realized mid-scoping that duplicate-account handling wasn't covered anywhere — you'd add it to `specs/au-auth.md` with the next available ID *before* listing it in the Phase.

If a Phase ships and the user is unhappy with the result, the fix usually goes into the durable spec — clarify the requirement, add a missing edge-case ID, then schedule a follow-up Phase that targets the new/updated IDs.

## Living document

When implementation reveals a wrong, impossible, or incomplete requirement, update the durable spec *first* (edit in place under the same ID, or append a new ID), then adjust the active Phase's TODO ID list if affected. The behavior commit also touches the spec.

If a spec or TODO change is needed mid-Phase, stop work, make the change, resume. Never edit while subagents are running.

## Backlog and Meta

Both live in `SPEC.md` only — domain specs don't carry them.

- **Backlog** — future requirements, open questions, big ideas. Not active work. Consider when informing active decisions; don't start without Planner approval to promote into Requirements and a Phase. **Promote or delete** — lingering items are noise.
- **Meta** — unscoped tooling and configuration tasks: test-harness additions, linter config, pre-commit hooks. Flat list, no Objectives or Phases. Planner and Manager both add. Lives at the end of `DONE.md`, appended in completion order (not reverse-chronological like Phases). Clears by request, not at any handoff.
