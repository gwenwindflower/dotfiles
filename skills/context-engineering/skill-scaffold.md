# Scaffolding a new skill

## Skills are containers

A skill is a broad domain container: SKILL.md is a short index, and each topic, workflow, or tool lives in its own module beside it. Add a module to an existing skill before adding a skill; a narrow job (mapping a codebase, auditing CI) is a module, not a skill. Fewer, deeper skills keep the startup list short. External skills in a domain we cover are distilled into that spine through [upstream-fold](upstream-fold.md), not installed top-level.

## Naming

Name the domain in as few words as stay unambiguous:

- **Topic noun** (`python`, `chezmoi`, `obsidian`, `context-engineering`) — the default. Use the bare language, runtime, or tool name when it is the domain.
- **`<name>-mode`** (`learning-mode`, `ultra-concise-mode`) — for a behavior the user toggles on and off for the rest of a session.

Don't fold in words the domain already implies (`context-engineering`, not `agent-context-engineering`) or adjectives that describe our taste (`python`, not `clean-python`).

Third-party skills keep their upstream names; they update externally.

## Workflow

1. Clarify with the user — jobs-to-be-done, examples, what existing context is missing
2. Create the skill directory manually in the right source tree:
   - User-level skills: `~/.local/share/chezmoi/skills/<skill-name>/`, a chezmoi-ignored tree that `gh skill` installs from; no chezmoi prefixes
   - Project skills: the project's own skill directory, if the user explicitly wants project-local scope
3. Add `SKILL.md` manually with frontmatter `name` and `description`, then a short Markdown title
4. Write SKILL.md tight; offload depth into modular `<topic>.md` files alongside it only when needed
5. Add `scripts/` or `assets/` only when they are directly used by the skill
6. [Write the description](skill-descriptions.md) before declaring done

## Structure

A real skill (`project-tooling`, trimmed) bundling assets, a script, flat modules, and a nested module group:

```text
project-tooling/
├── assets/
│   └── rust/
├── herdr-plugins/
│   ├── project-shape.md
│   └── workflow.md
├── scripts/
│   └── bootstrap.sh
├── bootstrap.md
├── mise.md
├── releasing.md
└── SKILL.md
```

For simple skills, delete `assets/` and `scripts/`.

## Modular doc links

Use `[label](file.md)` relative to SKILL.md. Don't include the extension in the label. Files live next to SKILL.md — no `references/` subdir for new skills (older skills may have one; preserve if present unless the user asks to flatten).

## Template-style assets

If a skill ships scaffolding files meant to be copied and customized, **never name them `*.tmpl`**. Skills often live inside chezmoi-managed trees, and chezmoi renders any `.tmpl` file as a Go template at apply time — it will mangle content and strip the suffix.

Use `.template` instead — it signals intent to humans and scripts without colliding. If you need real templating, pick Handlebars / Jinja / `${VAR}` and drive rendering from a script in the skill itself.
