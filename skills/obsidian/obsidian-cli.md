# Obsidian CLI

`obsidian` talks to the running Obsidian app, so it sees what the app sees: resolved links, the metadata cache, plugin state, and the rendered workspace. Use it for app-backed work: link graph and metadata inventories, base queries, the Tasks inventory, and plugin and theme development. Note content is read, searched, and written with `notesmd-cli` ([notesmd-cli.md](notesmd-cli.md)); the CLI's `read` and `search` are for when the app is already up for other work. Linux VMs have no app, so the CLI is macOS-only.

`obsidian help` lists the installed commands and `obsidian help <command>` shows one command's options. Plugins add commands (`templater:create-from-template`) only while they are enabled, so read the installed help rather than assuming a command from the [docs](https://help.obsidian.md/cli) exists.

## Preflight

The CLI acts on whichever vault the app has focused, and the first command launches the app if it is closed. Open it explicitly and confirm the vault before any other command:

```bash
open -a Obsidian
obsidian vault info=path
```

The printed path must equal `$OBSIDIAN_DEFAULT_VAULT`. If it differs, stop and ask Winnie to focus that vault. Don't pass `vault=` to redirect the CLI; a name-selected vault is not the verified path. Wait for indexing to finish on a cold start before trusting counts.

## Syntax

- Parameters take `key=value`; quote values with spaces: `name="My note"`.
- Flags are bare words: `total`, `counts`, `verbose`.
- In `content=` values, `\n` is a newline and `\t` a tab.
- `path=` is exact from the vault root (`dev/tackle/Tasks.md`). `file=` resolves like a wikilink and can hit a same-named note elsewhere, so prefer `path=`.
- A file-scoped command with neither targets the active file, which is whatever Winnie has open. Always pass a target.
- Many list commands take `format=json`; `total` returns a count instead of the list.

## Reading

| Command | Returns |
| --- | --- |
| `vault`, `files folder=<dir> ext=md`, `folders` | Vault info and file or folder listings |
| `file path=<p>`, `read path=<p>`, `outline path=<p> format=json`, `wordcount path=<p>` | One file's info, contents, headings, and counts |
| `links path=<p>`, `backlinks path=<p> counts format=json` | Outgoing links and backlinks |
| `unresolved counts verbose format=json` | Links to notes that don't exist, with their source files |
| `orphans`, `deadends` | Notes with no incoming links, and notes with no outgoing links |
| `properties counts sort=count format=json`, `property:read name=<n> path=<p>` | Property names in use with counts, and one note's value |
| `tags counts sort=count format=json`, `tag name=<t> verbose`, `aliases verbose` | Tags in use with counts, one tag's files, and aliases |
| `search query=<q> path=<dir> format=json`, `search:context query=<q> format=json` | App search results, with matching lines for `search:context` |
| `bases`, `base:views path=<p>`, `base:query path=<p> view=<v> format=json` | Base files, their views, and a view's rows |
| `templates`, `template:read name=<n>` | Templates and their content |
| `tasks ... format=json` | Checkbox lines; the `tasks` skill's sync recipes own inventory and status |
| `plugins:enabled versions`, `themes`, `snippets:enabled`, `version` | App, plugin, and theme state |

`properties` and `tags` are the quickest way to see which fields, tags, and values already exist before writing frontmatter ([markdown.md](markdown.md)).

## Writing

The CLI can create, append, prepend, set and remove properties, move, rename, and delete. Note content and frontmatter still go through `notesmd-cli` and `rematter`. Use a CLI write only when a skill workflow names it (such as `obsidian task` in the `tasks` sync recipes) or Winnie asks for it.

- `move path=<p> to=<dir>` and `rename path=<p> name=<n>` go through the app. Prefer them over `mv` for a linked note, then check `unresolved`.
- Treat `eval` and `dev:cdp` as writes: they run with full access to the app and vault.
- Only on Winnie's explicit request: `delete` (especially `permanent`), `history:restore`, `command id=`, `plugin:install`, `plugin:uninstall`, `plugin:enable`, `plugin:disable`, `plugins:restrict`, `theme:install`, `theme:set`, `theme:uninstall`, `snippet:enable`, `snippet:disable`, `workspace:load`, `workspace:delete`, `reload`, and `restart`.
- Commands with `open`, `newtab`, or a `*:open` form change what Winnie sees; leave the workspace alone unless asked.

## Plugin and theme development

Confirm with `vault info=path` that the focused vault is the one named for the work. Then loop:

```bash
obsidian plugin:reload id=my-plugin
obsidian dev:errors
obsidian dev:console level=error limit=20
obsidian dev:dom selector=".workspace-leaf" text
obsidian dev:css selector=".workspace-leaf" prop=background-color
obsidian dev:screenshot path="$TMPDIR/obsidian.png"
```

1. Reload the plugin after each code change.
2. Read `dev:errors`; fix and reload until it is empty.
3. Check the result in the DOM, computed CSS, or a screenshot.
4. Read `dev:console` for warnings and unexpected logs.

Where a relative `dev:screenshot path=` lands is unverified, so pass an absolute path outside the vault. `dev:errors clear` and `dev:console clear` reset the buffers between runs. `dev:mobile on` and `off` toggle mobile emulation, `dev:debug on` attaches the CDP debugger for `dev:cdp method=<CDP.method> params=<json>`, and `eval code="app.vault.getFiles().length"` runs JavaScript in the app.
