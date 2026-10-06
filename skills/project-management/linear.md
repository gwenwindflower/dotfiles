# Linear

Plans live in Linear: what to do next, how work groups, what blocks what, and what shipped. Specs stay in the repo ([specs](specs.md)).

## Workspaces

`linear-cli` keeps one profile per workspace and falls back to the current one, which is whatever was last switched to. Name the profile on every read and write: `--profile <name>` per command, or `LINEAR_CLI_PROFILE` in the project's `mise.toml` `[env]` for a repo that always uses one workspace. Prefer those over `linear-cli config workspace-switch`, which changes the default for every other session too. A Linear MCP connector is bound to the workspace it was authorized for; its result URLs (`linear.app/<workspace>/…`) show which.

| Profile | Used for | Teams | Conventions |
| --- | --- | --- | --- |
| `lightdash` | Lightdash work | Many; read the team's labels and statuses first | [Lightdash workspace](lightdash.md) |
| `supermodellabs` | Supermodel Labs and personal projects | `WBG` | None yet; build them as the work needs them |

Reads run in the sandbox; writes go to the harness reviewer. `linear-cli agent` and `linear-cli common` print agent-oriented usage, and [searching](searching.md) covers relevance search through `linear-cli api`.

## Shaping work

An issue is a task written in plain language. It usually maps to one PR, but that's a guidepost: a small chore can ride along with related work, and a big change can span a few PRs.

- **Start with the fewest objects that carry the information.** One issue with a checklist is the default.
- **Sub-issues** are for pieces that need their own owner, brief, or PR. Never keep a checklist line and a sub-issue for the same work.
- **Parents and projects don't repeat their children.** A parent says what the group is for; each child holds its own scope. When a fact appears in both, it comes out of the parent.
- **A project** is coordination structure, not a folder: use one for committed ownership, roadmap reporting, or a release. Shared rationale and cross-cutting links live in the project description or a Linear doc; issues link back rather than copying context. Milestones mark meaningful checkpoints, never status, priority, or sequence.
- **Documents** for a cluster of related issues (shared framing, design rationale) are Linear Docs. A doc needs a project home.
- **Order** comes from priority and the issue list, not from numbering. Titles never carry numbers or `Phase N`.

## Relations

- **Blocking** only when one issue's output is another's required input. Likely order alone is not a dependency, and an unsettled definition never is.
- **Related** for partial but important overlaps not already covered by a shared project or parent. Topical similarity alone never qualifies; no relations beats padded ones.
- **Mentioning an issue in a description creates a relation**, so mention one only where the relation is wanted.

## Issues and PRs

- Branch per the team's convention; when there is none, name the branch for the work (`feat/oauth`) and let the PR carry the ID.
- The PR description carries `Closes <issue ID>`, plus `Part of <parent ID>` when the issue has a parent. Linear moves status on merge; confirm it did.
- The PR description is the record: what shipped, the calls made, and anything worth a follow-up issue. Comment on the issue only when its next reader needs something the PR doesn't say.
- Close a parent when its last child lands, with a one-line comment if the group's outcome needs saying.
