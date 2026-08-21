### Markdown Editing

Follow markdownlint-cli2 expectations where they matter here.

- Ignore line length; wrapping is editor/renderer work. Behave as if `line-length: false` is set.
  - Other errors that can be de-prioritized if they seem to be consistent within a doc: not starting with h1 (some documents are structured around many parallel h2s), html elements (these are generally fine, if they're being included it's probably being rendered by something that handles them), and duplicate headings (sometimes a variety of parallel headers may have the same set of h3 subsections, as an example, this is fine if that's the pattern; random unrelated duplicate headings, particularly at different levels, should be treated as an error though).
- Always add a language to fenced code blocks. Use `text` for generic output, file trees, logs, or ASCII art.
- Format tables with spaces around inner pipes and no outside padding.
- Preserve escaped pipe literals in tables, such as `\|` and `\|\|`; remove escapes only when moving the syntax into code contexts outside Markdown tables.

```markdown
| Name | Description |
| --- | --- |
| `\|\|` | logical or |
```
