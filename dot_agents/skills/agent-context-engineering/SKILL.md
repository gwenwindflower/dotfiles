---
name: agent-context-engineering
description: Author and maintain agent context markdown — AGENTS.md, rules, skills, memory files. Use when creating, editing, or refactoring any agent-focused doc, or after major codebase exploration to capture learning.
---

# Agent Context Docs

Write effective context files that give coding agents the knowledge they need without wasting tokens.

> [!IMPORTANT]
> We use `AGENTS.md` and `.agents/` as generic names. For agent-specific equivalents (CLAUDE.md / `.claude/`, GEMINI.md, etc.), apply the same guidance. If something doesn't work as expected, check that agent's docs — these tools evolve fast.

## Core Principles

- **Specific and actionable.** "Use 2-space indentation in TypeScript" beats "format code properly"
- **Progressive disclosure.** Minimal root file, modular detail loaded on demand
- **Challenge every line.** Only add what agents can't infer from code. Ask: "Does this justify its token cost?"
- **No redundancy.** Don't repeat README, package.json, or code-inferable patterns
- **Living document.** Update after significant exploration to prevent re-crawling

## Creating a New AGENTS.md

Include:

- Brief project context (1-2 sentences: what it is, primary language/framework)
- Goals and priorities
- **Project structure** — key directories and purposes (high value per token, prevents repeated `find`/`tree`/`ls`)
- Key commands (build, test, lint)
- Architecture (non-obvious patterns, key abstractions, data flow)
- Conventions (specific rules, non-standard style, things not inferable from code)

Exclude:

- Generic language idioms and standard library usage
- Content already in README or package.json
- Vague directives ("write clean code", "follow best practices")

## Index Pattern (Primary)

The recommended approach for progressive disclosure:

1. Create modular docs in a `.docs/` directory with descriptive filenames (e.g., `adding-new-shadcn-ui-components.md`)
2. Add a tight index list in AGENTS.md — simple paths with optional context, **not** @reference imports

```text
# Shopping App Agent Guidance

**IMPORTANT**: Prefer retrieval-led reasoning over pre-training-led reasoning

.docs/adding-new-shadcn-ui-components.md
.docs/using-drizzle-orm-with-supabase.md
.docs/adding-new-endpoints-to-v2-api.md
```

The agent decides what to load based on the task at hand, preserving context window and focus.

For projects with clear splits (frontend/backend, api/services), create subdirectory-scoped indexes with their own `.docs/`:

```text
src/frontend/AGENTS.md     → src/frontend/.docs/...
src/backend/AGENTS.md      → src/backend/.docs/...
```

### Rules vs. Docs

| Type | Purpose | Scope |
| --- | --- | --- |
| **Rule** | How something should be done, always (workflow, tone, conventions) | User-level if global, project-level if specific |
| **Doc** | State of something, how it works (API spec, architecture, reference) | Skill if cross-project, `.docs/` if project-specific |

## Patterns to Avoid

These appear modular but don't provide real progressive disclosure:

### @reference imports

Most agents load @referenced files fully on encounter. Treat @references as inlined content — any modularity is organizational only, not progressive. Follow import chains carefully to avoid accidental context bloat. Recursive loading (Claude Code: max depth=5) compounds the risk.

### Rules directories

All files load at session start — equivalent to @importing every file. Appropriate for genuinely universal project rules, but most content is better served by the index pattern where agents choose what to load.

### Path-scoped rules

Conditional disclosure via YAML frontmatter globs (e.g., `paths: ["src/api/**/*.ts"]`). Better than global rules, but still automatic rather than agent-driven.

## Living Document Workflow

After significant work:

1. Update AGENTS.md with discoveries (structure changes, new patterns, design decisions, implementation details)
2. Decide placement:
   - Universally relevant → root AGENTS.md
   - Area-specific → modular file in `.docs/` with index entry

## Refactoring Overgrown AGENTS.md

For files past ~60 lines or with poor structure:

1. **Analyze** — eliminate conflicting or redundant instructions
2. **Categorize** — group by function, topic, or path
3. **Split and index** — move detail into descriptively-named `.docs/` files, add index entries
4. **Distill** — justify each remaining line: "Does every agent in this directory need this in every session?"

## File Locations

| Location | Shared With | Loaded |
| --- | --- | --- |
| `AGENTS.md` / `.agents/AGENTS.md` | Team (tracked) | Always |
| `.agents/rules/*.md` | Team (tracked) | Always |
| `AGENTS.local.md` | User (untracked) | Always |
| `~/.agents/AGENTS.md` | User (all projects) | Always |
| `~/.agents/*` | User (all projects) | Always (varies by agent) |

## Formatting

Follow standard markdownlint rules:

- **Code blocks**: Always specify a language. Use `text` for file trees and non-code content
- **Tables**: Spaces around inner pipe edges (`| cell | cell |` not `|cell|cell|`)

## MCP Tool References

Use fully qualified names: `ServerName:tool_name` (e.g., `BigQuery:bigquery_schema`). Without the server prefix, tools may not resolve when many MCP servers are available.

## Quality Checklist

- [ ] Every instruction is specific and actionable
- [ ] No duplication with README or other docs
- [ ] Root file is minimal outside of index
- [ ] No generic advice the agent already knows
- [ ] Recent exploration has been synthesized and captured
