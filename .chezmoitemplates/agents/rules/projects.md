### Projects

SPOT applies when a repo has both `SPEC.md` and `TODO.md`.

| File | Job |
| --- | --- |
| `SPEC.md` | Project-level what and why; indexes domain specs |
| `specs/<dom>-<slug>.md` | Durable domain requirements with stable IDs |
| `TODO.md` | Active Phases, Objectives, and Tasks |
| `DONE.md` | Shipped work and rationale |
| `docs/` | How the system works now |

Load the `spot-project-management` skill before authoring specs, planning Phases, or when briefed to run a Phase.

#### Shape

| Level | Markdown | Meaning |
| --- | --- | --- |
| Phase | `## Phase N: Description` | One branch's worth of work; a context boundary |
| Objective | `### Description` | One reviewable unit; lands as one conventional commit |
| Task | `- [ ] description` | Sequential step |

Phases are independent unless a `**Dependencies**: <N>` line says otherwise; dependencies chain. Phase numbers are stable IDs, not ordering. `**Requirements**: <id>` lines tie a Phase to spec IDs. When TODO and specs disagree, specs win — flag the mismatch.

#### Execution

- A session runs a Phase on one branch in one worktree. Helpers (teammates, subagents) work in that same tree and never run `git add` or `git commit` — they report done; the owning session reviews, then commits or sends back.
- An Objective closes as one well-named conventional commit, its TODO checkoff folded in. Branch names and commit subjects describe the work (`feat/oauth`, `feat(auth): add GCP oauth`) — SPOT stays out of git surfaces.
- No bookkeeping-only commits. Amend the final TODO→DONE move into the Phase's last commit.
- Requirement changes are planning work: pause, edit the spec deliberately, resume. Don't bend requirements to match output mid-Phase.
- A Phase is complete when every Task is done, listed requirements are met, DONE.md is updated, and the branch is clean.
- Truly unrelated Phases can run as parallel sessions on worktrees (worktrunk + herdr); the parent session creates, briefs, and folds them. Load the skill before splitting.

#### Stops

- `#user` marks Tasks needing human credentials, judgment, installs, or deployments. Stop when blocked.
- Surface ambiguous wording, risky approaches, and requirement concerns before building.
- Names are cross-agent contracts; sharpen vague ones before building on them.
- TDD by default; SPOT-specific exceptions live in the skill.
