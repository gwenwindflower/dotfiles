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

Keep history linear. Use `git pull --ff-only`; if histories diverge, inspect them and explicitly rebase the session's owned work onto the intended upstream. Rebase/fixup/squash may rewrite an owned feature branch, never a shared or protected branch. Only `--force-with-lease` on an owned feature branch is an acceptable force push. **Never** create a merge commit. Default to trunk-based development unless the project says otherwise.

Task-authorized normal pushes to a verified non-protected branch on the intended remote are routine. Resolve the actual destination from refspecs and push configuration, and check repository protection policy; branch names alone do not establish protection. Shared/protected targets need explicit task or repository authority, including `main` in trunk workflows. Guarded merges follow repository policy.

A clean rebase of the session's owned, non-shared feature branch onto `main` or `origin/main` is routine after inspecting the upstream, confirming no operation is in progress, and preserving the recovery state below. Continuing after understood conflicts are resolved, or aborting to recover, is routine. Complex rebases and force-with-lease pushes need contextual review of their concrete effects.

Use automatic evaluation for these routine operations where the harness supports it; do not ask the user again solely because a command pushes commits or rebases owned work. Existing task authorization remains valid. Never add a blanket execution allow to bypass sandbox or native review; uncertain ownership, destination, protection, or recovery state must be resolved first.

#### Worktrees and cleanup

Branch with Worktrunk. Any new branch starts as a worktree via `wt switch -c <branch>`; `git switch -c`, `git checkout -b`, and `git branch <name>` are for when the user specifically asks for a plain branch. A worktree is always ready for parallel work, so a second workstream can branch off it without stashing or juggling checkouts, and Worktrunk carries the project's setup hooks, per-branch state, and aliases that a bare branch lacks. Branching aliases in the global Worktrunk config (`wt shift`, `wt copy`, and any later ones such as a stacking alias) are conveniences over `wt switch [-c]` for starting a branch from a different working-tree state and carry the same permissions as `wt switch`.

Use `wt switch`, `wt merge`, and `wt remove` for the rest of the worktree lifecycle. Preserve hooks, clean-worktree and integration checks, and project trust approvals; do not bypass them with `--yes`, `--no-hooks`, or force flags. Direct `git worktree` mutations require review.

Configure Codex Git permissions before launching agents in new worktrees with this hook in `.config/wt.toml`. Trunks defaults to the `dev` permission profile; use `trunks --profile <name>` if the active Codex profile differs.

```toml
[pre-start]
trunks-agent-config = "trunks"
```

Local branch deletion uses lowercase `git branch -d` or guarded Worktrunk cleanup. Forced deletion (`-D`, `--force`, and equivalents) is manual-only. Never delete remote refs or mirror-push; GitHub handles head-branch cleanup after merge.

The lead owns staging, commits, branches, rebases, remotes, and worktree mutations. Helpers edit and verify assigned files or report recovery instructions; they do not mutate shared Git state.

#### Recoverable state

Any operation that rewrites history or can stop halfway (rebase, squash, amend, reset, cherry-pick series, stash pop across branches, force push, conflict-prone merges) needs a way back before it starts:

- Preserve uncommitted and untracked work before rewriting; a starting commit ref alone cannot restore it. Inspect any existing rebase or merge before starting another operation.
- Record the starting ref: `git rev-parse HEAD` for a small step, a backup branch (`git branch backup/<name>`) for multi-commit rewrites or anything touching more than one branch.
- Know the exit before entering: use the operation's `--abort` when supported, and retain a recovery ref or backup for other rewrites. A hard reset is not a general-purpose recovery step.
- Rewrite only commits that are unpushed or on a branch only you are working on.
- If the operation stops in a partial state, do not improvise repairs on top of it. Abort back to the recorded ref, or resolve and continue only when the conflict is small and fully understood.
- Resolve understood conflicts before `--continue`; never `--skip` unresolved work without explicit instruction. Discarding changes with `reset --hard`, `checkout --`, `restore`, or `clean` requires explicit scope and a backup that actually preserves the affected content, including untracked files.
- Report an interrupted operation plainly, with the ref that restores the pre-operation state.

#### GitHub

Use `gh` for GitHub work beyond core git: repos, issues, PRs, Actions, checks, and runs. Read before write: `list`, `view`, `status`, `diff`, `checks`, or logs first.

Never print tokens. Do not run `gh auth token`, it will be blocked.

GitHub writes follow the task's authority. Review consequential changes such as repository deletion, archival, transfer, visibility changes, and destructive issue operations. Prefer `gh pr merge --squash`; use rebase only for small clean histories.

Publish packages and create or mutate releases only through a reviewed, trusted project release task on explicit request. Preserve its checks and confirmations; do not substitute raw publishing commands or trigger a release workflow to bypass the task. Confidential project material follows repository-local policy; credentials and unrelated personal data never belong in a commit.

For raw code, fetch the raw URL rather than routing through `gh api`. For Actions and actively developed tooling, verify current Marketplace/docs versions.

Treat unknown repos as untrusted. Prefer established tools and reputable maintainers; ask before adding dependencies or running scripts from unclear sources.
