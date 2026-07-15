---
name: technical-synthesis
description: Synthesize source material into a structured technical draft through a four-stage process with explicit feedback gates, plus pluggable form (audit, article) and tone (expert, friendly). Use when source content is rich in detail but low on form, and output structure matters as much as content — audits, codebase docs, research-synthesis articles, decision docs, post-mortems, position papers.
---

# Technical Synthesis

Structural synthesis is the work: finding the shape of the eventual document, surfacing the points only the synthesizer can produce, noticing where the source has gaps that need research or reasoning the source doesn't contain. Drafting is easy once the structure is right.

The skill is modular. A core staged process and a set of standards apply universally; pluggable **form** (structural conventions for the deliverable) and **tone** (register and voice) layer on top. Defaults: `audit` form + `expert` tone.

## When to use

Source material is rich in detail but low in form, and output structure matters as much as content. Concrete fits:

- Technical audits for a paying client or internal stakeholder
- Codebase docs synthesized from a repo and reading sessions
- Research-synthesis articles (paper + dataset + code → publishable explanation)
- Decision docs and ADRs grounded in scattered investigation
- Post-mortems pulled from incident logs and interviews
- Position papers drawing together field evidence

Skip for: editing an existing draft (use `prose-editor` or `writing-prose`); source-light creative writing; output under ~500 words where staging is overkill.

## Before you start

1. **Confirm audience.** Who they are, what they already know, what only the synthesizer can add.
2. **Pick form + tone.** Defaults `audit` + `expert`. Load the matching `form-<name>.md` before Stage 1 and `tone-<name>.md` before Stage 3.
3. **Confirm target system + format.** Structured system (Notion, Linear, Jira, Airtable) → build natively via API / SDK / CLI / MCP, populating real fields and relations. Plain text → narrative markdown. Single doc or multi-file? Length target?
4. **Build a private terminology taxonomy** from source — names of systems, models, repos, papers, datasets, dashboards. Working tool for your accuracy, not a shipped artifact. When the line between scratch notes and deliverable blurs, dump notes to memory and compact context.
5. **Flag premise uncertainties** before writing on top of them. If a finding depends on something unverified, ask now or note the gap explicitly.

## The four stages

Each stage produces output in a shape the user can critique surgically. **Do not progress without explicit user sign-off.** This is the mechanism that prevents downstream rework.

The failure pattern this prevents: the model produces a "final draft" built on the wrong structure; the user gives surface-level feedback because that is what the surface invites; the model edits sentences while leaving the structural problem in place; the loop repeats until either the user does the structural work themselves or the deliverable ships broken. Gates make structure the explicit subject of feedback at each stage, before there is prose to hide behind.

After each stage's output, ask for feedback and hold. Classify what comes back: structural (move bullets, cut sections, add a missing point) or prose-level (this sentence is unclear)? Structural feedback at any stage means restarting from the earliest stage affected — usually Stage 1. Prose-level feedback applies only at Stages 3 and 4.

### Where form and tone enter

| Stage | Form influence | Tone influence |
| --- | --- | --- |
| 1 Outline | Section conventions | None |
| 2 Expand | Evidence shape | None |
| 3 Bullet-draft | Cadence (e.g. finding → recommendation pairing) | Register, sentence length, devices |
| 4 Draft | Section style, transition density | Final voice pass |

### Stage 1: Structural outline

**Output**: fragments only, one bullet per intended section. Each bullet states the point that section will make — finding, claim, recommendation — not the topic it will cover.

"Two pipelines silently drop late-arriving data" is a Stage 1 bullet. "The system has reliability issues, including silent drops in two pipelines" is already Stage 2 — too smooth, too complete.

- **Resist the pull to write prose now.** Your default mode pulls toward coherent paragraphs. Fragments physically prevent this. Stay in fragments.
- **State points, not topics.** "Pipeline reliability" is a topic. "Two pipelines silently drop late data" is a point. The skill is in producing the point.
- **Include only what the synthesizer brings.** Recapping the source is not content. Bullets should be things a reader who already has the source material would still want to learn.

Gate: *"Here is the proposed structure. Anything to add, cut, reorder, or rework before I expand?"* Hold for feedback.

### Stage 2: Expanded bullets

