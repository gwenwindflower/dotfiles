# Neovim Config Agent Guidance

LazyVim-based config; extras are managed in `symsources/nvim/lazyvim.json`, not ad-hoc plugin specs. This file and `docs/` are chezmoi-ignored — repo-only, never deployed. Check LazyVim defaults and enabled extras before adding config; much is already provided.

## Plugin spec organization

Thematic multi-plugin files under `lua/plugins/` — no single-plugin files. Add a spec to the file matching its domain:

- `lang_<domain>.lua` — language tooling (LSP, lint, format, ft plugins); `lang_markdown.lua` also holds all "which markdown LSP runs where" scoping
- `ux.lua` — interface: pickers, explorers, completion (blink), navigation
- `utils.lua` — utility plugins (alignment, snippets, pairs, obsidian.nvim)
- `ai.lua`, `colors.lua`, `dash.lua`, `statusline.lua` — as named

`lua/config/vault.lua` is the shared module for the girlOS Obsidian vault path; all vault-scoped behavior routes through it.

## Keymap conventions

- `<LocalLeader>` namespaces, registered as which-key groups: `m` markdown (`ml` links, `mT` tables), `o` obsidian (vault buffers only), `n` mini.align, `s` snippets.
- `<M-…>` chords for buffer-local editing mechanics; `<D-…>` (kitty cmd-key) variants remap through their `<M-…>` equivalents rather than duplicating logic.
- `<C-Space>` is the tmux prefix — never bind it; `<M-Space>` is the established alternate (blink menu, flash treesitter).
- `<C-h/j/k/l>` belong to herdr-splits navigation.

## Behavioral gates to preserve

- Blink's completion menu never auto-shows in markdown except in vault buffers (`vim.b.obsidian_buffer`) — gate in `ux.lua`.
- marksman has `workspace_required = true` and diagnostic filtering for the chezmoi repo; markdown-oxide attaches only inside the vault.

## Docs

- `docs/obsidian.md` — the girlOS vault system: obsidian.nvim + markdown-oxide + marksman territories, mkdnflow coexistence, keymaps, tuning knobs
