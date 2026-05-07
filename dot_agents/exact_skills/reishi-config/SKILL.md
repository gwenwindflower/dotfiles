---
name: reishi-config
description: Configure reishi (`rei`), the cross-agent context manager that distributes markdown rules, skills, and project docs from one source to many agent targets. Use when running `rei` commands, editing `~/.config/reishi/config.toml`, linking agents or projects, importing or pulling tracked skills from GitHub, or migrating existing agent context into reishi. Skip when authoring skill/rule/doc content (use agent-skills, agent-context-engineering).
allowed-tools:
  - Bash(rei *)
---

# Reishi

## Overview

Reishi distributes three kinds of markdown context from one **source** (`~/.config/reishi/`) to many **targets** (configured agents and projects):

- **rules** — always-on; flat `.md` files under `rules.source`, ship to each agent's `rules` path.
- **skills** — conditional; dirs under `skills.source`, each with a `SKILL.md`, ship to each agent's `skills` path.
- **docs** — project-scoped; `docs.source/<project>/*.md` compile into a token-budgeted index that ships to each project's root.

## Vocabulary

- **fragment** — one md file
- **source** — the canonical copy under `~/.config/reishi/`
- **target** — where sync writes to (an agent's skills/rules dir, or a project root)
- **sync** — local write, source → targets
- **pull** — network fetch from a tracked skill's GitHub remote → source
- **remote** — the GitHub URL backing a tracked skill

## Config

`rei config init` creates `~/.config/reishi/config.toml` and source dirs (idempotent). `rei config show` prints the effective config; `rei config path` prints the file path. `REISHI_CONFIG` overrides the location; `REISHI_LOCKFILE` overrides the lockfile path.

Load-bearing semantics:

- **Sync method** — `copy` makes targets stable snapshots; `symlink` keeps them live against source. Override per call with `--method=copy|symlink`.
- **Compile** — set `compile = true` on an agent to receive a single concatenated artifact instead of a dir of files. The artifact lives in source first (git-trackable), then sync ships it.
- **Shared agent** — `include_shared_agent` toggles the built-in `~/.agents/` target. Add `[agents.shared]` only when you want to override the default skills/rules paths.
- **Project filter** — without `fragments`, every `.md` in `docs.source/<project>/` participates in compilation; with it, only the listed files do.

Full annotated `config.toml`: [config-reference](config-reference.md).

## Linking targets

```bash
rei config link agent <name> --skills <path> --rules <path>
rei config link project <name> --target <repo-root>
rei config unlink agent|project <name> [--remove-source]
```

Pass `--force` to overwrite an existing entry. `unlink project --remove-source` also deletes the `docs.source/<name>/` dir.

## Skills

```bash
rei skills new <name>                        # scaffold + auto-sync (skill authoring lives in agent-skills)
rei skills validate <skill-path>
rei skills list [--all]                      # --all includes _deactivated/
rei skills move <old> <new>
rei skills remove <name>
rei skills activate|deactivate <name>        # auto-syncs
rei skills sync [name] [--check|--dry-run] [--agents=...] [--method=...]
```

Active skills sit under `skills.source`; deactivated skills live in a sibling `_deactivated/`. Skill names: lowercase letters, digits, hyphens; max 64 chars.

Installing or pulling tracked skills from GitHub: [importing-skills](importing-skills.md).

## Rules and docs

Rules are flat (no subdirs) and ship to each agent's `rules` path; docs are project-scoped and compile into a per-project index. Both support `compile`, `sync`, and `--check`/`--dry-run`. See [rules-and-docs](rules-and-docs.md).

## Top-level sync

```bash
rei sync [--agents=...] [--projects=...] [--method=...] [--dry-run]
```

Compiles + syncs all three constructs. Local-only, idempotent.

## `--check` vs `--dry-run`

- `--check` — diagnostic, no writes. `skills sync --check` reports per skill × agent: `fresh | stale | diverged | missing | symlink`. `skills pull --check` does a SHA probe with no download.
- `--dry-run` — preview-only execution path; no writes, no auto-syncs.

## Migrating existing context into reishi

Moving from chezmoi-managed dotfiles or ad-hoc agent dirs into reishi as the source of truth: [migrating-from-chezmoi](migrating-from-chezmoi.md). Don't run `rei sync` mid-migration — it overwrites targets from source.

## Gotchas

- **Lockfile is real state.** `rei skills add -t` writes to `~/.config/reishi/reishi-lock.toml`. Deleting a tracked skill dir without `rei skills remove` leaves a stale entry that `pull` will resurrect.
- **`include_shared_agent` defaults.** The init template writes `true`; the underlying load default is `false`. Confirm with `rei config show` if unsure what's effective.
