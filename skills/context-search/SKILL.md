---
name: context-search
description: Searching context - zg semantic code search, ast-grep structural search and outlines, qmd markdown and girlOS vault, agentsview past sessions, ctx7 library docs.
allowed-tools: Bash(zg:*), Bash(qmd:*), mcp__qmd__*
---

# Context search

Pick the corpus, then the retrieval mode. A known literal (identifier, path, error text, config key) is an `rg` job in any corpus. Load the doc for the tool the question needs:

| Question | Tool | Doc |
| --- | --- | --- |
| Unknown wording, flow, or architecture in code and mixed workspaces | `zg` | [zvec-grep](zvec-grep.md) |
| Code by structure - AST patterns, language constructs, rewrite targets | `ast-grep` | [vendor/ast-grep](vendor/ast-grep/SKILL.md) |
| Cheap structural map of files, imports, exports, members before reading source | `ast-grep outline` | [vendor/outline](vendor/outline/SKILL.md) |
| Markdown knowledge bases, notes, the girlOS vault | `qmd` | [vendor/qmd](vendor/qmd/SKILL.md), then [qmd-upkeep](qmd-upkeep.md) |
| Why a decision was made, how something was done before, prior instructions | `agentsview` | [agentsview](agentsview.md) |
| Current docs for a library or framework | `ctx7` | [ctx7](ctx7.md) |

Run the indexed search before broad file reads or delegating discovery. A snippet that answers the question counts as read.

Docs under `vendor/` are upstream skills, refreshed by `gh skill update`. Where they say "this skill" or name another skill, read it as this doc set; where they suggest installing an MCP server or skills, don't.
