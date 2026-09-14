### Config

Machine configuration is declared in the chezmoi source tree at `~/.local/share/chezmoi` and deployed to `~` by `chezmoi apply`. The repo's `AGENTS.md` and the `chezmoi` skill carry the detail; the rules below hold whether or not either is loaded.

#### Dotfiles

- **Never run a real `chezmoi apply`.** That includes `chezmoi apply -R`, `chezmoi update`, and `chezmoi init --apply`. Always pass `-n` (`--dry-run`): `chezmoi apply -n --no-pager`. A real apply reconciles the whole home directory at once, including `exact_` directories, run scripts, and the shell config, so a half-finished workstream in the source tree can break the shell or other basics of the machine. Verify with the dry run and `chezmoi diff --no-pager`, then tell the user what to apply.
- **Always `--no-pager`** on `chezmoi diff`, `cat`, `managed`, and `data`; they hang a subshell otherwise.
- **Edit the source, not the deployed file.** Changes made under `~` are overwritten on the next apply. The one exception is a symlinked file that an external tool writes (`symsources/`), where the deployed path and the source are the same file.
- **Name source files by attribute.** `dot_` adds the leading dot, `private_` sets 0600/0700, `executable_` sets +x, `symlink_` makes a symlink whose content is the target path, `exact_` makes a directory delete anything not in source on apply, and `.tmpl` renders a Go template and strips the suffix. Never use `.tmpl` as a literal suffix for non-chezmoi templates.
- **Copy by default.** Symlink only files that external tools edit; a script only for a side effect no file can express. Every script is an action that can fail.
- **`exact_` deletes.** Adding the prefix to a directory that other tools also write into removes their files on apply. Check before adding it.
- Load the `chezmoi` skill before touching templates, scripts, `.chezmoiignore`, or anything beyond a plain source-file edit.
