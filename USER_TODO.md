# User TODOs

Tracked issues to address manually. These are minor cross-platform gaps and pre-existing TODOs carried over from charmschool.

## Cross-Platform: `pbcopy` on Linux

`pbcopy` is macOS-only. These files use it and will silently fail on Linux. Replace with a cross-platform clipboard helper (e.g., `fish_clipboard_copy`, or a wrapper that dispatches to `pbcopy`/`xclip`/`wl-copy`).

- `dot_config/fish/user_conf/25-fzf.fish:31` — fzf ctrl-y binding
- `dot_config/fish/user_conf/25-fzf.fish:58` — fzf variables ctrl-y binding
- `dot_config/fish/functions/ops.fish:55,63` — 1Password credential copy

## Cross-Platform: `open .` on Linux

`open` is macOS-only. Replace with `xdg-open` on Linux or guard with OS check.

- `dot_config/fish/user_conf/23-bindings.fish:57-58` — alt-super-o binding

## Pre-Existing TODOs (from charmschool)

- `dot_config/fish/user_conf/22-abbrs.fish.tmpl:91` — Set up env files for crush, opencode, copilot, and codex
- `dot_config/fish/user_conf/23-bindings.fish:20` — Find a better binding for up/down command history search
- `dot_config/fish/config.fish:23` — Eliminate `git` fish plugin in favor of custom functions/abbreviations
- `dot_config/fish/functions/_wrap_op_interactive.fish:2` — Make a visual selection version
- `dot_config/fish/functions/_wrap_echo.fish:2` — Make a visual selection version
- `dot_config/fish/functions/xcl.fish:24` — Add bun cache location to cache cleaner
