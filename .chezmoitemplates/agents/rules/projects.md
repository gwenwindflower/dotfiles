### Projects

Serious projects use SPOT project management; smaller or early projects borrow parts of it without the full ceremony. Specs are the same everywhere. The plan lives in one of two places: markdown in the repo, or Linear.

| File | Job |
| --- | --- |
| `SPEC.md` | Project-level what and why; indexes domain specs |
| `specs/<dom>-<slug>.md` | Durable domain requirements with stable IDs |
| `docs/` | How the system works now |
| `TODO.md` | Repo plan: active Phases, Objectives, and Tasks |
| `DONE.md` | Repo plan: shipped work and rationale |

Detect the plan home before planning or picking up work: `TODO.md` at the root means the repo plan; a Linear team, project, or issue named in the brief or the project context means Linear, and `TODO.md`/`DONE.md` do not exist. Load the `spot-project-management` skill before authoring specs, planning work, or when briefed to run a Phase or parent issue. In Linear mode also load `managing-issues` before reading or writing any issue. Otherwise this context is enough to work within the system.

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

- A session runs a Phase or parent issue on one branch in one worktree. Helpers (teammates, subagents) work in that same tree and never run `git add` or `git commit` — they report done; the owning session reviews, then commits or sends back.
- An Objective closes as one well-named conventional commit. Branch names and commit subjects describe the work (`feat/oauth`, `feat(auth): add GCP oauth`) — the planning system stays out of them.
- No bookkeeping-only commits. Repo plan: fold the TODO checkoff into the Objective's commit and amend the final TODO→DONE move into the Phase's last commit. Linear: put the issue's magic word (`Closes ENG-123`) in the commit trailer or PR description so status moves on its own.
- Requirement changes are planning work: pause, edit the spec deliberately, resume. Don't bend requirements to match output mid-Phase.
- A Phase is complete when every Task is done, listed requirements are met, the ledger is updated (`DONE.md`, or a closing comment on the parent issue), and the branch is clean.
- Truly unrelated Phases or parent issues can run as parallel sessions on worktrees (worktrunk + herdr); the parent session creates, briefs, and folds them. Decide on parallelization in planning, weighing the speed gain against the cost of folding the changes in cleanly.

##### Example commits with plan details

Repo plan, an auth Phase called Phase 3 with two Objectives:

```text
feat(auth): add oauth flow for GCP

<optional body bullets>

Completes `Add GCP OAuth` in Phase 3

Co-Authored-By: <Agent Name> <agent email>
```

```text
fix(auth): patches pkce loophole

Completes `Fix PKCE vulnerability` in Phase 3
Closes Phase 3

Closes #456

Co-Authored-By: <Agent Name> <agent email>
```

Linear, the same work as sub-issues ENG-311 and ENG-312 under parent ENG-310:

```text
fix(auth): patches pkce loophole

Closes ENG-312
Closes ENG-310

Co-Authored-By: <Agent Name> <agent email>
```

Plan details go after any body bullets, before the trailers. Never a separate commit like `chore(spot): close Phase 3` — the close is folded into the last Objective's commit.

#### Stops

- `#user` marks Tasks needing human credentials, judgment, installs, or deployments. Stop when blocked.
- Surface ambiguous wording, risky approaches, and requirement concerns before building.
- Names are cross-agent contracts; sharpen vague ones before building on them.
- TDD by default; SPOT-specific exceptions live in the skill.
