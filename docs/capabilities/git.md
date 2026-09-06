# Git and worktrees

Agents can inspect repository history and perform authorized source-control work while the lead session retains ownership of shared Git state and remote effects.

## Repository work

- Status, diff, log, blame, branches, tags, remotes, and other read-only inspection should be routine.
- Remote traffic authenticates over SSH through the 1Password agent, which the sandbox cannot reach, so fetch, pull, and push run outside the sandbox under narrow per-command exclusions instead of a session-wide sandbox drop. Fetch, fast-forward pull, and branch switching are routine; every push is approval-gated.
- The lead session may stage and commit completed in-scope work when authorized by the task and repository workflow.
- Helpers edit and verify their assigned files but do not stage, commit, branch, rebase, push, or mutate worktrees.
- History remains linear. `--force-with-lease` on a feature branch the session owns is the only permitted force form, and it is approval-gated like any push; bare `--force` or `-f` is blocked, and protected or shared branches are never force-pushed.
- GitHub work uses `gh`, reads before writes, and treats publishing, merging, closing, or deleting as separate authority.

## Worktrees

- Agents may inspect the source checkout from a worktree when repository metadata or context requires it.
- Worktrunk supports the worktree workflow: listing, status, configuration, switching, and creation are routine; merging or removal follow the task's authority and ownership boundary.
- Worktrunk places worktrees as sibling directories of the checkout, outside the sandbox's writable set, so `wt` runs outside the sandbox and relies on permission rules and guidance for its boundary.
- The capability remains tool-independent if a different worktree interface becomes the daily driver.

## Commit policy

- Commit subjects describe the work, follow the repository's conventional format, and carry the active agent's attribution.
- SPOT checkoffs travel with the behavior commit; bookkeeping-only commits are blocked unless the work is deliberately planning-only.
- User terminal commits remain SSH-signed. Harnesses that cannot access the 1Password signing agent may inject a session-scoped identity and signing override without changing global Git configuration.

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | Bash permissions, sandbox exclusions for remote Git and Worktrunk, Git environment hook, SPOT commit hook, teammate Git-write hook, and Worktrunk plugin | Most explicit command and ownership enforcement. |
| Codex | Sandbox Git access, `GIT_OPTIONAL_LOCKS`, session identity, shared guidance, and Worktrunk hooks | Native multi-agent ownership is guided by shared rules; command approvals remain contextual. |
| OpenCode | Read-oriented Git command permissions, Worktrunk plugin, agent definitions, and shared guidance | Git writes ask by default; no teammate-specific Git hook is currently configured. |

## Verification

- Repository inspection and worktree status do not require broad Git write permission.
- A helper attempting to mutate Git state is stopped and reports its work to the lead.
- Remote writes remain distinguishable from local commits.
- Fetch, pull, and worktree creation complete without a sandbox-override prompt; a push prompts once, and a bare force push is refused.
- Agent commits made outside the sandbox are still unsigned and attributed to the session identity.
- Worktree navigation does not grant permission to merge or remove worktrees.
