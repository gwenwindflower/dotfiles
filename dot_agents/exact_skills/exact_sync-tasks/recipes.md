# Tool Recipes

These are capability-checked recipes, not an unattended sync engine. Read installed help before using flags and inspect actual JSON keys instead of assuming capitalization. Pass task text as structured arguments; never interpolate note or reminder contents into shell code.

## Preflight and scope

```bash
date '+%Y-%m-%dT%H:%M:%S%z %Z'
rem --help
notesmd-cli --help
notesmd-cli search-content --no-interactive --format json --vault "$OBSIDIAN_DEFAULT_VAULT" 'Task Sync'
open -a Obsidian
obsidian help
```

Require a nonempty `OBSIDIAN_DEFAULT_VAULT`; it is the allowed vault path and the only vault identity the skill knows. Use it on every notesmd-cli call and never spell the vault name or path in a command. If Reminders access fails, report the exact macOS/EventKit or sandbox error and continue only independent work. Do not change privacy settings, disable checks, or treat an access error as zero reminders.

The Obsidian CLI is the task inventory tool; `notesmd-cli` is the note reader and writer. The CLI needs the app: the first command launches Obsidian if it is not running, so run `open -a Obsidian` explicitly, wait for the vault to finish indexing, and never rely on whichever vault is focused. Load the `obsidian-cli` skill and read `obsidian help` for the installed command surface. Remote Linux environments have no app, so inventory there is limited to the file-based partial audit below.

```bash
obsidian vault info=path
```

The bare command targets the vault the app has focused. Its reported path must equal `OBSIDIAN_DEFAULT_VAULT` before any read or write; if it differs, stop and ask the user to focus that vault in Obsidian. Do not pass `vault=` to redirect the CLI: the bare form is the one the permission policy allows, and a name-selected vault is not the verified path.

## Inventory Tasks

`obsidian tasks` lists every checkbox line the app recognizes, filtered by status character and scoped by file or path. `format=json` emits an array of `{status, text, file, line}`: the status character, the raw task line including its `- [ ]` prefix, the vault-relative note path, and the line number as a string. Line numbers are temporary locators; keep the raw line beside them.

```bash
obsidian tasks format=json
obsidian tasks total
obsidian tasks todo format=json
obsidian tasks 'status=x' format=json
obsidian tasks 'status=/' format=json
obsidian tasks path="dev/tackle" format=json
```

`todo` is exactly `status=" "`, but `done` is every status other than todo, so it mixes completed, cancelled, in-progress, and non-task symbols. Inventory by explicit `status=` for each symbol in the plugin settings and reconcile their sum against `total`; a symbol the CLI does not surface is a coverage gap to report, not an empty collection.

Status meaning comes from the Tasks plugin settings, not the CLI. Read them from the vault:

```bash
jq '{globalFilter, taskFormat, statusSettings: {core: [.statusSettings.coreStatuses[] | {symbol, name, type}], custom: [.statusSettings.customStatuses[] | {symbol, name, type}]}}' \
  "$OBSIDIAN_DEFAULT_VAULT/.obsidian/plugins/obsidian-tasks-plugin/data.json"
```

Apply the global filter (a task without it is not a Tasks task when the filter is nonempty), the task format (emoji signifiers for dates, priority, recurrence, IDs, and dependencies), and each status symbol's `type`. `TODO`, `IN_PROGRESS`, `DONE`, `CANCELLED`, and `NON_TASK` are the categories that drive status mapping; a `NON_TASK` symbol such as an idea or question marker is excluded from sync, and a checked custom status need not mean done. Read `globalQuery`, `useFilenameAsScheduledDate`, and the date-setting keys when they change how a line should be interpreted.

Parse each raw line with the emoji format rules into status, description, tags, IDs, dependencies, priority, all dates, and recurrence, and keep heading and parent context from the source note. Repeated identical lines need location or anchor disambiguation. Chunk large inventories and reconcile counts.

If the app is unavailable, use `notesmd-cli` searches and file reads for a clearly labeled partial audit that applies the same `data.json` settings. Do not drive creation or absence reconciliation from that fallback.

## Read contextual notes

```bash
notesmd-cli search-content --no-interactive --format json --vault "$OBSIDIAN_DEFAULT_VAULT" 'tackle'
notesmd-cli print 'dev/tackle/Tasks' --vault "$OBSIDIAN_DEFAULT_VAULT"
```

