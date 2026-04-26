---
name: agent-skills
description: Create and improve highly effective Agent Skills. Use when user wants to create a new skill, or when auditing and improving existing skills
allowed-tools:
  - Bash(rei *)
  - WebFetch(domain:docs.agentskills.io)
  - WebFetch(domain:code.claude.com)
---

Create and improve Agent Skills: modular packages extending agents with specialized workflows, domain knowledge, and bundled resources.

**Skills must be very terse and high signal.** Every line should earn its place — if a sentence doesn't change agent behavior, cut it. Skill content is loaded into context on every trigger; bloat directly costs tokens and dilutes the instructions that matter.

Fetch the [latest docs](https://code.claude.com/docs/en/skills) before continuing with the detailed content here.

## Workflow

1. Ask clarifying questions about skill goals, preferences, or examples
2. Plan contents (additional files? scripts? assets?)
3. Consult [overview](overview.md) if you need schema or structural details
4. Scaffold with `rei skills new <skill-name>` (skip for existing skills)
5. Write SKILL.md, add scripts, modular docs, and assets as needed
6. Validate with `rei skills validate <skill-path>`
7. Distribute to agent targets with `rei sync` (or `rei skills sync <name>`)

Follow in order. Skip steps only with clear reason. User can opt out of validation.

## `rei` CLI

Skills are managed globally with a tool called reishi, which the user created and maintains. Commands are accessed via `rei skills`. Reishi's config acts as the source of truth, then syncs to every configured agent target (Claude, OpenCode, the shared `~/.agents/` location, etc.) via copy or symlink.

Skills source defaults to `~/.config/reishi/skills/`. Run `rei config show` to see effective config and targets.

### Create

```bash
rei skills new my-skill                           # scaffold in skills.source
rei skills new my-skill --path path/to/project    # custom location
```

Generates a scaffold with a SKILL.md template plus `scripts/` and `assets/` dirs. Customize or remove as needed. Modular reference docs go directly in the skill root, linked from SKILL.md.

#### Structure Example

Here's a real skill called github-actions-workflows, which bundles reusable workflow templates, modular reference docs, and an installation script for scaffolding workflows into projects:

```text
 github-actions-workflows
├──  assets
│   ├──  ci.yml.template
│   ├──  release-build.yml.template
│   └──  release.yml.template
├──  scripts
│   └──  executable_install-workflow.sh
├──  ci.md
├──  release-build.md
├──  release.md
└──  SKILL.md
```

For simple skills, delete the `assets/` and `scripts/` dirs after scaffolding to reduce clutter.

#### Template-Style Assets

If a skill ships scaffolding files meant to be copied and customized (workflow stubs, config starters, etc.), **do not name them `*.tmpl`**. Skills often live inside chezmoi-managed trees, and chezmoi treats any `.tmpl` file as a Go template — it will render the file at apply time and strip the suffix, mangling content and changing the deployed filename. Use `.template` instead — it signals intent to humans and scripts without colliding with chezmoi.

If you need *real* templating for those assets (variable substitution, conditionals), pick a format that can't collide with Go templates: Handlebars, Jinja, envsubst-style `${VAR}` files, etc. Drive the rendering from a script in the skill itself, not from the host config tool.

### Validate

```bash
rei skills validate <skill-path>
```

### Add External Skills

```bash
rei skills add <github-tree-url>             # single skill or whole skills dir
rei skills add -tp <github-tree-url>         # track for future pulls, prefix with org
```

`-t/--track` records the remote in the lockfile so `rei skills pull` can fetch updates later. `-p/--prefix` namespaces skills (infer from GitHub org, or pass an explicit value).

#### Example

```bash
rei skills add -t https://github.com/readwiseio/readwise-skills/tree/master/skills -p readwise
```

This would add every skill in that directory, prefix them with `readwise_`, and track the source for future updates. The `readwise_` prefix is important to avoid name collisions and to signal provenance.

### Sync and Pull

```bash
rei sync                              # sync all constructs (skills/rules/docs) to targets
rei skills sync [name] [--dry-run]    # skills only; --check inspects without writing
rei skills pull [name] [--check]      # fetch updates for tracked skills (network)
```

`sync` is local-only and always safe. `pull` hits GitHub for tracked skills, with divergence protection — locally modified files stay put and remote versions land alongside as `<filename>_1.md`.

Auto-sync runs after `skills new`, `add`, `activate`, `deactivate`, and `pull`.

### List and Manage

```bash
rei skills list                       # active skills
rei skills list --all                 # include deactivated
rei skills deactivate <skill-name>    # hide without deleting
rei skills activate <skill-name>      # restore
```

## Loading Model

1. **Startup**: Only name + description loaded — aim for <100 tokens each, this determines trigger quality
2. **Triggered**: Full SKILL.md loaded — this is why terseness matters. Every token here competes with the user's actual task context — link to modular docs for depth rather than inlining it, using markdown links relative to the skill root
3. **On demand**: References, assets, scripts loaded as needed — use many small modular files for progressive disclosure

### Link format

Reference links should be formatted as `[example](example.md)` or `[descriptive name](useful-reference-doc.md)`, do not include the extension in the label portion of the markdown link. When creating skills, these should point to files colocated with the SKILL.md. We've moved away from using an explicit `references/` directory, though you may see this in some externally sourced skills. Follow the pattern if it's already there, unless the user explicitly requests for you to refactor to a flatter structure.

## Full Schema

Frontmatter and content spec beyond basics: <https://agentskills.io/specification>
