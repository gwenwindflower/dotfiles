# Git Commits

## Signing Commits

**IMPORTANT**: Commits are signed with SSH keys, stored in 1Password. This should be accessible via 1Password's SSH agent, but if commits are failing because of signatures, stop and ask the user to do the commit manually, and instruct them to troubleshoot their signing key setup.

## Format

```text
type(scope): brief description in imperative mood

Optional body with rationale and context. Feel free to be detailed here.

[Co-author tag for Claude Code commits]
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

The diff and the subject do most of the work. In SPOT projects the durable docs (specs, DONE.md) carry the *why*. Reach for a body only when it adds something a future reader can't get from the diff or those docs.

Hard rules when you do write one:

- **3-5 short bullets, max.** One sentence each. Imperative mood. No fluff, no narrative paragraphs, no re-explaining the diff.
- **Substance only:** the reason behind a non-obvious choice, an external constraint that drove the approach, a surprise worth flagging, a goal being targeted.
- **Reference Phases at the end** when applicable: `Closes Phase <n>`.

Caveman-speak it if you have to. Concision beats prose every time.

Bad — paragraph re-explaining the diff:

```text
feat(auth): add JWT refresh

This commit adds a JWT refresh flow to the auth module. We are doing this
because users were getting logged out frequently and we wanted to improve
the experience. The implementation uses the existing google-auth-library
and lives in src/auth/refresh.ts. We considered rolling our own JWT
verification but decided against it because the surface is finicky.
```

Good — bullets, substance, reference:

```text
feat(auth): rotate google oauth state token per request

- close CSRF replay window flagged by au-R008 audit
- align rotation interval with email-flow (15min) for consistency
- new util in auth/oauth/state.ts; covered by au-R008 test
Closes Phase 4
```
