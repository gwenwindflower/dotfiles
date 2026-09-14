# Writing Specs

Planning work. A spec is the contract between the person who asked for the work and the agents who build it. It has to do two jobs at once: the person reads it top to bottom and says "yes, that's what I want" or points at the wrong line; an agent builds from it without guessing. The whole burden of clarity sits here — there are no separate constraints sections or acceptance criteria. Requirements get stable IDs so plans can point at them.

## Write for the person who asked

Agents drift toward formal, dense specs that only other agents can parse. Resist it:

- **Plain sentences.** "Users can sign in with Google" beats "The system shall provide Google-based authentication capabilities." Name who does what and what they see.
- **Short.** `SPEC.md` goals in 3–8 sentences, a domain spec's goals in 3–5, a requirement in one sentence of about 25 words. If a requirement needs two sentences it is two requirements.
- **No filler words.** Drop leverage, robust, seamless, ensure, facilitate, comprehensive, orchestrate, canonical, and "surface" as a verb. Say what happens.
- **No boilerplate structure.** Skip empty sections, "N/A" lines, and headers that exist to look complete. A spec with three requirements is a paragraph and three bullets.
- **Say each thing once.** Goals set direction; requirements pin behavior. Don't restate a requirement in the goals or a goal in a requirement.
- **Vocabulary only when it earns its place.** Define a term when the project uses it in a specific way; don't build a glossary of ordinary words.

Readback test before a spec lands: cover the IDs and read it as prose. If it doesn't sound like the person describing their own project, plain it down.

## Shape

### `SPEC.md`

```markdown
## Goals
3-8 sentences: what this is, what it should do, what it should not do.
Non-goals matter most — they prevent helpful drift.

## Vocabulary           (only when the project's words carry specific meaning)
Inline glossary or a pointer to a docs/ glossary file.

## Domain specs
@-import index of specs/<dom>-*.md files.

## Requirements
Project-scope only — cross-cutting checks that belong to no one domain.
IDs: R001, R002, ...

## Backlog
Future requirements, open questions, big ideas. Promote or delete.
Last section — never duplicated in the plan.
```

### `specs/<dom>-<slug>.md` (durable domain spec)

```markdown
## Goals
3-5 sentences scoped to the domain: what this slice does, what it doesn't.

## Requirements
Bulleted list. IDs: <dom>-R001, <dom>-R002, ...
```

Skip empty sections. Domain specs don't carry their own Backlog — that stays project-scope in `SPEC.md`.

## Greenfield mode — edit ruthlessly before ship

The append-only rules below exist to keep **external references** honest: tests citing IDs, commits closing Phases, ledger entries, follow-up work referencing earlier work. Those references only exist once the project has started shipping.

While a project is still in planning — nothing shipped, no commits referencing requirement IDs — there's nothing to preserve. **Edit ruthlessly.** Renumber freely. Delete obsolete requirements outright rather than retiring them. Restructure domain splits. Rewrite goals and non-goals. If a decision gets superseded before the first Phase lands, replace it cleanly — no ADR, no `~~retired~~` marker, no historical breadcrumb. This applies to plans, specs, and project docs alike.

The switch flips at first ship. Once the first Phase closes — or the first commit references a requirement ID — IDs become soft-immutable: existing IDs keep their numbers and edit in place; new requirements append; substantive reversals on already-shipped requirements get ADRs.

## Requirement IDs