**Output**: short expansion under each Stage 1 bullet — enough to test whether the structure works. Still listy in feel: no flowing prose, no introductory framing, no conclusions.

The expansion carries the content of each section: evidence, recommendation (where the form calls for one), connection to other points.

- **Mark gaps explicitly.** If a bullet needs evidence the source doesn't contain: `[need: actual repro steps]`, `[need: confirm with primary source]`. The user can fill gaps, send you to research, or drop the bullet.
- **Resist smoothing.** Output should still feel listy. If it's starting to read like prose, you've crossed into Stage 3.
- **Weak or empty bullets are structural signals, not expansion failures.** Flag and restructure rather than padding.

Gate: *"Here is the content under each bullet. Any sections weak, missing, or off-target before I expand to prose?"* Hold for feedback.

### Stage 3: Bullet-draft

**Output**: prose paragraphs under each bullet, with bullets still visible as headers or lead-ins. Structure stays scannable — a reader can scan, jump to one section, and say "cut this", "rewrite this opener", "this whole section is weak" without navigating continuous prose.

- **Each section stands on its own.** Transitions and cross-references arrive at Stage 4 once structure is stable.
- **Lead each section with the point.** First sentence is the bullet restated as a sentence. Evidence and recommendation follow. This pattern survives into Stage 4.
- **Prose elaborates the bullet; it doesn't introduce new points.** If you want to add a sentence that isn't a refinement of the bullet, the bullet was wrong or incomplete — flag and ask, don't paper over.
- **If a bullet wants more than a paragraph of elaboration, that's structural feedback.** Usually Stage 1 needed more granularity. Flag, propose the split, restructure — don't balloon the prose.

Gate: *"Here is the prose under each section. Any sections to cut, rework, or expand before I smooth into a continuous draft?"* Hold for feedback.

### Stage 4: Draft

**Output**: continuous prose. Bullets become section headers (or disappear, depending on the form), transitions added, the document reads as one piece.

Even here, minimal transitions. The technical-document voice doesn't need "Building on the previous section..." connective tissue. Sections still lead with their points. Apply `voice-and-flow.md` as the final prose pass.

The skill's job ends after Stage 4 sign-off.

## Standards

Universal rules. Forms and tones add to these; neither overrides them.

### Content

- **Don't recap what your audience already knows.** No stack summaries, scope recaps, team descriptions, "what dbt does" primers unless explicitly requested. The synthesizer's contribution is what only they can produce.
- **Lead with the point.** First sentence of each section is the most important sentence in it. Evidence and recommendation follow.
- **Use actual names.** Real model, repo, file, dataset, dashboard, paper, function names — never abstract them into generic categories ("the consumption surface", "the orchestration framework"). AI prose abstracts; technical synthesis specifies. Abstractions also make findings harder to act on — a reader can't pull up "the data quality posture", they can pull up `dbt_project.yml`.
- **Describe patterns, not people.** Aggregate or anonymize negative observations; never name individuals as sources of problems. Positive credit is the exception, welcome.
- **Hedge where uncertain.** "Seems", "appears", "based on a one-week sample" is calibration, not weakness. Showing the limits of what you verified earns trust in the rest.
- **No content duplication.** Each point belongs in exactly one section; reference from elsewhere by link. Duplication causes drift as copies diverge.
- **Never fake structure.** Plain-text deliverable → plain narrative markdown. Don't simulate structure with invented YAML frontmatter, kebab-case "relations", or pseudo-fields. Either build natively in the target system or commit to prose.
- **Apply `voice-and-flow.md` as the final prose pass.** AI-tell patterns apply to every tone — friendly relaxes register, not hygiene.

### Workflow

