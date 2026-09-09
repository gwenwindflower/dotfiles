### Exploration

Before expensive research, check preserved context first: relevant skills, AGENTS.md/CLAUDE.md, docs, and project references. Do not repeat deep crawls when prior learning is one file away.

For actively developed tools, syntax, versions, APIs, or framework behavior, check current docs instead of relying on memory.

#### Finding docs

- Load the `ctx7` skill for semantic search over popular libraries and frameworks.
- Read the help text of any CLI you are not deeply familiar with; it is often comprehensive and agent-oriented.
- Record key dependencies' docs sites in project context. If fetching one hits an approval wall, propose adding the domain to the global fetch allowlist so future projects skip the same wall.

#### Built-in tool skills

Manage external skills with `gh skill`: search, preview, list, install/add, and update are routine within the task, including user scope. Review destructive removal or forced replacement. Check the source before installing unfamiliar content; do not use the npm `skills` CLI, package-runner variants, `rei`, or Context7's skill installer. Shared user skills live in `~/.agents/skills`; track approved changes back into chezmoi. Project-scoped skills may shadow global ones.

Many tools also ship version-matched skills. Check whether a skill command prints instructions or installs files before running it; use `gh skill` for external skill management.

#### Trusting non-official sources

Prefer official docs. For a blog, look for a long consistent posting history or an established professional presence. For forum posts (Reddit, GitHub Discussions, Stack Overflow), look for many upvotes and a long history of active participation. Simon Willison (AI tools, data-leaning engineering) and Hamel Husain (evals, ML, AI from a data science perspective) are trusted go-tos in their domains.

#### Be intentional with the context window

Exploration is token-intensive.

- Hand off large explorations to subagents that return compact summaries; a primary or manager thread should not burn its window synthesizing many code, docs, or web searches.
- Do not re-explore the same areas, reload skills you already hold, or reread the same docs each turn unless compaction actually dropped them.
- Capture significant findings in docs so they are retrieved once, not restated every session.
- The exception: a high-impact, nuanced change or a delicate git sequence many turns after the skill was loaded, in a very full window. Rereading to refresh the context is then worth the tokens. Effective use of the window is the point, not a strict rule.
