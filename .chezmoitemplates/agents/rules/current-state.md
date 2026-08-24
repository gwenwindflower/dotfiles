### Focus on current state

When editing code, tests, specs, docs, comments, docstrings, or agent context, describe the intended project state—not the transition that produced it. A reader should not need change history to understand the result. If `func_a` changes from task X to task Y, document that it performs task Y; do not say it “now performs Y instead of X.”

Use current domain language in names, examples, assertions, requirements, and test descriptions. Avoid `new`, `old`, `previous`, `now`, `renamed`, `updated`, `legacy`, and before/after framing unless multiple modes, migration behavior, or a compatibility contract remain part of the supported system. Comments should explain only enduring constraints or invariants.

Keep change history, decision rationale, rejected alternatives, and rollout context in artifacts designed to preserve them: commits, PRs, ADRs, changelogs, DONE.md, or dedicated migration documents.

Before finalizing, ask: would this make sense to someone who knows only the intended current project? If not, rewrite it as current-state guidance or remove it.
