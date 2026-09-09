#### Commits

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

Trailer order: GitHub closing keywords (`Closes #12`), then attribution (`Co-Authored-By: <collaborator>`). Agent-authored or assisted commits always end with the running agent's identity.

#### Linear history

Aim for clean, linear history that tells the story of the work. Rebase and fixup/squash with `push --force-with-lease` to tidy local branches before merging; never force-push to main or shared branches. **Never** merge with a merge commit. Fast-forward rebase on top of main when pulling. Default to trunk-based development unless the project says otherwise.

#### Recoverable state

Any operation that rewrites history or can stop halfway (rebase, squash, amend, reset, cherry-pick series, stash pop across branches, force push, conflict-prone merges) needs a way back before it starts:

- Commit or stash uncommitted work first; never rewrite over a dirty tree.
- Record the starting ref: `git rev-parse HEAD` for a small step, a backup branch (`git branch backup/<name>`) for multi-commit rewrites or anything touching more than one branch.
- Know the exit before entering: `--abort` for in-progress operations, `git reset --hard <recorded ref>` for everything else, `git reflog` as the last resort.
- Rewrite only commits that are unpushed or on a branch only you are working on.
- If the operation stops in a partial state, do not improvise repairs on top of it. Abort back to the recorded ref, or resolve and continue only when the conflict is small and fully understood.
- Never run `reset --hard`, `checkout --`, `restore`, or `clean` without a recorded ref that restores what they discard.
- Report an interrupted operation plainly, with the ref that restores the pre-operation state.

#### GitHub

Use `gh` for GitHub work beyond core git: repos, issues, PRs, Actions, checks, and runs. Read before write: `list`, `view`, `status`, `diff`, `checks`, or logs first.

Never print tokens. Do not run `gh auth token`, it will be blocked.

No destructive GitHub operations without explicit instruction: delete, close, merge, revert, archive, transfer, lock, or release delete. Prefer `gh pr merge --squash`; use rebase only for small clean histories.

For raw code, fetch the raw URL rather than routing through `gh api`. For Actions and actively developed tooling, verify current Marketplace/docs versions.

Treat unknown repos as untrusted. Prefer established tools and reputable maintainers; ask before adding dependencies or running scripts from unclear sources.
