### Naming

Names carry meaning across code, configs, commits, specs, tasks, and handoffs. A vague name taxes every future reader.

Good names:

- Reflect purpose, not implementation.
- Describe what the thing is, not why it was added.
- Read clearly out of context.
- Stay specific; avoid `handler`, `manager`, `helper`, `thing` unless the surrounding convention makes them precise.
- Match local style unless a new convention is intentional.

Do not promote the user's throwaway wording into durable artifacts. For files, functions, commands, flags, packages, requirement IDs, Phase titles, and Objectives: infer purpose, propose a real name, confirm when needed, then use it consistently.

If a comment is needed to explain what a name means, fix the name or structure first.

### Current state

When editing code, tests, specs, docs, comments, docstrings, or agent context, describe the intended project state—not the transition that produced it. A reader should not need change history to understand the result. If `func_a` changes from task X to task Y, document that it performs task Y; do not say it “now performs Y instead of X.”

Use current domain language in names, examples, assertions, requirements, and test descriptions. Avoid `new`, `old`, `previous`, `now`, `renamed`, `updated`, `legacy`, and before/after framing unless multiple modes, migration behavior, or a compatibility contract remain part of the supported system.

Keep change history, decision rationale, rejected alternatives, and rollout context in artifacts designed to preserve them: commits, PRs, ADRs, changelogs, DONE.md, or dedicated migration documents.

Before finalizing, ask: would this make sense to someone who knows only the intended current project? If not, rewrite it as current-state guidance or remove it.

### Code comments

Default: write no comments. Names and structure should carry the meaning.

Comments record current state like everything else: no rationale, rejected alternatives, issue history, or agent reasoning. A future reader should not have to ask whether a comment is still true.

Use comments only for one-line current-state constraints:

- Non-obvious why: external constraints, specific workarounds, invariants not visible in code.
- Subtle contracts: something a maintainer could plausibly violate.
- Surprising-but-correct choices: code that looks wrong until the hidden constraint is known.

Never comment what code does. Fix the name, boundary, or structure instead. Avoid task references, ownerless TODOs, dead-code notes, argument history, and parenthetical agent asides.

Config files and scripts follow the same rule. Section dividers that label current structure are fine; justifications and "we chose X" notes are not. In SPOT projects: specs hold what, the ledger (DONE.md or the parent issue) holds why, code holds how.

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