Replace the example note path with a discovered exact path. Consume all pages if pagination is enabled. Search is useful for context and existing destinations; title-only matches do not establish identity.

`notesmd-cli create -a` appends; it is not a task-line updater. Use it for checkpoint entries and new tasks only after duplicate checks:

```bash
notesmd-cli create -a 'org/_inbox/Task Sync' -c "$sync_checkpoint" --vault "$OBSIDIAN_DEFAULT_VAULT"
```

Construct `sync_checkpoint` through safe structured input and retain valid JSON inside a fenced block. For initial note creation, first establish the path is absent and omit `-a`. Do not overwrite a whole note to change one task.

For a status change on an existing line, `obsidian task` sets the status character in place:

```bash
obsidian task ref="dev/tackle/Tasks.md:14"
obsidian task ref="dev/tackle/Tasks.md:14" done
obsidian task ref="dev/tackle/Tasks.md:14" status=/
```

Show the task first and compare its line to the inventory's raw line; a mismatch means the file moved under you, so re-read before writing. `done` and `status=` change only the checkbox character. They do not add a done date or generate the next occurrence of a recurring task, so for a recurring line, or when the plugin settings add done and cancelled dates, apply the full replacement line through an exact-content targeted edit instead. Never use `toggle`: it is not idempotent and its result depends on the current state.

Any change beyond the status character (description, dates, priority, metadata) is an exact-content targeted edit of that line, preserving every other byte of the note.

## Read and update Reminders

```bash
rem lists -o json
rem list -o json
rem list --completed -o json
rem list --incomplete -o json
rem show "$reminder_id" -o json
```

Use full-list inventory plus explicit completed/incomplete reads to check coverage when defaults are uncertain. Deduplicate repeated results by full ID. Inspect detailed records for mapped or conflicting reminders. Read list account/sharing information; identical list names across accounts must be disambiguated before any command that accepts a name.

After identity resolution, these are targeted mutation shapes; variables represent validated values from the change set:

```bash
rem add "$task_title" --list "$list_name" --notes "$notes_with_sync_marker" -o json
rem update "$reminder_id" --title "$task_title" -o json
rem update "$reminder_id" --notes "$preserved_notes_with_sync_marker" -o json
rem complete "$reminder_id"
rem show "$reminder_id" -o json
```

Capture creation output before any subsequent write. Never use `rem import` as an upsert or replay an export to repair a failed run; importing may create duplicates. Export affected records with `rem export --format json --output-file <explicit-backup-path>` when a backup is needed, and inspect its coverage rather than assuming every Apple field round-trips.

Check installed date flags before mapping deadlines. `rem add --due` can introduce a default time and notification. For a Tasks date-only deadline, require supported date-only behavior or an established explicit time/alarm convention; otherwise create the undated counterpart with the exact source date preserved in sync metadata and mark deadline mapping pending. `--silent` suppresses an alarm but does not prove the due value is date-only. Never map a Tasks scheduled date to the reminder deadline just because that is the available flag.

### Native sections

The [published rem commands](https://rem.sidv.dev/docs/commands/) do not document native section management. Inspect installed help for actual support. When available, verify section identities and membership after changes. When unavailable, maintain the intended list/section mapping in the sync record and report a concrete native-section action for the user. Continue supported list and task sync; do not pretend tags, title prefixes, or extra lists are sections. Do not edit Apple's database or call undocumented Apple APIs to bridge this gap. Any alternative adapter needs verified capabilities and authorization within the session.

## Growing programmatic support

Keep extraction, normalization, matching, planning, and application separate. A reusable helper should read immutable snapshots and emit a deterministic JSON change set without writes by default. An executor should consume only resolved operations with expected originals and journal each verified result. Add scripts when real runs establish stable input schemas and repeated work; do not encode a guessed plugin or rem JSON interface.

Before enabling automated writes, exercise realistic fixtures for duplicate titles across projects, moved notes, missing counterparts, completed/custom statuses, conflicting dates, date-only/time-zone boundaries, recurrence rollover, reminder-only domains, unsupported sections, truncated inventories, and interruption after creation but before checkpointing. The core invariants are no data loss, no unintended cross-domain writes, recoverable partial runs, and zero changes on an unchanged second pass.
