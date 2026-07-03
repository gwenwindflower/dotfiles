# Multi-Issue Proposals

Use a multi-issue proposal (one-pager) when a product idea needs a short narrative anchor plus several actionable issues, but is not yet bought into as a full project.

## When To Use

- The work is a cohesive product direction, workflow loop, or capability expansion.
- One issue would become too broad, but each issue still needs shared context.
- The proposal is speculative or early enough that project overhead would be premature.
- The issues can move independently while still benefiting from a common framing doc.

Use a Linear project instead when the work has committed staffing, milestones, roadmap reporting, or release coordination needs.

## Shape

Create a Notion doc, Google Doc, or a Linear document directly in the tool, etc. (follow company conventions) — this will serve as the anchor:

- Lead with the current product gap and why it matters.
- Describe the desired workflow or system behavior at user level.
- Link each issue with a one-line role in the larger proposal.
- Keep implementation bets provisional unless a constraint is already known.
- Name open questions that could change scope, ownership, or terminology.

Create issues as independently actionable slices:

- Each title should name the product area and outcome.
- Each issue should state current behavior, desired behavior, and open questions.
- Avoid making the doc required to understand the issue's local scope.
- Add Related links between sibling issues so the cluster survives outside the doc.
- If one issue becomes a blocker, use blocker relations instead of relying on prose.

## Example Pattern

`Sandia Sandboxes as collaborative agent workspaces` anchors a three-issue proposal inside the `Team sandboxes` project:

| Issue | Role in proposal |
| --- | --- |
| `SAN-214` | Shared navigation: teammates can join the same sandbox session, see presence, and follow or hand off control while investigating the running environment. |
| `SAN-215` | Work assignment: sandbox-linked tasks can be assigned to specific agents, users, or agent-user pairs, with ownership visible from the session. |
| `SAN-216` | Workspace discoverability: sandbox sessions surface their related tasks, owners, files, logs, and agent activity from one team-accessible workspace view. |

The document carries the larger bet: Sandia sandboxes could evolve from isolated execution environments into collaborative workspaces where teams navigate live state, delegate work, and review agent progress without losing the sandbox as the source of truth.

The issues stay separate because shared navigation, work assignment, and workspace discoverability can be scoped, debated, and shipped independently. They are linked as related issues because the product value depends on reading them as a cohesive collaboration loop.

## Review Checklist

- Is the doc explaining a cohesive product direction instead of restating ticket bodies?
- Are the collective issues DRY? Have you centralized vision in the doc and more detail specs and ideas into the issues, linking out to context when needed rather than duplicating it?
- Can an issue be executed by reading only the issue and its direct links, rather than requiring reading all issues and the doc up front?
- Are sibling issues linked in both the doc and as properly linked issues in Linear?
- Are speculative pieces marked as open questions rather than hidden requirements? Is the tone correctly suggestive rather than demanding (could, should, would NOT need, must)
- Would a project add useful coordination now, or just ceremony? What existing project does this mini-arc fit into?
