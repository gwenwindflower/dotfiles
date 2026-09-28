# notesmd-cli

`notesmd-cli` reads and writes vault files directly, with no running app, so it works on every machine. It is the default tool for searching, reading, creating, and appending notes. Where notes land and when to write at all come from the global notes vault rules.

Pass `--vault "$OBSIDIAN_DEFAULT_VAULT"` on every call; the flag accepts the vault path, and no default vault is registered. Note names are vault-relative paths without the `.md` extension (`org/_inbox/Task Sync`).

| Command | Does |
| --- | --- |
| `search-content --no-interactive --format json "<term>"` | Content search; `--page` and `--page-size` (max 100) paginate |
| `print "<note>"` | Prints a note; `--mentions` appends linked mentions |
| `list [path]` | Lists files and folders under a vault path |
| `create "<note>" -c "<content>"` | Creates a note |
| `create "<note>" -a -c "<content>"` | Appends to an existing note |
| `frontmatter "<note>" --print` | Prints the note's frontmatter |
| `frontmatter "<note>" --edit --key <k> --value <v>` | Sets one key; `--delete --key <k>` removes one |
| `move "<note>" "<new-path>"` | Moves or renames a note and rewrites links to it |
| `delete "<note>"` | Deletes a note |

- `search`, `open`, and `daily` open a fuzzy picker or the Obsidian app, and so does `search-content` without `--no-interactive`. Never run them from an agent.
- Search for an existing note before creating one. `create -o` overwrites the whole note; append or edit a key instead unless replacing the note is the request.
- `--open` and `--editor` open the result in an app; leave them off.
- Vault administration (`add-vault`, `remove-vault`, `set-default-vault`) is manual-only.
- Frontmatter keys and values follow the vault's existing patterns ([markdown](markdown.md#properties)); bulk frontmatter work belongs to [rematter](rematter.md).
- A captured note gets a Title Case name, wikilinks to the related notes the search turned up, and one line naming the project and task that prompted it. Capturing never calls for `rematter`.
- Edit, move, or delete only the note the request names, after confirming it is the right one, and preserve the content around an edit.
- Present a batch (a loop of commands, an import or export, mass deletion, a reorganization) as one change set and get a yes before running it.
