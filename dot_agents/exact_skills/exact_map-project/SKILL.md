---
name: map-project
description: Orient in an unfamiliar existing project and produce a durable map — improved agent context files when the project lacks them, or an orientation doc that powers guided user learning. Use when asked to orient, onboard, map, or get up to speed in an existing codebase, or when landing in a project whose agent context is thin enough to be worth fixing. Skip when current AGENTS.md and docs already cover the project — read those instead.
---

# Map a Project

Orientation is a context-budget problem plus an externalized-memory problem, not a reading problem. Explore strategically, then write the map down so nobody — agent or human — pays the exploration cost twice.

## Exploration method

Sample; never read exhaustively. The goal is a stable structural model, and each step below buys the most model per token.

1. **Metadata before code.** Directory tree, file names and sizes, README, build manifests, lockfile. Form hypotheses about the architecture before opening a single source file — names and structure carry disproportionate signal.
2. **Rank by churn and references.** `git log --oneline -20` shows activity and commit vocabulary; `git log --format= --name-only | sort | uniq -c | sort -rn | head` ranks hot files. Load-bearing code is what many files import and commits keep touching — explore those subsystems first.
3. **Trace one path end to end.** Find the entry point (main, router, CLI dispatch) and follow one representative request or command all the way through. A single deep trace yields layering, naming conventions, error-handling style, and dependency direction at once — cheaper than broad sampling.
4. **Tests are executable specs.** Read the nearest integration tests before implementations — names and assertions state intent — and run a scoped suite (never the full one) to check your model against reality.
5. **Fan out; keep conclusions.** A question spanning more than ~3 unknown files goes to a read-only subagent that returns a compressed report. Raw exploration dumps never belong in the main context.
6. **Verify before trusting.** End with one falsifiable prediction ("X lives in Y; Z fails if…") and check it. A wrong prediction means re-explore, not proceed.

Stop when new files stop changing the model.

## Output — pick the audience

| Map for | Deliverable |
| --- | --- |
| Agent — project context thin or missing | AGENTS.md/CLAUDE.md plus a `docs/` index |
| User — wants to understand the codebase | `.agents/docs/orientation.md` plus guided exercises |

Doing both: write the agent context first, then derive the orientation doc from it. For capturing learnings at the end of an ordinary working session (rather than a deliberate mapping pass), use `capture-context` instead.

### Agent context

Load the `agent-context-engineering` skill before writing — it owns structure, the index pattern, and what earns a line. Mapping-specific rules on top:

- Record only what is surprising or non-inferable: gotchas, non-obvious conventions, pointers to where detail lives. If one grep would re-derive it, don't write it down.
- Describe stable structure — boundaries, entry points, conventions — not volatile detail like specific function names or line counts. When a map contradicts observed code, the code wins; fix the map in the same session.
- History explains why, code states what. Churn findings set exploration priorities; they don't go in current-state docs.

### User orientation

Write `<project root>/.agents/docs/orientation.md`. Create the directory if needed; never overwrite an existing orientation file — number a new one (`orientation-2.md`) and flag it to the user. Structure:

```markdown
# Repo Orientation: <name>

## One-line purpose
## Pipeline / main modules
## Key files
## Core concepts
## Common gotchas
## Suggested exercise sequence
```

Section guidance: pipeline as ordered stages (or module relationships if there is no pipeline); 6–10 key files as `` `path` — what it does | why read it``; 3–5 core concepts with where each lives in the code; 2–3 gotchas with real paths.

The exercise sequence is exactly 2 exercises, each read-then-synthesize: point the learner at one specific short artifact, then ask them to explain or synthesize what they just read ("Open `models.py`, find the dataclass the pipeline produces — what do its fields tell you about the stages?"). Never ask them to predict something they have no basis for; prediction, tracing, and debugging exercises belong to later sessions via `learning-opportunities`.

Hand off with `/learning-opportunities orient`, which runs the doc as a guided exercise.
