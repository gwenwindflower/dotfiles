---
name: context-search
description: Searching context - zg semantic code search, ast-grep structural search and outlines, qmd markdown and girlOS vault, agentsview past sessions via its CLI help, ctx7 library docs.
allowed-tools: Bash(zg:*), Bash(qmd:*), mcp__qmd__*
---

# Context search

Pick the corpus, then the retrieval mode. A known literal (identifier, path, error text, config key) is an `rg` job in any corpus. Load the doc for the tool the question needs:

| Question | Tool | Doc |
| --- | --- | --- |
| Unknown wording, flow, or architecture in code and mixed workspaces | `zg` | [zvec-grep](zvec-grep.md) |
| Code by structure - AST patterns, language constructs, rewrite targets | `ast-grep run`, `ast-grep scan` | [ast-grep](ast-grep.md) |
| Cheap structural map of files, imports, exports, members before reading source | `ast-grep outline` | [ast-grep](ast-grep.md) |
| Markdown knowledge bases, notes, the girlOS vault | `qmd` | [qmd](qmd.md) |
| Why a decision was made, how something was done before, prior instructions | `agentsview session search` | `agentsview session search --help` |
| Current docs for a library or framework | `ctx7` | [ctx7](ctx7.md) |

Run the indexed search before broad file reads or delegating discovery. A snippet that answers the question counts as read.
