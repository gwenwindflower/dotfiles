# Tasks and Reminders

Obsidian Tasks and Apple Reminders are first-class tools for Claude Code, Codex, and OpenCode on the macOS workstation. Agents should read, reconcile, organize, and schedule tasks under user direction while retaining each harness's sandbox and approval boundaries. Remote Linux environments can inspect an available vault but cannot access the Mac's EventKit store without an explicitly configured host integration.

## Expected behavior

- Use `notesmd-cli` for contextual notes and `obsidian` for plugin-backed operations in girlOS, explicitly targeted through `OBSIDIAN_DEFAULT_VAULT`. Inventory Tasks according to its settings and parser, including completed/custom statuses; a checkbox search is not an equivalent inventory.
- Use `rem` for Apple Reminders, preserving full IDs, notes, dates, alarms, recurrence, and list membership. macOS privacy authorization and a successful complete inventory are prerequisites for reconciliation.
- Apply the shared `sync-tasks` skill for matching, field-level conflicts, durable checkpoints, recovery, and verification. Its topical preferences define development/learning/writing as bidirectional and cleaning/errands as Reminders-only.
- Treat an explicit sync as authority for resolved, targeted synchronization within its scope. Keep ambiguous matches, destructive cleanup, and shared-list moves subject to concrete user decisions. Scheduling suggestions become writes when accepted or directly requested.
- Report incomplete coverage and unsupported native sections. Tool permission does not establish that every Apple property or Tasks feature is supported.

## Access layers

| Surface | Required access | What it does not grant |
| --- | --- | --- |
| Vault files via notesmd-cli | Read/write access to the exact girlOS path; inherited vault environment variable | Other vaults, broad note reorganization, or app IPC |
| Running Obsidian and Tasks | CLI enabled in Obsidian; running app; explicitly targeted vault; sandbox access to the `~/.obsidian-cli.sock` unix socket | Arbitrary app-side JavaScript solely because the shell command is allowed |
| Reminders via rem | macOS Reminders privacy authorization and harness-specific service access: sandboxed in Claude, command-scoped host execution in Codex | Direct editing of Apple's database, unrelated app access, or permission to delete tasks |
| Approval policy | Routine reads and task-authorized mutations, with review for ambiguous/destructive operations | Bypassing macOS privacy or Seatbelt restrictions |

