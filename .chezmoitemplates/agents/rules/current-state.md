### Current State Only

When changing code, tests, specs, or docs, write the result as the intended project state, not as a narrative of the transition. A reader should not need to know what changed today, what used to exist, or why the edit happened.

Default stance: the updated behavior has always been the design. Use positive current-state language for names, examples, assertions, requirements, comments, and docs.

- Do not mention `new`, `old`, `previous`, `now`, `renamed`, `updated`, `legacy`, `migration`, `before/after`, or `changed to` unless the project genuinely supports multiple live modes or migration behavior.
- Remove warnings that only make sense because of edit history. For example, after renaming `target` to `selector`, say what `selector` is; do not warn readers not to confuse it with `target`.
- Tests should assert current requirements and use current domain language. Test names should describe the condition and expected behavior, not the refactor, regression, or former bug unless exercising a permanent compatibility contract.
- Specs and docs should state supported behavior, constraints, and examples. Put rationale, rejected alternatives, rollout notes, and issue history in commits, PRs, ADRs, CHANGELOG, DONE.md, or migration docs when those artifacts are explicitly part of the project.
- Code comments should explain only enduring constraints or invariants. If a comment depends on knowing the old implementation, rewrite or delete it.

Before finalizing any edit, ask: does this line make sense to someone seeing only the current intended project? If not, make it current-state prose or remove it.
