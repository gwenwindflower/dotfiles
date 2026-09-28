# gh stack

`gh stack` is a GitHub CLI extension for stacked PRs. A stack is an ordered chain of branches on a trunk; each branch has one PR based on the branch below it, so a reviewer sees only that layer's diff. `gh stack <command> --help` is authoritative for flags; `gh stack help <command>` prints only the top-level help.

```text
(main) <- billing/schema <- billing/api <- billing/ui
```

Left is the bottom, right is the top. The bottom merges first. `up` moves toward the top, `down` toward the trunk.

## Worktrees

A stack lives in one worktree, and `gh stack` switches branches inside it. Start the worktree for the bottom layer with `wt switch -c`, then `gh stack init` adopts that branch and `gh stack add` creates each layer above it in the same checkout. Git refuses to check out a branch that is live in another worktree, so a layer checked out elsewhere breaks navigation and cascade rebases. When layers must live in separate worktrees, build the GitHub stack with `gh stack link` (see below) and do the rebases by hand.

## Non-interactive use

Under a TTY most commands open a prompt or a full-screen TUI and block. Always use the non-interactive form:

| Run | Never run | Why |
| --- | --- | --- |
| `gh stack view --json` | bare `view` | Opens a TUI |
| `gh stack submit --auto` | bare `submit` | Prompts for each PR title |
| `gh stack merge <target> --yes` | `gh pr merge` | `gh pr merge` cannot merge a stack |
| `gh stack init <branch>...` | bare `init` | Prompts for branch names |
| `gh stack add <branch>` | bare `add` | Prompts for a name |
| `gh stack checkout <target>` | bare `checkout` | Opens a picker |
| `up` / `down` / `top` / `bottom` / `trunk` | `switch`, `modify` | Menu or TUI only |

With more than one remote, pass `--remote <name>` to `push`, `submit`, `sync`, `rebase`, and `link`. `checkout` has no `--remote` flag and needs `remote.pushDefault` set; setting it is repo config, so ask first.

## Designing the stack

Plan the layers before writing code. Splitting a finished branch later is far harder, since there is no non-interactive reorder.

- A stack is a dependency chain: code a layer depends on lives in that layer or a lower one. Foundations go at the bottom.
- Add a layer when the next change is a different concern that depends on what exists so far: backend to frontend, core logic to tests or docs, a different reviewer, or a diff already big enough to review alone.
- A layer that can't be described in one sentence is two layers.
- One stack tells one story. Unrelated work gets its own stack; a trivial incidental fix can ride along.
- Stacks are strictly linear, one parent and at most one child. Parallel work is a separate stack.
- Layer names share a topic and name the concern, following the repo's branch convention (`feat/billing-schema`, `feat/billing-api`). Names are used verbatim; `add -m` without a name generates a date-slug name, so always name the branch.

Stage each layer deliberately with `git add <paths>` and `git commit`, not `add -Am`. `gh stack add <branch>` leaves the working tree alone, so uncommitted changes follow onto the new branch.

## Core loop

```bash
gh stack init feat/billing-schema     # adopts or creates, checks out the last branch listed
git add <paths> && git commit -m "feat(billing): add invoice schema"
gh stack add feat/billing-api         # must run from the top branch, else exit 5
git add <paths> && git commit -m "feat(billing): add invoice routes"
gh stack submit --auto                # push every layer, open draft PRs, link the stack
gh stack view --json
```

- `init a b c` lays down the whole chain at once: existing branches are adopted, missing ones branch from the one before. `--base` picks a non-default trunk. `init` also enables `git rerere`.
- `add -Am` right after `init` commits onto the empty first branch instead of creating a new one.
- `submit --auto` titles a single-commit PR from the commit subject and body, and a multi-commit PR from the humanized branch name. Edit titles afterward with `gh pr edit`. `--open` marks new and existing PRs ready for review.
- `push` pushes branches without touching PRs.

## Editing a lower layer

Commit a change on the layer that owns it, never on the top branch. Find the owner with `gh stack view --json`, or `git log --all -- <path>` when unclear.

```bash
gh stack checkout feat/billing-schema   # or gh stack down
git add <paths> && git commit -m "fix(billing): tighten invoice constraints"
gh stack rebase --upstack               # replay every layer above onto the change
gh stack top
```

## Rewrites and force pushes