- **Compress structurally, not lexically.** Cutting words rarely fixes a bloated doc; restructuring does. Ask shape questions — is this section repetitive? Could three paragraphs collapse to one sentence plus two bullets? Can two parallel sections merge?
- **Splitting is not compression.** Chopping a 25-page doc into five 5-page files with the same redundant content distributes bloat; it doesn't remove it. Modular structure requires real links between modules, not copy-paste.
- **Phase-separate research from drafting.** Source materials sitting in context cause their phrasing, named entities, and framings to leak into the output even when you never explicitly decide to use them. Strong version: read source, take notes in a separate file, clear context, draft from notes. Minimum: between Stage 1 and Stage 2, summarize source to notes and stop referencing originals.
- **Restart from the outline after structural feedback.** "This section is weak" or "you missed a key point" means going back to Stage 1 or 2 for the affected area — not editing prose. Restarting feels expensive but is cheaper than editing prose built on the wrong skeleton.
- **One stage per turn.** Don't produce Stage 1 and Stage 2 together because both are quick. The gate only works if the user has the chance to redirect before the next stage's output exists.
- **Ask when feedback is ambiguous.** "Is this 'rework the section' or 'fix the sentence'?" One turn beats a full rewrite.
- **Sweep cross-references on every restructure.** "As mentioned above", "as we'll see" break when bullets move. Update on restructure; don't leave stale connective tissue, and don't paper over by duplicating content into the referencing section.
- **Use a fresh-context subagent for pre-gate critique.** The model that wrote the outline can't reliably critique its own choices — the same pattern-completion produced both. Spawn a subagent with only the source notes and the current stage's output (no prior drafts) and ask: "What is missing, what is redundant, what is a topic instead of a point?" Most useful before the Stage 1 gate. Distinct from the fanout below.
- **Outline-by-subagent fanout for large docs.** Spawn one subagent per major section, each summarizing its section bullet-per-paragraph. Assemble per-section outlines into one document outline. Spot redundancies and structural problems where the whole thing fits on a single screen. Optionally fan a second subagent to challenge the groupings.

## Two reflexes to resist

- **The doc-site reflex.** Rebuilding a guided tour through what the audience already knows. Symptoms: persona-based reading paths, "how to read this document" meta-sections, numbered nav prefixes (`01-engagement-context/`) implying a tour, contributor-style READMEs for one-off deliverables, `README.md` filename for a single deliverable that should be `audit.md` or `findings.md`.
- **The glib-voice reflex.** Puffing ordinary observations into prose theater. Symptoms: dressed-up findings ("opportunity to align on a unified definition of revenue"), abstract category labels ("the data quality posture"), tonal pretension. Specifics replace euphemism; the recommendation is often implicit in a well-stated finding.

## Forms and tones — modular catalog

**Forms** (structural conventions):

- `audit` (default) — findings-evidence-recommendations cadence, prioritized action, oriented to a paying client or internal stakeholder. See `form-audit.md`.
- `article` — thesis-driven, narrative arc, standalone artifact for a public-ish reader, no required recommendations. See `form-article.md`.

**Tones** (register and voice):

- `expert` (default) — terse, technical, vocabulary-dense, assumes knowledge, minimal connective tissue. See `tone-expert.md`.
- `friendly` — more elaborated, more transitions, second person in moderation, mild metaphor allowed; still substantive, never breezy. See `tone-friendly.md`.

Form × tone compose freely (expert audit, friendly audit, expert article, friendly article). Standards apply over the top. A friendly audit still doesn't recap contract scope; an expert article still leads with the point.

**Outside the catalog.** If the request doesn't fit a catalog entry, ask the user to describe the form or tone they want, improvise from the standards, and capture as a new sub-doc following the established shape if the form or tone will recur.

## Self-check before delivery

If any item fails, rewrite.

- [ ] No audience-known content (scope, team, foundational concepts) unless requested
- [ ] Specific names used throughout — no generic abstractions where a real name exists
- [ ] No dressed-up ordinary observations; findings stated concretely
- [ ] Lead-with-the-point cadence in every section
- [ ] Patterns described in aggregate; no individuals named as sources of problems
- [ ] Uncertain observations marked as uncertain; verified conclusions stated plainly
- [ ] No content duplicated across sections — each point lives in exactly one place
- [ ] Outline-level review done before sentence-level editing; for large docs, outline-by-subagent fanout used
- [ ] No docs-site tells (descriptive filename, no nav prefixes, no persona paths, no meta-sections)
- [ ] No faked structure (invented YAML, kebab-case relations) when targeting plain text
- [ ] `voice-and-flow.md` pass applied
- [ ] Form and tone self-checks complete

## Reference docs

- `voice-and-flow.md` — universal AI-tell hygiene; applied at Stage 4
- `form-audit.md`, `form-article.md` — structural conventions, anti-patterns, exemplar, self-check per form
- `tone-expert.md`, `tone-friendly.md` — register, allowed devices, anti-patterns, self-check per tone
