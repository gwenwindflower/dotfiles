# Skill Frontmatter

YAML at the top of SKILL.md. The schema is mostly shared across agents, with a few agent-specific fields.

## Universal

| Field | Required | Notes |
| --- | --- | --- |
| `name` | yes | kebab-case, matches the skill directory |
| `description` | yes | what + when, ≤1024 chars — see [effective descriptions](effective-descriptions.md) |

Don't quote string values unless they contain a colon or start with a YAML-reserved character.

## Claude Code

| Field | Notes |
| --- | --- |
| `allowed-tools` | List of tool patterns the skill may use without re-prompting (e.g. `Bash(rei *)`, `WebFetch(domain:example.com)`). Honored by Claude only. |
| `argument-hint` | Hint shown for slash-command invocation (e.g. `"[orient]"`). |
| `disable-model-invocation` | `true` → skill only runs via explicit slash command, never auto-triggered. Use for destructive or repo-rewriting skills. |
| `allowed-tools` block style | Either a YAML list or a single comma-separated string both work; list form is clearer. |

## OpenCode

OpenCode honors `name` and `description`. Tool gating is configured via the agent definition or plugin layer, not in skill frontmatter. `allowed-tools` is silently ignored — keep it anyway for Claude.

## Adding a new agent target

When extending support to a new agent:

1. Identify which fields the agent reads (check its skill spec)
2. Add a section above with the field list and any quirks
3. Keep the universal fields stable — agent-specific extensions go below
4. Update `rei` config so `rei sync` distributes correctly to the new target

## Example

```yaml
---
name: github-actions-workflows
description: Author, audit, and scaffold GitHub Actions workflows. Use when editing .github/workflows/*.yml or scaffolding CI for Supermodel Labs projects.
allowed-tools:
  - WebFetch(domain:docs.github.com)
  - Bash(gh workflow *)
---
```
