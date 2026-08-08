#### Git Commits

Commits are SSH-signed through 1Password. If signing fails, stop and ask the user to commit manually or fix signing; do not disable signing unless the environment has an explicit hook/config for it.

Format:

```text
type(scope): imperative subject

optional body bullets

Closes #123

Co-Authored-By: <Agent Name> <agent email>
```

Use conventional types: `feat`, `fix`, `test`, `refactor`, `perf`, `style`, `build`, `ci`, `chore`, `docs`.

Subject rules: imperative mood, specific, no period, max 72 chars.

Commit bodies should be used **only** when multiple meaningful tasks are not captured by the title, when a rationale is valuable to record why a change was needed, or to explain why a certain approach was taken. If needed, use at most 3-5 `*` bullets, one sentence each, imperative/state-focused. Keep deeper rationale in specs, TODO.md/DONE.md, ADRs, docs, and PRs. **Never** restate the commit title in more detail or add prose paragraphs. Bodies must add value, not volume to the commit history.

##### Linear history

Aim for clean, linear history that tells the story of the work. Rebase and fixup/squash with `push --force-with-lease` to tidy local branches before merging; never force-push to main or shared branches. **Never** merge with a merge commit. Fast-forward rebase on top of main when pulling. Default to trunk-based development unless the project says otherwise.

##### Trailer rules

Order: GitHub closing keywords (`Closes #12`), then attribution (`Co-Authored-By: <collaborator>`). Agent-authored or assisted commits always end with the running agent's identity.
