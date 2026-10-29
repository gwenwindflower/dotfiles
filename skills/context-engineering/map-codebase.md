# Mapping a codebase or package

Explore an unfamiliar codebase or dependency strategically, then write the map down so nobody pays the exploration cost twice. Skip the pass when AGENTS.md and `docs/` already cover the area; read those instead.

## Exploration method

Sample; never read exhaustively. Stop when new files stop changing the model.

1. **Metadata before code.** Directory tree, file names and sizes, README, build manifests, lockfile. Form hypotheses about the architecture before opening a source file, then check them with `ast-grep outline <dir> --items exports` ([ast-grep](ast-grep.md)).
2. **Rank by churn and references.** `git log --oneline -20` shows activity and commit vocabulary; `git log --format= --name-only | sort | uniq -c | sort -rn | head` ranks hot files. Explore the subsystems many files import and commits keep touching first.
3. **Trace one path end to end.** Find the entry point (main, router, CLI dispatch) and follow one representative request or command all the way through. One deep trace shows layering, naming, error handling, and dependency direction at once.
4. **Tests are executable specs.** Read the nearest integration tests before implementations, and run a scoped suite (never the full one) to check the model against reality.
5. **Fan out; keep conclusions.** A question spanning more than about three unknown files goes to a read-only subagent that returns a compressed report. Concept questions go to `zg query` first ([zvec-grep](zvec-grep.md)).
6. **Verify before trusting.** End with one falsifiable prediction ("X lives in Y; Z fails if…") and check it. A wrong prediction means re-explore, not proceed.

### Packages

For a dependency, read the installed source the project resolves (`node_modules/<pkg>`, the venv's `site-packages`, `~/.cargo/registry/src`, `go env GOMODCACHE`), not the latest upstream. Outline its public surface, read its own tests and examples for intended use, and check current docs for the installed version. Record the docs site and any gotchas in project context.

## Writing the map

The map is agent context: AGENTS.md or CLAUDE.md plus a `docs/` index. Learnings from an ordinary working session go through [capture-session](capture-session.md) instead. Follow [SKILL.md](SKILL.md) for structure, the index pattern, and what earns a line. On top of that:

- Record only what is surprising or non-inferable: gotchas, non-obvious conventions, pointers to where detail lives. If one grep would re-derive it, leave it out.
- Describe stable structure (boundaries, entry points, conventions), not volatile detail like function names or line counts. When a map contradicts the code, the code wins; fix the map in the same session.
- Churn findings set exploration priorities; they don't go in current-state docs.

