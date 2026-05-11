# Markdown Editing

Based on markdownlint rules (markdownlint-cli2).

## Line length

Ignore. The line-length rule is disabled in our config; if you see warnings, ignore them. Modern editors and renderers wrap automatically.

## Code blocks (MD040)

Always specify a language after the opening backticks. Use `text` for non-executable monospace content (file trees, ASCII art, generic output) — satisfies the linter and signals "not code."

````markdown
```typescript
const x = 1;
```

```text
project/
└── src/
```
````

## Tables (MD030)

Inner pipes need spaces on both sides; outer pipes have no outside space. Same rule for the separator row.

```markdown
| Name | Description |
| --- | --- |
| foo | A foo thing |
```

Claude often emits tables without spacing (`|Name|Description|`). Fix on sight — it fails the linter and renders inconsistently across viewers.

### Pipe Literals

Sometimes a table contains a pipe as part of in-cell content, such as an OR operator `|` or `||` or a SQL concatenation `||`, in those cases, escaping pipes is handled with `\|`. These will satisfy linter errors and be stripped from rendered output. If you see them in markdown files, they are correct and should be left in place, but if using the syntax described in the table in outside code contexts then you should strip the escape characters.

An example:

```markdown
| Operator | Logic |
| --- | --- |
| `<=` | less than or equal |
| `&&` | logical and |
| `\|\|` | logical or |
| `!` | logical not |

```

When rendered the OR will be `||` and this will not trigger the linter.
