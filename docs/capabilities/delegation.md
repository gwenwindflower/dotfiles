# Delegation

Agents can delegate bounded work to specialized helpers while the lead retains scope, integration, and Git ownership.

## Expected behavior

- Use specialized roles for planning, Git recovery, prose drafting, and prose review when their trigger applies.
- Give each helper a concrete task, clear file or responsibility ownership, and enough context to work independently.
- Keep helpers aware that they share a working tree and must preserve one another's changes.
- Return findings or completed edits to the lead for review and integration.
- Bound recursion, concurrency, and runtime so delegation does not become an uncontrolled background system.

## Safety boundary

Delegation does not expand the user's authority or the task's scope. Helpers do not own commits, remote effects, credentials, deployment, or destructive actions unless the user explicitly assigns that authority and the harness supports it safely.

## Shared roles

- `architect` — SPOT specs, plans, requirements, and research synthesis.
- `medic` — confusing or damaged Git states requiring specialized recovery.
- `prose-writer` — long-form human-facing prose.
- `prose-editor` — structured critique of human-facing prose.

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | Agent teams, subagents, role templates, teammate mode, and Git-write hook | Broadest collaboration surface and strongest helper Git enforcement. |
| Codex | Multi-agent feature, agent limits, role templates, and collaboration tools | Explicit concurrency and depth limits; lead ownership comes from shared rules. |
| OpenCode | Named subagents, agent modes, child sessions, and TUI child navigation | Role coverage is present; shared-tree and Git ownership rely primarily on guidance and default asks. |

## Verification

- Each shared role is discoverable with equivalent purpose across the three platforms.
- A helper receives a bounded task and cannot silently broaden it.
- Parallel helpers do not overwrite or revert one another's edits.
- The lead reviews and integrates results before committing.
