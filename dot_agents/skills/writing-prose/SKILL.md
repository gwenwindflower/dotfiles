---
name: writing-prose
description: "Improve narrative and expository writing: blog posts, articles, fiction, marketing copy, documentation prose. NOT for agent context files (AGENTS.md, rules, skills, memory), READMEs, tool descriptions, CLI help text, or any structured/functional markdown."
---

# Writing Prose

Rules for generating or editing prose. Targets narrative and expository writing — blog posts, articles, essays, fiction, documentation aimed at human readers.

**Does NOT apply to:** AGENTS.md, rules, skills, memory files, READMEs, tool descriptions, CLI output, commit messages, or any functional/structured markdown. For agent context files, use the `agent-context-docs` skill instead.

## Core Principles

1. **Write directly** — active voice, clear word choices, no stacked adjectives or emphasis filler
2. **Avoid formulaic patterns** — no binary contrasts, predictable openers, or repetitive dramatic structures

## Reference Files

- [Phrases and Wording](phrases-and-wording.md) — words, phrases, and cliches to eliminate or scrutinize
- [Voice and Flow](voice-and-flow.md) — sentence structure, rhythm, and rhetorical anti-patterns

## Editor Workflow

After writing prose, you **MUST** run a review loop with the `writing-prose-editor` subagent. It scores across 8 dimensions (1-5 pts each, 40 max). Revise and resubmit until score reaches 32/40. Do not self-score or bypass the editor.

1. Write following Core Principles
2. Submit full prose to `writing-prose-editor` subagent
3. If score < 32/40, revise based on cited issues, repeat from step 2
4. Present only after passing (≥ 32/40)
