# packy

Declaratively manage `.chezmoidata/packages.yaml` across four package managers:
`formula`, `cask`, `tap`, `uv`. Reads system state from `chezmoi data`; writes
manifest changes via `@std/yaml` round-trip. **Darwin-only** — all four
managers are macOS-flavored.

## Source

- `packy.ts` (tool)
- `packy_test.ts` (tests)

## Run

```fish
packy <subcommand>                    # via fish wrapper (preferred)
deno task packy <subcommand>          # via Deno
```

Subcommands and short aliases:

| Long | Short | Mutates manifest |
| --- | --- | --- |
| `add` | `a` | yes |
| `remove` | `rm` | yes |
| `list` | `ls` | no |
| `diff` | `d` | no |
| `check` | `c` | no |
| `upgrade` | `up` | no |
| `sync` | `s` | no |

Only `add` and `remove` ever mutate `packages.yaml`. Everything else is
read-only on the manifest.

## Test

```fish
deno task test:packy
```

## Profiles

Packages live under profile slots (`core`, `work`, etc.). `add` tracks under
the **current** profile; `add --profile X` moves an entry between profiles.
`sync` defaults to the `core` baseline with a warning when no profile is set.

## Subcommand semantics

- `add` — install if missing on the system, then track in the manifest under
  the current profile.
- `remove` — uninstall from the system and untrack from the manifest.
- `sync` — install any tracked packages missing from the system (no manifest
  writes). The recovery path after a fresh machine.
- `diff` — show drift between manifest and system state.
- `check` — same as `diff` but with a non-zero exit on drift (CI gate).
- `upgrade` — show available upgrades; runs the underlying manager's upgrade.
- `list` — print tracked packages by profile.

## What lives outside packy

**JS/TS globals** (node, aube, npm-backend CLIs) are managed via mise, not
packy. They live in `symsource_mise/config.toml` and are materialized by
`run_onchange_18-mise-install.sh.tmpl` on chezmoi apply. Don't add them to
`packages.yaml` — they won't install correctly and the manifest will drift.
