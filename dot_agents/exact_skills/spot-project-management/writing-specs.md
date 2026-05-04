# Writing Specs

Planner work. The whole burden of clarity sits in the spec — there are no requirement IDs, separate constraints sections, or acceptance criteria.

## Shape

Project and phase specs share sections, scaled to scope:

```markdown
## Goals
3-8 sentences: description, goals, **non-goals**.
Non-goals matter most — they prevent helpful drift.

## Requirements
Bulleted list. See "Writing requirements".

## Backlog          (project spec only)
Future requirements, open questions, big ideas. Promote or delete.

## Meta             (project spec only)
Unscoped tooling/config tasks.
```

Skip empty sections. Phase-spec backlogs would vanish at promotion — put those items in the project backlog or resolve before promoting.

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

Walk failure modes deliberately before promoting. For each requirement, ask about: empty/oversized/malformed/duplicate/null input; network drops mid-operation; concurrent requests; expired auth, missing permission, rate limits; upstream slow or down; retry and partial failure. Each non-obvious answer becomes a requirement. Edge cases discovered later go *back into the spec* — phase-specific to phase spec, cross-cutting to project spec.

## Anti-patterns

- **Stack-bleed** — "Use Postgres", "Implement with Hono", file paths. → TODO, not spec.
- **Vague verbs** — "manages", "handles", "supports". Rewrite as specific behavior.
- **False precision** — invented latency or load numbers. Move to Backlog as open questions.
- **Massive specs** — over ~300 lines is usually multiple phases pretending to be one. Split.
- **Reasoning in the spec** — "We chose X because Y" belongs in an ADR or DONE note. Specs are about *what*.
- **Unsurfaced ambiguity** — multiple valid interpretations go to Backlog as open questions, not silent guesses.

## Promotion gate

Before a Planner promotes a phase spec to TODO:

1. Every requirement could be checked or tested.
2. Phase-relevant Backlog questions are resolved or explicitly deferred.
3. User-supplied requirements are captured or intentionally out of scope.
4. Edge cases have been walked, not just transcribed.

If a spec drives a TODO that produces something the user didn't want, the fix usually goes into the spec.

## Living document

When implementation reveals a wrong, impossible, or incomplete requirement, the Planner updates the spec *first*, then adjusts affected TODO Objectives. The behavior commit also touches the spec.

**Planner never operates on a Phase while it's in flight.** If a spec or TODO change is needed mid-Phase, work stops, the change is made, and work resumes. Concurrent Planner edits and active Subagent work cause drift.
