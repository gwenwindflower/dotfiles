# Worktrunk

Worktrunk (`wt`) owns the worktree lifecycle: every branch starts with `wt switch -c <branch>`, lands with `wt merge`, and is cleaned up with `wt remove`. Never mutate worktrees with `git worktree add`, `move`, or `remove`; those skip the hooks that provision and clean up a worktree. Worktrees sit next to the main checkout as `<repo>.<branch>`, with `/` in the branch sanitized to `-`. Hooks, aliases, and commit generation live in [worktrunk-config.md](../project-tooling/worktrunk-config.md). In Claude Code, the plugin's `worktrunk:worktrunk` skill is the full upstream reference.

## Which worktree a command acts on

`wt` finds the repository from the working directory and the worktree from the command's arguments.

- **A branch argument names its worktree.** `wt switch <branch>`, `wt remove <branch>`, `wt step diff --branch <branch>`, and `wt step commit --branch <branch>` act on that branch's worktree from anywhere in the repo. Every such argument also takes the worktree's path, which is the only way to name a detached worktree.
- **`-C <path>` moves the working directory, not the selection.** Use it for another repository, or for commands that act on the current worktree and take no branch: `wt merge` and `wt step rebase|squash|push`, whose positional argument is the merge target. Adding `-C` on top of a branch argument names the worktree twice.

| Shortcut | Means |
| --- | --- |
| `^` | Default branch |
| `@` | Current branch |
| `-` | Previous worktree |
| `pr:<n>` or the PR URL | GitHub PR's branch; fork PRs get `pushRemote` set to the fork |

Shortcuts work anywhere a branch is accepted, including `--base`.

## Agents and the working directory

An agent's shell never follows `wt switch`: the `cd` comes from the interactive shell wrapper, which agent shells don't load. Create the worktree without it and work by path:

```bash
path=$(wt switch -c feat/oauth --no-cd --format=json | jq -r '.path')
git -C "$path" status
wt -C "$path" merge
```

- Branch-addressed commands (`wt remove feat/oauth`, `wt step diff --branch feat/oauth`) need no path.
- `-x <program>` starts the program inside the selected worktree whether or not the shell moves.
- To give a subagent its own worktree, create it with `wt switch -c <branch> --no-cd` and name the absolute path in the brief. `isolation: "worktree"` names the branch after Claude Code's internal agent ID (`agent-<id>`), which leaves throwaway branches and fires hooks against the wrong name.
- Hooks can't prompt in an agent shell, so an unapproved project hook aborts the command. See [approvals](../project-tooling/worktrunk-config.md#approvals).

## Creating and switching

```bash
wt switch -c feat/oauth                  # new branch off the default branch
wt switch -c feat/oauth-ui --base @      # stacked on the current branch
wt switch -c fix/release --base origin/release
wt switch feat/oauth                     # existing branch; creates its worktree if missing
wt switch pr:123                         # a PR's branch
```

- Without `-c`, the branch must exist locally or on the remote; a remote-only branch gets a local tracking branch.
- A new branch tracks its base only when the names match (`-c release --base origin/release`). Otherwise publish with `git push -u origin <branch>`.
- Creating a worktree runs `pre-switch`, creates it, runs `pre-start` to completion, then starts `post-start` and `post-switch` in the background. A failing `pre-start` step cancels `-x`.
- `wt shift <args>` and `wt copy <args>` carry uncommitted changes into the target: shift moves them, copy leaves them in place as well. Both pass their arguments to `wt switch` (`wt shift -c feat/split`) and use the shared stash stack, so don't run them while another session is stashing.
- `Path occupied` means another worktree holds the target path. `--clobber` deletes a stale non-worktree directory there; that is a deletion, so confirm it with the user first.
- To put a worktree on a different branch, `git switch` inside it. Normally, create a new worktree instead.

## Listing

`wt list` shows every worktree with its status; `--branches` adds branches without worktrees, `--full` adds CI status and LLM summaries.

