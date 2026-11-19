# Decision records (ADRs)

Optional, and rare. An ADR records a change of direction on something that already shipped — a spec requirement in a project that uses specs, or a load-bearing design choice — so the code and docs can say what's true now while the reasoning stays findable. Most changes need only a PR description or merge summary.

## When to write one

| Situation | Where it goes |
| --- | --- |
| Rationale for newly shipped work | The PR description or merge summary. **No ADR.** |
| Anything on a not-yet-merged branch | Edit in place. **No ADR.** |
| **Reversing or retiring shipped spec behavior** | **ADR.** Edit the spec to say what's true now; the ADR records why. |
| **A pivot in a load-bearing architectural choice** | **ADR**, when future work needs the reasoning and a PR isn't a findable enough home. |

When in doubt, ask: *will the next agent need to understand why this changed, not just what it is now?* If not, skip it.

## File shape

`docs/adr/yyyy-mm-dd-<slug>.md`, date-prefixed for chronological listing. Use the project's docs layout if it already has an ADR home. Copy [the template](assets/adr-template.md):

- Frontmatter: `name`, `date`, `amends` (what it changes: requirement IDs in a project that uses them, otherwise a short description or doc link), `status` (`proposed`, `accepted`, `rejected`, or `superseded`), and `superseded-by` when superseded.
- Four sections, in order: **Context**, **Decision**, **Alternatives considered** (one h3 per option, including keeping the original when that was real), **Consequences**. Keep each short.

## Lifecycle

- The ADR lands as `proposed` with its edits and flips to `accepted` in the commit that ships the change. The PR description or merge summary names the ADR file.
- `rejected` ADRs stay as a record of the path not taken.
- An accepted ADR is append-only; changing it means writing a new ADR and marking the old one `superseded`.
- An ADR recording a decision that already shipped without one stands alone as a `chore(adr)` commit.
