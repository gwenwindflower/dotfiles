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
Last section in SPEC.md — never duplicated in TODO.md.
```

### `specs/<dom>-<slug>.md` (durable domain spec)

```markdown
## Goals
3-8 sentences scoped to the domain: what this slice does, what it doesn't.

## Requirements
Bulleted list. ID format: <dom>-R001, <dom>-R002, ...
```

Skip empty sections. Domain specs don't carry their own Backlog — that stays project-scope in `SPEC.md`.

## Requirement IDs

Every requirement gets a stable, soft-immutable ID:

- **Format.** `<dom>-R<NNN>` for domain-scoped (e.g. `sk-R001`, `dc-R014`); `R<NNN>` for project-scoped in SPEC.md. Three-digit zero-padded, sequential within scope.
- **Domain prefixes.** Two letters by convention (`sk`, `dc`, `cf`). One reserved 3-letter exception: `dev-` for development-meta domains — tooling, test infrastructure, build/release plumbing, CI, internal-only requirements that aren't user-visible. Lives in one or more `specs/dev-*.md` files (e.g. `specs/dev-testing.md`, `specs/dev-release.md`) and ships as normal Phases. Keep new domains 2-letter unless they're development-meta.
- **Append-only.** Never reuse a retired ID. Never renumber. Gaps are cheap; broken external references (tests, TODO, DONE, commits) are not.
- **Granularity: one ID per testable check.** Each `If <bad cond>, then...` edge case is its own ID. Heuristic: *can I write a single test for exactly this?* Bundling lets a Manager mark "done" while only covering one of several checks.
- **Splits.** Original ID stays for whichever half kept the spirit; the new piece gets the next available ID. Note the split in DONE.
- **Edits in place.** Clarification, edge case added, wording sharpened — same ID, content changes. Git is the version history.
- **Retirement.** When a requirement is removed, mark it `~~retired~~` in place (or remove the line entirely if the spec is too long); never reuse the number.

Write each requirement as `- **<id>** — <one sentence>.` so IDs are easy to scan and grep.

## Writing requirements

Read each requirement back: *could a competent agent build the wrong thing and still claim this was satisfied?* If yes, rewrite. The four hardening checks below give that question structure — run them on every requirement before it lands in a spec.

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

## Harden the requirement

Four checks. Run each one on every requirement before it lands. **The moment one flags, push back on the user — don't draft around it.** A vague phrase or a quiet conflict caught here costs a wording edit; the same problem caught at Objective close costs a rollback; caught after ship, a follow-up Phase. The whole burden of clarity sits in the spec, so this is where the work gets done.

| Check | Ask | Weak | Strong |
| --- | --- | --- | --- |
| **Unambiguous** | Would two competent agents formalize this the same way? | *The system removes the record.* (hard delete? soft delete?) | *The system marks the record deleted such that it no longer appears in any user-facing view.* |
| **Consistent** | Does anything else in the spec demand incompatible behavior in the same situation? | *Always log uploads* + *Never persist data for guest users* — both fire when a guest uploads. | Narrow one to "for authenticated users", or define the precedence explicitly with a third requirement. |
| **Complete** | Is there a reachable input or state where nothing says what to do? | Upload spec covers `>10MB` and valid sizes — nothing covers 0-byte. | Add *If upload size is zero, then the system rejects with HTTP 400.* See [Edge cases as requirements](#edge-cases-as-requirements) for the systematic walk. |
| **Verifiable** | Can you name the inputs, the outputs, and the observable condition that would prove it satisfied? | *Logins feel fast.* | *When a user submits valid credentials, the system returns a session token within 300ms at p95.* |

In practice:

- **Push back on the user, not around them.** "I read this two ways — A or B?" beats picking one quietly. Surface the question with the alternatives named; commit to the answer in the same exchange so the spec lands sharpened rather than re-litigated next Phase.
- **One ambiguity, sometimes two requirements.** If "remove the record" turns out to mean *both* hard delete (admin) and soft delete (user), split into two IDs with the actor baked into each.
- **Conflicts hide between specs, not within one.** When scoping a Phase, scan the *other* requirements its IDs interact with — same actor, same resource, overlapping state. Cross-domain collisions are the easiest to miss solo.
- **The checks bleed into each other.** A vague verb usually trips Unambiguous *and* Verifiable at once; a missing edge case is almost always a Completeness gap. Treat the four as one lens with four facets, not a checklist to march through.
- **Untestable ≠ squishy.** A genuine UX judgment call gets marked *squishy* (the DONE note captures the call). Untestable usually means the requirement is still vague — sharpen until inputs, outputs, and observable conditions name themselves.
- **Don't formalize past the point of usefulness.** These checks exist to surface real ambiguity, not to enforce courtroom prose. If a requirement is already obvious to two readers, leave it alone. The trap is process for its own sake; the goal is fewer bugs at ship time.

## Edge cases as requirements

The systematic walk behind the **Complete** check above. Edge cases aren't a separate section in the spec — they're regular requirements phrased `If <bad condition>, then...` or `When <unusual event>...`.

Walk failure modes deliberately before scoping a Phase against a requirement. For each requirement, ask about: empty/oversized/malformed/duplicate/null input; network drops mid-operation; concurrent requests; expired auth, missing permission, rate limits; upstream slow or down; retry and partial failure. Each non-obvious answer becomes its own ID'd requirement in the appropriate spec. Edge cases discovered mid-Phase go back into the durable spec first (new ID, append-only), then get added to the Phase's TODO requirement list if they belong to the active Phase.

## Anti-patterns

- **Stack-bleed** — "Use Postgres", "Implement with Hono", file paths. → TODO, not spec.
- **Vague verbs** — "manages", "handles", "supports". Rewrite as specific behavior.
- **False precision** — invented latency or load numbers. Move to Backlog as open questions.
- **Massive specs** — when a domain spec gets unwieldy (~300+ lines, hard to scan), it usually means the domain has grown into two. Split into two domain specs with distinct two-letter prefixes; existing IDs keep their old prefix (don't renumber), new requirements take the new prefix.
- **Reasoning in the spec** — "We chose X because Y" belongs in an ADR or DONE note. Specs are about *what*.
- **Unsurfaced ambiguity** — multiple valid interpretations go to Backlog as open questions, not silent guesses.

## Writing the Phase entry

A Phase block in `TODO.md` has a header (with optional dependency and required requirement-ID lines), one or more Objectives (declarative goals), and Tasks under each Objective (imperative steps).

```markdown
## Phase 4: Google OAuth 🌀
**Dependencies**: 2
**Requirements**: au-R007, au-R008, au-R009, R002

