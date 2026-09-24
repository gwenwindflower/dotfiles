# Git and worktrees

Agents inspect history and complete task-authorized source-control work while the lead owns Git mutations and shared state.

## Levels

Levels are defined in [agent configuration](../agent-config.md#permission-levels); reviewer judgment follows [the review policy](../agent-review-policy.md).

| Family | Level | Notes |
| --- | --- | --- |
| Inspection (`status`, `diff`, `log`, `show`, `reflog`, branch and worktree listing) | `sandboxed` | `open` in Codex, where `.git` is read-only inside workspace roots. |
| Local writes (`add`, `commit`, `stash`, `switch` to an existing branch, `branch -d`, a clean rebase onto `main`, `merge --ff-only`) | `sandboxed` | `open` in Codex for the same reason. |
| Remote sync (`fetch`, `pull`, `clone`, `ls-remote`, `submodule update`, `gh repo clone`, `gh pr checkout`) | `open` | SSH runs through the 1Password agent on the host. |
| Worktrunk lifecycle (`wt switch`, `shift`, `copy`, `list`, `status`, `merge`, `remove`, `step`, `config show`, `hook show`) | `open` | Sibling worktrees, shared `.git`, hooks, and approvals live on the host. |
| Normal push to a non-protected branch | `review-open` | The reviewer resolves the real destination from refspecs and push config. |
| Complex rebase (`-i`, `--onto`, `--root`, `--exec`), plain branch creation (`switch -c`, `checkout -b`), direct `git worktree add`/`move`/`remove`/`prune`, remote edits | `review-open` | Branches start as worktrees through `wt switch -c`. |
| `push --force-with-lease` to the session's own branch, push to `main` or a protected branch | `review-request-open` | |
| Discarding work (`reset --hard`, `clean`, `checkout --`, `restore`, `stash drop`/`clear`), `rebase --skip`, `--no-verify` | `review-request-open` | These also need a preserved backup. |
| Bare force push (`--force`, `-f`, `+refspec`), `git config --global`, `wt config approvals` | `user-open` | |
| Remote ref deletion, mirror push, `branch -D`/`--force`, forced worktree removal, Worktrunk `--yes`/`--no-hooks`/force flags, `commit -S` | `deny` | GitHub deletes merged head branches. |
| `gh` reads | `sandboxed` | The keychain token works in both sandboxes. Codex routes every `gh api` call, reads included, to the reviewer. |
| `gh` PR and issue writes, `gh api` mutations, workflow rerun and cancel, `gh extension` installs | `review-open` | Read before write. |
| `gh pr merge`, PR approvals, repository create/fork/rename/archive/edit, secret and variable writes, release workflow dispatch | `review-request-open` | |
| `gh auth login`/`logout`/`refresh`/`switch`/`setup-git` | `user-open` | |
| `gh auth token`, `gh repo delete`, `gh release` mutations | `deny` | Releases run through the reviewed project release task. |

## Recoverable history

Before rebase, amend, squash, reset, or another operation that can stop midway, preserve uncommitted work and record the starting ref. A ref cannot recover untracked or uncommitted content by itself. Inspect any existing operation before starting another.

Resolve understood conflicts and continue, or abort to the preserved starting state. Do not use `--skip`, `reset --hard`, or forced cleanup to discard unresolved work. Report an interrupted operation and its recovery point.

Keep history linear: fast-forward integration or squash/rebase merging, never a merge commit. Commit subjects follow the repository convention and include the active agent's attribution. SPOT bookkeeping travels with the behavior commit.

## Worktrunk

Worktrunk is the agent-facing surface for branching. Every branch is a worktree, so parallel workstreams are always one `wt switch -c` away, and `wt` commands carry the day-to-day flow with their own hooks, checks, and per-branch state. Worktrunk's project hook approvals are independent of harness permission; never skip them with `--yes`, `--no-hooks`, or config changes. Set up per-project configs and use Worktrunk aliases to package complex or multi-step git operations.

Global branching aliases wrap `wt switch [-c]` for a particular starting state:

- `wt copy [-c] <branch>` copies staged, unstaged, and untracked changes to the destination and switches to it, preserving the source.
- `wt shift [-c] <branch>` moves those changes to the destination and switches to it, leaving the source clean after success.

Use `-c`/`--create` to create a branch, or omit it for an existing branch or worktree. `--base @` creates from the current HEAD; Worktrunk otherwise uses the default branch. The aliases use Git stash and reserve `--execute` for restoring changes. If switching or applying fails, the stash remains available for manual recovery.

An alias added to `symsources/worktrunk/config.toml` reaches review until both configs list it beside `shift` and `copy`.

## Authentication and metadata

SSH authentication uses 1Password's agent on the host. User terminal commits remain signed; agent sessions use a hook-provided unsigned identity, so never change signing settings or pass `-S` in response to a failure.

Sandboxed tools that need linked-worktree metadata resolve `git rev-parse --absolute-git-dir --git-common-dir`; a `.git` pointer alone does not grant its external target.

## GitHub and publication

Use `gh`, read before writing, and verify changed destinations. Confidential project material follows repository-local policy; credentials and unrelated personal data do not belong in commits. A normal push or merge is not publication unless the project's automation makes it so.

## Native enforcement

| Harness | Mechanism and limits |
| --- | --- |
| Claude Code | `open` families are excluded with a matching allow. `git push`, discard forms, complex rebase, branch creation, `git worktree` mutations, remote edits, and `gh` write subcommands are excluded without an allow, so they reach the classifier. Bare force, auth, and global config are `ask`; deletion, forced cleanup, and signing are `deny`, including `git -C` forms. |
| Codex | `git.rules` allows inspection, local writes, remote sync, and Worktrunk lifecycle; prompts on discard forms, complex rebase, branch creation, `--no-verify`, worktree and remote mutations, `gh` writes, and `gh api`; forbids user-open and deny families. `git push` has no allow, so it fails in the sandbox and escalates to the reviewer. |
| OpenCode | Ordered Bash patterns allow exact `git rebase main`, `git rebase origin/main`, `git rebase --continue`, and `git rebase --abort`; shared guidance requires ownership and recovery checks. Other rebases and pushes retain ask: this harness has no automatic evaluator or branch-protection-aware pattern. A broad push allow cannot express the target-dependent contract. Agent overrides preserve global safety rules; no process sandbox is supplied by command policy. |

Prefix rules match canonical forms only. Later flags, `--flag=value` forms, leading `git -C`/`-c`, executable paths, wrappers, and `gh api` payloads need the reviewer's judgment, and static rules cannot see branch protection or ownership. Never reshape a command to avoid a rule; a non-match is not authorization.

## Verification

- `codex execpolicy check` passes every `match` and `not_match` case in `git.rules`.
- Inspection and lowercase local branch cleanup run without review.
- A requested push to a feature branch is approved; an unrequested push to `main` is declined.
- A requested `--force-with-lease` is approved; an unrequested one is declined; a bare `--force` is handed to the user.
- Forced local cleanup, remote deletion, and `gh repo delete` are blocked in both harnesses.
- OpenCode's exact common rebase forms resolve to allow; additional arguments and complex variants retain ask, as do pushes without a branch-aware evaluator.
