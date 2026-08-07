### Fish Variables

Never create fish universal variables (`set -U` / `set -Ux`). They persist in machine-local `fish_variables` state, invisible to the dotfiles repo, and silently shadow config values — impossible to reason about or track across machines. Always export with `set -gx` in the right config location (in the dotfiles repo, a `.chezmoitemplates/fish/` fragment). If an existing universal shadows a config value, erase it with `set -eU <name>` and set it properly.
