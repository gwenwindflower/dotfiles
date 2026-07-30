---
name: effective-linear-issues
description: Use Linear effectively, not dogmatically. Unless project-local guidance overrides this global skill, use this for any work creating, managing, linking, or shipping work on Linear projects and issues.
---

# Managing Linear Issues Effectively

Using Linear well means responding to *context*. It's easy to follow a template, but for agents this ends up generating a lot of bloat and noise. Instead, tailor your response to the larger company, project, and issue context. A clear bug may want a well-templated, detailed bug report, while a small feature request being assigned directly to a teammate may only need a short description with a screenshot. This skill helps you calibrate this.

## Always

- Read existing issues, docs, comments, labels, statuses, and projects before changing anything. Use the Linear MCP to search thoroughly for context before creating new issues.
- Prefer enriching or linking existing issues over creating duplicates.
- If creating multiple issues, keep issues independently actionable; use a Project or a linked doc for shared context, rationale, and workflow vision.
- Preserve team conventions for titles, labels, statuses, priority, project, cycle, and ownership. These can vary within a company, project, or issue type. If conventions are unclear, look for similar issues to base your decisions on.
- Make relationships explicit with issue links and Related relations (actual property not just body links) when a set should be read together.
- Use Linear write tools only after the intended structure is coherent and draft(s) are approved.

## Creation Defaults

- **Labels**: don't apply labels unless the user asks for them.
- **Status**: confirm the status for new issues — Backlog, Triage, or Todo are the usual candidates; don't assume the default.
- **Assignment**: confirm whether the user wants new issues self-assigned; often a whole created batch should be assigned to them.
- **Milestones**: never number or prefix them — ordering is implicit. Be judicious: most projects don't need milestones at all; they earn their place in beefier multi-part projects, and only when each groups roughly five or more issues. A milestone wrapping 1–3 issues adds overhead, not clarity. And milestones mark checkpoints in the project's own arc — never repurpose them as status or sequencing metadata ("Backlog", "Next steps", "Fast follow"); statuses, priorities, and relations already carry that.
- **Titles**: a direct, scannable statement of the outcome. Never numbering or phase prefixes (ordering lives in Linear's structures, not in text), and never implementation details — "Execute restructure based on move map", not "Phase 1: skeleton migration (one mechanical PR)". The how belongs in the description.
- **Blocking relations**: only when truly load-bearing — one issue's output is another's input, or out-of-order execution breaks something (e.g. auditing a migration after it runs). A likely execution order is not coupling; chaining blocks through a sequence adds metadata ceremony and makes replanning harder. Note launch/timing intent in the description instead.

## Structure

Don't over-adhere to a rigid structure. Don't add duplicative or padded information for ceremony's sake if it adds no new information.

DRY prose is as crucial as code. DO NOT restate the same ideas or conditions in multiple parts of an issue or across related issues.

### General Types Guidance

Some general flexible principles:

- Bugs usually require more technical detail: version, environment, steps to reproduce, expected vs actual behavior, and logs or screenshots. Focus on those over trying to guess the issue, point out likely files, or offer solutions unless you've actually tested your solution.
- Feature requests should focus on desired state, rationale, and business impact. A clear vision of what the new feature enables, how you see it working, and why it matters is more useful than a pseudo implementation plan. Wireframes, mockups, and screenshots are far more useful than long text descriptions.
  - Properly frame feature ideas as speculative, not requirements. The tone should be suggestive not demanding (could, should, would NOT need, must).

## Linear Method Essentials

Distilled from Linear's own Method (linear.app/method); background that should shape how work gets filed:

- Write issues, not user stories: state a concrete, deliverable outcome (code, design, doc, decision) — story templates are ceremony ("a cargo cult ritual").
- Filing on someone else's behalf (bug reports, requests): frame the problem as an ask and let the assignee own the solution.
- Titles direct and scannable; descriptions minimal but contextual; quote user feedback verbatim rather than summarizing it.
- Product/UX debate belongs at the project or roadmap level, never embedded in issue descriptions.
- Ship incrementally — stage any project that can't shrink rather than building the whole thing before releasing.
- Start by creating issues; add projects/initiatives only as work scales — don't over-plan structure up front.
- When prioritizing, separate blockers (friction stopping product use) from enablers (nice-to-haves); blockers first.
- Plain terminology: "don't invent terms if possible — projects should be called projects."
- "Say no to busy work": process shouldn't need its own upkeep; remove or automate work-around-work.
- The structural model: issues are the unit of work · projects group issues toward one coordinated outcome · milestones subdivide a single project · cycles are the team's time-boxed cadence · initiatives group projects strategically. Use each as intended rather than improvising sequencing in text.

## Review Checks

Always do a pass to check for and fix the following when preparing to finalize:

- If working in an open source SaaS project, with both paying customers and public repos, always do a pass to make sure customer information is *only* in Linear and not synced to public repos or docs. Do not link private Slack threads or share screenshots to public systems like GitHub.

## References

- [Multi-Issue Proposals](multi-issue-proposals.md) — anchor a small connected issue set with a one-pager when it is bigger than one issue but not yet a project.
