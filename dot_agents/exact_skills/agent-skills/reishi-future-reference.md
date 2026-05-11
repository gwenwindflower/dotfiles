# Reishi Future Reference (DO NOT USE TODAY)

> [!CAUTION]
> **This doc is intentionally unlinked from SKILL.md.** It captures `rei` surface area that is **not** currently safe to use because skills and rules are managed by chezmoi. Reishi (`rei`) is experimental and in active development; the commands below will conflict with chezmoi-managed state and must not be run.
>
> Permitted commands today live in [reishi-skill-management-cli](reishi-skill-management-cli.md): `rei skills new`, `rei skills add`, `rei skills validate`. Nothing else.
>
> Preserve this file as-is so it can be re-linked easily once reishi is ready to take over deployment from chezmoi.

## Sync (do not run)

```bash
rei sync                              # all constructs (skills, rules, docs) → all targets
rei skills sync [name] [--dry-run]    # skills only
rei skills sync --check               # inspect without writing
```

Historically auto-ran after `new`, `add`, `activate`, `deactivate`, and `pull`. With chezmoi owning deployment today, syncing will overwrite or fight chezmoi's reconciliation of `~/.agents/skills/` and `~/.claude/skills/`. Use `chezmoi apply` instead.

## Pull updates (do not run)

```bash
rei skills pull [name] [--check]
```

Hits GitHub for tracked skills. Locally modified files are preserved; remote versions land alongside as `<filename>_1.md` so you can diff and merge intentionally.

## List & toggle (do not run)

```bash
rei skills list                       # active
rei skills list --all                 # include deactivated
rei skills deactivate <name>          # hide without deleting
rei skills activate <name>            # restore
```

## Rules and docs subcommands (do not run)

`rei rules …` and `rei docs …` are off-limits while chezmoi manages those trees (`dot_agents/exact_rules/` and the docs distributed alongside agent configs). Edit the chezmoi source directly and run `chezmoi apply`.

## Source-of-truth notes (for the future)

When reishi does graduate, its source of truth would live at `~/.config/reishi/skills/` (override via `rei config show`), with `rei sync` propagating to every configured target via copy or symlink. Adding a new agent target would include a step to update `rei` config so `rei sync` distributes correctly to it. None of this is in effect today.
