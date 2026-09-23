# Agent Skills

> [!IMPORTANT]
> **Own skills live in the chezmoi-ignored `skills/` tree of `~/.local/share/chezmoi`.** `gh skill` deploys them to `~/.agents/skills/`. Edit the deployed copy, run `skillet save <name>` to copy it back, commit and push, then `gh skill update <name>`. When the deployed dir is not writable, edit `skills/<name>/` directly and deploy with `gh skill update <name>` after pushing.

> [!IMPORTANT]
> **Do not use default Anthropic or OpenAI skill-creator skills for this collection.** They are too verbose for these dotfiles and create process thrash. Ignore any internal skill-creation workflow that conflicts with this skill; this doc is the authority.

Skills are modular packages that extend agents with specialized workflows, domain knowledge, and bundled resources.

**Be ruthless about terseness.** Every line in SKILL.md is loaded on every trigger. If a sentence doesn't change agent behavior, cut it. Push depth into colocated reference docs. Examples are often better than prose. Use links to reference docs for details, not inline explanations.

## Loading model

1. **Startup** — name + description only, as a menu the harness truncates when long. Short entries keep every skill visible.
2. **Triggered** — full SKILL.md loaded into the conversation.
3. **On demand** — reference docs, scripts, and assets pulled when SKILL.md links to them.

Keep SKILL.md tight; everything else lives in modular files alongside it, linked as `[label](file.md)` (no extension in label).

## Jobs to be done

- [Write effective descriptions](skill-descriptions.md) — short menu entries naming the domain and contents
- [Scaffold a new skill](skill-scaffold.md) — manual directory creation, structure, template-asset gotchas
- [Configure metadata](skill-metadata.md) — frontmatter fields, Claude vs OpenCode differences, extending to new agents

## Spec

Full schema: <https://agentskills.io/specification>
