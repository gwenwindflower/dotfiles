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

## Structure

Don't over-adhere to a rigid structure. Don't add duplicative or padded information for ceremony's sake if it adds no new information.

DRY prose is as crucial as code. DO NOT restate the same ideas or conditions in multiple parts of an issue or across related issues.

### General Types Guidance

Some general flexible principles:

- Bugs usually require more technical detail: version, environment, steps to reproduce, expected vs actual behavior, and logs or screenshots. Focus on those over trying to guess the issue, point out likely files, or offer solutions unless you've actually tested your solution.
- Feature requests should focus on desired state, rationale, and business impact. A clear vision of what the new feature enables, how you see it working, and why it matters is more useful than a pseudo implementation plan. Wireframes, mockups, and screenshots are far more useful than long text descriptions.
  - Properly frame feature ideas as speculative, not requirements. The tone should be suggestive not demanding (could, should, would NOT need, must).

## Review Checks

Always do a pass to check for and fix the following when preparing to finalize:

- If working in an open source SaaS project, with both paying customers and public repos, always do a pass to make sure customer information is *only* in Linear and not synced to public repos or docs. Do not link private Slack threads or share screenshots to public systems like GitHub.

## References

- [Multi-Issue Proposals](multi-issue-proposals.md) — anchor a small connected issue set with a one-pager when it is bigger than one issue but not yet a project.
