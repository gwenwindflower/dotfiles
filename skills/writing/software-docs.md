# Software docs

Humans and agents need the same thing from software docs: scannable, clear information at the right level of detail. This covers READMEs, `docs/` pages, guides, and reference. The `context-engineering` principles apply here too: be specific, disclose progressively, and record nothing twice.

## Write for what readers do

Decide what users need to know or might want to do, and document that. The goal is not to translate every detail of the software into natural language.

- **Include a caveat only when it changes what a reader does.** Sentences stuffed with edge cases make the common path hard to find.
- **Put exhaustive detail in reference pages**, where readers look things up, and keep it out of guides, where they follow along.
- **Leave out what the code, types, or help text already say** unless readers need it in the flow of the page.

## Edit the corpus, not just the page

Zoom out before every edit, including small targeted ones. Surgical additions piled onto a page slowly wreck its structure, and the knowledge base with it.

1. Read the whole page and skim its neighbours and the index before changing anything.
2. Decide where the information belongs, which may be a different page or section from the one named in the request.
3. Reshape the surrounding section when the addition does not fit its flow: reorder, merge, split, or retitle.
4. Reread the page top to bottom as a first-time reader and fix the flow.

### One home per fact

Record each detail in one place and link to it with a short pointer everywhere else. Details repeated at the same depth drift apart and rot. Before writing, search the corpus for an existing home; extend it or link to it.

### Page balance

- **Split a page** when readers arrive for several separate jobs and must scroll past the others.
- **Merge pages** too thin to stand alone; many tiny pages cost readers a click and their context each time.
- **Order a page** the way readers meet the topic: what it is, the common path, variations, then reference detail.

## Structure first

Default to structure. A page of chunky paragraphs is a draft.

| Content | Form |
| --- | --- |
| Sequential steps | Numbered list |
| Parallel items, options, rules | Bulleted list, often with a bold lead naming the item |
| Items sharing several comparable attributes, or lookup reference | Table |
| Commands, config, code, output | Fenced code block with a language |
| The one thing a reader must not miss | Bold, used sparingly |

- **Headings carry the outline.** A reader skimming only headings should find the right section. Name the content, not its category: `Rotate an API key`, not `Usage`.
- **Nest headings deliberately.** Use the full range of levels to show how ideas relate, and give sibling headings parallel wording.
- **Keep items short.** One idea per list item or table cell; move the detail to its home and link.

## Where prose belongs

Reach for paragraphs where connected reasoning helps:

- Introductions to a page or section
- Concept-oriented guides
- Summaries and conclusions that tie a page together

Write these as polished prose by the rest of this skill: full sentences, natural voice, neither clipped agent-context shorthand nor stiff formality.

## Describe the current system

Docs describe the software as it is. A reader arriving fresh has no memory of earlier behavior, so correcting it only plants a false assumption.

| Change | Write | Not |
| --- | --- | --- |
| `export` wrote CSV and writes Parquet | "`export` writes Parquet." | "`export` does not write CSV; it writes Parquet." |

Record decisions, rationale, and history only when that is the page's explicit job: changelogs, migration guides, ADRs.

## Before delivering

- The heading outline alone tells a reader what the page covers and where.
- No fact appears at full detail in two places.
- Every sentence makes sense to someone who knows only the current system.
- Each paragraph earns its place over a list or table.
