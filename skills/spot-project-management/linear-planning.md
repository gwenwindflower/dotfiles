# Linear Planning

The plan lives in Linear instead of `TODO.md`/`DONE.md`. Specs stay in the repo unchanged. Load `managing-issues` before reading or writing any issue: it owns the description format, search, labels, and GitHub sync. This file covers only what SPOT adds on top.

## Map the tiers, don't transplant them

Linear has projects, parent issues, sub-issues, and checklists. Think in tiers and execution sequence, not in a one-to-one mapping of Phase, Objective, and Task.

| Work size | Shape |
| --- | --- |
| A few related branches' worth, needing shared framing, an owner, or reporting | A project holding several parent issues; framing and cross-cutting links in the project description or a Linear doc |
| One branch's worth (a Phase) | A parent issue: goal, spec links, intended order of sub-issues, done criteria |
| One reviewable unit that lands as one commit (an Objective) | A sub-issue, or a checklist line in the parent when it needs no context of its own |
| A sequential step (a Task) | A checklist line in the issue body |

Rules of thumb:

- Start with the fewest objects that carry the information. A parent with three checklist lines beats a parent with three one-line sub-issues.
- Promote a checklist line to a sub-issue when it needs its own brief, its own assignee, or its own commit story.
- Create a project only when parent issues would otherwise repeat the same framing; a project is coordination, not a folder.
- No numbering, no `Phase N` in titles. Titles name the outcome in plain language, per `managing-issues`.

## Link specs from issues

A requirement ID means nothing inside Linear. Every spec reference in an issue is a link to the spec file on GitHub, on the default branch, with the ID and its one-sentence wording quoted inline so the reader can check the intent without leaving the issue:

```markdown
Requirements
- [au-R007](https://github.com/acme/app/blob/main/specs/au-auth.md) — As a user, I can authenticate with a Google account and reach the dashboard within 3 seconds of consent.
- [au-R008](https://github.com/acme/app/blob/main/specs/au-auth.md) — If a callback is missing the state token, the system rejects it with a clear error.
```

Link the file, not a line permalink: IDs are stable, line numbers are not. Put the list in the parent issue; a sub-issue links only the IDs it satisfies. When the wording quoted in an issue drifts from the spec, the spec wins and the issue gets corrected.

## Sequence without numbers

- Write the intended order of sub-issues in the parent description as a short list. That is enough for the owning session.
- Add a `blocks` relation only when one issue's output is another's required input. Likely order alone is not a dependency.
- Blocked issues chain the same way Phase dependencies do: an issue is unblocked when everything upstream is Done, not merely In Progress.
- Parallel sessions take separate parent issues with no blocking relation between them and the seam test from [parallel sessions](parallel-sessions.md) passing.

## Run a parent issue

Same flow as [running phases](running-phases.md) with these substitutions:

1. **Load context** from `SPEC.md`, the parent issue, its sub-issues, and each linked requirement's wording in the spec file. Confirm nothing upstream is still open.
2. **Move the parent to In Progress** when work starts. Use the team's branch convention; when there is none, name the branch for the work (`feat/oauth`) and let the commit trailer carry the ID.
3. **One sub-issue, one commit.** Put `Closes <ID>` in the commit body after any bullets, or in the PR description, so Linear moves the sub-issue on merge. Tick checklist lines in the issue as they land.
4. **Close** with a comment on the parent issue in place of the `DONE.md` block: what shipped, which requirement IDs are satisfied, decisions and surprises, and anything to fold back into the specs or the backlog. Keep it as tight as the description. Add `Closes <parent ID>` to the last commit so the parent moves to Done on merge, and confirm the status actually moved.
5. **Docs and specs** update in the same commits as the behavior. Spec-only edits still ride with a behavior commit; a deliberate planning-only commit is the rare exception.

## Backlog and decisions

- The Backlog stays in `SPEC.md`. A Linear issue in Backlog or Triage status is a promoted item waiting for an owner, not a second backlog; do not mirror the whole SPEC backlog into Linear.
- Open product decisions go in an `## Open decisions` block with the `needs-decisions` label, per `managing-issues`. Requirement changes still go to the spec first; the issue links the updated ID.
- ADRs work the same as in the repo plan ([decision records](adrs.md)); the closing comment on the parent issue names the ADR file.
