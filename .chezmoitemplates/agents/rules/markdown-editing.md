### Markdown editing

Follow markdownlint-cli2 expectations where they matter here.

- Ignore line length; wrapping is editor/renderer work. Behave as if `line-length: false` is set.
- Tolerate a missing leading h1, inline HTML, and duplicate headings when they are a consistent pattern in the doc (parallel h2 sections, repeated h3 subsections under each). Treat stray duplicate headings at different levels as errors.
- Write headings and titles in sentence case: capitalize the first word and proper nouns only (`Git commits`, `Using agent context`). Product names keep their own casing rules: names that are lowercase in running text but capitalized at sentence starts in their own docs follow suit (`Herdr configuration rules`), and names that stay lowercase everywhere stay lowercase here (`dbt guidance`).
- Always add a language to fenced code blocks. Use `text` for generic output, file trees, logs, or ASCII art.
- Format tables with spaces around inner pipes and no outside padding.
- Preserve escaped pipe literals in tables, such as `\|` and `\|\|`; remove escapes only when moving the syntax into code contexts outside Markdown tables.

```markdown
| Name | Description |
| --- | --- |
| `\|\|` | logical or |
```
