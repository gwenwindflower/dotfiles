---
name: project-management
description: Planning and doing dev work - writing and clarifying Linear issues, organizing them into projects, session planning for personal projects, optional per-project specs, and managing agents, git, worktrees, and PRs to execute the work.
---

# Project management

Everything here serves the project's goals, not the process. Adapt to how a project already works, and use the lightest planning that fits.

| Project | Plans live in | Lands as |
| --- | --- | --- |
| Lightdash | Linear issues, `lightdash` workspace | GitHub PR |
| Personal and Supermodel | The session's own planning tools or a markdown file; Linear only when the project docs point to a Linear project or Winnie asks | `wt merge`, unless the project docs or Winnie say PR |

- **An issue is a task in plain language.** It usually maps to one PR; treat that as a guidepost, not a rule.
- **Each fact lives in one place.** Parents don't repeat their children, and an issue's brief and comments add to its summary rather than recap it.
- **Make calls.** Pick the reasonable option, write it down, and flag it in the PR or merge summary. Stop only for choices with irreversible or external effects, or ones that change what's being built.
- **Specs are opt-in.** Write or cite one only when Winnie asks or the project's docs establish specs. Issues never mention specs otherwise, on any platform or project.
- **Name the Linear workspace on every command.** Without one, `linear-cli` runs against whichever profile was last switched to, and a search in the wrong workspace returns plausible, irrelevant results instead of an error. Profiles and how to set them: [linear](linear.md).

| Job | Doc |
| --- | --- |
| Connect to a workspace; shape issues, sub-issues, and projects; relations; PR magic words | [linear](linear.md) |
| Create or maintain skills inside Linear Agent | [linear-agent-skills](linear-agent-skills.md) |
| Write or rewrite an issue | [issues](issues.md) |
| Work in the Lightdash workspace: customers, readiness labels | [lightdash](lightdash.md), with [clarify](clarify.md), [compact-rubric](compact-rubric.md) |
| A public GitHub issue for Lightdash, cleanup of old GitHub issues, or editing an issue with a sync banner | [github-sync](github-sync.md) |
| Find issues or duplicates | [searching](searching.md) |
| Write specs, in a project that uses them | [specs](specs.md) |
| Record a reversal of a shipped spec or load-bearing design choice | [adrs](adrs.md) |
| Plan, start, land, or split work; helpers; parallel sessions | [working](working.md) |
| Create, merge, or remove worktrees with `wt` | [worktrunk](worktrunk.md) |
| Stacked PRs with `gh stack` | [gh-stack](gh-stack.md) |

Repo setup (template, mise tasks, prek, `wt.toml` hooks, local CI, releases) belongs to `project-tooling`; personal to-dos belong to `todos`.
