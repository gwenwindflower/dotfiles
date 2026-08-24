# Obsidian Vault Editing (girlOS)

How Neovim edits the girlOS Obsidian vault: two editing plugins and three LSP servers, each with an exclusive territory so nothing double-serves completions, renames, or diagnostics.

## Vault

- Path: `$OBSIDIAN_DEFAULT_VAULT` (`~/Library/Mobile Documents/iCloud~md~obsidian/Documents/girlOS`), exported by fish.
- `lua/config/vault.lua` is the single source of the path plus `contains(path)` / `buf_in_vault(bufnr)` helpers. Anything that scopes behavior to the vault goes through it.
- markdown-oxide reads the vault's own `.obsidian/daily-notes.json` and `.obsidian/app.json`, so daily-note folder (`day/`), new-file location, and attachment folder can't drift between nvim and the Obsidian app. Vault-relevant app settings: dailies in `day/` templated from `_templates/periodic/Daily`, attachments in `_media`, new files in current dir, wikilink style.

## Division of labor

| Concern | Outside vault | Inside vault |
| --- | --- | --- |
| Lists, tables, indent, numbering | mkdnflow | mkdnflow |
| Link follow/create, nav | mkdnflow (`<M-CR>`, `<M-Tab>`) | obsidian.nvim smart_action / oxide `gd` |
| Completion (`[[`, `#`, `[^`) | none (blink menu manual-only) | markdown-oxide, auto-popup |
| References/backlinks, rename | marksman | markdown-oxide (`grr`, `grn`) |
| Checkboxes | none | obsidian.nvim, cycle `[ ] → [/] → [x]` |
| Note rename/move | mkdnflow `MkdnMoveSource` | obsidian.nvim rename → oxide (backlink-safe) |
| Rendering | render-markdown.nvim | render-markdown.nvim |
| Dailies, templates, quick-switch, tags UI, paste_img | — | obsidian.nvim commands |

## LSP topology

| Server | Scope | Mechanism |
| --- | --- | --- |
| marksman | markdown in workspaces with `.git`/`.marksman.toml` | `workspace_required = true` in `lang_markdown.lua`; the vault has neither marker, so marksman never attaches there. Side effects: single-file markdown outside any repo gets no marksman, and git-initing the vault would let marksman back in |
| markdown-oxide | vault only | `root_dir` gate in `lang_markdown.lua` via `config.vault`; also enables `didChangeWatchedFiles.dynamicRegistration` (oxide needs it for live re-index + create-unresolved-file action) and per-buffer codelens refresh (backlink counts) |
| obsidian-ls (obsidian.nvim in-process) | vault notes, unconditional | Cannot be disabled by config; an `LspAttach` autocmd in the obsidian.nvim spec (`plugins/utils.lua` `init`) clears its completion/rename/references/definition capabilities so oxide is the sole provider. It keeps code actions (templates, properties, extract — the fork is moving visual-mode commands there) |

`vim.lsp.buf.rename` (`grn`) and `:Obsidian rename` both resolve to oxide because obsidian-ls's renameProvider is cleared — one writer for vault-wide backlink updates.

## obsidian.nvim config (plugins/utils.lua)

| Option | Value | Constraint |
| --- | --- | --- |
| `ui.enable` | `false` | render-markdown.nvim owns rendering; both drawing conceals conflicts |
| `frontmatter.enabled` | `false` | rematter owns frontmatter schemas; obsidian must not inject/re-sort `id`/`aliases`/`tags` on save |
| `checkbox.order` | `{ " ", "/", "x" }` | matches the vault's in-progress `[/]` state |
| `note_id_func` | title as-is | vault uses human-readable filenames, not zettel timestamps |
| `legacy_commands` | `false` | single `:Obsidian` entrypoint; legacy names are removed in 4.0 |
| `picker.name` | `snacks.picker` | matches the snacks_picker extra |

Loaded on `ft = markdown` + `cmd = Obsidian` — cheap outside the vault since it only activates buffers under a configured workspace.

## Vault-buffer keymaps (`callbacks.enter_note`)

Buffer-local, applied on every note entry so they win over mkdnflow's filetype maps:

- `<M-CR>` n: smart_action (follow link / toggle checkbox / tag picker) — same chord as mkdnflow's contextual enter elsewhere; `<D-CR>` chains to it. Insert-mode `<M-CR>` stays mkdnflow list continuation. x: link selection to new note.
- `<C-,>` / `<C-.>`: jumplist `<C-o>`/`<C-i>` (mkdnflow's history doesn't track obsidian-followed links).
- `<LocalLeader>mlm`: shadowed to `:Obsidian rename` (MkdnMoveSource would break wikilinks).
- `<LocalLeader>o…`: which-key group for backlinks, tags, dailies, quick_switch, search, rename, new, templates, paste_img, toc, links, extract.
- Plugin defaults kept: `<CR>` smart_action, `]o`/`[o` link nav.

Blink completion auto-popup is suppressed for markdown except when `vim.b.obsidian_buffer` is set (obsidian.nvim sets it on vault buffers) — gate lives in `plugins/ux.lua`.

## markdown-oxide config surface

- Global: `~/.config/moxide/settings.toml` — not currently created; oxide defaults are in effect. Chezmoi-manage it (`private_dot_config/moxide/`) the first time a knob is needed.
- Vault-local: `.moxide.toml` in the vault root (outside chezmoi) sets `excluded_folders = ["_templates", "_media"]` so template scaffolds don't pollute completion and backlink counts.
- Install: mason, auto-installed by listing the server in `opts.servers`.

## Tuning knobs if problems appear

| Symptom | Knob |
| --- | --- |
| Unresolved-`[[link]]` diagnostics feel like noise | `unresolved_diagnostics = false` in settings.toml |
| Link text double-styled against render-markdown | `semantic_tokens = false` in settings.toml |
| Hover previews unwanted | `hover = false` in settings.toml |
| `:Obsidian yesterday` skips weekends | `daily_notes.workdays_only = false` in the obsidian.nvim opts |
| Per-note footer (backlinks/word count) unwanted | `footer = { enabled = false }` in the obsidian.nvim opts |
| iCloud sync churn causes re-index thrash | extend `excluded_folders`; report upstream rather than disabling the watcher |

## Verification

In a vault buffer: `:LspInfo` shows exactly `obsidian-ls` + `markdown_oxide` (no marksman); `:map <M-CR>` shows the smart_action shadow; typing `[[` auto-pops one set of completions. In a repo markdown file: marksman only, no completion auto-popup.