`rem` initializes a native EventKit client and requests macOS privacy authorization. Expanding a filesystem writable-root list does not establish that this service communication is allowed. Native tags, flags, URLs, and sharing information also use ReminderKit and need separate verification. See the [rem architecture](https://rem.sidv.dev/docs/architecture/).

## Platform implementations

| Harness | Present configuration | Required work |
| --- | --- | --- |
| Claude Code | `sandbox.excludedCommands` runs `rem` on the host; routine subcommands are allowed and destructive operations, interactive forms, and list-changing updates have ask rules; `autoMode` guidance names the host execution as expected | Verified in a fresh session. `allowAppleEvents` is also enabled but does not reach EventKit, so the exclusion stays. |
| Codex | `dot_codex/rules/reminders.rules` deploys to `~/.codex/rules/reminders.rules`; allowed prefixes run outside the sandbox, destructive prefixes and all updates use `prompt` | Restart after deploying the rules. Keep legacy `workspace-write` and existing vault roots; no global sandbox change is needed. |
| OpenCode 1.x | `permission.bash` allows routine rem subcommands and asks for other rem commands, list-changing updates, and interactive forms | Shell execution is already on the host. No OS sandbox is supplied by these permission rules. Obsidian external-directory coverage remains separate work. |

Claude's rem workflow is a rem-only host execution exception through `sandbox.excludedCommands`. No Mach service allowance that lets rem run inside the sandbox has been identified. Codex retains its separate per-command host execution policy.

`allowAppleEvents` permits Apple Events and Launch Services app opening; it does not reach EventKit. With it enabled, `/opt/homebrew/bin/rem lists` (a spelling the `excludedCommands` match does not catch) fails inside the sandbox with Mach error 4099 while the excluded `rem` form succeeds. The [sandbox runtime reference](https://github.com/anthropic-experimental/sandbox-runtime#other-configuration) describes its broader app-execution authority; rem's principal path uses EventKit and default-list discovery uses AppleScript. The setting is not part of this policy and can be dropped without affecting rem.

`sandbox.enableWeakerNetworkIsolation = true` already permits `com.apple.trustd.agent`, used by Go's macOS TLS certificate verification. It is not a general EventKit or Reminders permission. The [sandbox runtime reference](https://github.com/anthropic-experimental/sandbox-runtime#other-configuration) documents that specific service; investigate the actual EventKit denial rather than assuming the Go runtime makes both failures equivalent.

Codex's current [configuration reference](https://developers.openai.com/codex/config-reference) exposes no documented Apple Events or Mach lookup toggle. Its [execution rules](https://developers.openai.com/codex/rules) support per-command host execution: `allow` skips the prompt, `prompt` requests review, and the most restrictive matching rule wins. The user-managed default rules file remains untouched; `dot_codex/rules/` is deliberately not an exact directory because Codex writes additional rules itself.

Use [OpenCode 1.x permissions](https://opencode.ai/docs/permissions/) for the installed 1.18.20 harness: `permission.bash`, ordered with the last match winning. Do not substitute the V2 `permissions`/`shell` schema into this config.

## Configuration work

Reminders command policy is authored in the three harness sources. Obsidian-specific setup and scoped task-editing guidance below remain pending. Keep runtime settings separate from evidence that the tools work.

### Command policy

| Operation | Intended policy |
| --- | --- |
| rem help/version, list/lists/show/search/stats/today/overdue/upcoming | Allow routine reads; use JSON for reconciliation |
| rem add/update/complete/uncomplete/flag/unflag | Allow within an explicit task or sync; preserve identity and verify changes |
| rem delete/import, list management, shared-boundary moves | Review the concrete operation, including deletion aliases and force flags |
| Obsidian help, vault identity, `tasks` inventory, `task` status change, app launch | Allow the bare form, which targets the focused vault; the skill verifies its path against `OBSIDIAN_DEFAULT_VAULT` |
| Obsidian eval, generic command execution, plugin changes, deletion or whole-note overwrite | Review actual code or operation; no global `obsidian *` allow rule |

Use canonical `rem <subcommand> ...` forms so the operation-specific rules match. Claude uses `permissions.allow` and `permissions.ask`; OpenCode places specific ask rules after allows. Codex prefix rules cannot inspect a list flag at an arbitrary position, so all `update`/`edit` calls prompt there. Codex supports both `rem` and `/opt/homebrew/bin/rem` spellings. Other paths, global flags before subcommands, and complex shell wrappers retain the harness's default review behavior; do not rearrange commands to avoid review. Shared guidance and the sync change set retain the domain boundary.

Delete/remove/rm, imports, and list management require review even with force flags. Routine multi-ID completion remains allowed for task synchronization; a user request to clear or archive an entire list is a bulk cleanup decision, not implicit sync authority. Interactive sessions and skill installation are reviewed. These policies do not grant permission to modify unrelated tasks.

OpenCode grants direct girlOS file access through `permission.external_directory` on the vault path, alongside the existing read/edit secret protection. Claude and Codex keep their vault sandbox roots. Do not add Reminders database folders, broad Apple application containers, Full Disk Access requirements, or global Apple Events allowances without evidence that the chosen operation needs them. Prefer explicit reminder lists to avoid implicit default-list discovery.

### Guidance

`.chezmoitemplates/agents/rules/notes-vault.md` and Claude's `autoMode` allow and soft-deny entries express the same contract: incidental capture keeps its limited scope, and an explicit vault-task sync permits exact-content edits to the named existing task lines plus appends to the `org/_inbox/Task Sync` record. Neither permits broad note reorganization. Keep the `sync-tasks` skill aligned with that contract; it is guidance, not a filesystem permission.

Obsidian CLI policy on Claude and OpenCode allows `help`, `version`, `vault`, `vaults`, `tasks` (inventory), and `task` (single-line status change), in the bare form only, plus `open -a Obsidian` to launch the app the CLI requires. `eval`, `delete`, and `plugin:*` prompt on Claude; OpenCode's default `*: ask` prompts for everything else. The `tasks` command is the inventory source because it filters by status character and emits JSON with file paths, which `notesmd-cli` cannot do without custom parsing; the trade is that the app must be running, so the inventory is macOS-only.

### macOS and application setup

Enable Obsidian's CLI in Settings → General and keep the app running; the first CLI call launches it otherwise. The CLI talks to the app over the `~/.obsidian-cli.sock` unix socket, which Claude allows in `sandbox.network.allowUnixSockets` and the Codex profile in `network.unix_sockets`. Verify vault identity with `obsidian vault info=path` before any read; the bare form targets the focused vault, so the path must match `OBSIDIAN_DEFAULT_VAULT` or the sync stops. `vault=<name>` forms are not allowed because a wildcard before the subcommand also matches any inserted option, and a name-selected vault bypasses the path check. See [Obsidian CLI](https://obsidian.md/help/cli).

Establish Reminders access in the launch context used for each harness. Check System Settings → Privacy & Security → Reminders if macOS requests or denies authorization. An EventKit connection error can also originate from sandboxed service lookup; distinguish these causes with a host-side read and sandbox violation evidence. Do not reset TCC or change privacy settings programmatically as a diagnostic shortcut.

## Verification and outstanding evidence

Inspection on 2026-09-08: Claude Code 2.1.263, Codex CLI 0.153.4, OpenCode 1.18.20, Homebrew rem-cli 0.12.0.

- With the CLI enabled and the socket allowed, `obsidian vault info=path` returns the path in `OBSIDIAN_DEFAULT_VAULT` and `tasks format=json` returns `{status, text, file, line}` records inside the Claude sandbox. Without the socket allowance the CLI reports it cannot find Obsidian even while the app is running. `tasks done` returns every non-todo status, so per-symbol `status=` reads are the inventory unit.
- Inside either harness sandbox, rem fails during Reminders initialization with access denied and Mach error 4099; `rem list` works in Winnie's normal terminal. The denied service has not been identified.
- `rem lists -o json` succeeds with explicitly approved unsandboxed execution in Codex. In a fresh Claude session, `rem list -o json` and `rem lists -o json` succeed without a prompt through `sandbox.excludedCommands`, and the same binary called by full path from the sandbox fails with the Mach error above.
- In a fresh Claude session, `notesmd-cli create`, `create -a`, `print`, and `search-content` run inside the sandbox without a prompt against a probe note in `org/_inbox/`, and `notesmd-cli delete` on that session-created note completes. No existing note or reminder has been mutated.
- The deployed Codex rules match their source. `codex execpolicy check` with the existing default rules confirms routine reads are allowed and forced deletion, deletion aliases, imports, list deletion, and updates prompt. OpenCode JSONC parses successfully and its config symlink resolves to the edited source. Fresh-session routing and prompts remain to be verified in Codex and OpenCode.
- Git commit `70106e73764ed757fccc3f8550c80afeac934a0b` on 2026-07-07 introduced Claude's `enableWeakerNetworkIsolation` for Go CLIs such as `gh`. Its commit message describes token/key access; upstream specifies the narrower trustd/TLS mechanism.
- `/usr/bin/log show` reports `Cannot run while sandboxed`; service-denial diagnosis needs host-side logs. Do not retry under another tool to evade the boundary.

Next checks, in order:

1. Verify `obsidian tasks total` in fresh Codex and OpenCode sessions.
2. Verify Codex's rules-based host exception in a fresh session and confirm OpenCode's routine command policy. Recheck macOS authorization only if access stops working.
3. Evaluate destructive commands through permission diagnostics without executing them. Confirm delete aliases, imports, list deletion, and shared-list-capable updates receive review.
4. Check one user-designated disposable task through create, read, update, completion, and an unchanged second sync. Test both routine access and the destructive-operation review boundary; cleanup requires its own scoped authorization. Verify completed history, native metadata, and sections separately.

For a blocked command, the two supported routes are to configure its exact denied resource where the harness supports that control, or run the exact diagnostic on the host and supply the result. Neither requires disabling sandboxing for the whole agent session.
