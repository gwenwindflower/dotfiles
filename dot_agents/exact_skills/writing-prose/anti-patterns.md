# Prose Anti-Patterns

Hard-no list of AI-writing tells distilled from real edit passes. Every entry below was a pattern that survived several reads before getting caught — they're subtle, recur often, and erode trust as a class. Read before drafting or editing any prose meant for human readers.

## The voice we're going for

Plain, direct, grounded. Lead with the point, not the setup. Hedge where uncertain; be humble on genuine judgment calls.

Trust the reader. They can infer more than the writer thinks. Anything that re-explains what they already know is friction.

No punch, no snark, no glib, no slick.

---

## 1. Rhetorical constructions that scream LLM

The strongest tells. Cut on sight.

**"It's not A. It's B."** — false contrast to score a rhetorical point. State B directly.

- Bad: "The flagship treats DVC as a participation signal; the tool operators treat it as a throughput signal."
- Good: One sentence stating the grain mismatch.

Variants: "Not because X. Because Y.", "The answer isn't X. It's Y.", "It feels like X. It's actually Y.", "The question isn't X. It's Y.", "stops being X and starts being Y." Same formula, same fix.

**Staccato triples** — three short fragments strung together for rhythm.

- Bad: "There is no registry, no seed table, no macro."
- Good: One phrase naming the gap.

Same family: "[Noun]. That's it. That's the [thing].", "X. And Y. And Z."

**Punchy zingers at section ends** — aphoristic closers that "feel" satisfying.

- Bad: "The 260-line Zoom-registration matcher goes away; the registry accretes under review."
- Good: Collapse the point into the recommendation itself.

**Symmetrical If/If or parallel constructions** — twin-clause balance for cleverness.

- Bad: "If the agent succeeds, the spine is right. If it fails, the failure mode points at which layer is wrong."
- Good: One statement of the property.

**Em-dash zinger chains** — em-dashes carrying unearned emphasis.

- Bad: "the auth and infra story is already solved end-to-end — that's why the worked example is built around it"
- Good: Tighten and drop the em-dash payoff.

Em-dashes themselves are fine; the pattern to cut is the *zinger payoff*, the em-dash setting up a clever closer. See [voice-and-flow](voice-and-flow.md) for when em-dashes work.

---

## 2. Hollow emphasis

Emphasis without semantic load. The reader hears the volume but gets no signal.

- **Italics-for-tone** on individual words (*shape*, *itself*, *before*, *answers*). Remove.
- **Bolded mid-sentence phrases** (`**thin BI surface that any presentation tool can render**`). Remove the bold; let the prose carry it.
- **Scare-quotes around your own framing**: `"'is the build paying off?'"`. Drop the quotes.

**Sentence-opening markers** — "More importantly", "Crucially", "Notably", "Importantly", "Interestingly". Drop. If a sentence is important, it'll read that way.

**Throat-clearing openers** — phrases that announce the writer is about to say something:

- "Here's the thing:"
- "The uncomfortable truth is"
- "It turns out"
- "Let me be clear"
- "The truth is,"
- "Can we talk about"
- "Here's what I find interesting"
- "Here's the problem though"

Drop and state directly. Announcing importance doesn't add it.

**Emphasis cliches** — "Full stop.", "Period.", "Let that sink in.", "Make no mistake", "Here's why that matters", "This matters because". Volume without signal.

---

## 3. Intensifier and puffery words

Strip on sight; they almost never do real work.

`actually`, `actual`, `clean(ly)`, `deeply`, `essentially`, `exactly`, `genuinely`, `inherently`, `interestingly`, `just`, `literally`, `merely`, `nice`, `of course`, `perfectly`, `precisely`, `pretty`, `quite`, `really`, `simply`, `so`, `surely`, `trivially`, `truly`, `ultimately`, `uniquely`, `very`

- Bad: "the design conversation is the **actual** gating step"
- Good: "the design conversation is the gating step"

- Bad: "is the right tool for **exactly this shape of work**"
- Good: "is the right tool for this work"

A few earn their keep when they specify a real degree or constraint: `crucially` for an element a system genuinely does not function without; `foundationally` for actual foundations; `fundamentally` when distinguishing a deep difference from a surface one. The test: does the word add a specific quantity, or just announce that the writer cares?

Emphasis adverbs *can* work on specific concrete details — "the button animation is really smooth" highlights a particular quality. They fail when applied to broad feelings — "really quite fantastic" is a hard remove.

**Absolutes** — `always`, `never`, `everybody`, `everywhere`, `nobody`. False authority when used for emphasis.

- Bad: "Everywhere you go, everybody's talking about X."
- Good: "A lot of my colleagues have praised X."

Genuine absolutes are fine; hyperbolic ones aren't.

**Coined adjective-nouns** — minting buzzy phrases for things that already have plain names.

- Bad: "the current dance", "the agentic substrate", "the canonical-eleven source list", "modeling exhaust"
- Good: "the workflow", "the agent layer", "the eleven sources", drop the metaphor.

A coined phrase earns its keep only when it names something specific that recurs throughout the piece and warrants a label.

**Phrase-flourishes** — colorful turns for things that are simple.

- Bad: "every new audience is a fresh round of negotiation about what counts as reachable"
- Good: State the gap plainly.

**Critique-by-metaphor** — "graveyard", "wild west", "the dance". Judgmental imagery for things with real, neutral names.

---

## 4. Jargon and tired cliches

Plain language beats jargon. When in doubt, describe the situation directly.

**Business jargon** — replace with plain words.

