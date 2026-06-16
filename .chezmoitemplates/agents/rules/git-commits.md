#### Git Commits

Commits are SSH-signed through 1Password. If signing fails, stop and ask the user to commit manually or fix signing; do not disable signing unless the environment has an explicit hook/config for it.

Format:

```text
type(scope): imperative subject

optional body bullets

Closes #123
Closes Phase <n>

Co-Authored-By: <Agent Name> <agent email>
```

Use conventional types: `feat`, `fix`, `test`, `refactor`, `perf`, `style`, `build`, `ci`, `chore`, `docs`.

Subject rules: imperative mood, specific, no period, max 72 chars.

Bodies are usually unnecessary. If needed, use 3-5 `*` bullets, one sentence each, imperative/state-focused. Keep rationale in specs, DONE.md, ADRs, PRs, or commits around the work.

##### Linear history

Aim for clean, linear history that tells the story of the work. Rebase and fixup/squash with `push --force-with-lease` to tidy local branches before merging; never force-push to main or shared branches. **Never** merge with a merge commit. Fast-forward rebase on top of main when pulling. Default to trunk-based development unless the project says otherwise.

###### SPOT project nuances

Don't make commits that only touch `TODO.md` or `DONE.md` — fold them into related work. When a separate close commit is warranted, Manager DONE.md updates use `chore(plan)`, spec-only edits use `chore(specs)`, and edits to `AGENTS.md`, `README.md`, or `docs/` use unscoped `docs`.

##### Trailer rules

Order: GitHub closing keywords (`Closes #12`), SPOT updates (`Closes Phase <n>`, `Completes <Objective> Objective for Phase <n>`), then attribution (`Co-Authored-By: <collaborator>`). Agent-authored or assisted commits always end with the running agent's identity.
