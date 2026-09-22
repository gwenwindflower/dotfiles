# Tone: Expert

The expert tone assumes the reader knows the technical domain and reads quickly. Density per sentence is high; connective tissue is minimal. The reader did not show up to be entertained — they showed up to extract the synthesizer's contribution and move on.

## Register

- **Vocabulary-dense.** Use terms of art directly; don't gloss them. A reader who doesn't know `idempotent` or `materialized view` is not the audience.
- **Assertive.** State conclusions directly; reserve hedging for genuine calibration on uncertain claims, not for politeness padding.
- **Third person or impersonal default.** Second person is rare; first person is rare; when either appears, it's load-bearing (e.g., "I haven't confirmed X" — hedging the synthesizer's verification).

## Rhythm and length

- **Short to medium sentences.** Prose scans like signal, not narrative. Long sentences earn their length by carrying a list or a tight causal chain, not by accumulating asides.
- **Minimal connective tissue between sections.** No "Building on the previous section..."; no "Having established X, we now turn to Y." Sections lead with their points and continue.
- **One idea per paragraph.** Paragraphs are dense but unilateral. A second idea in a paragraph is a sign that idea wanted its own section.

## Allowed devices

- **Hedging on uncertain claims** — encouraged. "Seems", "appears", "based on a one-week sample".
- **Technical jargon and precise terminology** — encouraged. Use the exact name of the thing.
- **Code, table, and command fragments inline** — encouraged. `prod_analytics`, `LatestOnlyOperator`, `dbt run --select state:modified+`.
- **Metaphor** — sparingly, only when it tightens a precise idea. Almost never decorative.
- **Asides** — almost never. If the aside is load-bearing, it earns its own sentence.

## Tone-specific anti-patterns

- Glossing technical terms the audience knows ("a SQL transformation tool called dbt")
- Politeness padding that softens conclusions ("you might consider perhaps looking at...")
- Decorative metaphor that doesn't tighten a specific idea
- Conversational transitions ("Now, the interesting thing is...", "What this means is...")
- Asides inside asides — em-dashed parentheticals stacked inside parenthesized clauses
- Second person used to address the reader directly ("you'll notice that...", "if you look at...")
- Throat-clearing intensifiers ("clearly", "obviously", "of course")

## Tone-specific self-check

- [ ] Terms of art used directly; nothing glossed unless the audience genuinely lacks the term
- [ ] Conclusions stated directly; no politeness padding
- [ ] Sentences scan as signal, not narrative — long sentences earn their length
- [ ] Minimal connective tissue between sections
- [ ] No decorative metaphor; metaphor present only where it tightens a precise idea
- [ ] No second-person address unless load-bearing
- [ ] No throat-clearing intensifiers ("clearly", "obviously", "of course")
