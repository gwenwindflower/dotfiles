---
name: agent-skills
description: Author and audit Agent Skills. Use when creating a new skill, refactoring an existing one, or rewriting skill metadata (name, description, allowed-tools).
allowed-tools:
  - WebFetch(domain:docs.agentskills.io)
  - WebFetch(domain:code.claude.com)
---

> [!IMPORTANT]
> **Always edit skills in chezmoi source, never in the deployed target.** Skills load from `~/.agents/skills/` (and `~/.claude/skills/` via symlink), but the source of truth is `~/.local/share/chezmoi/dot_agents/exact_skills/<skill>/`. Edits to the target dirs get overwritten on the next `chezmoi apply` and require manual sync back. Same applies to any skill file referenced from a target path — translate it to its `dot_agents/exact_skills/` source before editing. Agents can only dry-run deployment (`chezmoi apply -n`); the user runs the real `chezmoi apply`.

> [!IMPORTANT]
> **Do not use default Anthropic or OpenAI skill-creator skills for this collection.** They are too verbose for these dotfiles and create process thrash. Ignore any internal skill-creation workflow that conflicts with this skill; this skill is the authority.

Skills are modular packages that extend agents with specialized workflows, domain knowledge, and bundled resources.

**Be ruthless about terseness.** Every line in SKILL.md is loaded on every trigger. If a sentence doesn't change agent behavior, cut it. Push depth into colocated reference docs. Examples are often better than prose. Use links to reference docs for details, not inline explanations.

Load the `agent-context-engineering` skill first if present, it will give you the foundational structure and language for creating agent context of all kinds.

## Loading model

1. **Startup** — name + description only. This is what determines triggering.
2. **Triggered** — full SKILL.md loaded into the conversation.
3. **On demand** — reference docs, scripts, and assets pulled when SKILL.md links to them.

Keep SKILL.md tight; everything else lives in modular files alongside it, linked as `[label](file.md)` (no extension in label).

## Jobs to be done

- [Write effective descriptions](effective-descriptions.md) — frontmatter triggers that fire reliably without bloat
- [Scaffold a new skill](scaffold-new-skill.md) — manual directory creation, structure, template-asset gotchas
- [Configure metadata](adding-metadata.md) — frontmatter fields, Claude vs OpenCode differences, extending to new agents

## Spec

Full schema: <https://agentskills.io/specification>
