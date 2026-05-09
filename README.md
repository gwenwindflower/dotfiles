# dotfiles

Cross-platform dotfiles managed with [chezmoi](https://chezmoi.io). Fish + Neovim + Kitty, Catppuccin Frappe throughout. macOS is the persistent workstation; Linux is the dev-focused CLI for ephemeral VMs and containers.

## Install — persistent machine

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply gwenwindflower
```

This clones the repo into `~/.local/share/chezmoi` and applies it. Subsequent updates: `chezmoi update`.

## Install — ephemeral one-shot (Sprites, exe.dev VMs, containers)

```sh
CHEZMOI_ONESHOT=1 sh -c "$(curl -fsLS get.chezmoi.io)" -- init --one-shot gwenwindflower
```

`--one-shot` applies the dotfiles, then purges chezmoi (binary, source dir, config, cache) — leaving only the materialized files in `$HOME`. The `CHEZMOI_ONESHOT=1` flag is **required** here: this repo uses symlinks pointing into the chezmoi source dir for files that external tools edit (`lazy-lock.json`, Claude `settings.json`, etc.), and those symlinks would dangle the moment purge fires. Setting the env var triggers an apply-phase script that replaces each such symlink with a copy of its target before purge runs.

Without the env var, `--one-shot` will succeed but leave broken symlinks in the home dir.

## Development

See [AGENTS.md](AGENTS.md) for repo structure, conventions, and the symsource/symlink pattern in detail.
