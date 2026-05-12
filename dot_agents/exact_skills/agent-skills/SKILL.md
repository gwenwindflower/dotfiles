---
name: agent-skills
description: Author and audit Agent Skills. Use when creating a new skill, refactoring an existing one, or rewriting skill metadata (name, description, allowed-tools).
allowed-tools:
  - Bash(rei *)
  - WebFetch(domain:docs.agentskills.io)
  - WebFetch(domain:code.claude.com)
---

> [!CAUTION]
> **`reishi` (`rei`) is experimental and in active development. Skills and rules are managed by chezmoi.** Only these `rei` subcommands are permitted:
>
> - `rei skills new`
> - `rei skills add`
> - `rei skills validate`
>
> **Never run `rei sync`.** Do not use the `rei rules` or `rei docs` subcommands — they will conflict with chezmoi-managed state. Anything beyond the three allowed commands is off-limits until further notice.

Consider `rei` as a convenient helper for a narrow range of skills tasks for the time being.

> [!IMPORTANT]
> **Always edit skills in chezmoi source, never in the deployed target.** Skills load from `~/.agents/skills/` (and `~/.claude/skills/` via symlink), but the source of truth is `~/.local/share/chezmoi/dot_agents/exact_skills/<skill>/`. Edits to the target dirs get overwritten on the next `chezmoi apply` and require manual sync back. Same applies to any skill file referenced from a target path — translate it to its `dot_agents/exact_skills/` source before editing. Agents can only dry-run deployment (`chezmoi apply -n`); the user runs the real `chezmoi apply`.

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
- [Manage with reishi (`rei`)](reishi-skill-management-cli.md) — permitted commands only: `skills new`, `skills add`, `skills validate`

## Validate and ship

```bash
rei skills validate <skill-path>
chezmoi apply -n                      # agent dry-run only; user runs the real apply
```

Validate is the last step on any new or edited skill; the user can opt out for quick iteration. Agents must not run `chezmoi apply` without `-n` — hand off to the user for the real apply. **Do not run `rei sync`** — chezmoi owns deployment.

## Spec

Full schema: <https://agentskills.io/specification>
