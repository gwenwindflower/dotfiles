---
name: develop-agent-skills
description: Guide for creating and improving highly effective Agent Skills. Use when user wants to create a new skill, or when auditing and improving existing skills
allowed-tools:
  - Bash(rei *)
---

Create and improve Agent Skills: modular packages extending agents with specialized workflows, domain knowledge, and bundled resources.

**Skills must be very terse and high signal.** Every line should earn its place — if a sentence doesn't change agent behavior, cut it. Skill content is loaded into context on every trigger; bloat directly costs tokens and dilutes the instructions that matter.

Reference docs: [overview.md](overview.md) is pulled from the official Agent Skills spec. Consult it when you need to look up schema details, frontmatter options, or structural rules — don't read it routinely. Other reference docs are similarly optional based on need.

## Workflow

1. Ask clarifying questions about skill goals, preferences, or examples
2. Plan contents (additional files? scripts? assets?)
3. Consult [overview.md](overview.md) if you need schema or structural details
4. Initialize with `rei init <skill-name>` (skip for existing skills)
5. Write SKILL.md, add scripts, modular docs, and assets as needed
6. Validate with `rei validate <skill-path>`

Follow in order. Skip steps only with clear reason. User can opt out of validation.

## `rei` CLI

Skill management tool, available on PATH (`~/.local/bin/rei`).

### Create

```bash
rei init my-skill                           # shared skill (~/.agents/skills/)
rei init my-skill --path path/to/project    # project-scoped skill
rei init --fork <GitHub repo url>           # fork external skill (must have SKILL.md in root)
```

Default (no `--path`): creates in `~/.local/share/chezmoi/dot_agents/skills/`, applied by chezmoi to `~/.agents/skills/` and agent-specific locations. Prefer shared skills for broadly applicable knowledge (git prefs, shell env, frontend patterns).

Generates a scaffold with SKILL.md template, `scripts/`, `references/`, and `assets/` dirs. Customize or remove as needed.

### Validate

```bash
rei validate <skill-path>
```

### Add External Skills

```bash
rei add <GitHub repo url>    # works for single skills or directories, skips duplicates
```

### Refresh Reference Docs

If overview.md and other reference docs are >1 month old, update before relying on them:

```bash
rei refresh-docs
```

### List and Manage

```bash
rei list                         # active skills
rei list --all                   # include deactivated
rei deactivate <skill-name>     # hide without deleting
rei activate <skill-name>       # restore
```

## Loading Model

1. **Startup**: Only name + description loaded — aim for <100 tokens each, this determines trigger quality
2. **Triggered**: Full SKILL.md loaded — this is why terseness matters. Every token here competes with the user's actual task context. Link to modular docs for depth rather than inlining it
3. **On demand**: References, assets, scripts loaded as needed — use many small modular files for progressive disclosure

## Full Schema

Frontmatter and content spec beyond basics: <https://agentskills.io/specification>
