# Managing Skills with `rei`

Reishi (`rei`) is the user's CLI for managing skills, rules, and other agent constructs across multiple agent targets. Source of truth lives at `~/.config/reishi/skills/` (override via `rei config show`); `rei sync` propagates to every configured target via copy or symlink.

## Create

```bash
rei skills new <name>                       # scaffold in skills.source
rei skills new <name> --path path/to/proj   # scaffold in a project
```

Generates SKILL.md, `scripts/`, and `assets/`. Trim what you don't need.

## Validate

```bash
rei skills validate <skill-path>
```

Run before sync. Users can opt out for quick iteration.

## Sync

```bash
rei sync                              # all constructs (skills, rules, docs) → all targets
rei skills sync [name] [--dry-run]    # skills only
rei skills sync --check               # inspect without writing
```

Auto-runs after `new`, `add`, `activate`, `deactivate`, and `pull`. Local-only, always safe.

## Add external skills

```bash
rei skills add <github-tree-url>             # one-shot import
rei skills add -tp <github-tree-url>         # track for future pulls, prefix by org
```

`-t/--track` records the source in the lockfile. `-p/--prefix` namespaces to avoid collisions and signal provenance — infer from the GitHub org or pass an explicit value.

```bash
rei skills add -t https://github.com/readwiseio/readwise-skills/tree/master/skills -p readwise
```

## Pull updates

```bash
rei skills pull [name] [--check]
```

Hits GitHub for tracked skills. Locally modified files are preserved; remote versions land alongside as `<filename>_1.md` so you can diff and merge intentionally.

## List & toggle

```bash
rei skills list                       # active
rei skills list --all                 # include deactivated
rei skills deactivate <name>          # hide without deleting
rei skills activate <name>            # restore
```
