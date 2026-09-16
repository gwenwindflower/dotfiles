# Git and worktrees

Agents inspect history and complete task-authorized source-control work while the lead owns Git mutations and shared state.

## Command intent

| Operation | Policy |
| --- | --- |
| Inspection | Status, diff, log, reflog inspection, branch listing, remotes, and worktree listing are routine. A broad `git branch *` or `git worktree *` grant also permits mutations and is not an inspection rule. |
| Local changes | The lead may stage, commit, create/switch branches, and delete integrated local branches with lowercase `git branch -d`. Helpers report edits and findings without mutating Git state. |
| Pull and rebase | Prefer `git pull --ff-only`. A clean rebase of an owned, non-shared feature branch onto inspected `main` or `origin/main` is routine with no operation in progress and a recovery ref recorded. Continue after understood conflicts are resolved, or abort to recover. Complex rebases need contextual review; never rewrite shared/protected history or skip unresolved work. |
| Push and merge | Task-authorized normal pushes to verified non-protected branches on the intended remote should pass automatic evaluation without another user confirmation. Resolve refspecs and push configuration; names alone do not establish branch protection. Shared/protected targets need explicit task or repo authority, including `main` in trunk workflows. Guarded merges follow repo policy. `--force-with-lease` needs review and is reserved for an owned feature branch; unrestricted force and shared-branch rewrites are blocked. |
| Cleanup | Prefer `wt merge`/`wt remove`; retain their clean-worktree, integration, and hook checks. Forced deletion (`git branch -D`, `wt remove -D`/`--force`) is manual. Remote ref deletion and mirror pushes are blocked; GitHub handles head-branch cleanup after merge. |

## Recoverable history

Before rebase, amend, squash, reset, or another operation that can stop midway, preserve uncommitted work and record the starting ref. A ref cannot recover untracked or uncommitted content by itself. Inspect any existing operation before starting another.

Resolve understood conflicts and continue, or abort to the preserved starting state. Do not use `--skip`, `reset --hard`, or forced cleanup to discard unresolved work. Report an interrupted operation and its recovery point.

Keep history linear: fast-forward integration or squash/rebase merging, never a merge commit. Commit subjects follow the repository convention and include the active agent's attribution. SPOT bookkeeping travels with the behavior commit.

## Worktrunk

Use `wt switch`, `wt merge`, and `wt remove` for normal worktree workflows. Direct `git worktree add/move/remove/prune/repair` calls require review. Worktrunk's project hook approvals are independent of harness permission; do not use `--yes`, `--no-hooks`, or config changes to skip them. Take time to set up per-project configs to make the workflow as easy as possible, and use Worktrunk aliases to package up complex or multi-step git operations into easy commands.

Key global aliases used across projects:

- `wt copy [-c] <branch>` copies staged, unstaged, and untracked changes to the destination and switches to it, preserving the source.
- `wt shift [-c] <branch>` moves those changes to the destination and switches to it, leaving the source clean after success.

Use `-c`/`--create` to create a branch, or omit it for an existing branch/worktree. `--base @` creates from the current HEAD; Worktrunk otherwise uses the default branch. The aliases use Git stash and reserve `--execute` for restoring changes. If switching or applying fails, the stash remains available for manual recovery.

## Authentication

SSH authentication uses 1Password. Claude's remote-Git and Worktrunk host exclusions address SSH and sibling-worktree access; they do not grant task authority. Codex reviews host access contextually rather than broadly allowing all Git/Worktrunk execution outside its sandbox.


User terminal commits remain signed. Existing harness-provided session identity/signing overrides remain valid; never change global signing settings or disable signing in response to a failure.

## GitHub and publication

Use `gh`, read before writing, and verify changed destinations. Confidential project material follows repository-local policy; credentials and unrelated personal data do not belong in commits.

Repository deletion, archival, visibility changes, transfers, and destructive issue changes receive review. Package publication and release creation/mutation/deletion use a reviewed project release task on explicit request. Raw publication commands are blocked; a normal push or merge is not equivalent to publication unless the project's automation makes it so.

## Native enforcement

| Harness | Mechanism and limits |
| --- | --- |
| Claude Code | Routine pushes/rebases have no blanket Bash ask or allow, so auto mode can evaluate scope and state. Classifier guidance describes destination, ownership, and recovery checks. Explicit asks cover force-with-lease and canonical complex rebase flags; destructive denies, SSH/Worktrunk exclusions, and helper Git hooks remain. |
| Codex | `git.rules` gates canonical pushes/rebases/worktree mutations and blocks immediate force/delete flags and raw release commands. Prefix rules cannot inspect every argument position. |
| OpenCode | Ordered Bash patterns allow exact `git rebase main`, `git rebase origin/main`, `git rebase --continue`, and `git rebase --abort`; shared guidance requires ownership and recovery checks. Other rebases and pushes retain ask: this harness has no automatic evaluator or branch-protection-aware pattern. A broad push allow cannot express the target-dependent contract. Agent overrides preserve global safety rules; no process sandbox is supplied by command policy. |

For Codex, `git push origin --delete topic` reaches general push review, while `git push --delete origin topic` matches a prohibition. Leading `git -C`/`-c`, executable paths, wrappers, and `gh api` payloads require contextual inspection. Do not reshape a command to evade a rule.

## Verification

- Inspection and lowercase local branch cleanup retain the intended path.
- Forced local cleanup and remote deletion hit prohibitions in supported command forms.
- OpenCode's exact common rebase forms resolve to allow; additional arguments and complex variants retain ask, as do pushes without a branch-aware evaluator.
- Guarded Worktrunk integration keeps its checks and approvals.
- Raw publishing is blocked while an explicitly requested, project-authorized release task remains usable.
