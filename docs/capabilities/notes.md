# Obsidian notes

Agents use `notesmd-cli` for direct access to the girlOS vault and the official `obsidian` CLI when the running app or a plugin is required. Capture is available from any project; explicitly requested note editing and task reconciliation operate on the named vault content. The app and Reminders access requirements are documented in [Tasks and Reminders](tasks.md).

## Expected behavior

- Search, list, and print vault notes from any session to check whether a topic already has a home.
- Create new notes and append to existing ones in the vault's landing zones (`org/_inbox/`, `dev/<project>/`, `dev/_seeds`, `pen/00_ideas/`) instead of leaving scratch markdown or gitignored notes directories inside projects.
- Read and edit frontmatter keys on notes the session is working with.
- Always address the vault through `--vault "$OBSIDIAN_DEFAULT_VAULT"`, the path fish exports; no default vault is registered, and any other registered vault is out of scope.
- Use non-interactive notesmd-cli forms for capture. App-backed work explicitly targets the running girlOS vault and verifies its base path; do not use a focused-vault default.
- Treat the vault as a capture target during unrelated work. An explicit request to edit notes or reconcile vault tasks establishes a scoped vault task; it does not authorize reorganizing the rest of the vault.

## Safety boundary

The vault syncs to git rarely, so a destructive change is often unrecoverable. Delete, move, overwrite, frontmatter-key deletion, vault registration changes, and shell edits or removals under the vault path require explicit task authority and are expected only when the vault is the active project. When it is not, a session touches only notes it created. `rematter` is never run from a capture session.

Targeted sync edits preserve surrounding content and verify expected originals before writing. App-side `eval` executes with Obsidian's authority, so permission to read vault files is not equivalent to permission for arbitrary JavaScript in the app. Review that code or expose a narrowly defined adapter. The shared notes rule and Claude's auto-mode guidance both carry the scoped task-editing contract; see [configuration work](tasks.md#configuration-work).

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | `sandbox.filesystem.allowWrite` on the vault path; `permissions.allow` for read and additive `notesmd-cli` commands; `permissions.ask` for destructive forms and `permissions.deny` for vault registration changes; `autoMode` allow and soft-deny guidance | Native sandbox write plus command-level ask and deny rules. `Edit` and `Write` on vault files have no path rule; the auto-mode classifier applies the soft-deny guidance, with the explicit task-sync allow as its scoped exception. |
| Codex | Active `sandbox_workspace_write.writable_roots` grants vault write access; the inactive `workspace-winnie` profile also contains the path | Native sandbox write; `approval_policy = "on-request"`, `approvals_reviewer = "auto_review"`, and shared guidance govern additional authority. The profile is not active while `sandbox_mode` selects legacy sandboxing. |
| OpenCode | `permission.bash` allow rules for read and additive commands, ask rules for destructive forms, ordered after allow rules; `permission.external_directory` allows the vault path for direct file tools | Command-level gating only; no shell filesystem sandbox. |

Shared guidance for all three lives in `.chezmoitemplates/agents/rules/notes-vault.md`. Sandbox roots spell out the vault path because neither sandbox expands environment variables; `$OBSIDIAN_DEFAULT_VAULT` is the source of truth and the roots follow it.

## Verification

- From an unrelated project, `notesmd-cli search-content --no-interactive --vault "$OBSIDIAN_DEFAULT_VAULT" <term>` and `notesmd-cli create "org/_inbox/<Title>" -c <content> --vault "$OBSIDIAN_DEFAULT_VAULT"` run inside the sandbox without a prompt.
- `notesmd-cli delete`, `move`, `create --overwrite`, and `frontmatter --delete` prompt on Claude Code and OpenCode, and are declined by guidance on Codex outside a vault-as-project session. Vault registration commands are denied outright on Claude Code.
- A capture session does not edit notes it did not create and does not run `rematter`.
