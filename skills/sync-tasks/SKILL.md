---
name: sync-tasks
description: Reconcile Obsidian Tasks with Apple Reminders via rem - identity-safe sync, conflict review, priority and schedule planning.
argument-hint: "[topic or project] [sync, review, reconcile, or plan]"
---

# Sync Tasks

Treat data integrity as the primary outcome. Use `rem` for Reminders, the Obsidian CLI's `tasks` command for the vault task inventory interpreted through the Tasks plugin's settings, and `notesmd-cli` for reading and writing notes. Read [reconciliation](reconciliation.md) before syncing and [recipes](recipes.md) before accessing either system. Load `rem-cli` for Reminders mutations and `obsidian-cli` for the app-backed commands.

A sync session requires a nonempty `OBSIDIAN_DEFAULT_VAULT` and the Obsidian app focused on that vault, confirmed through the preflight in the recipes before any read or write. Never name the vault in a command; the environment variable is the only vault identity.

## Invocation

- `/sync-tasks` or `$sync-tasks`: inventory both systems, reconcile established mappings, organize unambiguous items under the preferences below, and add missing eligible counterparts. Report conflicts while continuing independent safe work. This authorizes routine sync writes, not deletion, speculative merging, or invented scheduling.
- A topic such as `dev tackle`, `cleaning kitchen`, or `writing` narrows mutations to that area. Inspect adjacent records to detect overlap, but do not reorganize unrelated areas. Match scope through mappings, note paths, headings, tags, and context; title keywords alone are insufficient.
- `review` previews without writes. `plan` or conversational input adds collaborative grouping, priority, dependency, and scheduling work; apply decisions the user actually makes. Preserve the active scope through follow-up messages.

An explicit sync makes the named vault tasks the work of this session; obey applicable vault editing restrictions and runtime permissions. If existing-note edits are prohibited in the current workspace, complete the permitted work and identify the exact remaining vault patches. Creating or editing this skill does not authorize a live sync.

## Preferences

| Area | Direction | Reminders organization |
| --- | --- | --- |
| Development | Bidirectional | One unified development list; sections by project |
| Cleaning | Reminders only | One cleaning list; sections by room |
| Personal errands | Reminders only | Preserve the existing list structure unless directed |
| Learning | Bidirectional | Reuse established lists and sections |
| Writing | Bidirectional | Reuse established lists and sections |

Discover actual list identities and established project/room names before creating anything. Do not create one list per development project or room. Cleaning and personal errands never back-sync to the vault; an existing vault task in either area is a discrepancy to resolve, not permission to delete or migrate it. Unknown or mixed domains remain unclassified until context or the user resolves them.

Use explicit user preferences and established mappings ahead of these defaults. Keep durable topical decisions in the sync record described in [reconciliation](reconciliation.md), including destination notes, list/section identities, exclusions, and scheduling conventions. Do not edit the skill itself during ordinary syncs.

## Workflow

1. **Read both systems.** Record scope, local time zone, versions, Tasks settings, inventory completeness, and the last successful sync record. Include completed tasks and reminders when reconciling identities and status. Distinguish a failed or partial read from an empty collection.
2. **Reconcile overlap and conflicts.** Match identities before interpreting differences. Produce a change set with source identity, counterpart, field-level before/after values, evidence, and disposition. Ask about ambiguous matches or competing edits together; proceed with unrelated resolved items.
3. **Organize Obsidian tasks.** Preserve source notes, headings, nesting, task syntax, and dependencies. Map each eligible task to its domain and destination. Keep tasks in their contextual notes; propose broad note moves or rewrites separately.
4. **Organize Reminders.** Map existing reminders first, including Reminders-only tasks and sections. Bring eligible development, learning, and writing reminders into an established contextual note; resolve an unknown destination before writing. Honor section capability limits from the recipes.
5. **Fill gaps and verify.** Create missing active counterparts only after overlap checks. Re-read affected records, confirm expected changes and preserved fields, record successful pairs, and run another comparison. An unchanged second pass must propose no writes.

Inventory every task recognized by Tasks in scope, including undated tasks. Active development, learning, and writing tasks are eligible for Reminders unless explicitly excluded. Completed/cancelled history participates in matching but does not generate a historical backlog of counterparts. Preserve blocked/deferred meaning; do not present everything as ready to act on. Account for each record as matched, created, updated, intentionally one-system, excluded, conflicting, or unsupported.

## Planning partner

Use task context to suggest concrete next actions, coherent batches, dependencies, and sequencing. Development groups by project and prerequisite; cleaning by room and shared supplies; errands by location; learning and writing by outcome or deliverable. Preserve distinct tasks and child tasks when grouping.

Separate hard deadlines, planned work dates, and notification times. Ask about capacity or missing deadlines only when they change the plan. Suggest priorities based on commitments, consequence of delay, and what unblocks other work; label estimates and recommendations. Do not assign every overdue task to today or turn suggested work dates into deadlines. Apply accepted decisions within scope and sync only fields with a defined mapping.

End with counts of verified changes and unresolved discrepancies, links or IDs for items needing decisions, and the smallest useful next question. Distinguish partial completion from a verified sync; report unsupported sections and fields explicitly.
