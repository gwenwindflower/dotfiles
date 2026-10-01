# Delegation

Agents can delegate bounded work to helpers while the lead retains scope and integration.

## Expected behavior

- Use the prose roles for long-form drafting and review; other work goes to general helpers briefed from skills.
- Give each helper a concrete task, clear file or responsibility ownership, and enough context to work independently.
- Keep helpers aware that they share a working tree and must preserve one another's changes.
- Return findings or completed edits to the lead for review and integration.
- Bound recursion, concurrency, and runtime so delegation does not become an uncontrolled background system.

## Safety boundary

Delegation does not expand the user's authority or the task's scope. Only one agent commits in a worktree at a time. Helpers do not own remote effects, credentials, deployment, or destructive actions unless the user explicitly assigns that authority and the harness supports it safely.

## Shared roles

- `writer` — long-form human-facing prose.
- `editor` — structured critique of human-facing prose.

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | Agent teams, subagents, role templates, and teammate mode | Broadest collaboration surface. |
| Codex | Multi-agent feature, agent limits, role templates, and collaboration tools | Explicit concurrency and depth limits; lead ownership comes from shared rules. Nested `codex exec` and `claude -p` runs go to the reviewer. |
| OpenCode | Named subagents, agent modes, child sessions, and TUI child navigation | Role coverage is present; shared-tree coordination relies on guidance and default asks. |

## Verification

- Each shared role is discoverable with equivalent purpose across the three platforms.
- A helper receives a bounded task and cannot silently broaden it.
- Parallel helpers do not overwrite or revert one another's edits.
- The lead reviews helper results before they land.
