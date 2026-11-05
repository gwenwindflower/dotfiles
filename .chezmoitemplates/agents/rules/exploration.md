### Exploration

Before expensive research, check preserved context first: relevant skills, AGENTS.md/CLAUDE.md, docs, and project references. Do not repeat deep crawls when prior learning is one file away.

For actively developed tools, syntax, versions, APIs, or framework behavior, check current docs instead of relying on memory.

#### Finding docs

- Read the help text of any CLI you are not deeply familiar with; it is often comprehensive and agent-oriented.
- Record key dependencies' docs sites in project context. If fetching one hits an approval wall, propose adding the domain to the global fetch allowlist so future projects skip the same wall.

#### Searching local corpora

Search code with `rg` or the harness's built-in grep by default. Any word you expect in the target, plus a likely directory or file type, makes it a text search, and `rg` is faster and exhaustive where an index is ranked and can be stale. The `context-engineering` skill has usage for `ast-grep`, `zg`, and `agentsview`; the `obsidian` skill covers `qmd`.

| You have | Tool |
| --- | --- |
| A word, identifier, path, error text, or config key you expect in the target | `rg` or built-in grep |
| A known function, component, or code pattern; a file's structure before reading it | `ast-grep run`, `ast-grep outline` |
| Only a description, in an unfamiliar codebase whose docs don't point to it | `zg` (zvec-grep) |
| Markdown knowledge bases and the girlOS vault | `qmd` |
| Recorded agent sessions | `agentsview` |

A subagent should not be spawned only to locate material. Treat a sufficient snippet as read and open the file only when the needed detail lies outside it.

#### Trusting non-official sources

Prefer official docs. For a blog, look for a long consistent posting history or an established professional presence. For forum posts (Reddit, GitHub Discussions, Stack Overflow), look for many upvotes and a long history of active participation. Simon Willison (AI tools, data-leaning engineering) and Hamel Husain (evals, ML, AI from a data science perspective) are trusted go-tos in their domains.

#### Be intentional with the context window

Exploration is token-intensive.

- Hand off large explorations to subagents that return compact summaries; a primary or manager thread should not burn its window synthesizing many code, docs, or web searches.
- Do not re-explore the same areas, reload skills you already hold, or reread the same docs each turn unless compaction actually dropped them.
- Capture significant findings in docs so they are retrieved once, not restated every session.
- The exception: a high-impact, nuanced change or a delicate git sequence many turns after the skill was loaded, in a very full window. Rereading to refresh the context is then worth the tokens. Effective use of the window is the point, not a strict rule.
