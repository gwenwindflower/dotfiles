# Decision records (ADRs)

Planner work, optional. ADRs are SPOT's **release valve** for amending decisions that have already shipped to main — they let us change direction on a committed requirement without rewriting history, while keeping records like `DONE.md` mostly immutable.

Use them sparingly. Most situations don't need one.

## When to write one (and when not to)

| Situation | Where it goes |
| --- | --- |
| New requirement | Durable spec (`SPEC.md` or `specs/`), with a fresh ID. **No ADR.** |
| Requirement on a not-yet-merged branch | Edit in place or remove. **No ADR** — the branch hasn't committed to anything yet. |
| Rationale for newly shipped work | `DONE.md` narrative for the Phase. **No ADR.** |
| **Changing the behavior of a shipped requirement** | **ADR.** Edit the requirement in place (or retire it) *and* write the ADR to publicize the reversal and preserve the rationale. |
| **Retiring a shipped requirement** | **ADR.** Same shape — explain why. |
| Mid-project pivot in a load-bearing architectural choice | **ADR.** Optional; use when the choice will affect future Phases enough that DONE narrative isn't a discoverable enough home. |

The point: `DONE.md` is append-only. Once a Phase lands, its block stays put. ADRs are how we **publicize a change in direction** without going back and editing what we said before.

## File shape

`docs/adr/yyyy-mm-dd-<slug>.md` — date-prefixed for chronological listing, slug for human navigation. Default location is `docs/adr/`; pick something else if the project's docs layout already disagrees, but stay consistent within a project.

Frontmatter:

```yaml
---
name: <Human-readable title>
date: yyyy-mm-dd
requirements: [<id>, <id>, ...]
status: proposed | accepted | rejected | superseded
superseded-by: yyyy-mm-dd-<slug>  # only when status: superseded
---
```

Body — four h2 sections, in this order, no more:

1. **Context** — 3-8 sentences. The situation, what's prompted the rethink, and the existing requirement(s) being amended quoted by ID with current wording.
2. **Decision** — 1-3 sentences. The new direction. Name the spec edits this ADR drives — new wording, retired IDs, new IDs.
3. **Alternatives considered** — one h3 per option (`### Option A: <label>`). Include *do nothing / keep the original requirement* when it was a real option.
4. **Consequences** — h3 `Positives` and h3 `Negatives`, each a short bullet list.

A starting template lives at [assets/adr-template.md](assets/adr-template.md). Copy it; don't reinvent the shape per ADR.

## Status lifecycle

- **proposed** — drafted, not yet acted on. Spec edits not yet landed.
- **accepted** — in effect; spec edits are landed.
- **rejected** — written and discussed, not adopted. Keep the file as a record of the consideration; it documents the path not taken.
- **superseded** — a later ADR overrode this one. Set `superseded-by:` to the new ADR's filename. The old ADR stays in place — never delete or rewrite a superseded ADR; supersede again if needed.

Once accepted, an ADR is itself append-only. Edits beyond typo fixes mean supersession.

## How an ADR rides through a Phase

The common case — ADR drives spec changes that land in a Phase:

1. Planner writes the ADR with `status: proposed` and the new spec edits in the same Phase scope. The Phase's `**Requirements**:` line covers the changed IDs.
2. The Phase that lands the spec edits also lands the ADR file. The Phase-close commit flips `status: accepted`.
3. The Phase's `DONE.md` block mentions the ADR by filename so future readers can trace it from either direction (requirement → ADR, or ADR → shipping Phase).

Purely retrospective ADRs — recording a decision that already shipped without one — stand alone as a `chore(adr)` commit. That's a legitimate spec-only commit case (see [running-phases](running-phases.md#spec-only-commits--when-they-earn-their-keep)).

## Don't over-use them

Every active ADR is a flag that says "this part of the spec has history worth understanding." If they pile up fast, it usually means one of two things:

- The spec was thrashed under-formalized. Apply the [hardening checks](writing-specs.md#harden-the-requirement) harder upfront and most ADRs become unnecessary.
- The project is in a genuine period of flux that warrants the historical record. Fair, but worth occasionally pausing to acknowledge — "we're churning, why?"

When in doubt, ask: *will the next agent reading the spec need to understand why this changed, not just what it is now?* If no, skip the ADR — let the spec edit and the Phase's DONE narrative speak for themselves.
