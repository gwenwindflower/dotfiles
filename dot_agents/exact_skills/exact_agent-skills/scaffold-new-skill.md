# Scaffolding a New Skill

## Naming

Two valid shapes, chosen by scope:

- **Topic noun** (`chezmoi`, `fish-shell`, `effective-sql`) — for skills that span multiple actions or carry special topic knowledge.
- **Present-tense active verb phrase** (`capture-context`, `mine-session-knowledge`, `map-project`) — for skills scoped to one action, or whenever a verb makes the trigger clearer. The verb form must complete the sentence "As an agent I want to `<skill-name>`" — so `develop-subagents`, never `developing-subagents`.

Third-party skills keep their upstream names; they update externally.

## Workflow

1. Clarify with the user — jobs-to-be-done, examples, what existing context is missing
2. Create the skill directory manually in the right source tree:
   - User-level skills: `~/.local/share/chezmoi/dot_agents/exact_skills/exact_<skill-name>/` — the `exact_` prefix is required on the skill dir itself and on every subdirectory inside it (`assets/`, `scripts/`, etc. become `exact_assets/`, `exact_scripts/`), since chezmoi's `exact_` reconciliation doesn't recurse
   - Project skills: the project's own skill directory, if the user explicitly wants project-local scope
3. Add `SKILL.md` manually with frontmatter `name` and `description`, then a short Markdown title
4. Write SKILL.md tight; offload depth into modular `<topic>.md` files alongside it only when needed
5. Add `scripts/` or `assets/` only when they are directly used by the skill
6. [Write the description](effective-descriptions.md) before declaring done

## Structure

A real skill (`github-actions-workflows`) bundling templates, modular docs, and a script:

```text
exact_github-actions-workflows/
├── exact_assets/
│   ├── ci.yml.template
│   ├── release-build.yml.template
│   └── release.yml.template
├── exact_scripts/
│   └── install-workflow.sh
├── ci.md
├── release-build.md
├── release.md
└── SKILL.md
```

For simple skills, delete `assets/` and `scripts/`.

## Modular doc links

Use `[label](file.md)` relative to SKILL.md. Don't include the extension in the label. Files live next to SKILL.md — no `references/` subdir for new skills (older skills may have one; preserve if present unless the user asks to flatten).

## Template-style assets

If a skill ships scaffolding files meant to be copied and customized, **never name them `*.tmpl`**. Skills often live inside chezmoi-managed trees, and chezmoi renders any `.tmpl` file as a Go template at apply time — it will mangle content and strip the suffix.

Use `.template` instead — it signals intent to humans and scripts without colliding. If you need real templating, pick Handlebars / Jinja / `${VAR}` and drive rendering from a script in the skill itself.