`push`, `submit`, and `sync` push every active layer with `--force-with-lease`, and `sync` and `rebase` rewrite every layer above the change. Treat them as a force-with-lease push of owned branches: before running one, show which layers get rebased and which refs move, and run them only on a stack the session owns. `push` and `submit` are not atomic; a rejected branch moved on the remote, so fix it and rerun. `sync` pushes atomically.

## Staying in sync

`gh stack sync` fetches, reconciles with the GitHub stack, fast-forwards the trunk, cascade-rebases, pushes, and refreshes PR state. It never opens PRs. `--prune` also deletes local branches for merged PRs; without it nothing is pruned.

- A squash-merged layer is detected and skipped with `rebase --onto`, so no manual cleanup is needed after a squash merge.
- If the local and GitHub stacks diverged, `sync` prints both chains, changes nothing, and exits 0 with `Sync aborted`. Check for that message or compare `view --json`.
- `rebase --downstack` covers trunk to the current branch; `--no-trunk` aligns layers with each other without touching the trunk.

## Merging

```bash
gh stack merge 42 --yes --squash    # PR #42 and every unmerged PR below it
gh stack merge 7 --yes --squash     # every unmerged PR in stack #7
```

Always pass `--squash`; without a method flag the last-used method is reused. The merge is all-or-nothing across the set, and PRs must be open and not drafts. A merge queue on the base branch overrides the method and may land the PRs in separate groups. Merging follows the task's authority like any other PR merge.

## Reading state

`view --json` writes JSON to stdout; status text goes to stderr, so branch on exit codes, never parse stderr.

```text
trunk, currentBranch
branches[]     name, head, base, isCurrent, isMerged, isQueued, needsRebase
branches[].pr  number, url, state (OPEN | MERGED | QUEUED); absent when no PR exists
```

`base` is the parent SHA the branch last contained. `needsRebase` is true when the parent's current tip is no longer an ancestor.

## Exit codes

| Code | Meaning | Recovery |
| --- | --- | --- |
| 1 | Generic error | Read stderr |
| 2 | Not in a stack | `gh stack init`, or `gh stack checkout <target>` |
| 3 | Rebase conflict | See below |
| 4 | GitHub API failure | Check `gh auth status`, retry |
| 5 | Invalid arguments | Fix the call; `add` off the top branch lands here |
| 6 | Branch is in several stacks | `gh stack checkout` a branch unique to the intended stack, or pass a stack number |
| 7 | Rebase already in progress | `gh stack rebase --continue` or `--abort` |
| 8 | Stack file locked | Another `gh stack` process is writing; retry after about 5s, report if it persists |
| 9 | Stacked PRs not enabled on the repo | Tell the user |
| 10 | Interrupted `modify` session | `gh stack modify --abort` |

On exit 3 from `rebase`, resolve the files, `git add` them, and run `gh stack rebase --continue` per conflicting layer; `--abort` restores every layer. On exit 3 from `sync`, every branch is already restored: run `gh stack rebase` to reproduce the conflict, then resolve the same way. `rerere` replays a resolution on each layer above.

## Restructuring

Reorder, rename, and removal have no non-interactive path; `modify` is TUI-only even when an error suggests it. Tear down and rebuild instead, which keeps branches and PRs:

```bash
gh stack unstack                                 # drops the grouping locally and on GitHub
gh stack init --base main feat/a feat/b feat/c   # re-adopts the existing branches
gh stack submit --auto                           # fixes PR bases and re-links
```

Stack metadata does not change ancestry. To reorder layers, rewrite ancestry first with `git rebase --onto`, one layer range (`git log <old-parent>..<branch>`) at a time from the bottom up. That is a multi-branch rewrite: create `backup/<branch>` refs first and present the plan.

- `unstack --local` drops only local tracking. Use it before `checkout <pr>` when a different local stack covers those branches, or to keep GitHub's version after a divergence (then `checkout <stack-number>`).
- To keep the local version after a divergence, `unstack` then `submit --auto`.
- PRs that are queued or have auto-merge enabled stay stacked through an `unstack`.

## Linking without local tracking

`gh stack link` builds or extends a GitHub stack through the API with no local state, for branches in separate worktrees or managed by another tool. Arguments run bottom to top as branch names or PR numbers; a leading number that matches an existing stack appends the rest to it (`gh stack link 7 feat/d`). It pushes branches (non-force), creates missing PRs, fixes wrong bases, and never removes a PR from a stack. Navigation commands don't work on a linked stack until `gh stack checkout <stack-number>` sets up tracking.
