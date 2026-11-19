# Specs

Specs are opt-in. Write, update, or cite one only when Winnie asks for it or the project's docs establish specs, and follow that project's layout and conventions. Issues don't mention specs unless she asks or the project's docs say they should, in any workspace or project.

## What belongs in a spec

A spec states the few contracts that are easy to drift from and hard to pin with tests: key functionality a reader must agree on, and pitfalls an agent is likely to fall into without one. It is not a test suite in prose, so it doesn't enumerate every input, edge case, or outcome.

| Spec it | Not a spec |
| --- | --- |
| Cool Tool has the same commands, names, and behavior across its CLI, API, and MCP server. | Unit tests are written in pytest. |
| Deleting a workspace never deletes the warehouse data it points at. | Issues are tracked in Linear. |
| Config precedence is flags, then env vars, then the project file, then defaults. | Every PR passes `mise run check`. |
| Output stays plain text when stdout isn't a TTY, so piped output never carries color codes. | The empty-string, 0-byte, and 10MB+ cases each return a specific HTTP code. |

The right column is docs (how the repo, tools, and team work), test cases (which belong in tests), or nothing. Development tooling, release process, and developer workflow are never specs.

## Writing one

- **Short, individually and as a whole.** A requirement is one plain sentence; a spec is a short page. If it keeps growing, it's describing implementation or tests.
- **Plain sentences.** "Users can sign in with Google" beats "The system shall provide Google-based authentication capabilities." Name who does what and what they see.
- **Each thing once.** Goals set direction; requirements pin behavior. Don't restate one in the other.
- **What, not how or why.** No stack choices or file paths; rationale goes in the PR or an [ADR](adrs.md).
- **Open questions** are prose bullets for undecided behavior. Promote one into a requirement when the work settles it, or delete it. Future work goes in the project's plan, not the spec.

Readback test: read it aloud. If it doesn't sound like Winnie describing her own project, plain it down; if a line wouldn't stop a capable agent from building the wrong thing, cut it.

## Keeping it true

When the work shows a requirement is wrong, edit it in the same commit as the behavior and note the change in the PR or merge summary. Check with Winnie first when the change alters what's being built. Never quietly bend a requirement to match the output. If the project uses requirement IDs, follow its scheme and don't renumber IDs that anything already cites.