- **Format.** `<dom>-R<NNN>` for domain-scoped (`sk-R001`, `dc-R014`); `R<NNN>` for project-scoped in `SPEC.md`. Three digits, sequential within scope.
- **Domain prefixes.** Two letters (`sk`, `dc`, `cf`). One reserved 3-letter exception: `dev-` for development-meta domains — tooling, test infrastructure, build/release, CI, anything internal rather than user-visible. Lives in `specs/dev-*.md` (`specs/dev-testing.md`, `specs/dev-release.md`) and ships as normal work.
- **Append-only once shipped.** Never reuse a retired ID. Never renumber. Gaps are cheap; broken references in tests, plans, and commits are not.
- **One ID per testable check.** Each `If <bad condition>, then...` edge case is its own ID. Heuristic: *can I write a single test for exactly this?* Bundling lets a session mark "done" while only covering one of several checks.
- **Splits.** The original ID stays with whichever half kept the spirit; the new piece gets the next available ID. Note the split in the ledger.
- **Edits in place.** Clarification, edge case added, wording sharpened — same ID, content changes. Git is the version history.
- **Retirement.** Mark `~~retired~~` in place (or remove the line if the spec is long); never reuse the number.

Write each requirement as `- **<id>** — <one sentence>.` so IDs are easy to scan and grep.

## Writing requirements

Read each requirement back: *could a competent agent build the wrong thing and still claim this was satisfied?* If yes, rewrite.

Write natural sentences first. These shapes help when a plain sentence leaves the trigger or the actor unclear — they are options, not a template to fill:

| Shape | Use for | Example |
| --- | --- | --- |
| **As a `<role>`...** | Who benefits and what they can do | *As a registered user, I can upload a photo and see it in my library within 5 seconds.* |
| **When `<event>`...** | Behavior triggered by something | *When a user submits the form, the system checks the file type before storing it.* |
| **While `<state>`...** | Behavior that depends on a mode | *While the queue is paused, new enqueues are rejected with a clear error.* |
| **If `<condition>`, then...** | Failures and unwanted input | *If an upload exceeds 10MB, then the system rejects it with HTTP 413.* |
| **Always / Never ...** | Invariants and prohibitions | *Never store credentials in plaintext.* |

Rules of thumb:

- One sentence per requirement. Name the actor.
- "Shall", "will", and "must" are equivalent; "can" and "is" usually read better. Pick what a person would say.
- Lists, tables, or small diagrams are fine when prose can't capture it.
- If you can't name a check or test for it, it's still vague.

## Harden the requirement

Four checks. Run them on every requirement before it lands. **The moment one flags, push back on the user — don't draft around it.** Caught here, an ambiguity costs a wording edit; at review, a redo; after ship, a follow-up Phase.

