# Working on issues

One task usually becomes one branch in its own worktree, landing as one PR or `wt merge`. Branch mechanics live in [worktrunk](worktrunk.md); commit format, history, and push authority come from the global git rules.

## Planning

How work is planned depends on the project; check its docs first.

- **Lightdash:** issues in Linear ([linear](linear.md), [lightdash](lightdash.md)).
- **Personal and Supermodel projects with a Linear project named in their docs:** issues in that project, in the `supermodellabs` workspace.
- **Every other personal or Supermodel project:** plan with the harness's own planning tools, or a markdown file — a scratch file by default, or a project file (committed or not) when Winnie agrees to one. Don't write issues or specs before doing the session's work.

## Starting

1. Read the task and anything it links: the issue and its parent, the plan file, or the conversation.
2. On a Linear issue, move it to In Progress.
3. `wt switch -c <branch>`, named for the work (`feat/oauth`, `fix/session-expiry`). If the session starts on the default branch, branch first.

## Making calls

- Make reasonable calls as the work needs them: pick the sensible definition, apply it, write it down where it belongs (code or docs), and flag it in the PR or merge summary.
- Stop and ask for choices with irreversible or external effects, or ones that change what's being built.
- Name concrete risks instead of generic rollout steps. "Attio's org-created workflow pings sales, so check that orgs newly appearing in the export are recent" beats "produce a rollout plan".

## Landing

- **Lightdash, repos Winnie doesn't own, and collaborator-heavy projects** go through a GitHub PR, merged with `gh pr merge --squash`. The PR description carries the record and the Linear magic words ([linear](linear.md#issues-and-prs)).
- **Personal and Supermodel projects** land locally with `wt merge`, testing in the worktree first, unless the project docs set up a PR-based CI and release flow or Winnie asks for a PR. Open a PR anyway when a change needs remote verification (GitHub Actions workflows, cross-architecture builds, a breaking change that deserves visibility).
- **A personal project with no local CI yet:** load `project-tooling` to set up the worktrunk local CI (mise tasks, prek, `wt.toml` hooks), and record the landing flow in the project's agent docs so later sessions don't have to work it out again.

Two kinds of stack, one per stack:

| Stack | Shape | Lands with |
| --- | --- | --- |
| Local worktree stack | Each layer in its own worktree, created with `wt switch -c <child> --base @`; `wt` rebases one branch at a time | `wt merge <parent>` folds a layer down, then the bottom merges into the default branch |
| GitHub stacked PRs ([gh-stack](gh-stack.md)) | Layers in one worktree or one each, as the work needs; `gh stack` cascades rebases across them | `gh stack merge <pr> --yes --squash`, bottom-up on GitHub, then `wt remove` per layer |

The two don't mix on one stack: `wt merge` squashes a layer into its parent, which breaks a chain of PRs.

## Helpers

Delegate a big, self-contained piece of work to a helper (a subagent or teammate) when it saves real time. Brief it with the task, the agreed names, and why the work matters.

- Only one agent commits in a worktree at a time. Helpers sharing a worktree with the lead hand their work back for the lead to commit, or take turns.
- Parallel helpers in one worktree need near-disjoint files; otherwise they trample each other. When in doubt, serialize, or give each its own worktree and branch.
- Review helper work before it lands: does it do what the task asks, do the tests exercise it, do names match, did anything outside the assignment change? Send off-target work back with a sharper brief rather than patching over it.

## Parallel sessions

Separate tasks can run as separate sessions, each in its own worktree. A lead session can assign several, then watch the PRs and CI (`gh pr checks`, `gh run watch`) or the worktrees (`wt list`) and land them as they pass.

Split only when the seam is real: each branch can be named without mentioning the other, they touch near-disjoint files, and each side is enough work to pay for the setup. Litmus: *would these branches merge cleanly with zero coordination?* If you have to think about it, don't split.

1. **Check the repo is worktree-ready.** A fresh worktree has to build and test without manual setup; `project-tooling` covers the `wt.toml` hooks that make that true. If it isn't ready, fix that or say so before splitting.
2. **Pick the base.** `wt switch -c` bases on the default branch; `--base @` stacks on the current branch when the work folds back into it.
3. **Spawn a full session in the new worktree**, such as a herdr pane running `claude`, `codex`, or `opencode` (see the `herdr` skill). A full session can spawn its own helpers, which a subagent can't.
4. **Brief it** with the task (issue ID or a self-contained description), what done looks like, and whether it opens a PR or stops for the lead to fold the branch.
5. **Watch for done.** Idle with a dirty tree or no commits means blocked or waiting on input; check rather than assume. `wt list --format=json` shows each branch's state.
6. **Fold one branch at a time** with `wt merge <target>` from the child worktree, after reviewing the whole-branch diff. Each later branch rebases onto the updated target. On failure the merge aborts in place; fix in the worktree and re-run.

Leftovers (abandoned experiments, branches `wt list` flags as integrated) go through `wt remove`.
