# Trade-offs

Graph tools prove only structural decisions. Abstraction level, error handling, data-model shape, state ownership, and trust boundaries need a model reading the diff. The model makes each choice legible and frames the open question; the human decides. The model never prescribes, blocks, or applies a fix.

## Contract

1. **Anchor to the diff.** Each item's anchor is a changed line that is the locus of the trade-off. The prose may name untouched code as the affected party; the anchor may not point there.
2. **Keep three layers separate and neutral.**
   - `observed`: what the change does, read straight from the diff. "Returns the raw error to the caller", not "returns the raw error instead of mapping it", which already judges.
   - `tradeoff`: what it gains and what it costs, both sides at equal weight.
   - `question`: the call the human owns, genuinely open. If the only question names a fix, reframe it.
3. **Fence it.** Every item is an inference (`deterministic: false`); it never gates or auto-posts.
4. **Provenance.** `captured: true` only when the agent that wrote the code in this session is reporting the rationale it actually had. Reconstructed intent is always `false`.
5. **Abstain freely.** Keep the top five by `consequence`, then `confidence`. When nothing rises to a real decision, return `abstained: true` with an empty list.
6. **Don't duplicate the tools.** Skip anything fallow's decisions or a linter already raised.
7. **One cross-cutting slot**, only when no single changed line is the cause (a combination of changes, or something the diff omits): anchor `cross-cutting`, confidence `low`.
8. **Options never pick.** An item may list two or more moves, each with a real gain and cost, unranked, always including "Keep as is". With only one move besides keeping, omit options; a single move is a prescription.

`consequence` is impact if the call is wrong; `confidence` is how strongly the diff supports the reading (`high`: the diff alone shows it; `medium`: plus a reasonable assumption; `low`: mostly reconstructed). They are independent.

## Lenses

Scan the diff through these; most changes touch two or three.

| Lens | Where the choice hides |
| --- | --- |
| Abstraction | Extracted vs inlined; a generalization built for one caller |
| Coupling | Two concerns joined; a reach across a seam; new shared mutable state |
| Data model | Optional vs required; invariant in the type vs checked at runtime; enum vs open string |
| Error handling | Result vs throw; propagate vs swallow; silent fallbacks; failure granularity |
| Control flow | A branch hiding a second responsibility; implicit statement ordering |
| Performance | Sync vs async; eager vs lazy; a cache and its invalidation; work on a hot path |
| Dependencies | A new package vs a few native lines; the transitive surface |
| API ergonomics | Names encoding assumptions; boolean or positional parameters; leaky abstractions |
| Compatibility | Breaking vs additive; implied data or config migrations; missing deprecation path |
| State ownership | Where state lives; lifecycle and cleanup; global vs scoped |
| Extensibility | A seam for a future that may not come; a hard-coded choice costly to change |
| Testability | Hidden time, IO, or randomness; no seam left for a test |
| Trust boundary | Where input is validated; secret handling; injection surfaces |

## Named moves

Use this vocabulary so two runs describe the same restructuring the same way:

- Replace a conditional chain with a typed model or a dispatcher.
- Collapse duplicate branches into one flow.
- Separate orchestration from business logic.
- Move feature-specific logic to the module that owns the concept.
- Reuse the canonical helper instead of a near-duplicate.
- Make a type boundary explicit so downstream branching disappears.
- Delete a pass-through wrapper that adds indirection without clarifying the API.
- Extract a helper, or split a large file into focused modules.
- Keep as is.

## Output

Render each item for a human as the anchor, then observed, trade-off, options, and the question last. With fallow, emit the JSON envelope to `.fallow-review/tradeoffs.json` so a review surface can render it; it is never round-tripped through `--walkthrough-file` and never presented as fallow-validated.

```json
{
  "graph_snapshot_hash": "<echoed from the fallow guide, when there is one>",
  "abstained": false,
  "tradeoffs": [
    {
      "id": "to:src/core/api.ts:42:error-handling",
      "anchor": "src/core/api.ts:42",
      "lens": "error-handling",
      "observed": "save() returns the raw DB error to the caller.",
      "tradeoff": "Callers see full storage detail with no translation layer, and depend on the storage layer's error shapes.",
      "options": [
        { "move": "Keep as is", "gains": "Callers can match on the exact storage failure.", "costs": "Callers depend on storage error shapes." },
        { "move": "Make a type boundary explicit", "gains": "Callers depend on one domain error shape.", "costs": "Detail the mapping drops is lost, and the mapping must be kept in sync." }
      ],
      "question": "How should save() surface a storage failure to its callers?",
      "consequence": "high",
      "confidence": "medium",
      "captured": false,
      "deterministic": false
    }
  ]
}
```

Sort items by anchor, then lens. The `id` is `to:<anchor>:<lens>`, so one line can carry several lenses without colliding.
