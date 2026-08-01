---
name: effective-linear-issues
description: Creates and maintains clear, appropriately scoped Linear issues and projects. Use when reading, drafting, triaging, linking, or updating Linear work; defer to project-local workflow conventions.
---

# Effective Linear Work

## Work From Context

- Inspect the team, recent similar work, and relevant projects, docs, comments, labels, statuses, and cycles before deciding structure or fields.
- Search for duplicates before creating anything. Enrich or link existing work when it already represents the outcome.
- Follow explicit user direction first, then established local conventions. Ask only when an unresolved choice would materially change the result.
- Treat an explicit create or update request as write approval. Otherwise, present the proposed structure and obtain approval before using Linear write tools.
- Keep customer and other private context in private Linear workspaces. Never copy private Slack links or screenshots into public GitHub issues or docs; generalize private context before syncing work publicly.

## Use the Lightest Structure

- **Issue**: one concrete, independently deliverable outcome.
- **Multi-issue proposal**: a speculative direction that needs a short narrative anchor and several independently actionable issues. Follow [Multi-Issue Proposals](multi-issue-proposals.md).
- **Project**: coordinated work with a shared outcome, ownership, roadmap reporting, or release needs.
- **Milestone**: a meaningful checkpoint within a substantial project, usually grouping about five or more issues. Never use milestones as status, priority, or sequence labels.
- **Cycle**: the team's time-boxed execution cadence.
- **Initiative**: a strategic group of projects.

Start with issues and promote the work only when coordination warrants it. Stage projects that cannot ship incrementally.

Use Related relations for cohesive sibling work. Use blocking relations only when one issue's output is another's required input or executing out of order would break the work; likely sequence alone is not a dependency.

## Draft Issues

- Write a direct, scannable title that names the outcome. Omit numbering, phase prefixes, and implementation details.
- Keep the description minimal but sufficient to act without reading every sibling issue or the parent document. Put shared rationale and product or UX debate in the project or anchor doc, then link it.
- Apply explicitly requested fields. Otherwise infer only clear local conventions; do not add labels or priority merely to fill fields.
- For bugs, capture environment, version, reproduction steps, expected and actual behavior, and useful evidence. Do not guess at causes, files, or solutions.
- For features, describe the desired state, rationale, and impact. Separate the requested outcome from proposed solutions, and mark unvalidated ideas as proposals or open questions rather than requirements.
- When filing on someone else's behalf, frame the problem as an ask and leave solution ownership with the assignee. Preserve exact user wording when it is safe and useful.
- Keep prose DRY within an issue and across related work.

## Review Before Writing

- The issue or project has one clear outcome and the lightest useful structure.
- Titles, fields, ownership, and status match the request or established team conventions.
- Dependencies and sibling relationships use Linear relations, not body text alone.
- Each issue is locally actionable; shared context is linked rather than copied.
- Speculation is visibly distinct from requirements.
- Customer or private information cannot leak into public systems.
