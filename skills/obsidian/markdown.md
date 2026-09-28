# Obsidian Flavored Markdown

Obsidian extends CommonMark and GFM with wikilinks, embeds, callouts, properties, comments, and a few inline marks. Only those extensions are covered here; standard markdown works as usual. Notes are created and appended through `notesmd-cli` ([notesmd-cli.md](notesmd-cli.md)).

## Writing a note

- Link related notes with wikilinks. Search the vault for the real note name first; a wikilink to a missing note shows up as unresolved.
- Use `[[wikilinks]]` for notes in the vault, since Obsidian updates them on rename. Use `[text](url)` only for external URLs.
- Write headings in sentence case.
- Copy the frontmatter shape of a sibling note of the same kind rather than composing one.

## Links

```markdown
[[Note Name]]
[[Note Name|Display text]]
[[Note Name#Heading]]
[[Note Name#^block-id]]
[[#Heading in this note]]
```

A block ID is `^id` at the end of a paragraph. For a list or a quote, put it on its own line after the block:

```markdown
This paragraph can be linked. ^key-claim

- Item one
- Item two

^steps
```

## Embeds

Prefix a wikilink with `!` to embed it inline.

```markdown
![[Note Name]]
![[Note Name#Heading]]
![[Note Name#^block-id]]
![[image.png]]
![[image.png|300]]
![[image.png|640x480]]
![[document.pdf#page=3]]
![[document.pdf#height=400]]
![[audio.mp3]]
![[Reading.base]]
![[Reading.base#View Name]]
![Alt text|300](https://example.com/image.png)
```

A single number sets the width and keeps the aspect ratio. A search embed is a fenced `query` block holding an Obsidian search:

````markdown
```query
tag:#Book "systems thinking"
```
````

## Callouts

```markdown
> [!note]
> Body text.

> [!warning] Custom title
> Body text.

> [!tip] Title only

> [!faq]- Collapsed by default
> Hidden until expanded.

> [!faq]+ Expanded, but foldable
> Visible until collapsed.

> [!question] Outer
> > [!note] Inner
> > Nested body.
```

| Type | Aliases |
| --- | --- |
| `note` | |
| `abstract` | `summary`, `tldr` |
| `info` | |
| `todo` | |
| `tip` | `hint`, `important` |
| `success` | `check`, `done` |
| `question` | `help`, `faq` |
| `warning` | `caution`, `attention` |
| `failure` | `fail`, `missing` |
| `danger` | `error` |
| `bug` | |
| `example` | |
| `quote` | `cite` |

## Properties

Frontmatter fields and tags come from the vault's existing patterns. Never invent a field or a tag: no topic tags and no project fields. Type tags such as `#Book` and `#Dataset` and enum fields such as `status` take existing values only; ask before adding a value. Read what exists from sibling notes, or with `obsidian properties counts` and `obsidian tags counts` when the app is running ([obsidian-cli.md](obsidian-cli.md)). Bulk frontmatter work belongs to `rematter` ([rematter.md](rematter.md)).

Properties are YAML between `---` fences at the very top of the note.

| Type | YAML |
| --- | --- |
| Text | `field: Some text` |
| Number | `field: 4.5` |
| Checkbox | `field: true` |
| Date | `field: 2026-01-15` |
| Date and time | `field: 2026-01-15T14:30:00` |
| List | `field: [one, two]` or a YAML block list |
| Link | `field: "[[Other Note]]"` |

A wikilink in frontmatter must be quoted, or YAML reads it as a nested list.

Obsidian's built-in properties are `tags`, `aliases` (alternate names offered in link suggestions), and `cssclasses` (classes applied to the note's view). Tags in frontmatter go without the `#`:

```yaml
---
tags:
  - Book
aliases:
  - Short Name
---
```

## Tags

An inline tag is `#tag`; `#parent/child` nests. Tags hold letters, digits (never first), `_`, `-`, and `/`. The same rules on existing tags apply inline and in frontmatter.

## Inline marks

```markdown
==Highlighted text==
Visible text %%hidden in reading view%% more text.

%%
A hidden block.
%%

Text with a footnote[^1].

[^1]: Footnote body.

An inline footnote.^[Footnote body.]

Inline math: $e^{i\pi} + 1 = 0$

$$
\frac{a}{b} = c
$$
```

## Mermaid

Obsidian renders fenced `mermaid` blocks. Adding `class NodeName internal-link;` makes a node link to the note with that name. Diagram style and format choice live in the `diagramming` skill.
