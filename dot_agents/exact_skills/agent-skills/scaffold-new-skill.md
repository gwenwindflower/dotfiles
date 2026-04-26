# Scaffolding a New Skill

## Workflow

1. Clarify with the user — jobs-to-be-done, examples, what existing context is missing
2. Scaffold: `rei skills new <skill-name>` (or `--path` for a project location)
3. Write SKILL.md tight; offload depth into modular `<topic>.md` files alongside it
4. Drop `scripts/` and `assets/` if unused — flatter is better
5. [Write the description](effective-descriptions.md) before declaring done
6. Validate: `rei skills validate <skill-path>`
7. Sync: `rei sync`

## Structure

A real skill (`github-actions-workflows`) bundling templates, modular docs, and a script:

```text
github-actions-workflows/
├── assets/
│   ├── ci.yml.template
│   ├── release-build.yml.template
│   └── release.yml.template
├── scripts/
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
