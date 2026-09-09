# Git and worktrees

Agents inspect history and complete task-authorized source-control work while the lead owns Git mutations and shared state.

## Command intent

| Operation | Policy |
| --- | --- |
| Inspection | Status, diff, log, reflog inspection, branch listing, remotes, and worktree listing are routine. A broad `git branch *` or `git worktree *` grant also permits mutations and is not an inspection rule. |
| Local changes | The lead may stage, commit, create/switch branches, and delete integrated local branches with lowercase `git branch -d`. Helpers report edits and findings without mutating Git state. |
| Pull and rebase | Prefer `git pull --ff-only`. If histories diverge, inspect ownership and explicitly rebase the session's work onto the intended upstream. Rebase is reviewed; never rewrite shared/protected history or skip unresolved work. |
| Push and merge | Normal pushes and guarded merges follow task and repo policy, including `main` in trunk workflows. `--force-with-lease` is reserved for an owned feature branch; unrestricted force and shared-branch rewrites are blocked. |
| Cleanup | Prefer `wt merge`/`wt remove`; retain their clean-worktree, integration, and hook checks. Forced deletion (`git branch -D`, `wt remove -D`/`--force`) is manual. Remote ref deletion and mirror pushes are blocked; GitHub handles head-branch cleanup after merge. |

## Recoverable history

Before rebase, amend, squash, reset, or another operation that can stop midway, preserve uncommitted work and record the starting ref. A ref cannot recover untracked or uncommitted content by itself. Inspect any existing operation before starting another.

Resolve understood conflicts and continue, or abort to the preserved starting state. Do not use `--skip`, `reset --hard`, or forced cleanup to discard unresolved work. Report an interrupted operation and its recovery point.

Keep history linear: fast-forward integration or squash/rebase merging, never a merge commit. Commit subjects follow the repository convention and include the active agent's attribution. SPOT bookkeeping travels with the behavior commit.

## Worktrunk and authentication

Use `wt switch`, `wt merge`, and `wt remove` for normal worktree workflows. Direct `git worktree add/move/remove/prune/repair` calls require review. Worktrunk's project hook approvals are independent of harness permission; do not use `--yes`, `--no-hooks`, or config changes to skip them.

SSH authentication uses 1Password. Claude's remote-Git and Worktrunk host exclusions address SSH and sibling-worktree access; they do not grant task authority. Codex reviews host access contextually rather than broadly allowing all Git/Worktrunk execution outside its sandbox.

User terminal commits remain signed. Existing harness-provided session identity/signing overrides remain valid; never change global signing settings or disable signing in response to a failure.

## GitHub and publication

Use `gh`, read before writing, and verify changed destinations. Confidential project material follows repository-local policy; credentials and unrelated personal data do not belong in commits.

Repository deletion, archival, visibility changes, transfers, and destructive issue changes receive review. Package publication and release creation/mutation/deletion use a reviewed project release task on explicit request. Raw publication commands are blocked; a normal push or merge is not equivalent to publication unless the project's automation makes it so.

## Native enforcement

| Harness | Mechanism and limits |
| --- | --- |
| Claude Code | Bash rules, classifier guidance, SSH/Worktrunk exclusions, and helper Git hooks. Specific flag rules take precedence over routine allows. |
| Codex | `git.rules` gates canonical pushes/rebases/worktree mutations and blocks immediate force/delete flags and raw release commands. Prefix rules cannot inspect every argument position. |
| OpenCode | Ordered Bash patterns and a read-only medic shell allowlist. Agent overrides must preserve global safety rules. No process sandbox is supplied by command policy. |

For Codex, `git push origin --delete topic` reaches general push review, while `git push --delete origin topic` matches a prohibition. Leading `git -C`/`-c`, executable paths, wrappers, and `gh api` payloads require contextual inspection. Do not reshape a command to evade a rule.

## Verification

- Inspection and lowercase local branch cleanup retain the intended path.
- Forced local cleanup and remote deletion hit prohibitions in supported command forms.
- Rebase review checks ownership, dirty state, and the recovery point.
- Guarded Worktrunk integration keeps its checks and approvals.
- Raw publishing is blocked while an explicitly requested, project-authorized release task remains usable.
