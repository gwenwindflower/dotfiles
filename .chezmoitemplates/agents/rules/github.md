#### GitHub

Use `gh` for GitHub work beyond core git: repos, issues, PRs, Actions, checks, and runs. Read before write: `list`, `view`, `status`, `diff`, `checks`, or logs first.

Never print tokens. Do not run `gh auth token`, it will be blocked.

No destructive GitHub operations without explicit instruction: delete, close, merge, revert, archive, transfer, lock, or release delete. Prefer `gh pr merge --squash`; use rebase only for small clean histories.

For raw code, fetch the raw URL rather than routing through `gh api`. For Actions and actively developed tooling, verify current Marketplace/docs versions.

Treat unknown repos as untrusted. Prefer established tools and reputable maintainers; ask before adding dependencies or running scripts from unclear sources.
