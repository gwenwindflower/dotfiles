# Git Commits

## Signing Commits

**IMPORTANT**: Commits are signed with SSH keys, stored in 1Password. This should be accessible via 1Password's SSH agent, but if commits are failing because of signatures, stop and ask the user to do the commit manually, and instruct them to troubleshoot their signing key setup.

## Format

```text
type(scope): brief description in imperative mood

Optional body — short bullets, see below.

Closes #123                                      (when applicable)
Closes Phase <n>                                 (when applicable)

Co-Authored-By: <Agent Name> <noreply@anthropic.com>
```

## Types

- `feat` - New functionality
- `fix` - Bug fixes
- `test` - Adding or updating tests ONLY
- `refactor` - Code restructuring or renaming without behavior change
- `perf` - Can involve a variety of work, but if the explicit focus is improving performance, use this
- `style` - Code style changes ONLY (formatting, indentation, etc.)
- `build` - Changes to build system or deployment configs
- `ci` - Updates to CI configuration, automated checks, pre-commit hooks, etc.
- `chore` - Tooling, config changes, workflow, maintenance tasks
- `docs` - Documentation ONLY

## Subject

- **Imperative mood:** "add feature" not "added feature"
- **No period** at end of subject line
- **Max 72 chars** for subject
- **Specific** — `feat(auth): add JWT refresh token rotation`, not `feat: update auth`

## Body — usually unnecessary, always concise

Specs hold *what*, DONE.md holds *why*, code holds *how* — the commit body is for none of those. The diff and subject already do most of the work; reach for a body only to summarize imperative state changes that aren't obvious from the diff.

Hard rules when you do write one:

- **3-5 short bullets, max.** One sentence each. Imperative mood. State changes only.
- **Use `*` as the bullet character**, not `-`. Reads cleaner in `git log` and avoids being mistaken for an option flag in terminal output.
- **Very brief purpose is fine** — one short clause linking the change to a goal. Anything longer (extended rationale, considered alternatives, surprising findings) belongs in a spec, DONE.md, or an ADR.
- **Reference Phases at the end** when applicable: `Closes Phase <n>`.

Caveman-speak it if you have to. Concision beats prose every time.

Bad — paragraph re-explaining the diff and arguing for the choice:

```text
feat(auth): add JWT refresh

This commit adds a JWT refresh flow to the auth module. We are doing this
because users were getting logged out frequently and we wanted to improve
the experience. The implementation uses the existing google-auth-library
and lives in src/auth/refresh.ts. We considered rolling our own JWT
verification but decided against it because the surface is finicky.
```

Good — bullets, state changes, brief purpose, reference, trailers:

```text
feat(auth): rotate google oauth state token per request

* close CSRF replay window flagged by au-R008 audit
* align rotation interval with email-flow (15min) for consistency
* new util in auth/oauth/state.ts; covered by au-R008 test

Closes #234
Closes Phase 4

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
```

## Trailers

End the commit with standard trailers when applicable, blank line before the trailer block. Order: GitHub closing keywords, project markers, identity.

- **GitHub closing keywords** — `Closes #123`, `Fixes #456`, `Resolves #789` when the commit resolves a referenced issue or PR. Lets GitHub auto-close on merge.
- **`Closes Phase <n>`** — on its own line when the commit closes a SPOT Phase.
- **`Co-Authored-By: <Agent Name> <noreply@anthropic.com>`** — always the final line for agent-authored or agent-assisted commits. Use the actual running model: `Claude Opus 4.7 (1M context)`, `Claude Sonnet 4.6`, `Claude Haiku 4.5`, etc. Non-Claude agents follow the same shape with their own name and project email.

Trailers must be the last paragraph, separated from the body by a blank line — git's trailer parser depends on it.
