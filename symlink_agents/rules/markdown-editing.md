# Markdown Editing

Markdown editing rules are based on markdownlint rules, as implemented in markdownlint-cli2.

## Line Length

This one you should ignore.

Don't manually try to break lines to fit line-length limits. This rule is always disabled in the users' markdownlint config, if it's not yet and you're seeing errors, you can ignore them - it will be disabled soon. All modern editors and markdown renderers handle wrapping automatically. Line length restrictions are just a legacy rule that remains in the official Markdown spec for compatibility with old tools, but it's not necessary for modern markdown editing. Just write naturally and let the editor handle line wrapping.

## Code Blocks

Code blocks must always specify a language identifier. This is required by standard markdownlint rules (MD040).

### Rule

Always use a language after the opening triple backticks:

````markdown
```typescript
const x = 1;
```
````

Never leave code blocks without a language:

````markdown
```
const x = 1;
```
````

### Use `text` for Non-Code Content

For content that isn't code but needs monospace formatting (file trees, diagrams, ASCII art, generic output), use `text`:

````markdown
```text
project/
├── src/
│   ├── index.ts
│   └── utils/
├── tests/
└── package.json
```
````

This satisfies markdownlint while clearly indicating the block isn't executable code.

## Tables

Tables in "compact" style require spaces around inner pipe edges. This is required by standard markdownlint rules (MD030) and improves compatibility across renderers.

### Rule

Inner pipes need spaces on both sides. Outer pipes have no space on the outside edge.

### Example: Claude Code Default Output (Incorrect)

Claude Code tends to generate tables without inner spacing:

```markdown
|Name|Description|
|---|---|
|foo|A foo thing|
|bar|A bar thing|
```

This fails markdownlint and renders inconsistently.

### Corrected Format

Add spaces around inner pipe edges:

```markdown
| Name | Description |
| --- | --- |
| foo | A foo thing |
| bar | A bar thing |
```

### Pattern

```text
| cell | cell | cell |
  ^  ^  ^  ^  ^  ^
  spaces around inner content
```

The separator row follows the same rule:

- Wrong: `|---|---|`
- Correct: `| --- | --- |`

### Quick Fix

When you see a table without spacing, add a single space after each `|` and before each `|` (except the outer edges of the first and last pipes in a row).
