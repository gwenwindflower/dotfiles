### Markdown Editing

Follow markdownlint-cli2 expectations where they matter here.

- Ignore line length; wrapping is editor/renderer work.
- Always add a language to fenced code blocks. Use `text` for generic output, file trees, logs, or ASCII art.
- Format tables with spaces around inner pipes and no outside padding.
- Preserve escaped pipe literals in tables, such as `\|` and `\|\|`; remove escapes only when moving the syntax into code contexts outside Markdown tables.

```markdown
| Name | Description |
| --- | --- |
| `\|\|` | logical or |
```
