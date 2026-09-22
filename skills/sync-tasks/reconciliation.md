# Reconciliation and Integrity

## Identity and durable state

Search for an existing Task Sync record with `notesmd-cli` before creating one. Reuse it; otherwise create `org/_inbox/Task Sync` during an authorized sync. Keep preferences and append-only JSON checkpoints there through `notesmd-cli`, not in the dotfiles repo or the skill. Checkpoints contain a schema version, run ID, timestamp/time zone, scope, completeness, mappings, pending operations, and last successfully verified values for each side. Preserve prior checkpoints for recovery; never treat an incomplete run as a complete baseline.

For each pair retain:

- A generated UUID `syncId`, domain, and recurrence series/occurrence identity if applicable.
- Vault path, note path, stable block ID where available, Tasks dependency ID where present, exact original task line, and surrounding heading/parent context. Line numbers are temporary locators. Tasks dependency IDs and block IDs are different fields; preserve both.
- Full reminder ID, account/list identity, section identity when exposed, and original fields. Never persist a short ID as the primary key.
- Separate normalized Obsidian and Reminders baselines for title, status, dates, priority, and any other mapped field, plus raw values needed to preserve unsupported information.

For a confirmed pair, append a uniquely delimited marker to reminder notes while preserving the user's text:

```text
[obsidian-task-sync]
sync-id: <UUID>
source: <percent-encoded Obsidian URI identifying the note and block>
[/obsidian-task-sync]
```

Reuse an existing block anchor or add a unique one through an authorized targeted note edit. Preserve any existing native reminder URL; place provenance in the marker rather than overwriting a useful link. Preserve the marker on subsequent note updates. Record intended creation and its UUID before writing, include the marker in the initial creation, then capture the returned full ID. If creation times out, search the complete inventory for that UUID before retrying. If the marker or ledger cannot be persisted, defer creation rather than risk an untracked duplicate.

Match in order: verified sync UUID and ledger pair; unique source anchor; then candidate similarity using description, domain, project, heading, dates, and recurrence occurrence. Similar titles are evidence to review, never an automatic merge. Reject one-to-many mappings and duplicate markers/anchors. For moved notes, missing IDs, and copied tasks, locate and verify the source before repairing the mapping. Do not silently transfer a mapping to the nearest title match.

## Field-level reconciliation

Compare both current sides against their own last verified baseline, not against a whole-note modification time. Whole-file timestamps do not establish which task field changed last.

| Observation | Action |
| --- | --- |
| Neither side changed | No write |
| One side changed a representable field | Propagate that field to its confirmed counterpart |
| Both changed to equivalent values | Record agreement without rewriting |
| Both changed differently | Preserve both; request a field-level resolution |
| First pairing has different values, no baseline | Treat differences as conflicts; do not guess a winner |
| Counterpart absent from a complete inventory | Search identity/move history; flag possible deletion before recreation |
| Source unavailable, partial, stale, or unreadable | Mark unknown; do not infer absence or advance its baseline |

Merge independent field edits only when their semantics do not interact. Status plus recurrence, or due date plus alarms, require joint reconciliation. Clearing a field is a change only with baseline evidence or user instruction; a missing API property is unknown, not empty. Preserve both-side baselines for lossy mappings so an unchanged round trip cannot gradually erase detail.

## Semantic boundaries

| Field | Mapping rule |
| --- | --- |
| Description | Preserve links, tags, IDs, and metadata in the source; derive a readable reminder title. Retain a reversible mapping before propagating title edits back. Never replace a full task line with its title. |
| Status | Use configured Tasks status types, not just checkbox characters. Completion, cancellation, in-progress, and non-task statuses differ. Propagate completion/reopening only for a verified occurrence and unambiguous change; a checked custom status need not mean done. |
| Dates | Map an explicit Tasks due date to deadline semantics. Keep start, scheduled, inferred scheduled, created, done, and cancelled dates separate. Preserve date-only values and local calendar dates; do not convert midnight UTC into a different day. Reminders times/alarms have no automatic Tasks date-only equivalent. |
| Priority | Tasks has more levels than Reminders. Preserve the original level; use an established mapping, or propose highest/high → high, medium → medium, normal → none, low/lowest → low. Reverse low/high without a baseline is ambiguous. |
| Structure | Keep note/heading/parent context and Tasks dependency IDs. A Reminders section groups tasks; it does not encode task dependency or parent-child semantics. Preserve subtasks and attachments even if rem cannot expose them. |
| Reminder-only metadata | Retain flags, location triggers, alarms, rich notes, URLs, assignments, and unsupported fields on their owning side. Never clear them because the vault lacks equivalents. |

### Recurrence

Use one recurrence generator per series. Default to Tasks for bidirectional domains, Reminders for cleaning/errands. With Tasks owning recurrence, mirror the current occurrence as a nonrecurring reminder and let Tasks generate the successor on verified completion. Do not enable recurrence on both sides. Existing dual recurrence, incompatible rules, or unknown ownership require reconciliation before completion.

The Tasks toggle API returns replacement text and may return multiple lines, an empty result, or a custom status transition. Inspect the result before writing; preserve completion history and assign the successor its own occurrence mapping and unique block anchor. Never blindly retry a toggle, copy a completed occurrence's identity to its successor, or assume completion produces exactly one new occurrence. `onCompletion` deletion or other destructive outcomes require explicit authorization; otherwise leave that pair pending. Re-read both systems before linking a generated successor.

## Applying and recovering

Prepare small operation groups with identity, expected original values, intended changes, and recovery status. Re-read immediately before each write. For note edits use compare-and-replace on exact content; if it differs, stop that edit and reconcile from a fresh read. Preserve unaffected bytes and nested content. For reminders, recheck the full record and send only the fields being changed; `--notes` replaces the entire notes field.

There is no transaction across Obsidian and Reminders. Record each verified success, retaining unfinished operations when the second side fails. Resume by reading actual state and the journal; never replay the whole batch blindly or roll back over intervening user edits. After a list move, re-resolve reminder identity; shared-list moves can recreate records and affect collaborators.

Missing records do not authorize deletion. Do not delete duplicates, merge histories, clear fields, reopen completed work, or move through a shared-list boundary merely to make counts agree. Routine sync can propagate a well-evidenced status change; ambiguous completion conflicts need a user decision. Before any authorized destructive operation, capture the available original data and explain any fields the tool cannot back up. An export is evidence, not a guaranteed lossless restore of every Apple-only property.

Verify fresh values and preserved metadata after writes, then compare again against the verified checkpoints. Failed verification stays pending. Do not claim cloud-wide convergence from a local EventKit read; report the local observation and investigate unexpected iCloud lag before duplicate creation.
