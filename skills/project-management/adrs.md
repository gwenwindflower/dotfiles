# Decision records (ADRs)

Optional. An ADR records a change of direction on a requirement that already shipped, so the spec can say what's true now while the reasoning stays findable. Use them sparingly; most situations don't need one.

## When to write one

| Situation | Where it goes |
| --- | --- |
| New requirement | The spec, with a fresh ID. **No ADR.** |
| Requirement on a not-yet-merged branch | Edit in place or remove. **No ADR.** |
| Rationale for newly shipped work | The PR description. **No ADR.** |
| **Changing the behavior of a shipped requirement** | **ADR.** Edit the requirement in place (or retire it) and write the ADR to record the reversal and its rationale. |
| **Retiring a shipped requirement** | **ADR.** Same shape — explain why. |
| A pivot in a load-bearing architectural choice | **ADR**, when future work needs the reasoning and a PR description isn't a findable enough home. |

When in doubt, ask: *will the next agent reading the spec need to understand why this changed, not just what it is now?* If not, skip it.

## File shape

`docs/adr/yyyy-mm-dd-<slug>.md`, date-prefixed for chronological listing. Use the project's docs layout if it already has an ADR home. Copy [the template](assets/adr-template.md):

- Frontmatter: `name`, `date`, `requirements` (the IDs it amends), `status` (`proposed`, `accepted`, `rejected`, or `superseded`), and `superseded-by` when superseded.
- Four sections, in order: **Context** (the situation, quoting the amended requirements by ID), **Decision** (the new direction and the spec edits it drives), **Alternatives considered** (one h3 per option, including keeping the original when that was real), **Consequences** (positives and negatives).

## Lifecycle

- The ADR lands as `proposed` with its spec edits and flips to `accepted` in the commit that ships the change. The PR description names the ADR file.
- `rejected` ADRs stay as a record of the path not taken.
- An accepted ADR is append-only; changing it means writing a new ADR and marking the old one `superseded`.
- An ADR recording a decision that already shipped without one stands alone as a `chore(adr)` commit.

ADRs piling up fast usually means specs were written loosely or ahead of what anyone understood. Sharpen the requirements that drive work ([sharpening checks](specs.md#sharpening-checks)) and hold off on the ones nobody needs yet.
