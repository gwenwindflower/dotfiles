### Notes vault

Write to the girlOS Obsidian vault only when Winnie asks: to capture, remember, save, or note something, or to write up a deep dive, idea, or comparison for her to read later. Research, plans, and explanations otherwise stay in the reply or in project docs; do not file them in the vault unprompted. When the reply runs long and a note would help, offer one in a sentence and wait for a yes. Once asked, use `notesmd-cli` rather than scratch markdown inside the project, and link the note in the reply.

Always pass `--vault "$OBSIDIAN_DEFAULT_VAULT"`; the flag accepts the vault path, no default vault is registered, and other vaults are out of scope.

- Search first: `notesmd-cli search-content --no-interactive --format json --vault "$OBSIDIAN_DEFAULT_VAULT" "<term>"`, then `print` a candidate. Append to an existing note (`create -a "<path>" -c "<content>"`) when one already covers the topic.
- Landing zones: `org/_inbox/` for anything unsorted (the default), `dev/<project>/` when the project already has a folder there, `dev/_seeds` (append) for new project ideas, `pen/00_ideas/` for writing seeds.
- Create with `notesmd-cli create "org/_inbox/<Title>" -c "<content>" --vault "$OBSIDIAN_DEFAULT_VAULT"`. Use a Title Case name, Obsidian Flavored Markdown, wikilinks to related notes you found while searching, and one line naming the project and task that prompted the note.
- Never use `search`, `open`, or `daily` without `--content`: they open a fuzzy picker or the Obsidian app.
- Individual note, task, and reminder changes are routine when requested, from any project: edit content, change status or dates, move an item between established projects/lists, or delete the named item. Preserve surrounding content and verify identity before editing. Incidental capture still touches only its intended notes.
- Review batches as one change set before execution, including loops of individual commands, imports/exports, mass deletion, and broad reorganization. An explicit sync authorizes its resolved task changes and the `org/_inbox/Task Sync` record; ambiguous matches, unrelated edits, and bulk cleanup need a concrete decision. Do not assume a wrapper script will receive automatic review.
- Vault creation/removal, registration, and default-vault changes are manual-only. Do not run vault administration commands even during an authorized note-editing task.
- Never run `rematter` from a capture session.
- Do not make up new frontmatter fields or tags; only use existing patterns. No topic tags, no project fields, etc. These don't exist in the vault and are not to be invented.
- If using existing 'type tags' (#Book, #Dataset) or enum files (e.g. `status`), use existing values, or ask if a new value really needs to be added.
