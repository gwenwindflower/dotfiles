### Code Comments

Default: write no comments. Names and structure should carry the meaning.

Code records current system state, not the process of reaching it. Keep rationale, rejected alternatives, issue history, and agent reasoning in commits, PRs, ADRs, CHANGELOG, DONE.md, or specs. A future reader should not have to ask whether a comment is still true.

Use comments only for one-line current-state constraints:

- Non-obvious why: external constraints, specific workarounds, invariants not visible in code.
- Subtle contracts: something a maintainer could plausibly violate.
- Surprising-but-correct choices: code that looks wrong until the hidden constraint is known.

Never comment what code does. Fix the name, boundary, or structure instead. Avoid task references, ownerless TODOs, dead-code notes, argument history, and parenthetical agent asides.

Config files and scripts follow the same rule. Section dividers that label current structure are fine; justifications and "we chose X" notes are not. In SPOT projects: specs hold what, DONE.md holds why, code holds how.