| Symbol | Meaning |
| --- | --- |
| `+` `!` `?` | Staged, modified, untracked |
| `✘` | Merge conflicts |
| `↻` | Rebase, merge, or other git operation in progress |
| `⊟` | Prunable: the worktree directory is gone |
| `⊞` | Locked; no `wt` removal path touches it, even with force flags |
| `_` | Same commit as the default branch and clean; safe to remove |
| `⊂` | Content already integrated into the default branch; safe to remove |
| `✗` | Merging into the default branch would conflict |
| `↑` `↓` `↕` | Ahead of, behind, or diverged from the default branch |
| `⇡` `⇣` `⇅` | Ahead of, behind, or diverged from the upstream |
| 🤖 💬 | Agent working or waiting (see [markers](../project-tooling/worktrunk-config.md#state-and-markers)) |

`--format=json` emits schema 2, an envelope with the rows under `.items`:

```bash
wt list --format=json | jq '.items[] | select(.branch == "feat/oauth")'
wt list --format=json | jq -r '.items[] | select(.display.state == "integrated" or .display.state == "empty") | .branch'
```

## Merging

`wt merge [target]` merges the current worktree's branch into the target, the default branch unless named. It is local only: it never fetches, and publishing is a separate `git push` that follows the repo's push rules. The pipeline:

1. **Commit**: runs `pre-commit` hooks, then commits uncommitted changes. Skipped when squashing, which stages them instead.
2. **Squash**: runs `pre-commit` hooks, then combines every commit since the target into one with a generated message. Swept-in working-tree changes are backed up to `refs/wt-backup/<branch>` first.
3. **Rebase**: onto the target, when anything needs replaying.
4. **`pre-merge` hooks**: the project's merge gate. A failure aborts with everything in place.
5. **Fast-forward** the target; its worktree's files update too.
6. **`pre-remove` hooks**, then removal of the worktree and branch. The primary worktree, a locked one, and `--no-remove` keep the worktree.
7. **`post-remove` and `post-merge` hooks** in the background.

- Squash is the default. Pass `--no-squash` when the branch's commits are the record, such as one commit per Objective.
- A stacked branch folds into its parent with `wt merge <parent-branch>`.
- `--stage all` (the default) sweeps untracked files into the commit. Commit or clean deliberately before merging.
- A rebase conflict stops the merge with the rebase open in the worktree. Resolve and `git rebase --continue`, or `git rebase --abort`; every `wt step` and `wt merge` refuses to run until it settles.
- Never pass `--no-hooks` or `-y`/`--yes` to get past a failing gate or an approval prompt; that is the user's call.

## Removing

`wt remove [branch-or-path...]` removes the current worktree by default, runs in the background, and deletes the branch only when it is integrated into the default branch. Integration covers squash and rebase merges: same commit, ancestor, empty three-dot diff, matching trees, a simulated merge that adds nothing, or a matching squash commit's patch-id.

- `--no-delete-branch` keeps the branch; `--foreground` waits for the removal. Background output goes to `.git/wt/logs/<branch>/internal/remove.log`.
- A dirty worktree or an unintegrated branch is refused. `-f`/`--force` (discard changes) and `-D` (delete an unmerged branch) are the user's call; report the refusal instead.
- `wt step prune --dry-run` previews bulk cleanup of integrated worktrees and branches. It skips dirty, locked, and main worktrees, and anything younger than `--min-age` (1 day).
- `git worktree lock <path>` protects a worktree from every removal path.

## Step subcommands

| Command | Does |
| --- | --- |
| `wt step diff [--branch b] [-- --stat]` | Everything `wt merge` would include: committed, staged, unstaged, and untracked changes against the merge base |
| `wt step commit [--branch b]` | Stages per `--stage` and commits with a generated message, running `pre-commit` hooks; `--dry-run` prints the message only |
| `wt step squash` | Squashes commits since the target into one |
| `wt step rebase [target]` | Rebases onto the target, or reports it already up to date |
| `wt step push [target]` | Fast-forwards the local target ref to this branch; nothing leaves the machine |
| `wt step copy-ignored [--from b] [--to b]` | Reflink-copies gitignored files (deps, caches) between worktrees; skips existing files |
| `wt step for-each -- <cmd>` | Runs a command in every worktree |
| `wt step prune` | Removes integrated worktrees and branches |

## Troubleshooting

- **`needs approval` / `Cannot prompt for approval`**: stop and ask the user to run `wt config approvals add` in the repo. Check beforehand with `wt config approvals list --format=json | jq -r .state`.
- **Hook failed or did nothing**: `wt hook show --expanded` prints each hook with its variables filled in. `-v` on any command prints the resolved template variables. `wt hook <type> --dry-run` previews and `wt hook <type>` re-runs a hook by hand.
- **Background hook output**: `.git/wt/logs/<branch>/<user|project>/<hook-type>/<name>.log`; `wt config state logs get` lists them, and `.git/wt/logs/commands.jsonl` records every hook and LLM command with its exit code.
- **Wrong default branch** after a remote rename: `wt config state default-branch clear`.
- **Stale 🤖 or 💬 marker** after a killed session: `wt config state marker clear [--branch b]`.
- **`wt list` times out**: a wedged `git fsmonitor--daemon` in the named worktree. `git status` there hangs too; stop that daemon.
- **Anything else**: `-vv` writes `trace.log` and `diagnostic.md` under `.git/wt/logs/`.
