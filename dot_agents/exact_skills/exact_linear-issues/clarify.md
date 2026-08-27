# Clarify an Issue

Rewrite an existing product issue into the description format so a human groks it in 30 seconds and an implementing agent can open a PR without follow-up questions.

## Process

**Fetch everything** — description, comments, customer requests, attachments, linked PRs. Comments usually hold the real current state: scope drift, partial fixes that already landed, open decisions. When comments contradict the description, the description is describing the wrong issue.

**Decide how deep to go before touching the repo.** Read the issue, name what the rewrite is missing, and reach only that far. Most issues need no sandbox; a sandbox is the last rung, not the first step.

| State | Description | Missing | Go this far |
| --- | --- | --- | --- |
| **Exhaustive** | Facts present, buried in prose/screenshots/threads | Nothing; needs less | Shape clarity from issue's content. Confirm citations and assumptions, fix if incorrect. |
| **Ambiguous** | Scope, surface, or entry point unclear | Orientation | Grep and read files/issues/PRs for prior art. Verify citations. Add clarity and detail as needed. |
| **Missing impl. detail** | Can't name entry point or root-cause theory without observing behavior | Evidence only a live run can produce | Sandbox repro, then clarify. |

Before starting a sandbox, write down the questions you need it to answer. If these aren't clear, you don't need it. A ⚠️ Unreproduced marker is a valid state — don't run an instance just to upgrade it to ✅; reproduce only when the agent brief can't be written without it. If the issue is already clear from the customer report, screenshots, or confirmed details from the team, don't run a sandbox just to verify it — when that evidence matches a code read that explains it, mark it 📸 Corroborated. If you suspect the report is incorrect, a sandbox investigation is appropriate.

**Surface what's open** — an unresolved product decision (default vs opt-in, conflicting prior designs, ambiguous scope) means the issue is not agent-ready. Still write the summary, list the decision under `## Open decisions`, comment @-mentioning whoever owns the call if high confidence on who that is, and label with `needs-decisions`. Never resolve a product decision silently, and never remove readiness labels other than `needs-clarification`, which this pass resolves.

**Rewrite the description** in the two-part format. Displaced detail worth keeping — design explorations, rejected alternatives, screenshots — moves to a comment or a linked doc before the rewrite lands, so it stays findable without reading issue history.

**Tidy metadata** — sharpen the title into a scannable outcome; link historical issues used for research or cited for context when relevant. A customer thread from Slack goes in the Customer requests panel when you have access to it; otherwise add it as a top-level Linear comment. The final step is removing the `needs-clarification` label. That and applying `needs-decisions` are this pass's only readiness-label writes — never add `ai-ready`; the gate re-grades on the rewrite and awards it. Self-check against the [compact rubric](compact-rubric.md) to predict that re-grade. A clear miscategorization of product area or issue type is fair to fix, but don't add labels or priority just to fill fields.

## Guardrails

**Only the description syncs publicly.** On a GitHub-synced issue (sync banner comment present) the title and description mirror to the public GitHub issue. Regular Linear comments and the Customer requests panel never sync.

**Never post into the GitHub sync thread.** Replies threaded under the sync banner comment publish to GitHub (`parentId` in the API, the "Post to GitHub" box in the UI). Agent comments are top-level, always — reply into the sync thread only when the task is explicitly to answer the GitHub reporter publicly, which is rare.

**Linear documents need a project home.** Support-board issues have none, so overflow detail goes in comments or external links instead.
