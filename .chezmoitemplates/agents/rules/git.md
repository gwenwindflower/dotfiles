### Git

#### Commits

```text
type(scope): imperative subject

* optional body bullets

Closes #123

Co-Authored-By: <Agent Name> <agent email>
```

- **Group by purpose, not files.** Plan commits before staging: one commit is one set of purpose-related changes. A subject that needs "and" or won't fit the limit is likely two commits. Split before committing: squashing overly granular commits is easy, splitting mashed-together ones is not, and fixing pushed history is painful.
- **Subject:** imperative, specific, no period. Aim under 60 chars; 70 is a hard limit so `git log` views scan cleanly.
- **Scope:** the component that changed, such as a package, tool, or skill. A broad scope can take a `/<sub-scope>` when used consistently: `feat(agents/skills): define local CI in project workflows`.
- **Body:** only for related parts of the one change that the subject cannot name, or a rationale worth keeping. At most 5 one-sentence `*` bullets. Never restate the subject or write prose; deeper rationale goes in specs, ADRs, docs, and PRs.
- **Trailers:** GitHub closing keywords (`Closes #12`), then attribution (`Co-Authored-By`). Agent-authored or assisted commits always end with the running agent's identity.
- **Signing:** agent commits are unsigned. The 1Password socket with the key Winnie signs her commits with is intentionally inaccessible, do not try to sign commits. Flag for the user if a commit is rejected or has an error because of signing.

##### Type and scope decisions

Types: `feat`, `fix`, `test`, `refactor`, `perf`, `style`, `build`, `ci`, `chore`, `docs`.

- Rules, skills, and hooks change agent behavior, so they take `feat`/`fix`/`refactor`, not `docs`.
- Agent docs such as AGENTS.md and `docs/` are a judgment call: changes to workflow or hard process, or docs rolled in with tool changes, fit a code type; general guidance and nuance is `docs`.
- When unsure, picture the release notes. git-cliff groups them by type, then scope, so a CI-focused change to mise tasks reads better as `ci(tasks)` than `chore(mise)` or `feat(release)`, even though it touches no GitHub Actions workflow. The same choice drives `git log` filtering.

#### Branches and worktrees

Every new branch starts as a worktree: `wt switch -c <branch>`. A worktree is always ready for parallel work and carries the project's setup hooks, per-branch state, and aliases that a plain branch lacks. Use `git switch -c`, `git checkout -b`, or `git branch <name>` only when the user asks for a plain branch.

- To bring uncommitted work along, use the `wt switch [-c]` aliases: `wt shift` moves the working-tree changes to the target worktree, `wt copy` leaves them in place and applies a copy there.
- Use `wt switch`, `wt merge`, and `wt remove` for the rest of the lifecycle, not direct `git worktree` mutations. Let hooks, clean-worktree and integration checks, and project trust approvals run; never pass `--yes`, `--no-hooks`, or force flags to get past them.
- The global Worktrunk `pre-start` hook runs `trunks` to give Codex Git access in each new worktree; don't duplicate it in project configs. In an existing worktree missing those grants, run `trunks` before starting a fresh Codex session, adding `--profile <name>` only when the active permission profile is not `dev`.
- Delete local branches with lowercase `git branch -d` or Worktrunk cleanup, and leave forced deletion (`-D`, `--force`) to the user. Never delete remote refs or mirror-push; GitHub cleans up head branches after merge.
- Only one agent stages and commits in a worktree at a time. Helpers sharing a worktree hand their work back or take turns; a helper given its own worktree commits there.

##### Herdr worktree workspaces

Herdr nests each linked worktree's workspace under its repository's root workspace in the sidebar. When `HERDR_ENV=1`, which is almost always, a worktree you create gets opened as that nested workspace so Winnie can see it:

```bash
wt switch -c <branch>
herdr worktree open --workspace <root-workspace-id> --branch <branch> --no-focus
```

