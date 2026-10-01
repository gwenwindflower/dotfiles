# Specs

A spec is the contract between the person who asked for the work and the agents who build it. The person reads it top to bottom and says "yes, that's what I want" or points at the wrong line; an agent builds from it without guessing. Specs live in the repo, where version control evolves them; the plan for doing the work lives in Linear.

## Using specs well

Specs record clear requirements whenever they're known or needed. They can drive a big plan for a fresh build, grow alongside fixes, or be written after the fact for an older project moving onto specs. How much to spec, and when, is a judgment call that can change over a project's life.

Specs let agents work independently over long stretches, let people check intent against their goals, and give tests something stable to point at. Their cost is upkeep: a requirement written before anyone understands the behavior is a guess someone has to maintain.

Dimensions worth weighing:

- **Maturity.** A new project can spec its design up front. A years-old one usually gains specs as its parts get touched.
- **Existing workflow.** Adapt to a strong one and work within it. Bring a chaotic one into order through improvements people feel, a few at a time, rather than a front-loaded overhaul.
- **Kind of project.** A CLI or app has designed behavior that can be written down ahead. Data and analytics work discovers behavior from source data, so its requirements tend to come out of the work.
- **Tests.** A clear test pattern is where specs hook in. When specs and tests are both weak, improve them together. A monorepo with several frameworks follows each area's own conventions.
- **People and horizon.** A solo project needs less written down than a team of hundreds. Agents working alone over a long horizon need more. A team that doesn't use specs doesn't get them pushed into its issues.

The trap is over-investment: many specs up front, then following them at the expense of the project's goals. Specs serve the goals; when following one works against them, say so.

