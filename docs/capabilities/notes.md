# Obsidian notes

Agents read and maintain girlOS under the user's direction from any project. Note-level work and vault administration have different boundaries.

## Expected behavior

- Use `notesmd-cli` for notes and `obsidian` for app/plugin-backed tasks. Always target girlOS; pass `--vault "$OBSIDIAN_DEFAULT_VAULT"` to notesmd-cli and verify the running Obsidian vault's base path before app-backed work.
- Write captures only when requested. Search first and append to a relevant existing note; use the vault's landing zones rather than scratch project markdown.
- Individual requested edits, status/date changes, moves between established projects, and deletion of the named item are routine. They do not require the vault to be the session's working directory.
- Preserve identity and surrounding content. Re-read expected text before a targeted edit; a mismatch is a stop signal.
- Review batch scope before imports/exports, mass deletion, or broad reorganization. An explicit sync authorizes resolved changes within its named scope, not unrelated cleanup.

## Safety boundary

A loop of individual commands is still a batch. Incidental capture does not authorize bulk restructuring or `rematter`. File access does not grant arbitrary application authority.

## Levels

| Family | Level | Notes |
| --- | --- | --- |
| `notesmd-cli` reads, captures, and individual edits, moves, and deletions | `sandboxed` | Through the vault write grant. |
| Routine `obsidian` CLI reads and task changes | `sandboxed` | Through the granted `~/.obsidian-cli.sock`. |
| Vault batches (imports, exports, mass deletion, loops) | `sandboxed` | The review policy treats batches as requested-only, but sandboxed calls never reach a reviewer, so guidance holds the scope. |
| `obsidian eval`, `command`, `plugin` | `review-request-open` | The reviewer checks the actual code and scope. |
| Vault administration (`notesmd-cli add-vault`, `remove-vault`, `set-default-vault`) | `deny` | Manual-only, even during an authorized note-editing task. |

## Platform implementations

| Harness | Mechanism |
| --- | --- |
| Claude Code | Vault write grant and socket; `obsidian eval`/`command`/`plugin` excluded without an allow; vault-administration denies. |
| Codex | Vault write grant and absolute socket path in the `dev` profile; `OBSIDIAN_DEFAULT_VAULT` set through `shell_environment_policy.set`; `notes.rules` prompts on app-side code and forbids vault administration. |
| OpenCode | Ordered Bash rules plus `external_directory` access for girlOS. File tools and shell permissions are separate; the shell has no OS sandbox here. |

Shared behavior lives in `.chezmoitemplates/agents/rules/notes-vault.md`. The vault environment variable supplies the CLI path; sandbox grants contain the literal path because they do not expand arbitrary environment variables.

## Verification

- Requested note changes work from an unrelated project without requiring a vault-wide task.
- Vault administration is blocked independently of ordinary note operations.
- App identity is checked before reading or mutating tasks; see [Tasks and Reminders](tasks.md).