### Provider integration
- [ ] Wire up the OAuth client library
- [ ] Implement the callback handler

### Session management
- [ ] Issue session tokens on success
- [ ] Implement token refresh
```

Format rules:

- **Header:** `## Phase N: <name>` with optional status marker (🌀 active, ✅ done) at the end. Phase numbers are stable IDs assigned in creation order, not a sequencing instruction.
- **Dependencies line** (optional): `**Dependencies**: <N>, <N>, ...`. Bare Phase numbers — type is implicit; deps can only be other Phases. Omit the line entirely when there are none. A Phase is unblocked once every listed dependency is in DONE.
- **Requirements line:** directly under the header (or under Dependencies if present) — `**Requirements**: <id>, <id>, ...`. Bare IDs only; wording lives in the spec, not TODO.
- **Objectives** are `### <description>` — declarative, not imperative. "Provider integration", not "Integrate the provider".
- **Tasks** are `- [ ] <imperative step>` under their Objective. Sequential within an Objective; Objectives parallel within a Phase.

Phase titles and Objective wording are the labels the Manager and every subagent work from. Don't carry casual user phrasing — "the OAuth thing", "auth stuff" — into either. Propose a real name that reads cleanly out of context, confirm with the user, then build on it. See [naming](../../rules/naming.md).

## Phase dependencies

Phases run in parallel by default. The `**Dependencies**:` line is how the Planner declares that one Phase must wait for another.

- **What it means.** "Phase 5 depends on Phase 2" → Phase 5 cannot start until Phase 2 is in DONE. Not "started," not "merged to a branch" — fully promoted.
- **Independence is the goal.** Two Phases that touch different surfaces — different routes, different commands, separate subsystems — are usually independent and can run in parallel across worktrees or agent teams. Don't add a dependency unless you genuinely have one.
- **Coupling judgment.** Sometimes nominally-independent Phases share enough churn — both rewriting the same Vite config, both touching a core schema — that branch-switching costs more than serializing. That's a real reason to declare a dependency. Per-project judgment call; lean toward independence when the surfaces are clean.
- **Follow-ups.** When a Phase emerges as a follow-up to one currently in flight, declare the dependency at scoping time so a Manager doesn't pick it up early.
- **Cycles are bugs.** If two Phases mutually depend, they're really one Phase — merge them or split the work differently.