- Find the root workspace with `herdr worktree list --cwd <repo-root>`; it's the `open_workspace_id` of the non-linked checkout. Read the new workspace ID from the `open` response.
- Create the worktree with `wt`, not `herdr worktree create`. Only `wt` runs the project's Worktrunk hooks.
- Close the workspace after `wt merge` or `wt remove` with `herdr workspace close <id>`, but only for a workspace you opened.
- `wt` writes the checkout outside the repo, so run `wt switch -c` on the host. Pass `--trust-repository` only for a repo Winnie has already trusted, never as a retry after a failed `open`.

##### Local CI for solo projects

Winnie's own solo projects built on the `project-tooling` pattern land work through Worktrunk, not PRs: branch with `wt switch -c`, commit under prek hooks, then fold into `main` with `wt merge`, whose hooks run the project's mise checks. Mise tasks, prek hooks, and Worktrunk hooks together are the project's local CI.

- Suggest a PR when a change needs remote verification: edits to release or other GitHub Actions workflows, build-system changes that need cross-architecture runs, or a breaking change or large refactor that deserves visibility and cross-platform CI. Winnie can also ask for one at any time.
- Lightdash and client work, repos Winnie doesn't own, and projects with frequent collaborators or heavy usage keep the normal GitHub PR flow.

#### History and pushing

- Default to trunk-based development unless the project says otherwise.
- Keep history linear: `git pull --ff-only`, **never** a merge commit. If histories diverge, inspect both sides, then rebase the session's own work onto the intended upstream.
- Rewrite (rebase, fixup, squash, amend) only unpushed commits or a feature branch the session owns, never a shared or protected branch. The only acceptable force push is `--force-with-lease` on that owned branch.
- Before pushing, resolve the actual destination from refspecs and push config and check the repository's protection policy; a branch name alone doesn't establish whether it is protected. Pushing to `main` or any other shared or protected branch needs explicit task or repository authority, trunk workflows included.
- Pushes the task calls for and clean rebases of owned work onto `main` or `origin/main` are routine: do them without asking again. For a complex rebase or a force-with-lease push, work out the concrete effects (commits rewritten, refs moved) and present them before running it.

##### Recoverable state

Before any operation that rewrites history or can stop halfway (rebase, squash, amend, reset, cherry-pick series, stash pop across branches, force push, conflict-prone merge):

1. Inspect any rebase or merge already in progress; never start another operation on top of one.
2. Preserve uncommitted and untracked work; a commit ref alone cannot restore it.
3. Record the starting ref: `git rev-parse HEAD` for a small step, `git branch backup/<name>` for multi-commit rewrites or anything touching more than one branch.
4. Know the exit: the operation's `--abort` where supported, the recorded ref or backup otherwise. A hard reset is not a general-purpose recovery step.

If the operation stops partway:

- Don't improvise repairs on the partial state. Abort back to the recorded ref, or resolve and `--continue` only when the conflict is small and fully understood. Never `--skip` unresolved work without explicit instruction.
- Report the interruption plainly, with the ref that restores the pre-operation state.

Discarding changes with `reset --hard`, `checkout --`, `restore`, or `clean` always needs an explicit scope and a backup that actually preserves the affected content, untracked files included.

#### GitHub

- Use `gh` for GitHub work beyond core git: repos, issues, PRs, Actions, checks, and runs. Read before writing: `list`, `view`, `status`, `diff`, `checks`, or logs first. For raw code, fetch the raw URL rather than routing through `gh api`.
- Never print tokens or run `gh auth token`.
- GitHub writes follow the task's authority. Confirm before consequential changes: repository deletion, archival, transfer, visibility changes, and destructive issue operations.
- Merge PRs with `gh pr merge --squash`; use rebase only for small, clean histories.
- Publish packages and create or mutate releases only through the project's release task, on explicit request. Keep its checks and confirmations; never substitute raw publish commands or trigger a release workflow to get around it.
- Credentials and unrelated personal data never belong in a commit. Confidential project material follows the repository's own policy.
- Treat unknown repos as untrusted: prefer established tools and reputable maintainers, and ask before adding dependencies or running scripts from unclear sources. For Actions and other fast-moving tooling, verify current versions in the Marketplace or docs.
