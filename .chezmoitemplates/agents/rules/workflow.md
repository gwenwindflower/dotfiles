### Task restraint

Scale end-of-task rituals to the change. A targeted docs edit, a backlog entry, or a clarified comment needs no `git status` sweep, full test run, or detailed commit; do the edit and report it. Reserve the full loop of status, tests, and a well-formed commit for material code or behavior changes.

### Use TDD

Default to red-green TDD for behavior changes: features, bug fixes, API changes, and user-facing workflows. Skip only for tiny non-behavior edits or when the project says otherwise.

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

Plans live in Linear; specs live in the repo. Load `project-management` before planning work, writing specs, reading or writing an issue, or running work across helpers or parallel sessions.

| Home | Holds |
| --- | --- |
| Linear | What to do and in what order: issues, sub-issues, projects |
| `SPEC.md`, `specs/` | Requirements, when the project uses specs; how much to invest is a judgment call per project |
| `docs/` | How the system works now |
| PR description | What shipped, the calls made, and `Closes`/`Part of` magic words |

An issue is a task written in plain language; it usually maps to one PR. Parents and projects don't repeat their children. Branch names and commit subjects describe the work, never the planning system.

- `#user` marks work needing human credentials, judgment, installs, or deployments. Stop when blocked.
- Make reasonable calls, write them down, and flag them in the PR. Stop for choices with irreversible or external effects, or ones that change what's being built.

#### Issues and tasks

Issues are work and project tracking in Linear or GitHub. Tasks are Winnie's personal to-dos in Reminders and the vault, even when one mirrors an issue assigned to her.

- Load `project-management` before reading or writing any issue.
- Load `tasks` before reading or changing any task or reminder.
- A request about "my tasks" or "to-dos" means tasks; a request about tickets, the backlog, or a named issue means issues. Changing one never implies changing the other.

#### Notes vault

The girlOS Obsidian vault is Winnie's knowledge base for deep dives and learning resources. Write to it only when she asks to capture, save, or write something up; research, plans, and explanations otherwise stay in the reply or in project docs. When a reply runs long and a note would help, offer one in a sentence and wait for a yes.

- Load the `obsidian` skill before saving a note or doing any other work in the vault.
- Search for an existing note first and append when one already covers the topic.
- Land a note in `org/_inbox/` by default, `dev/<project>/` when the project already has a folder there, `dev/_seeds` (append) for new project ideas, or `pen/00_ideas/` for writing seeds.
- Link the note in the reply.
