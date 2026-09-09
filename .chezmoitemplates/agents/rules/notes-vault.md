### Notes vault

Write to the girlOS Obsidian vault only when Winnie asks: to capture, remember, save, or note something, or to write up a deep dive, idea, or comparison for her to read later. Research, plans, and explanations otherwise stay in the reply or in project docs; do not file them in the vault unprompted. When the reply runs long and a note would help, offer one in a sentence and wait for a yes. Once asked, use `notesmd-cli` rather than scratch markdown inside the project, and link the note in the reply.

Always pass `--vault "$OBSIDIAN_DEFAULT_VAULT"`; the flag accepts the vault path, no default vault is registered, and other vaults are out of scope.

- Search first: `notesmd-cli search-content --no-interactive --format json --vault "$OBSIDIAN_DEFAULT_VAULT" "<term>"`, then `print` a candidate. Append to an existing note (`create -a "<path>" -c "<content>"`) when one already covers the topic.
- Landing zones: `org/_inbox/` for anything unsorted (the default), `dev/<project>/` when the project already has a folder there, `dev/_seeds` (append) for new project ideas, `pen/00_ideas/` for writing seeds.
- Create with `notesmd-cli create "org/_inbox/<Title>" -c "<content>" --vault "$OBSIDIAN_DEFAULT_VAULT"`. Use a Title Case name, Obsidian Flavored Markdown, wikilinks to related notes you found while searching, and one line naming the project and task that prompted the note.
- Never use `search`, `open`, or `daily` without `--content`: they open a fuzzy picker or the Obsidian app.
- The vault syncs to git rarely, so destructive changes are often unrecoverable. `delete`, `move`, `create --overwrite`, `frontmatter --delete`, vault registration changes, and shell edits or removals under the vault path are only for sessions where the vault is the active project and the user asked for that change. From any other project, touch only notes this session created, and never reorganize or bulk-edit existing notes.
- An explicit task sync (`/sync-tasks`, or a direct request to reconcile vault tasks with Apple Reminders) scopes edits to the named existing task lines and the `org/_inbox/Task Sync` record: exact-content targeted replacements and appends only, never note moves, deletions, or whole-note rewrites.
- Never run `rematter` from a capture session.
