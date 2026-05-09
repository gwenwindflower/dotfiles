# Code Comments

Default: write no comments. Names and structure should carry the meaning.

## State, not process

The principle behind every rule here: **a codebase records the current state of the system, not the process of getting there.** Comments that describe what was tried, why a choice was made, what alternative was rejected, or what the agent was reasoning about while writing are notebook entries, not source. They drift from reality the moment the next change lands; a future reader has no way to tell live constraint from historical justification.

Process belongs in commits, PR descriptions, ADRs, CHANGELOG, DONE.md — places designed to be read as history. Code is read in arbitrary order by people who need to know what's true *now*.

(Note: README and CONTRIBUTING.md describe *current* state too, just at a different audience — README for usage, CONTRIBUTING for contributor workflow. Neither is a home for decision rationale.)

A useful test: imagine a contributor reading the comment six months from now and asking "ok, but is that still true?" If the comment can rot like that, it's process, and it shouldn't be there.

## Names and structure first

If a function needs a comment to explain *what* it does, the name is wrong. If a block needs a comment to explain *what* the code does, the structure is wrong. If a config section needs a comment to explain *what* it configures, the layout is wrong. Fix the name, structure, or section before reaching for a comment.

Heavy commenting is a smell — one-comment-per-function diffs almost always mean weak names, misshapen structure, or comments-as-cover for uncertainty. Push back early in review; comment cruft is much harder to strip once other code is built on top of it.

## When a comment IS warranted

Narrow cases only — one short line each, each capturing *current* state:

- **Non-obvious *why*** — a workaround for a specific bug, an externally-imposed constraint, an invariant not visible from the code.
- **Subtle contract** — something a reader could plausibly violate without realizing.
- **Surprising-but-correct choice** — looks wrong at first glance, isn't.

No multi-paragraph docstrings. No annotating every function.

## What never belongs

All of these are process bleeding into source:

- **What the code does.** The code shows that — fix the names.
- **Task or change references.** "Added for the foo flow", "from issue #123", "used by X" — commit/PR territory.
- **TODOs without owners, dead-code markers, "// removed" notes.** Delete the dead code; file a real follow-up if it matters.
- **Argument history.** "We chose X because Y", "Z is the right call here because…" → DONE.md or an ADR. The giveaway is a tone of justification, as if convincing the reader (or the author).
- **Reasoning the agent worked through while writing.** Parenthetical asides like "(complements the other thing)", "(no extra setup needed)", "(fits the existing convention)" are thinking-out-loud preserved by accident. Cut them.

## Config files and scripts

Same rules apply. A `prek.toml`, CI workflow, Dockerfile, shell script — read by future contributors who need to know what is *configured*, not what was *considered*.

- **Section dividers reflecting current structure are fine.** `# === Built-ins ===` above a list of built-in hooks is state — it labels what's there.
- **Sentence-long justifications, parenthetical asides, "we picked X because Y" notes are not.** If the project hosts decision history (DONE.md in SPOT, a CHANGELOG, an ADR directory), put them there; otherwise the commit message is enough. Often the right answer is *nowhere* — small choices don't need durable rationale.
- **Tool docs links over inline explanation.** A one-line pointer to the tool's docs serves the curious reader without baking explanation into the file.

## In SPOT projects

Specs hold *what*. DONE.md holds *why*. Code holds *how*. If you find yourself writing a comment that re-explains a requirement or a decision rationale, that note belongs in the spec or DONE entry, not the source.
