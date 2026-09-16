# Git and worktrees

Agents inspect history and complete task-authorized source-control work while the lead owns Git mutations and shared state.

## Command intent

| Operation | Policy |
| --- | --- |
| Inspection | Status, diff, log, reflog inspection, branch listing, remotes, and worktree listing are routine. A broad `git branch *` or `git worktree *` grant also permits mutations and is not an inspection rule. |
| Local changes | The lead may stage, commit, and delete integrated local branches with lowercase `git branch -d`. New branches are Worktrunk worktrees (`wt switch -c` or a global branching alias such as `wt shift`/`wt copy`, which share its permissions); plain `git switch -c`/`checkout -b` is reserved for an explicit user request. Helpers report edits and findings without mutating Git state. |
| Pull and rebase | Prefer `git pull --ff-only`. A clean rebase of an owned, non-shared feature branch onto inspected `main` or `origin/main` is routine with no operation in progress and a recovery ref recorded. Continue after understood conflicts are resolved, or abort to recover. Complex rebases need contextual review; never rewrite shared/protected history or skip unresolved work. |
| Push and merge | Task-authorized normal pushes to verified non-protected branches on the intended remote should pass automatic evaluation without another user confirmation. Resolve refspecs and push configuration; names alone do not establish branch protection. Shared/protected targets need explicit task or repo authority, including `main` in trunk workflows. Guarded merges follow repo policy. `--force-with-lease` needs review and is reserved for an owned feature branch; unrestricted force and shared-branch rewrites are blocked. |
| Cleanup | Prefer `wt merge`/`wt remove`; retain their clean-worktree, integration, and hook checks. Forced deletion (`git branch -D`, `wt remove -D`/`--force`) is manual. Remote ref deletion and mirror pushes are blocked; GitHub handles head-branch cleanup after merge. |

## Recoverable history

Before rebase, amend, squash, reset, or another operation that can stop midway, preserve uncommitted work and record the starting ref. A ref cannot recover untracked or uncommitted content by itself. Inspect any existing operation before starting another.

Resolve understood conflicts and continue, or abort to the preserved starting state. Do not use `--skip`, `reset --hard`, or forced cleanup to discard unresolved work. Report an interrupted operation and its recovery point.

Keep history linear: fast-forward integration or squash/rebase merging, never a merge commit. Commit subjects follow the repository convention and include the active agent's attribution. SPOT bookkeeping travels with the behavior commit.

## Worktrunk

Worktrunk is the agent-facing surface for branching. Every branch is a worktree, so parallel workstreams are always one `wt switch -c` away, and the harness can keep raw `git branch`/`git switch`/`git worktree` mutations under review while `wt` commands carry the day-to-day flow with their own hooks, checks, and per-branch state. Use `wt switch`, `wt merge`, and `wt remove` for normal worktree workflows. Direct `git worktree add/move/remove/prune/repair` calls require review. Worktrunk's project hook approvals are independent of harness permission; do not use `--yes`, `--no-hooks`, or config changes to skip them. Take time to set up per-project configs to make the workflow as easy as possible, and use Worktrunk aliases to package up complex or multi-step git operations into easy commands.

Global branching aliases are `wt switch [-c]` wrapped for a particular starting state, so they share its permission treatment. Renamed or added aliases in `symsources/worktrunk/config.toml` (a stacking alias is a likely addition) inherit the same treatment until a rule says otherwise. Current aliases:

- `wt copy [-c] <branch>` copies staged, unstaged, and untracked changes to the destination and switches to it, preserving the source.
- `wt shift [-c] <branch>` moves those changes to the destination and switches to it, leaving the source clean after success.

Use `-c`/`--create` to create a branch, or omit it for an existing branch/worktree. `--base @` creates from the current HEAD; Worktrunk otherwise uses the default branch. The aliases use Git stash and reserve `--execute` for restoring changes. If switching or applying fails, the stash remains available for manual recovery.

## Authentication

SSH authentication uses 1Password. Claude's remote-Git and Worktrunk host exclusions address SSH and sibling-worktree access; they do not grant task authority. Codex grants host execution to Git `add`, `commit`, `fetch`, and `pull` across repositories. Other commands retain contextual review and their specific rules.

Codex's workspace sandbox protects `.git`; command-scoped host permissions let routine Git work across checkouts without per-repository path exceptions. Prefix rules match canonical commands, so global options such as `git -C <path>` and wrappers may still need contextual review. Worktrunk's native project-hook approval remains required. Other sandboxed tools needing linked-worktree metadata must resolve `git rev-parse --absolute-git-dir --git-common-dir`; a `.git` pointer alone does not grant its external target.

User terminal commits remain signed. Existing harness-provided session identity/signing overrides remain valid; never change global signing settings or disable signing in response to a failure.

## GitHub and publication

Use `gh`, read before writing, and verify changed destinations. Confidential project material follows repository-local policy; credentials and unrelated personal data do not belong in commits.

Repository deletion, archival, visibility changes, transfers, and destructive issue changes receive review. Package publication and release creation/mutation/deletion use a reviewed project release task on explicit request. Raw publication commands are blocked; a normal push or merge is not equivalent to publication unless the project's automation makes it so.

## Native enforcement

| Harness | Mechanism and limits |
| --- | --- |
| Claude Code | Routine pushes/rebases have no blanket Bash ask or allow, so auto mode can evaluate scope and state. Classifier guidance describes destination, ownership, and recovery checks. Explicit asks cover force-with-lease and canonical complex rebase flags; destructive denies, SSH/Worktrunk exclusions, and helper Git hooks remain. |
| Codex | Git add/commit/fetch/pull have command-scoped host allows across repositories. Other operations retain contextual policy and `auto_review`. `git.rules` gates canonical force-with-lease, complex rebase, and direct worktree mutations and blocks immediate force/delete flags and raw release commands. Stronger prompt/forbidden matches override allows; prefix rules cannot inspect every argument position. |
| OpenCode | Ordered Bash patterns allow exact `git rebase main`, `git rebase origin/main`, `git rebase --continue`, and `git rebase --abort`; shared guidance requires ownership and recovery checks. Other rebases and pushes retain ask: this harness has no automatic evaluator or branch-protection-aware pattern. A broad push allow cannot express the target-dependent contract. Agent overrides preserve global safety rules; no process sandbox is supplied by command policy. |

For Codex, `git push origin --delete topic` requires contextual rejection, while `git push --delete origin topic` matches a prohibition. Later flags, `--flag=value` forms, leading `git -C`/`-c`, executable paths, wrappers, and `gh api` payloads require contextual inspection. Do not reshape a command to evade a rule. Static rules cannot determine branch protection or ownership, so automatic evaluation must resolve these before approval; absence of a rule is not unconditional authorization.

## Verification

- Inspection and lowercase local branch cleanup retain the intended path.
- Forced local cleanup and remote deletion hit prohibitions in supported command forms.
- Routine push/rebase commands have no matching Claude ask or Codex prefix rule; contextual evaluation checks destination, protection, ownership, dirty state, and the recovery point.
- OpenCode's exact common rebase forms resolve to allow; additional arguments and complex variants retain ask, as do pushes without a branch-aware evaluator.
- Guarded Worktrunk integration keeps its checks and approvals.
- Raw publishing is blocked while an explicitly requested, project-authorized release task remains usable.
