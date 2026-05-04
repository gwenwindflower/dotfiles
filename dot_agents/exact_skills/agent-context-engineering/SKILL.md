---
name: agent-context-engineering
description: Author and maintain agent context markdown — AGENTS.md, rules, skills, memory files. Use when creating, editing, or refactoring any agent-focused doc, or after major codebase exploration to capture learning.
---

# Agent Context Docs

Every line is loaded on every trigger. If it doesn't change agent behavior, cut it.

> [!NOTE]
> `AGENTS.md` and `.agents/` are both real and stand-ins. They're the shared cross-agent standard adopted by most non-Claude tools, *and* the generic model for agent-specific equivalents (`CLAUDE.md`, `GEMINI.md`, `.codex/`, etc.). Guidance here applies to all of them.

## Principles

- **Specific and actionable.** "Use 2-space indentation in TypeScript" beats "format code properly."
- **Progressive disclosure.** Minimal root file; modular detail loaded on demand.
- **No redundancy.** Don't repeat README, package.json, or anything inferable from code.
- **Living document.** Update after significant exploration to prevent re-crawling.

## Authoring AGENTS.md

Include only what an agent can't infer from the code:

- 1–2 sentence project context (what it is, primary stack)
- Goals, priorities, non-goals
- Project structure — key directories and their purpose (high token value, prevents repeated `fd`/`tree`)
- Key commands (build, test, lint) when non-obvious
- Architecture: non-obvious patterns, key abstractions, data flow
- Conventions that diverge from defaults

Exclude generic language idioms, README content, and vague directives ("write clean code").

## Index Pattern

The recommended progressive-disclosure approach:

1. Put modular docs in `.docs/` with descriptive filenames (`adding-shadcn-components.md`)
2. List them as a tight index in AGENTS.md — plain paths, **not** `@`-imports

```text
# Shopping App Agent Guidance

.docs/adding-shadcn-components.md
.docs/using-drizzle-with-supabase.md
.docs/adding-v2-api-endpoints.md
```

The agent picks what to load. For projects with clear splits (frontend/backend), scope subdirectory indexes:

```text
src/frontend/AGENTS.md → src/frontend/.docs/...
src/backend/AGENTS.md  → src/backend/.docs/...
```

### Rules vs. docs

| Type | Purpose | Scope |
| --- | --- | --- |
| **Rule** | How something should be done, always (workflow, conventions) | User-level if global, project-level if specific |
| **Doc** | State of something / how it works (API, architecture) | Skill if cross-project, `.docs/` if project-specific |

## Patterns to Avoid

- **`@reference` imports.** Most agents inline them fully on encounter. Treat as inlined content; recursive loading (Claude Code: depth 5) compounds bloat.
- **Rules directories.** All files load at session start — equivalent to `@`-importing every file. Reserve for genuinely universal rules.
- **Path-scoped frontmatter globs.** Better than global, but still automatic rather than agent-driven.

## Living Document Workflow

After significant work, update AGENTS.md with new structure, patterns, or decisions. Universally relevant → root; area-specific → `.docs/` with index entry.

## Refactoring Overgrown Files

For AGENTS.md past ~60 lines or with poor structure:

1. Eliminate conflicting or redundant instructions
2. Group remaining content by function or path
3. Move detail into `.docs/` files; add index entries
4. Justify each remaining line: does every agent in this directory need it every session?

## File Locations

| Location | Shared With | Loaded |
| --- | --- | --- |
| `AGENTS.md` / `.agents/AGENTS.md` | Team (tracked) | Always |
| `.agents/rules/*.md` | Team (tracked) | Always |
| `AGENTS.local.md` | User (untracked) | Always |
| `~/.agents/AGENTS.md` | User (all projects) | Always |
| `~/.agents/*` | User (all projects) | Varies by agent |

## MCP Tool References

Use fully qualified names: `ServerName:tool_name` (e.g., `BigQuery:bigquery_schema`). Bare tool names may not resolve when many MCP servers are connected.
