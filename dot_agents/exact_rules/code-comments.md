# Code Comments

Default: write no comments. Names and structure should carry the meaning.

If a function needs a comment to explain *what* it does, the name is wrong. If a block needs a comment to explain *what* the code does, the structure is wrong. Fix the name or the structure first; reach for a comment only after.

## When a comment IS warranted

Narrow cases only — one short line each:

- **Non-obvious *why*** — a workaround for a specific bug, an externally-imposed constraint, an invariant not visible from the code.
- **Subtle contract** — something a reader could plausibly violate without realizing.
- **Surprising-but-correct choice** — looks wrong at first glance, isn't.

No multi-paragraph docstrings. No annotating every function.

## What never belongs in code comments

- **What the code does.** The code shows that — fix the names if it doesn't.
- **Task or change references.** "Added for the foo flow", "from issue #123", "used by X" — that's commit-message and PR territory, not source.
- **TODOs without owners, dead-code markers, "// removed" notes.** Delete the dead code; file a real follow-up if it matters.
- **Argument history.** "We chose X because Y" → DONE.md or an ADR. The codebase is not the project's notebook.

## Heavy commenting is a smell

When a diff approaches one-comment-per-function, that almost always means weak names, misshapen structure, or an agent using comments as cover for uncertainty. Fix the names and structure; don't land the comments. Push back early in review — comment cruft is much harder to strip later, especially once other code is built on top of it.

## In SPOT projects

Specs hold *what*. DONE.md holds *why*. Code holds *how*. Don't blur the layers — durable docs are the agent's notebook, not the source files. If you find yourself writing a comment that re-explains a requirement or a decision rationale, that note belongs in the relevant spec or DONE entry, not the code.
