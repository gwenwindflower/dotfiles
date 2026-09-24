# Tasks and Reminders

Agents read, reconcile, organize, and schedule Obsidian Tasks and Apple Reminders under user direction. Routine individual changes should not stop for redundant confirmation.

## Expected behavior

- Use `notesmd-cli` for contextual notes, the Obsidian CLI for the Tasks inventory, and `rem` for Reminders. Interpret Tasks settings and custom/completed statuses; checkbox search is not an equivalent inventory.
- Preserve IDs, notes, dates, alarms, recurrence, and project/list membership. Distinguish an incomplete inventory from an empty collection.
- Follow `sync-tasks` for matching, field-level conflicts, checkpoints, and verification. Explicit sync authorizes resolved changes within its scope.
- Individual completion, reopening, scheduling, flags, content edits, and moves between established projects/lists are routine when requested. Ambiguous identity, recipients, or destinations still require clarification.
- Review the aggregate change set for imports/exports, list administration, mass deletion, and scripted batches. Native multi-ID calls and loops have the same scope boundary.

## Access layers

| Surface | Required access | Boundary |
| --- | --- | --- |
| Vault files | Exact girlOS filesystem root and `OBSIDIAN_DEFAULT_VAULT` | No other vaults or vault administration |
| Obsidian app | Running app with CLI enabled; `~/.obsidian-cli.sock`; verified active vault | No arbitrary app-side JavaScript from a file-access grant |
| Reminders | macOS privacy authorization and EventKit/ReminderKit service access | No direct database edits or unrelated Apple application access |
| User authority | Requested task or sync and resolved identities | No implied bulk cleanup or invented scheduling |

`rem` initializes EventKit even for some help invocations. macOS privacy permission and sandbox service lookup are separate checks. Do not reset TCC or expand Apple container access to diagnose a command failure.

## Levels

| Family | Level | Notes |
| --- | --- | --- |
| `rem` reads, add, and individual update, complete, flag, and list moves | `open` | EventKit needs the host. Prefer JSON for reconciliation. |
| `rem delete`/`rm`/`remove` | `review-open` | An individual requested deletion is routine; multi-ID deletion is judged as a batch. |
| `rem import`/`export`, `list-mgmt`/`lm` | `review-request-open` | Batches and list administration. |
| `rem interactive`, `rem skills` | `review-open` | |
| Obsidian task changes and individual note edits | `sandboxed` | After vault and record identity checks; see [Obsidian notes](notes.md#levels). |
| `obsidian eval`/`command`/`plugin` and vault administration | See [Obsidian notes](notes.md#levels) | |

Moving across a shared-list boundary can recreate a reminder with a different ID. If the user has already requested that specific move, preserve its fields, use the tool's documented confirmation mechanism, and update the stored mapping. Ask only if the destination or sharing scope is unresolved; routine project moves do not require a second approval solely because they are moves.

## Platform implementations

| Harness | Mechanism and limits |
| --- | --- |
| Claude Code | `rem` and `rem *` are excluded; routine subcommands have allows, and the rest reach the classifier. `allowAppleEvents` does not establish EventKit access. |
| Codex | `reminders.rules` allows routine reads and mutations on the host, with review for deletion, import/export, list administration, interactive use, and skill installation. Both `rem` and `/opt/homebrew/bin/rem` are covered. |
| OpenCode 1.x | Ordered `permission.bash` patterns; routine updates/moves are allowed and bulk operations ask. Shell already runs on the host. |

Prefix rules cannot count IDs or identify every option position. A host allow for `rem complete` also matches multi-ID completion; there is no claim of automatic batch detection. The agent reviews scope across calls before executing a batch. Do not add a universal `rem *` host allow.

Both sandboxes grant `~/.obsidian-cli.sock`. Verify live Obsidian IPC in the harness launch context; configuration alone is not proof the app connection works.

## Verification

- A complete scoped inventory preserves native task/status semantics.
- An individual completion or list move matches routine policy; deletion/import/export/list administration reaches review.
- A sync verifies each write and reports unmatched or unsupported records.
- Vault-administration commands are blocked across harnesses.
- A host-side `rem lists -o json` succeeds with privacy authorization; its sandboxed equivalent can fail with Mach error 4099. Retain command-scoped host execution rather than broad Apple filesystem grants.

Supporting references: [rem architecture](https://rem.sidv.dev/docs/architecture/), [Codex execution rules](https://developers.openai.com/codex/rules), [OpenCode 1.x permissions](https://opencode.ai/docs/permissions/), [Obsidian CLI](https://obsidian.md/help/cli). Use the installed OpenCode 1.x schema, not V2 `permissions`/`shell` keys.
