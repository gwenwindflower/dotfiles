---
name: project-management
description: Planning and doing the work - Linear and GitHub issues, specs, ADRs, wt worktrees, landing PRs, helpers, parallel sessions. Repo tooling uses project-tooling.
---

# Project management

Plans live in Linear; specs live in the repo; work happens on a branch in its own worktree and lands as a PR or `wt merge`. Everything here serves the project's goals, not the process. Adapt to how a project already works, and move it toward one consistent way of working over time rather than front-loading structure.

- **An issue is a task in plain language.** It usually maps to one PR; treat that as a guidepost, not a rule.
- **Each fact lives in one place.** Parents don't repeat their children, and issues link specs and docs instead of restating them, and an issue's brief and comments add to its summary rather than recap it.
- **Make calls.** Pick the reasonable option, write it down, and flag it in the PR. Stop only for choices with irreversible or external effects, or ones that change what's being built.
- **Name the Linear workspace on every command.** Without one, `linear-cli` runs against whichever profile was last switched to, and a search in the wrong workspace returns plausible, irrelevant results instead of an error. Profiles and how to set them: [linear](linear.md).

| Job | Doc |
| --- | --- |
| Connect to a workspace; shape issues, sub-issues, and projects; relations; PR magic words | [linear](linear.md) |
| Write or rewrite an issue | [issues](issues.md) |
| Work in the Lightdash workspace: customers, readiness labels, GitHub sync | [lightdash](lightdash.md), with [clarify](clarify.md), [compact-rubric](compact-rubric.md), [github-sync](github-sync.md) |
| Find issues or duplicates on Linear and GitHub | [searching](searching.md) |
| Decide how much to spec; write requirements | [specs](specs.md) |
| Record a reversal on a shipped requirement | [adrs](adrs.md) |
| Start, land, or split work; helpers; parallel sessions | [working](working.md) |
| Create, merge, or remove worktrees with `wt` | [worktrunk](worktrunk.md) |
| Stacked PRs with `gh stack` | [gh-stack](gh-stack.md) |

Repo setup (template, mise tasks, prek, `wt.toml` hooks, CI, releases) belongs to `project-tooling`; personal to-dos belong to `tasks`.
