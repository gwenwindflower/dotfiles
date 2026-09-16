# Obsidian notes

Agents read and maintain girlOS under the user's direction from any project. Note-level work and vault administration have different boundaries.

## Expected behavior

- Use `notesmd-cli` for notes and `obsidian` for app/plugin-backed tasks. Always target girlOS; pass `--vault "$OBSIDIAN_DEFAULT_VAULT"` to notesmd-cli and verify the running Obsidian vault's base path before app-backed work.
- Write captures only when requested. Search first and append to a relevant existing note; use the vault's landing zones rather than scratch project markdown.
- Individual requested edits, status/date changes, moves between established projects, and deletion of the named item are routine. They do not require the vault to be the session's working directory.
- Preserve identity and surrounding content. Re-read expected text before a targeted edit; a mismatch is a stop signal.
- Review batch scope before imports/exports, mass deletion, or broad reorganization. An explicit sync authorizes resolved changes within its named scope, not unrelated cleanup.

## Safety boundary

Vault creation/removal, registration, and default-vault changes are manual-only. `notesmd-cli add-vault`, `remove-vault`, and `set-default-vault` are prohibited even during an authorized note-editing task.

A loop of individual commands is still a batch. Review its complete change set rather than assuming the harness will detect or separately review the loop. Incidental capture does not authorize bulk restructuring or `rematter`.

App-side `obsidian eval` and generic command execution need review of the actual code and scope. File access does not grant arbitrary application authority.

## Platform implementations

| Harness | Mechanism |
| --- | --- |
| Claude Code | Vault sandbox write root, routine note-command permissions, classifier guidance for individual/batch scope, and vault-administration denies. |
| Codex | `sandbox_workspace_write.writable_roots` includes the exact vault path; `notes.rules` forbids canonical vault administration and reviews app-side code. Routine note changes stay sandboxed with no host allow. |
| OpenCode | Ordered Bash rules plus `external_directory` access for girlOS. File tools and shell permissions are separate; the shell has no OS sandbox here. |

Shared behavior lives in `.chezmoitemplates/agents/rules/notes-vault.md`. The vault environment variable supplies the CLI path; sandbox roots contain the literal path because they do not expand arbitrary environment variables.

## Verification

- Requested note changes work from an unrelated project without requiring a vault-wide task.
- Vault administration is blocked independently of ordinary note operations.
- Batch scripts preserve the same review boundary as native bulk commands.
- App identity is checked before reading or mutating tasks; see [Tasks and Reminders](tasks.md).
