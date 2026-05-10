---
name: agent-skills
description: Author and audit Agent Skills. Use when creating a new skill, refactoring an existing one, or rewriting skill metadata (name, description, allowed-tools).
allowed-tools:
  - Bash(rei *)
  - WebFetch(domain:docs.agentskills.io)
  - WebFetch(domain:code.claude.com)
---

> [!IMPORTANT]
> **Always edit skills in chezmoi source, never in the deployed target.** Skills load from `~/.agents/skills/` (and `~/.claude/skills/` via symlink), but the source of truth is `~/.local/share/chezmoi/dot_agents/exact_skills/<skill>/`. Edits to the target dirs get overwritten on the next `chezmoi apply` and require manual sync back. Same applies to any skill file referenced from a target path — translate it to its `dot_agents/exact_skills/` source before editing.

Skills are modular packages that extend agents with specialized workflows, domain knowledge, and bundled resources.

**Be ruthless about terseness.** Every line in SKILL.md is loaded on every trigger. If a sentence doesn't change agent behavior, cut it. Push depth into colocated reference docs.

Fetch the [latest spec](https://code.claude.com/docs/en/skills) before substantive work.

## Loading model

1. **Startup** — name + description only. This is what determines triggering.
2. **Triggered** — full SKILL.md loaded into the conversation.
3. **On demand** — reference docs, scripts, and assets pulled when SKILL.md links to them.

Keep SKILL.md tight; everything else lives in modular files alongside it, linked as `[label](file.md)` (no extension in label).

## Jobs to be done

- [Write effective descriptions](effective-descriptions.md) — frontmatter triggers that fire reliably without bloat
- [Scaffold a new skill](scaffold-new-skill.md) — `rei skills new`, structure, template-asset gotchas
- [Configure metadata](adding-metadata.md) — frontmatter fields, Claude vs OpenCode differences, extending to new agents
- [Manage with reishi (`rei`)](reishi-skill-management-cli.md) — full CLI: add, sync, pull, validate, activate

## Validate and ship

```bash
rei skills validate <skill-path>
rei sync                              # propagate to all configured agent targets
```

Validate is the last step on any new or edited skill; the user can opt out for quick iteration.

## Spec

Full schema: <https://agentskills.io/specification>
