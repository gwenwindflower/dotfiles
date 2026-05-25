---
name: claude-code-hooks
description: Configure Claude Code hooks in settings.json (PreToolUse, PostToolUse, SessionStart, Stop, etc.). Use when adding or debugging Claude Code hooks, or automating actions tied to Claude tool events. Skip for OpenCode automations (use opencode-plugin-config).
---

# Claude Code Hooks

Hooks fire on tool events (PreToolUse, PostToolUse, SubagentStart, TaskCompleted, etc.) and run a shell command. Exit 0 = continue, exit 2 = block with stderr as feedback to Claude.

## Authoring a hook

1. Drop the script in `~/.claude/hooks/` (source: `dot_claude/exact_hooks/`). Prefix `executable_` if it's invoked directly.
2. Wire it into `~/.claude/settings.json` (source: `symsource_claude/settings.json`) under the matching event.
3. Trigger the event in a session and confirm behavior.

Reference: [hooks guide](https://code.claude.com/docs/en/hooks-guide), [hooks config](https://code.claude.com/docs/en/hooks).

## Configured hooks

`External` marks hooks that wire into a third-party tool's state machine (the script itself may live in our tree, but the integration is owned elsewhere).

| Event | Matcher | Hook | External | Purpose |
| --- | --- | --- | --- | --- |
| `SessionStart` | — | `set-sandbox-tmpdir.sh` | | Set `$TMPDIR` to sandbox-writable per-project temp dir |
| `SessionStart` | — | `set-git-nosign.sh` | | Disable SSH commit signing inside the sandbox |
| `UserPromptSubmit` | `*` | `herdr-agent-state.sh working` | x | Mark agent working in the herdr state daemon |
| `PreToolUse` | `*` | `herdr-agent-state.sh working` | x | Same — keep state fresh as tools fire |
| `PreToolUse` | `Write\|Edit\|NotebookEdit` | `worktree-guardrails.sh` | | Block Dev writes to absolute paths outside its worktree |
| `PreToolUse` | `Bash` | `block-cross-worktree-bash.sh` | | Block Dev `git commit/add/rm/mv` targeting another repo |
| `PermissionRequest` | `*` | `herdr-agent-state.sh blocked` | x | Mark agent blocked on permission prompt |
| `Stop` | `*` | `herdr-agent-state.sh idle` | x | Mark agent idle |
| `SessionEnd` | `*` | `herdr-agent-state.sh release` | x | Release agent slot in herdr |
| `SubagentStart` | `dev` | `dev-worktree-anchor.sh` | | Inject worktree anchor + commit contract into Dev context |
| `TaskCompleted` | — | `require-teammate-commit.sh` | | Block task completion until the worktree is committed clean |

## Shared helpers (`lib/dev-hook-common.sh`)

Source from any hook that gates on teammate or worktree context:

```bash
source "$(dirname "$0")/lib/dev-hook-common.sh"
```

| Function | Purpose |
| --- | --- |
| `hook_read_input` | Slurp stdin once into `$HOOK_INPUT` (call before any extractor) |
| `hook_field <jq-path>` | Echo a field from `$HOOK_INPUT`. Empty if missing. e.g. `hook_field '.cwd'` |
| `gate_teammate` | Exit 0 if `.teammate_name` is unset (not in a subagent context) |
| `worktree_root_for <cwd>` | Echo worktree root if `<cwd>` is inside a non-main linked worktree; return 1 otherwise. Use as `root="$(worktree_root_for "$cwd")" \|\| exit 0` |
| `is_git_mutation <command>` | Return 0 if command contains `git commit\|add\|rm\|mv`. Use as `is_git_mutation "$cmd" \|\| exit 0` |
| `effective_dir_for_command <cmd> <fallback>` | Parse `cd <dir>` and `git -C <dir>` from a bash command; echo the effective working dir, or `<fallback>` if neither pattern matched |

## Conventions

- **Gate early.** Hooks fire on every matching tool call — return fast when irrelevant. The standard prologue is `hook_read_input` → `gate_teammate` → resolve cwd/worktree → tool-specific logic.
- **Exit 2 to block.** stderr becomes feedback to Claude. Use it for genuine policy violations the agent should see and correct.
- **Exit 0 to pass.** Any "this doesn't apply to me" path returns 0. Never block on missing context (no `teammate_name`, no `cwd`, etc.) — that's how non-team sessions get poisoned.
- **PostToolUseFailure does not fire when a PreToolUse hook blocks.** If the tool never executed, there's no failure to post-process. Don't try to chain block-then-explain across the two events.
- **`WorktreeCreate` fires in the parent session, not the child.** Output lands in the agent that *created* the worktree, not the one *working in* it. For child-side context use `SubagentStart` with the appropriate matcher.

## Returning JSON

For anything richer than exit 0/2 — injecting prompt context, controlling permissions, halting processing, suppressing output — print a JSON object to stdout. Most event types accept JSON; the shape is consistent:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "<EventName>",
    "<event-specific field>": "<value>"
  }
}
```

Common payloads:

| Event(s) | Field | Effect |
| --- | --- | --- |
| `SubagentStart`, `SessionStart`, `UserPromptSubmit`, `PostToolUse` | `additionalContext` | String injected into the agent's prompt |
| `PreToolUse` | `permissionDecision` (`allow\|deny\|ask`) + `permissionDecisionReason` | Override the permission flow |

Top-level fields work across all events: `continue: false` + `stopReason` halts processing; `suppressOutput: true` hides stdout from the transcript; `decision: "block"` + `reason` blocks the action on events that support it (e.g. `Stop`, `SubagentStop`).

Build the JSON with `jq -n --arg x "$text" '{...}'` — string-interpolating untrusted content into a heredoc invites escape bugs. See the [hooks reference](https://code.claude.com/docs/en/hooks) for the full per-event schema.
