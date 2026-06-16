# Managing Skills with `rei`

> [!CAUTION]
> Reishi (`rei`) is **experimental and in active development**. Skills and rules are currently managed by **chezmoi** (skill source at `~/.local/share/chezmoi/dot_agents/exact_skills/`; rule source at `.chezmoitemplates/agents/rules/`). Only three `rei` subcommands are permitted right now:
>
> - `rei skills new`
> - `rei skills add`
> - `rei skills validate`
>
> **Never run `rei sync`.** Do not use `rei rules` or `rei docs`. The full CLI surface (sync, pull, list, activate/deactivate, rules, docs) is preserved in [reishi-future-reference](reishi-future-reference.md) for when reishi graduates — it is intentionally unlinked from SKILL.md and must not be acted on today.

## Create

```bash
rei skills new -p ~/.local/share/chezmoi/dot_agents/exact_skills <name>   # scaffold directly into chezmoi source
rei skills new <name> --path path/to/proj                                 # scaffold in a project
```

Always pass `-p ~/.local/share/chezmoi/dot_agents/exact_skills` for user-level skills so the skill lands in chezmoi source from the start — no post-hoc move required. Generates SKILL.md, `scripts/`, and `assets/`. Trim what you don't need.

## Add external skills

```bash
rei skills add <github-tree-url>             # one-shot import
rei skills add -tp <github-tree-url>         # track for future pulls, prefix by org
```

`-t/--track` records the source in the lockfile. `-p/--prefix` namespaces to avoid collisions and signal provenance — infer from the GitHub org or pass an explicit value.

```bash
rei skills add -t https://github.com/readwiseio/readwise-skills/tree/master/skills -p readwise
```

If adding a user-level skill, pass `-p ~/.local/share/chezmoi/dot_agents/exact_skills` so the import lands in chezmoi source directly — no post-hoc move. **Do not** run `rei sync` afterwards.

## Validate

```bash
rei skills validate <skill-path>
```

Run before committing. Users can opt out for quick iteration.

## Deploying changes

Agents can only dry-run: `chezmoi apply -n` to preview. The user runs the real `chezmoi apply` to propagate skill edits from the source tree to `~/.agents/skills/` and `~/.claude/skills/`. **Never** `rei sync`.
