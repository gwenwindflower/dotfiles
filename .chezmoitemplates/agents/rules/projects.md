### Projects

We use the SPOT project management for most serious projects. Often early or smaller projects will draw elements from SPOT, without the full ceremony required when doing full spec-driven, test-driven agentic development. Full SPOT applies when a repo has both `SPEC.md` and `TODO.md` (which generally also include a `DONE.md` if there are completed tasks and a `specs/` dir to handle domain-scoped specs, but a brand new project may not have these yet).

| File | Job |
| --- | --- |
| `SPEC.md` | Project-level what and why; indexes domain specs |
| `specs/<dom>-<slug>.md` | Durable domain requirements with stable IDs |
| `TODO.md` | Active Phases, Objectives, and Tasks |
| `DONE.md` | Shipped work and rationale |
| `docs/` | How the system works now |

Load the `spot-project-management` skill before authoring specs, planning Phases, or when briefed to run a Phase. Otherwise this context is enough to work within the system.

#### Shape

| Level | Markdown | Meaning |
| --- | --- | --- |
| Phase | `## Phase N: Description` | One branch's worth of work; a context boundary |
| Objective | `### Description` | One reviewable unit; lands as one conventional commit |
| Task | `- [ ] description` | Sequential step |

Phases are independent unless a `**Dependencies**: <N>` line says otherwise; dependencies chain (if Phase 7 depends on Phase 6, and 6 on 5, Phase 7 is also blocked by 5 even if directly linked). Phase numbers are stable IDs, not ordering. Phase content can be updated but new phases should always be appended. `**Requirements**: <id>` lines tie a Phase to spec IDs. When TODO and specs disagree, specs win — flag the mismatch.

#### Execution

- A session runs a Phase on one branch in one worktree. Helpers (teammates, subagents) work in that same tree and never run `git add` or `git commit` — they report done; the owning session reviews, then commits or sends back.
- An Objective closes as one well-named conventional commit, its TODO checkoff folded in. Branch names and commit subjects describe the work (`feat/oauth`, `feat(auth): add GCP oauth`) — SPOT stays out of git surfaces.
- No bookkeeping-only commits. Amend the final TODO→DONE move into the Phase's last commit.
  - Add SPOT bookkeeping details in commit body after the meaningful content.
- Requirement changes are planning work: pause, edit the spec deliberately, resume. Don't bend requirements to match output mid-Phase.
- A Phase is complete when every Task is done, listed requirements are met, DONE.md is updated, and the branch is clean.
- Truly unrelated Phases can run as parallel sessions on worktrees (worktrunk + herdr); the parent session creates, briefs, and folds them. Load the skill before splitting.
  - Decisions on parallelization should be made in planning, to weigh the speed gains against complexity of folding the changes in cleanly.

##### Example commits with SPOT details

Imagining an auth-focused phase called Phase 3, with two Objectives, the commits might look like:

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

SPOT details should always be placed after commit body bullets, right before the trailer content.

Importantly, **not** a separate commit like `chore(spot): close Phase 3` — the close is folded into the last Objective's commit. Bookkeeping commits are not meaningful when reviewing a good linear git history.

#### Stops

- `#user` marks Tasks needing human credentials, judgment, installs, or deployments. Stop when blocked.
- Surface ambiguous wording, risky approaches, and requirement concerns before building.
- Names are cross-agent contracts; sharpen vague ones before building on them.
- TDD by default; SPOT-specific exceptions live in the skill.