Update the line in place when reality changes (a dependency dissolves, a new one surfaces). Phase numbers themselves are append-only — never reuse, even if a Phase is retired.

Heuristics:

- A Phase is a chunk one agent team can take to DONE in a single context window. Phases are context boundaries — pace them so a Manager can pick one up cold from `SPEC.md` + the Phase's requirement IDs. Too big and the team loses the thread; too small and the team-assembly overhead outweighs the work.
- An Objective is a chunk a single subagent can own end-to-end. If two Objectives must serialize, they're really one Objective with two Tasks.
- Tasks should be specific enough that a subagent doesn't need a separate huddle to start. "Wire up the OAuth client library" is fine; "Do the OAuth stuff" isn't.
- Don't restate requirements in Tasks — the requirement IDs are the contract. Tasks are *how*, requirements are *what*.

## Scoping a Phase

When a Planner sets up a new Phase in `TODO.md`, the job is to give the Manager a tight, focused list of requirement IDs to satisfy. Workflow:

1. **Identify the work.** From a user request, a Backlog item, a follow-up from a prior Phase, or a learning that surfaced in DONE — figure out *what* the Phase is doing.
2. **Scan the durable specs for matching requirements.** Open the relevant domain spec(s) and `SPEC.md`. List the requirement IDs whose satisfaction would mean this Phase is done.
3. **Fill any gaps in the durable spec first.** If the Phase needs to deliver something no existing requirement covers, write the new requirement(s) into the right domain spec with new appended IDs. Walk edge cases (one ID per testable check). Run new *and* existing IDs touched by this Phase through the four hardening checks — surface any ambiguity, conflict, gap, or unverifiability to the user *now*, not at Objective close. Don't write requirements directly into TODO — they live in the durable spec; TODO only references them.
4. **Confirm test-ability.** Each listed ID must be checkable or testable. If something is genuinely squishy, mark it in the spec ("squishy: judgment call in DONE") so the Manager doesn't get stuck looking for a test.
5. **Decide dependencies.** Look at active and unstarted Phases — does this one truly need to wait for another, or share enough churn with one that serializing avoids worse pain? If yes, list the blocker Phase numbers on a `**Dependencies**:` line directly under the header. Otherwise — the more common case — omit the line. See "Phase dependencies" above.
6. **List the IDs in the Phase.** Add a `**Requirements**:` line directly below the header (or under Dependencies if present). Only IDs — the wording lives in the spec.
7. **Sanity-check coverage.** Read the Phase Tasks against the listed requirements: does every Task contribute to satisfying at least one ID, and does every ID have at least one Task that drives it? Mismatches mean the Tasks or the ID list need fixing before the Phase starts.

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

## Backlog

The last section of `SPEC.md`. Future requirements, open questions, big ideas. Not active work — consider when informing active decisions, but don't start without Planner approval to promote into Requirements and a Phase. **Promote or delete** — lingering items are noise.

- Lives only in `SPEC.md`. Domain specs don't carry their own Backlog. **Never duplicated in `TODO.md`** — TODO is for active Phases.
- Items are prose bullets (ideas, not Tasks); no checkboxes, no IDs until they're promoted into the relevant spec.

## Development-meta requirements (the `dev-` domain)

Test-harness additions, fixture reorgs, linter config, pre-commit hooks, build/release plumbing, CI — anything that isn't user-visible behavior but still needs to ship — are normal requirements in the `dev-` domain. Treat them like any other domain:

- Live in `specs/dev-*.md` (e.g. `specs/dev-testing.md`, `specs/dev-release.md`). Split files when one grows past ~300 lines, same as user-facing domains.
- Get IDs (`dev-R001`, `dev-R002`, ...) and ship as normal Phases scoped against those IDs.
- Indexed from `SPEC.md`'s `## Domain specs` list alongside user-facing domains.

There is no separate Meta section — that special case is gone. Tooling work is just work; the only difference is that `dev-` requirements describe internal targets (the test suite, the build, the harness) rather than user-visible behavior.
