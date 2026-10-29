# Skill frontmatter

YAML at the top of SKILL.md. The schema is mostly shared across agents, with a few agent-specific fields.

## Universal

| Field | Required | Notes |
| --- | --- | --- |
| `name` | yes | kebab-case, matches the skill directory |
| `description` | yes | menu entry naming the domain and contents, under 200 chars — see [effective descriptions](skill-descriptions.md) |

Keep descriptions as plain ASCII scalars with no colons or YAML-reserved characters; separate with ` - `, semicolons, or periods.

Never set `allowed-tools`. Tool permissions live in each harness's config, managed through the `agent-config` skill, and harnesses honor the field inconsistently.

## Claude Code

| Field | Notes |
| --- | --- |
| `argument-hint` | Hint shown for slash-command invocation (e.g. `"[on\|off]"`). |
| `disable-model-invocation` | `true` → skill only runs via explicit slash command, never auto-triggered. Use for destructive or repo-rewriting skills. |

## OpenCode

OpenCode honors `name` and `description`.

## Adding a new agent target

When extending support to a new agent:

1. Identify which fields the agent reads (check its skill spec)
2. Add a section above with the field list and any quirks
3. Keep the universal fields stable — agent-specific extensions go below
4. Point the agent's skill directory at `~/.agents/skills` (a `symlink_*` entry in chezmoi) or install with `gh skill install --agent <agent>`.

## Example

```yaml
---
name: context-engineering
description: Agent context - AGENTS.md, CLAUDE.md, rules, memory, skills, subagents. Session capture, codebase and package mapping, zg and ast-grep code search, agentsview history.
---
```
