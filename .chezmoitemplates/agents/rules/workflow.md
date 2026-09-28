### Task restraint

Scale end-of-task rituals to the change. A targeted docs edit, a backlog entry, or a clarified comment needs no `git status` sweep, full test run, or detailed commit; do the edit and report it. Reserve the full loop of status, tests, and a well-formed commit for material code or behavior changes.

### Use TDD

Default to red-green TDD for behavior changes: features, bug fixes, API changes, and user-facing workflows. Skip only for tiny non-behavior edits or when the project says otherwise; SPOT's exceptions live in the `spot-project-management` skill.

Loop:

1. Write a failing test for the requirement.
2. Run it and confirm it fails for the intended reason.
3. Refine the test if its wording or assertion is wrong.
4. Implement the smallest passing change.
5. Repeat for the next in-scope edge case.

Match the existing suite's framework, layout, naming, and style. Test the project's goals, specs, and expressed end state; do not add speculative fixtures or parameters.

Tests should prove substantive behavior. Avoid tests that only assert project meta-conditions, implementation plumbing, mocked call counts, file existence, generated boilerplate, or code paths outside the core logic. If a test would still pass while the user-visible requirement is broken, it is noise.

If you find a major unrelated coverage gap, report it before filling it. Use descriptive test names that state condition and expected behavior.

### Projects

Serious projects use SPOT project management; smaller or early projects borrow parts of it without the full ceremony. Specs are the same everywhere. The plan lives in one of two places: markdown in the repo, or Linear.

| File | Job |
| --- | --- |
| `SPEC.md` | Project-level what and why; indexes domain specs |
| `specs/<dom>-<slug>.md` | Durable domain requirements with stable IDs |
| `docs/` | How the system works now |
| `TODO.md` | Repo plan: active Phases, Objectives, and Tasks |
| `DONE.md` | Repo plan: shipped work and rationale |

Detect the plan home before planning or picking up work: `TODO.md` at the root means the repo plan; a Linear team, project, or issue named in the brief or the project context means Linear, and `TODO.md`/`DONE.md` do not exist. Load the `spot-project-management` skill before authoring specs, planning work, or when briefed to run a Phase or parent issue. Otherwise this context is enough to work within the system.

#### Shape

Work is planned in three tiers. The repo plan names them; Linear maps them onto its own objects without the numbering.

| Tier | Repo plan | Linear | Meaning |
| --- | --- | --- | --- |
| Phase | `## Phase N: Description` | Parent issue | One branch's worth of work; a context boundary |
| Objective | `### Description` | Sub-issue (or a checklist item when small) | One reviewable unit; lands as one conventional commit |
| Task | `- [ ] description` | Checklist item in the issue body | Sequential step |

A Linear project groups several related parent issues when the work is big enough to need shared framing, ownership, or reporting; otherwise parent issues stand alone. Do not force every level: a small piece of work is one issue with a checklist.

Repo plan: Phases are independent unless a `**Dependencies**: <N>` line says otherwise, and dependencies chain (if Phase 7 depends on 6 and 6 on 5, Phase 7 is also blocked by 5). Phase numbers are stable IDs, not ordering; update Phase content in place, append new Phases. `**Requirements**: <id>` lines tie a Phase to spec IDs.

Linear: no numbering. Sequencing is a `blocks` relation only when one issue's output is another's required input; otherwise state the intended order in the parent description. Spec references are links to the spec file on GitHub with the ID and its one-sentence wording quoted inline, because a bare `au-R007` means nothing inside Linear.

When the plan and the specs disagree, specs win — flag the mismatch.

#### Execution

- A session runs a Phase or parent issue on one branch in one worktree. Helpers (teammates, subagents) work in that same tree and report done; the owning session reviews, then commits or sends back.
- An Objective closes as one well-named conventional commit. Branch names and commit subjects describe the work (`feat/oauth`, `feat(auth): add GCP oauth`) — the planning system stays out of them.
- No bookkeeping-only commits. Repo plan: fold the TODO checkoff into the Objective's commit and amend the final TODO→DONE move into the Phase's last commit. Linear: put the issue's magic word (`Closes ENG-123`) in the commit trailer or PR description so status moves on its own.
- Requirement changes are planning work: pause, edit the spec deliberately, resume. Don't bend requirements to match output mid-Phase.
- A Phase is complete when every Task is done, listed requirements are met, the ledger is updated (`DONE.md`, or a closing comment on the parent issue), and the branch is clean.
- Truly unrelated Phases or parent issues can run as parallel sessions on worktrees (worktrunk + herdr); the parent session creates, briefs, and folds them. Decide on parallelization in planning, weighing the speed gain against the cost of folding the changes in cleanly.

##### Plan details in commits

Plan details go after any body bullets, before the trailers. The last Objective of Phase 3 in a repo plan:

```text
fix(auth): patch pkce loophole

* optional body bullets

Completes `Fix PKCE vulnerability` in Phase 3
Closes Phase 3

Closes #456

Co-Authored-By: <Agent Name> <agent email>
```

Every Objective's commit carries its `Completes` line; only the last adds `Closes Phase N`. In Linear the closing keywords are the plan details: `Closes ENG-312` for the sub-issue, then `Closes ENG-310` when it also finishes the parent. Never a separate commit like `chore(spot): close Phase 3`.

#### Stops

- `#user` marks Tasks needing human credentials, judgment, installs, or deployments. Stop when blocked.
- Surface ambiguous wording, risky approaches, and requirement concerns before building.

#### Issues and tasks

Issues are work and project tracking in Linear or GitHub. Tasks are Winnie's personal to-dos in Reminders and the vault, even when one mirrors an issue assigned to her. A capitalized Task is neither: it is a step in a SPOT plan.

- Load `managing-issues` before reading or writing any issue.
- Load `tasks` before reading or changing any task or reminder.
- A request about "my tasks" or "to-dos" means tasks; a request about tickets, the backlog, or a named issue means issues. Changing one never implies changing the other.

#### Notes vault

The girlOS Obsidian vault is Winnie's knowledge base for deep dives and learning resources. Write to it only when she asks to capture, save, or write something up; research, plans, and explanations otherwise stay in the reply or in project docs. When a reply runs long and a note would help, offer one in a sentence and wait for a yes.

- Load the `obsidian` skill before saving a note or doing any other work in the vault.
- Search for an existing note first and append when one already covers the topic.
- Land a note in `org/_inbox/` by default, `dev/<project>/` when the project already has a folder there, `dev/_seeds` (append) for new project ideas, or `pen/00_ideas/` for writing seeds.
- Link the note in the reply.
