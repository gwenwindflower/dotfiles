# Compact Readiness Rubric

The readiness gate is an automation that reviews an issue's full evidence trail — description, comments, relations, linked PRs, code — then applies one readiness label and a short "AI readiness review" comment. This is its grading logic distilled for issue improvers: predict the grade an edit will earn, and aim the edit at the failing gate. Predicting `ai-ready` never licenses applying it; the gate awards that label.

## The five gates

1. **Problem** — the issue clearly describes what is wrong or what behavior is wanted.
2. **Repro / acceptance** — a bug has concrete reproduction info or enough technical evidence to reproduce it; a feature has acceptance criteria or a definition of done (the brief's stated done-when behaviors satisfy this).
3. **Expected vs actual** — stated or clearly established; for a feature, the completed behavior is defined.
4. **No blocking concerns** — no unresolved objections, dependencies, conflicting implementations, or open product/policy decisions. Missing implementation detail is not a blocker when an existing codebase pattern answers it; an undefined product or security policy always is.
5. **Scope** — the narrowest sufficient patch is bounded enough for one agent to implement and test as one focused PR.

The deciding test for `ai-ready`: *could an agent implement the narrowest sufficient patch, add regression tests, and open a focused PR for human review — without deciding what the product or security policy should be?*

## Scope is the fix, not the blast radius

The gate scores the narrowest sufficient patch, not every affected or recommended location — a report can list many affected files while the fix is one shared enforcement point. Localized means roughly: one enforcement point (or a few closely related), one subsystem, reuses an existing pattern, around three production files plus tests (evidence, not a limit), no schema migration, no new policy decision. Optional defense-in-depth recommendations don't force decomposition: the minimal fix grades first, hardening becomes follow-up issues.

## Security severity is not a readiness factor

Auth, permissions, credentials, secrets, and SQL safety are normal implementation domains. Clear required behavior plus a localized patch is `ai-ready` even for critical vulnerabilities; mandatory human security review before merge doesn't change that. `human-led-high-risk` is reserved for work that cannot be delivered as a reviewable PR: irreversible data migrations, coordinated multi-system rollouts where partial deploy is unsafe, direct live-production intervention.

## Grading order

1. Missing information or an unresolved decision → `needs-clarification` / `needs-decisions`; the gate names the single most important question to resolve.
2. All gates pass and the patch is localized → `ai-ready`.
3. Requirements clear but code inspection confirms multiple independently deliverable changes → `needs-decomposition`.
4. All else clear but undeliverable as a PR → `human-led-high-risk`, rare by design.

When the blocker is a discrete product call, use `needs-decisions` so the owner acts; `needs-clarification` is for issues anyone with context can fix.

## What an improving edit does

The gate re-grades on meaningful changes — description edits, new repro or acceptance criteria, human comments, new relations or linked PRs — and ignores its own label and comment churn.

- Verified repro or stated done-when behaviors clears gates 2–3.
- A recorded product call clears `needs-decisions`; delete the resolved entry from `## Open decisions`.
- Splitting into scoped issues with individual briefs clears `needs-decomposition`.
- A clean rewrite with all facts present clears `needs-clarification`.

A human-authored classification always wins over the gate's. Don't fight one — note the conflict for the human instead.
