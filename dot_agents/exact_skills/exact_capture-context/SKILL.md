---
name: capture-context
description: End-of-session capture of state changes, novel learnings, and durable preferences into project context files. Use when the user runs `/capture-context`, says "capture context" / "update the docs", or when wrapping a session that introduced non-trivial deps, architecture changes, or explicit "remember this" callouts.
---

# Capture Context

A thin workflow wrapper around [agent-context-engineering](../agent-context-engineering/SKILL.md). The job here is **deciding what's worth capturing**; the authoring rules live in that skill.

## Workflow

1. **Scan the session** for capture candidates (see categories below).
2. **Diff against existing context** — read `AGENTS.md`, `.agents/` rules, `.docs/` index, and surface relevant memory files. Drop anything already covered.
3. **Triage** the survivors against the priority rules.
4. **If nothing survives, stop.** Tell the user "nothing worth capturing" — a no-op is the correct outcome more often than not.
5. **Otherwise**: load [agent-context-engineering](../agent-context-engineering/SKILL.md) and apply its authoring rules to update the right files. Show the user the proposed edits before writing if any are non-trivial.

## What to scan for

Four categories, in priority order:

| Category | Examples |
| --- | --- |
| **Project state changes** | New API server, swapped test framework, new component library, schema/migration, new build target, new top-level dir |
| **Explicit user callouts** | "Remember that we always X", "make a note that Y", "add this to AGENTS.md" |
| **Non-trivial dependencies** | New runtime (Bun added alongside Node), new infra primitive (Redis added), new SDK that reshapes a layer |
| **Novel learnings & preferences** | Discovered gotcha, non-obvious convention the user confirmed, workflow preference expressed |

## Priority rules

**Always capture** (the top three categories):

- Project state changes
- Explicit user callouts to remember something
- Non-trivial deps that reshape how an agent should approach the codebase

**Judge critically** (learnings & preferences):

- Skip if already in your private Memory (the auto-memory system). Memory handles cross-session personal preferences; project context files handle things every agent working in *this repo* needs.
- Skip if it's a one-off — the user fixed a typo, you learned the file exists, neither belongs in durable docs.
- Capture if a future agent in this repo would plausibly re-learn it or get it wrong without the note.

**Never capture**:

- Anything already in `AGENTS.md`, rules, or `.docs/` (re-read first, don't trust memory of what's there)
- Ephemeral task state ("we're mid-refactor on X")
- Things derivable from `git log`, `package.json`, file structure, README
- Generic best practices ("write tests")

## Routing

Use [agent-context-engineering](../agent-context-engineering/SKILL.md)'s file-location guidance. Quick map:

- **Project-wide, every-session-relevant** → root `AGENTS.md` (keep tight)
- **Project-wide, area-specific** → new file in `.docs/` + index entry in `AGENTS.md`
- **Cross-project workflow knowledge** → propose a skill, not a project doc
- **User-personal preference** → save to Memory (private auto-memory), not the tracked repo

## Slash-command form

When invoked as `/capture-context`, the user is explicitly asking for the scan. Be more willing to surface borderline candidates and let them decide. When self-triggered at end of session, be stricter — only fire when the bar above is clearly met.