Over time, move the project toward one consistent spec rhythm (where specs live, how they're written, when they change) and then work within it. When a rhythm already exists, use it.

## Write for the person who asked

Agents drift toward formal, dense specs that only other agents can parse. Resist it:

- **Plain sentences.** "Users can sign in with Google" beats "The system shall provide Google-based authentication capabilities." Name who does what and what they see.
- **Short.** Goals in a few sentences, a requirement in one sentence. If a requirement needs two sentences it is two requirements.
- **No filler words.** Drop leverage, robust, seamless, ensure, facilitate, comprehensive, orchestrate, canonical, and "surface" as a verb. Say what happens.
- **No boilerplate structure.** Skip empty sections, "N/A" lines, and headers that exist to look complete. A spec with three requirements is a paragraph and three bullets.
- **Say each thing once.** Goals set direction; requirements pin behavior. Don't restate a requirement in the goals or a goal in a requirement.
- **Vocabulary only when it earns its place.** Define a term when the project uses it in a specific way; don't build a glossary of ordinary words.

Readback test before a spec lands: cover the IDs and read it as prose. If it doesn't sound like the person describing their own project, plain it down.

## Shape

A starting shape for projects without one. When a project already has a spec layout, use it.

- **`SPEC.md`** — the project contract: goals and non-goals, vocabulary when the project's words carry specific meaning, an `@`-import index of domain specs, project-scope requirements (`R001`), and open questions. Non-goals matter most; they prevent helpful drift.
- **`specs/<dom>-<slug>.md`** — one per domain: a few sentences of goals, then requirements (`<dom>-R001`). Two-letter prefixes for user-visible domains (`sk-skills.md`, `dc-docs.md`); the reserved `dev-` prefix for tooling (test harness, hooks, build and release, CI).

```markdown
## Domain specs
- @specs/sk-skills.md
- @specs/dev-release.md
```

Open questions are prose bullets for murky definitions and undecided behavior. Promote one into a requirement when the work settles it, or delete it. Future work goes to Linear, not the spec.

## Requirement IDs

- **Format.** `<dom>-R<NNN>` for domain-scoped (`sk-R001`), `R<NNN>` for project-scoped. Three digits, sequential within scope. Write each requirement as `- **<id>** — <one sentence>.` so IDs are easy to scan and grep.
- **One check per ID.** A requirement that bundles several checks lets work be called done while covering only one. Heuristic: *can a single test cover exactly this?*
- **Edit freely until something references it.** Before any test, commit, issue, or PR cites an ID, renumber, delete, and restructure at will.
- **After that, append-only.** Existing IDs keep their numbers and edit in place; new requirements take the next number; retired ones are marked `~~retired~~` and never reused. Gaps are cheap; broken references are not. Substantive reversals on shipped requirements get an [ADR](adrs.md).
- **Splits.** The original ID stays with whichever half kept the spirit; the new piece gets the next number.

## Writing requirements

Read each requirement back: *could a competent agent build the wrong thing and still claim this was satisfied?* If yes, rewrite.

Write natural sentences first. These shapes help when a plain sentence leaves the trigger or the actor unclear — they are options, not a template to fill:

| Shape | Use for | Example |
| --- | --- | --- |
| **As a `<role>`...** | Who benefits and what they can do | *As a registered user, I can upload a photo and see it in my library within 5 seconds.* |
| **When `<event>`...** | Behavior triggered by something | *When a user submits the form, the system checks the file type before storing it.* |
| **While `<state>`...** | Behavior that depends on a state | *While the queue is paused, new enqueues are rejected with a clear error.* |
| **If `<condition>`, then...** | Failures and unwanted input | *If an upload exceeds 10MB, then the system rejects it with HTTP 413.* |
| **Always / Never ...** | Invariants and prohibitions | *Never store credentials in plaintext.* |

If you can't name a check or test for a requirement, it's still vague.

## Sharpening checks

Use these on a requirement that reads loose or will drive a lot of independent work. Skip them when two readers already agree on what it means.

| Check | Ask | Weak | Strong |
| --- | --- | --- | --- |
| **Unambiguous** | Would two competent agents build this the same way? | *The system removes the record.* (hard delete? soft delete?) | *The system marks the record deleted so it no longer appears in any user-facing view.* |
| **Consistent** | Does anything else in the spec demand incompatible behavior in the same situation? | *Always log uploads* + *Never persist data for guest users* — both fire when a guest uploads. | Narrow one to "for signed-in users", or add a third requirement that says which wins. |
| **Complete** | Is there a reachable input or state where nothing says what to do? | Upload spec covers `>10MB` and valid sizes — nothing covers 0-byte. | Add *If upload size is zero, then the system rejects with HTTP 400.* |
| **Verifiable** | Can you name the inputs, outputs, and observable condition that prove it? | *Logins feel fast.* | *When a user submits valid credentials, the system returns a session token within 300ms at p95.* |

When a check flags, ask if the readings lead to materially different results. Otherwise pick the reasonable reading, write it in, and say so. Either is fine; guessing without a trace is not.

Edge cases worth a thought when a requirement handles input or outside systems: empty, oversized, malformed, duplicate, or null input; network drops; concurrent requests; expired auth or missing permission; a slow or down upstream; retry and partial failure. Write down the answers that aren't obvious, as regular `If <condition>, then...` requirements.

A genuine UX judgment call ("feels responsive") can stay *squishy*; the PR records the call.

## Anti-patterns

- **Stack-bleed** — "Use Postgres", "Implement with Hono", file paths. That's implementation, not requirements.
- **Vague verbs** — "manages", "handles", "supports". Rewrite as specific behavior.
- **Formal filler** — "The system shall provide the capability to", "in order to facilitate". Say what happens.
- **False precision** — invented latency or load numbers. Make them open questions.
- **Massive specs** — past ~300 lines a domain has usually grown into two. Split with distinct prefixes; existing IDs keep their old prefix.
- **Reasoning in the spec** — "We chose X because Y" belongs in an ADR or the PR. Specs are about *what*.
- **Process as requirements** — rules about how the team works (rollout checklists, evidence logs, review steps) aren't requirements. They belong in docs or `AGENTS.md`.
- **Unsurfaced ambiguity** — multiple valid interpretations become open questions, not silent guesses.

## Specs and issues

Issues hold the work; specs hold the requirements. When an issue implements requirements, link the spec file once, on the default branch, and quote an ID with its wording only when a few specific requirements are the point. Don't restate requirements in the issue. A bare ID like `au-R007` means nothing inside Linear, and in a workspace where nobody uses specs, don't reference them at all.

## Living document

When the work shows a requirement is wrong or incomplete, edit it in place or append a new one in the same commit as the behavior, and note the change in the PR. Check with the user first when the change alters what's being built. Never quietly bend a requirement to match the output.
