# Working on issues

One issue usually becomes one branch in its own worktree, landing as one PR or `wt merge`. Branch mechanics live in [worktrunk](worktrunk.md); commit format, history, and push authority come from the global git rules.

## Starting

1. Read the issue, its parent's description, and any linked spec or doc.
2. Move the issue to In Progress.
3. `wt switch -c <branch>`, named for the work (`feat/oauth`, `fix/session-expiry`). If the session starts on the default branch, branch first.

## Making calls

- Make reasonable calls as the work needs them: pick the sensible definition, apply it, write it down where it belongs (code, docs, spec), and flag it in the PR.
- Stop and ask for choices with irreversible or external effects, or ones that change what's being built.
- Name concrete risks instead of generic rollout steps. "Attio's org-created workflow pings sales, so check that orgs newly appearing in the export are recent" beats "produce a rollout plan".

## Landing

- **Solo projects on the `project-tooling` pattern** land with `wt merge`; the project's `pre-merge` gate is the local CI. Open a PR only when the change needs remote verification.
- **Everything else** (Lightdash, repos Winnie doesn't own, collaborator-heavy projects) goes through a GitHub PR, merged with `gh pr merge --squash`.
- The PR description carries the record and the Linear magic words ([linear](linear.md#issues-and-prs)).

Two kinds of stack, one per stack:

| Stack | Shape | Lands with |
| --- | --- | --- |
| Local worktree stack | Each layer in its own worktree, created with `wt switch -c <child> --base @` | `wt merge <parent>` folds a layer down, then the bottom merges into the default branch |
| GitHub stacked PRs ([gh-stack](gh-stack.md)) | All layers as branches in one worktree | `gh stack merge <pr> --yes --squash`, bottom-up on GitHub |

`gh stack` switches branches inside a single checkout, so it can't navigate layers checked out in other worktrees; `gh stack link` covers that case.

## Helpers

Delegate a big, self-contained piece of work to a helper (a subagent or teammate) when it saves real time. Brief it with the task, the agreed names, and why the work matters.

- Only one agent commits in a worktree at a time. Helpers sharing a worktree with the lead hand their work back for the lead to commit, or take turns.
- Parallel helpers in one worktree need near-disjoint files; otherwise they trample each other. When in doubt, serialize, or give each its own worktree and branch.
- Review helper work before it lands: does it do what the issue asks, do the tests exercise it, do names match, did anything outside the assignment change? Send off-target work back with a sharper brief rather than patching over it.

## Parallel sessions

Separate issues can run as separate sessions, each in its own worktree. A lead session can assign several issues, then watch the PRs and CI (`gh pr checks`, `gh run watch`) and land them as they pass.

Split only when the seam is real: each branch can be named without mentioning the other, they touch near-disjoint files, and each side is enough work to pay for the setup. Litmus: *would these branches merge cleanly with zero coordination?* If you have to think about it, don't split.

1. **Check the repo is worktree-ready.** A fresh worktree has to build and test without manual setup; `project-tooling` covers the `wt.toml` hooks that make that true. If it isn't ready, fix that or say so before splitting.
2. **Pick the base.** `wt switch -c` bases on the default branch; `--base @` stacks on the current branch when the work folds back into it.
3. **Spawn a full session in the new worktree**, such as a herdr pane running `claude`, `codex`, or `opencode` (see the `herdr` skill). A full session can spawn its own helpers, which a subagent can't.
4. **Brief it** with the issue ID, what done looks like, and whether it opens a PR or stops for the lead to fold the branch.
5. **Watch for done.** Idle with a dirty tree or no commits means blocked or waiting on input; check rather than assume. `wt list --format=json` shows each branch's state.
6. **Fold one branch at a time** with `wt merge <target>` from the child worktree, after reviewing the whole-branch diff. Each later branch rebases onto the updated target. On failure the merge aborts in place; fix in the worktree and re-run.

Leftovers (abandoned experiments, branches `wt list` flags as integrated) go through `wt remove`.
