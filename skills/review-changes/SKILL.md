---
name: review-changes
description: Reviewing code changes - where to look, framing trade-offs as open questions, composing the review. fallow review briefs and graph-validated judgments for JS and TS.
---

# Reviewing changes

A review makes the consequential choices in a change legible and hands the calls to the human who owns them. Checks a tool already runs (lint, dead code, duplication, complexity, formatting) are counted, not re-derived.

| Job | Doc |
| --- | --- |
| Review a JS or TS change with a module graph behind it | [fallow](fallow.md) |
| Surface the design trade-offs no tool can detect | [tradeoffs](tradeoffs.md) |

## Composing the review

Order the write-up so the reader lands on what changes the outcome first:

1. **Structural decisions**: new public-API contracts, new cross-boundary coupling, new or major-bumped dependencies. Each carries the number that gives it weight, like consumers outside the diff.
2. **Trade-offs**: at most five, ranked by consequence. When nothing rises to a real decision, say so in one line.
3. **Deterministic findings**: one line of counts from the tools that own them, marked as outside the discussion.
4. **Deprioritized**: one line with the count and how to see them, so nothing is hidden.

A review with no decisions and no trade-offs is complete: "nothing consequential; deterministic findings: N". Never invent items to fill a slot.

## Rules

- **Leverage first.** One structural decision plus ten small notes means the decision is the review; the notes ride below it or not at all.
- **Numbers, not adjectives.** Every finding cites a count or a path. "Could be slow" is not a finding; "imported by 14 modules, 9 outside this diff" is.
- **Open questions, never prescriptions.** Ask how, what, or under what conditions. A question that names the fix ("..., or should this map to a domain error?") is a prescription; reframe it to the decision ("How should this surface a storage failure to its callers?").
- **Test adjacency is not coverage.** Say whether a test imports the changed unit; ask the author for the verification story when none does. Green tests verify behavior, not the design decisions.
- **Seams are facts, not demands.** When a high-risk change splits into independent slices, name the seam; splitting is the author's call.
