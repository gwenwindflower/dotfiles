# fallow

`fallow review` turns a JS or TS changeset into a review brief built from the module graph. It subtracts deterministic findings, ranks changed units by attention score, and frames the few structural decisions as questions anchored to graph signals. It always exits 0; `fallow audit` is the pass/fail CI gate. fallow is not installed globally, so check `fallow --version` or the project's dev dependencies before relying on it.

## Brief

```bash
fallow review                                   # base auto-detected from the upstream merge-base
fallow review --base origin/main
git diff --find-renames origin/main...HEAD | fallow review --base origin/main --diff-stdin
```

`--format json` emits the full envelope (`decisions`, `focus`, `deltas`, `impact_closure`, `partition`, `graph_facts`). `--max-decisions N` tunes the cap; `--show-deprioritized` expands the collapsed focus list.

## Decisions

Each decision is a framed question with a `signal_id`, a `category`, and an `anchor_file`/`anchor_line`. There are three categories:

| Category | Signal |
| --- | --- |
| `coupling-boundary` | A new cross-zone dependency edge |
| `public-api-contract` | A new exported API, or a changed contract consumed outside the diff |
| `dependency` | A `package.json` that adds third-party entries or crosses a major (or `0.x` minor) version; batched per manifest, weighted by in-repo importers (`blast`, `internal_consumer_count`) |

Frame a `dependency` decision as the changelog question ("which documented change from 2.x to 3.x reaches these 14 importers?") rather than guessing the behavior change. It has no suppress action; never put a `// fallow-ignore` comment in a manifest.

A decision carries `previous_signal_id` when its anchor file was renamed, so a prior comment can follow a `git mv`.

## Judgment loop

fallow post-validates agent or human judgments against the live graph; an anchor it never emitted is rejected.

1. Fetch the guide: `fallow review --base <ref> --walkthrough-guide --format json > guide.json`. It holds the `digest`, the review `direction`, the `graph_snapshot_hash` staleness pin, `agent_schema`, the emitted `signal_id`s, and per-region `change_anchors` (`chg:<hex>`). The digest comes from the graph only, never PR prose.
2. Write judgments that match `agent_schema`:

   ```json
   {
     "graph_snapshot_hash": "<echoed verbatim from the guide>",
     "judgments": [
       { "signal_id": "<emitted signal>", "framing": "<reasoning with a number or path>", "action": "address", "concern": "coupling" },
       { "change_anchor": "<emitted chg: id>", "framing": "<note on this region>", "action": "consider" }
     ]
   }
   ```

   `action` is one of `block`, `address` (both required of the author), `consider` (optional), or `fyi`; the guide's `agent_schema.action_vocabulary` is enforced. `concern` is advisory; read the lenses from `agent_schema.concern_vocabulary`.
3. Validate: `fallow review --base <ref> --walkthrough-file judgment.json --format json`.

| Result | Meaning | Fix |
| --- | --- | --- |
| `accepted` | Anchor emitted and snapshot current; the framing stays `deterministic: false` and never gates | None |
| `unanchored-signal-id` | The `signal_id` was never emitted | Drop it or pick a real one |
| `unknown-change-anchor` | The `change_anchor` was never emitted | Re-anchor to a real region |
| `invalid-action` | The label is outside the vocabulary (checked after the anchor resolves) | Fix the anchor first, then the label |
| `stale-snapshot` | The tree moved since the guide was fetched | Re-fetch the guide and redo the judgments |

The same loop carries a human reviewer's notes from the terminal: show the tour with `fallow review --base <ref> --walkthrough`, collect a verdict and one of the four actions per flagged item, and validate them as judgments. fallow validates the anchor, never the note.

## Composing from the guide

Follow the order in [SKILL.md](SKILL.md) with fallow's fields:

- Decisions in `direction.order`, each with the digest `question` and `tradeoff` verbatim, then the framing, then `internal_consumer_count`, the `out_of_diff` paths, or the unit's `scoring_budget`.
- Subtract as one line of the brief's counts: "handled deterministically: N dead-code, N duplication, N complexity, N styling".
- `test_adjacency` on each direction unit is `none`, `untouched`, or `changed`; for a `review-here` unit with `none`, ask for the verification story.
- `digest.partition.independent_slices` appears only when a change has two or more connected components. Name them as an orientation fact when `digest.triage.risk_class` is `high`.