| Check | Ask | Weak | Strong |
| --- | --- | --- | --- |
| **Unambiguous** | Would two competent agents build this the same way? | *The system removes the record.* (hard delete? soft delete?) | *The system marks the record deleted so it no longer appears in any user-facing view.* |
| **Consistent** | Does anything else in the spec demand incompatible behavior in the same situation? | *Always log uploads* + *Never persist data for guest users* — both fire when a guest uploads. | Narrow one to "for signed-in users", or add a third requirement that says which wins. |
| **Complete** | Is there a reachable input or state where nothing says what to do? | Upload spec covers `>10MB` and valid sizes — nothing covers 0-byte. | Add *If upload size is zero, then the system rejects with HTTP 400.* See [Edge cases as requirements](#edge-cases-as-requirements). |
| **Verifiable** | Can you name the inputs, outputs, and observable condition that prove it? | *Logins feel fast.* | *When a user submits valid credentials, the system returns a session token within 300ms at p95.* |

In practice:

- **Ask, don't guess.** "I read this two ways — A or B?" beats picking one quietly. Name the alternatives and commit to the answer in the same exchange.
- **One ambiguity, sometimes two requirements.** If "remove the record" means *both* hard delete (admin) and soft delete (user), split into two IDs with the actor in each.
- **Conflicts hide between specs.** When scoping work, scan the *other* requirements its IDs interact with — same actor, same resource, overlapping state.
- **Untestable usually means vague.** A genuine UX judgment call gets marked *squishy* (the ledger captures the call). Otherwise sharpen until inputs, outputs, and observable conditions name themselves.
- **Don't formalize past usefulness.** The checks surface real ambiguity; they don't demand courtroom prose. If two readers already agree on a requirement, leave it alone.

## Edge cases as requirements

The systematic walk behind the **Complete** check. Edge cases aren't a separate section — they're regular requirements phrased `If <bad condition>, then...` or `When <unusual event>...`.

Before scoping work against a requirement, ask about: empty, oversized, malformed, duplicate, or null input; network drops mid-operation; concurrent requests; expired auth, missing permission, rate limits; upstream slow or down; retry and partial failure. Each non-obvious answer becomes its own ID'd requirement. Edge cases discovered mid-Phase go into the durable spec first (new ID, append-only), then onto the active Phase's requirement list if they belong there.

## Anti-patterns

- **Stack-bleed** — "Use Postgres", "Implement with Hono", file paths. → Plan, not spec.
- **Vague verbs** — "manages", "handles", "supports". Rewrite as specific behavior.
- **Formal filler** — "The system shall provide the capability to", "in order to facilitate". Say what happens.
- **False precision** — invented latency or load numbers. Move to Backlog as open questions.
- **Massive specs** — past ~300 lines a domain has usually grown into two. Split with distinct prefixes; existing IDs keep their old prefix, new requirements take the new one.
- **Reasoning in the spec** — "We chose X because Y" belongs in an ADR or the ledger. Specs are about *what*.
- **Unsurfaced ambiguity** — multiple valid interpretations go to Backlog as open questions, not silent guesses.

## Writing the Phase entry

Repo plan only; the Linear equivalent is a parent issue ([linear-planning](linear-planning.md)). A Phase block in `TODO.md` has a header (with optional dependency and requirement-ID lines), one or more Objectives (declarative goals), and Tasks under each Objective (imperative steps).

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

- **Header:** `## Phase N: <name>` with optional status marker (🌀 active, ✅ done). Phase numbers are stable IDs assigned in creation order, not a sequencing instruction.
- **Dependencies line** (optional): `**Dependencies**: <N>, <N>`. Bare Phase numbers. Omit when there are none. A Phase is unblocked once every listed dependency is in DONE.
- **Requirements line:** directly under the header (or under Dependencies) — `**Requirements**: <id>, <id>`. Bare IDs only; wording lives in the spec.
- **Objectives** are `### <description>` — declarative. "Provider integration", not "Integrate the provider".
- **Tasks** are `- [ ] <imperative step>` under their Objective. Sequential within an Objective; Objectives run in whatever order execution warrants and each lands as one commit.

Phase titles and Objective wording are what the executing session and its helpers work from. Don't carry casual user phrasing — "the OAuth thing" — into either. Propose a real name that reads cleanly out of context, confirm with the user, then build on it. See [naming](../../rules/naming.md).

## Phase dependencies

Phases run in parallel by default. The `**Dependencies**:` line declares that one Phase must wait for another. In Linear the same judgment produces a `blocks` relation.

- "Phase 5 depends on Phase 2" means Phase 5 cannot start until Phase 2 is in DONE — fully closed, not started or merged to a branch.
- **Independence is the goal.** Phases that touch different surfaces are usually independent. Don't add a dependency unless you genuinely have one.
- **Shared churn is a real reason.** Two nominally independent Phases both rewriting the same config or schema may cost more to branch-switch than to serialize. Lean toward independence when the surfaces are clean.
- **Follow-ups** to an in-flight Phase declare the dependency at scoping time so nobody picks them up early.
- **Cycles are bugs.** Mutually dependent Phases are one Phase — merge them or split the work differently.

Update the line in place when reality changes. Phase numbers are append-only — never reuse, even if a Phase is retired.

Sizing:

- A Phase is what one session can close in a single context window, and a fresh session can pick up cold from `SPEC.md` plus the Phase's requirement IDs.
- An Objective is one reviewable unit — one well-named commit. If no single subject covers it, split; if two Objectives only ever describe one change, merge.
- Tasks are specific enough to start without a huddle. "Wire up the OAuth client library" is fine; "Do the OAuth stuff" isn't.
- Don't restate requirements in Tasks. Requirement IDs are *what*; Tasks are *how*.

## Scoping a Phase

The job is to give the executing session a tight list of requirement IDs to satisfy. Same steps for a Linear parent issue, with spec links in place of the `**Requirements**:` line.

1. **Identify the work** — a user request, a Backlog item, a follow-up, or a learning from the ledger.
2. **Scan the durable specs** for the requirement IDs whose satisfaction would mean this Phase is done.
3. **Fill spec gaps first.** New behavior gets new appended IDs in the right domain spec, edge cases walked, hardening checks run on new *and* touched IDs. Surface ambiguity to the user now, not at review. Requirements never go directly into the plan.
4. **Confirm testability.** Mark genuinely squishy IDs in the spec ("squishy: judgment call in the ledger") so execution doesn't stall looking for a test.
5. **Decide dependencies** per the section above.
6. **List the IDs** on the `**Requirements**:` line.
7. **Check coverage.** Every Task drives at least one ID; every ID has at least one Task. Fix mismatches before the Phase starts.

### Example

`SPEC.md` and `specs/au-auth.md` exist. The user says: *"add Google OAuth login."* In `specs/au-auth.md` you find:

```markdown
- **au-R007** — As a user, I can sign in with a Google account and reach the dashboard within 3 seconds of consent.
- **au-R008** — If a Google callback is missing the state token, then the system rejects it with a clear error.
- **au-R009** — When a returning Google user signs in, their existing account is reused; never create a duplicate.
```

`R002` in `SPEC.md` ("every action keyboard-reachable") applies because the login flow has UI. The Phase becomes `## Phase 4: Google OAuth 🌀` with `**Requirements**: au-R007, au-R008, au-R009, R002`, then Objectives and Tasks.

If `au-R009` didn't exist yet, you'd add it to `specs/au-auth.md` with the next available ID *before* listing it in the Phase.

If a Phase ships and the user is unhappy, the fix usually goes into the durable spec — clarify the requirement, add a missing edge-case ID, then schedule follow-up work against the new or updated IDs.

## Living document

When implementation reveals a wrong, impossible, or incomplete requirement, update the durable spec *first* (edit in place under the same ID, or append a new ID), then adjust the active Phase's ID list or the parent issue's spec links. The behavior commit also touches the spec.

If a spec or plan change is needed mid-Phase, stop work, make the change, resume. Never edit while helpers are mid-task.

Substantive reversals on requirements **already shipped to main** — wording changes that alter behavior, retirements, behavior pivots — get an [ADR](adrs.md) alongside the spec edit. Edits to in-flight or never-shipped requirements don't. Before *any* Phase has shipped, [Greenfield mode](#greenfield-mode--edit-ruthlessly-before-ship) applies.

## Backlog

The last section of `SPEC.md`. Future requirements, open questions, big ideas. Not active work — consider it when informing decisions, but don't start on an item without promoting it into Requirements and a Phase or issue. **Promote or delete** — lingering items are noise.

- Lives only in `SPEC.md`. Domain specs don't carry a Backlog. Never duplicated in the plan.
- Items are prose bullets; no checkboxes, no IDs until promoted.

## Development-meta requirements (the `dev-` domain)

Test-harness additions, fixture reorganization, linter config, hooks, build/release plumbing, CI — anything that isn't user-visible but still needs to ship — are normal requirements in the `dev-` domain:

- Live in `specs/dev-*.md`. Split past ~300 lines like any domain.
- Get IDs (`dev-R001`, ...) and ship as normal Phases or issues scoped against them.
- Indexed from `SPEC.md`'s `## Domain specs` list alongside user-facing domains.

Tooling work is just work; `dev-` requirements describe internal targets (the test suite, the build, the harness) rather than user-visible behavior.