| Avoid | Use instead |
| --- | --- |
| Game-changer | Significant, important |
| Double down | Commit, increase |
| Circle back | Return to, revisit |
| On the same page | Aligned, agreed |
| Move the needle | Make a difference |

**Sports, gambling, and war metaphors** are prevalent in business writing but they're tired and alienate many readers. Dig for an original metaphor that earns its place, or describe what's happening.

**Tech jargon cliches in general prose** — "X is a feature, not a bug" is tired unless you're literally describing a software limitation with unexpected upside.

**Tired cliches** — wholesale drop:

- "Sing the praises of" → "speak highly of"
- "Seen the light" → "now understand"
- "Welcome to X" / "Welcome to the future of X"
- Year-stating: "Why are we still doing X in 2026?" → state the actual issue
- "X will never be the same" → name the specific shift
- "Wake up, X is here"

---

## 5. Re-explaining what the reader knows

Anything the reader brought to the piece is shared context — don't summarize it back at them.

- **Don't define common concepts.** A term shared between writer and audience doesn't need a gloss.
- **Don't restate the reader's own setup.** In domain writing (audits, reviews, internal docs), if the audience built or operates the system, don't enumerate it for them.
- **Don't editorialize their problems.** "which is fragile business logic embedded in SQL" — the reader sees the fragility.

**Tutorial framing** — bridges that explain what the piece is about to do.

- Bad: "Concretely this means…", "What follows is the part a reader needs to evaluate the approach"
- Good: Make the point. The reader doesn't need a tour guide.

**Sales-pitch reassurance** — confidence claims that read as defensive.

- Bad: "every metric and dimension keeps working", "well under any reasonable context budget", "so analysts and operators can trust it"
- Good: Drop. Honest uncertainty is more credible than smooth assurance.

**Telling instead of showing** — announcing difficulty or significance rather than demonstrating it. `actually`, `genuinely`, and `truly` are red flags here.

- Bad: "This is genuinely hard", "This is what leadership actually looks like", "Actually, this is a really significant improvement", "This is truly a game-changer"
- Good: Show the difficulty. Let the reader feel it through what you describe, not what you claim.

---

## 6. Reasoning leaking into the doc

**The most insidious tell of the current model generation.** Opus 4.7 and GPT-5.5 do extended internal reasoning before producing output. That reasoning routinely bleeds into the prose itself as reflective asides, process narration, and verbose recap of the working session.

The reader was not in the conversation. Cut anything that only makes sense if they had been.

- **Process narration** — "After looking at X, I noticed Y." Drop the narration; state Y directly.

- **Alternatives weighed in chat** — "We considered X but settled on Y because…" State Y; drop the deliberation.

- **Parenthetical asides** preserving thinking-out-loud:
  - Bad: "(complements the other thing)", "(no extra setup needed)", "(fits the existing convention)"
  - Good: Cut. If the parenthetical changes the meaning, fold it into the sentence; otherwise drop.

- **Quoted self-phrasings** from earlier in the working session:
  - Bad: "the entry mechanism is 'a person becomes an activist by taking their first tracked action.'"
  - Good: State the rule plainly without the self-quote.

- **Leftover planning-doc language** — scoping notes, doc-shape decisions, deliberate omissions:
  - Bad: "Step-by-step plan, not 'accelerate.'" / "What's deliberately under-specified here"
  - Good: Either resolve the question or cut the meta-note.

- **Reflective recaps of work just done** — sentences that summarize prose the reader has already read. The model that drafted the section wants to land it; the reader is already past it.

The test: would this sentence make sense to someone who skipped straight to this section? If it depends on having watched the doc get built, or on the working session behind it, cut it.

Process and history live elsewhere — commits, drafts, conversation transcripts. The piece holds the current state.

---

## 7. Document meta-voice

The piece doesn't narrate itself.

- **Drop structure meta**: "Two longer design pitches live as appendices because inlining them would bury the rest", "This section sits in Part 3 rather than Part 4 because…".
- **Drop scope/process recaps**: opener paragraphs that list what's covered, the four-part structure to come, the hours spent.
- **Drop performative "we"**: "before we add anything", "the work is built on", "for this one example". Phrase as findings or claims, not as tour guides.
- **No section-number cross-refs** (§1.4.2, Part 2, Part 4). They break the moment structure shifts. Use descriptive links to the relevant heading instead.
- **No cross-references inside intros**. Make the point first; link out only when the reader will actually want to leave.

**Topic-label headings** — headings should lead with the finding, not name the topic.

- Bad: "A thin presentation layer across the stack", "The four layers", "Retrieval and the always-loaded triad"
- Good: A heading that states what the section concludes.

---

## 8. Rigor

**No sentence fragments / telegraph style as a default.**

- Bad: "Cheapest item in the plan."
- Good: "This is the cheapest item in the plan because…"

Fiction and stylized prose use fragments deliberately for rhythm. The LLM default of breaking complete thoughts into telegraph fragments to feel punchy is the tell to cut.

**Verify before stating; show method alongside numbers.** When a confident claim rests on sampled evidence, name the method and add an `Open:` annotation flagging what isn't fully verified.

- Bad: "more than 150 raw references"
- Good: "more than 150 raw references (`grep -rE …`; may miss multi-line shapes)"

**Never name an individual as the source of a problem.** Even when file paths or directories carry someone's name. Patterns, not people — prefer neutral corpus descriptors when natural.

---

## The subtractive pass

Before shipping, read each sentence and ask whether removing it changes the meaning. If not, cut. Reread the headings — does each state a finding or label a topic? Reword the topic-labels. Pay extra attention to section openers and closers; rhetorical satisfaction tends to land at boundaries.

Every sentence the reader spends attention on should return something they didn't already have.
