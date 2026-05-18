# Claude Code Subagents

Claude Code-specific syntax and behavior. See [SKILL.md](SKILL.md) for cross-platform principles (description, body, permissions philosophy).

## File locations

| Location | Scope | Priority |
| --- | --- | --- |
| Managed settings `.claude/agents/` | Org-wide | 1 (highest) |
| `--agents` CLI flag (JSON) | Current session only | 2 |
| `.claude/agents/` | Current project | 3 |
| `~/.claude/agents/` | All your projects | 4 |
| Plugin's `agents/` | Where plugin enabled | 5 (lowest) |

Filename → agent name (lowercase, hyphens). `~/.claude/agents/code-reviewer.md` → `code-reviewer`. Project subagents are discovered by walking up from cwd; `--add-dir` paths are not scanned.

> **Disk edits require a session restart.** Use the `/agents` UI for changes that take effect immediately.

## Markdown format

```markdown
---
name: code-reviewer
description: Reviews code for quality and best practices. Use proactively after code changes.
tools: Read, Glob, Grep, Bash
model: sonnet
---

System prompt body. Role, workflow, constraints.
```

Body becomes the agent's full system prompt — Claude Code's default system prompt is replaced, not extended. Subagents get only the body plus basic env (cwd).

## Frontmatter fields

Required: `name`, `description`. Everything else optional.

| Field | Values | Purpose |
| --- | --- | --- |
| `name` | lowercase + hyphens | Unique ID; matches filename |
| `description` | one sentence | Routes auto-delegation |
| `tools` | comma list | Allowlist of tool names. Inherits all if omitted |
| `disallowedTools` | comma list | Denylist; applied before `tools` |
| `model` | `sonnet` / `opus` / `haiku` / full ID / `inherit` | Default `inherit` |
| `permissionMode` | see below | Permission gating |
| `maxTurns` | integer | Stop after N agentic turns |
| `skills` | list | Preload skill content at startup |
| `mcpServers` | list | Inline defs or string refs to existing servers |
| `hooks` | object | Lifecycle hooks scoped to this subagent |
| `memory` | `user` / `project` / `local` | Persistent dir across conversations |
| `background` | bool | Default-run as background task |
| `effort` | `low` / `medium` / `high` / `xhigh` / `max` | Override session effort |
| `isolation` | `worktree` | Run in temp git worktree (auto-cleanup if no changes) |
| `color` | red/blue/green/yellow/purple/orange/pink/cyan | UI tag |
| `initialPrompt` | string | Auto-submitted first turn when run as main session via `--agent` |

**Plugin subagents silently ignore** `hooks`, `mcpServers`, and `permissionMode`. Copy the file into `.claude/agents/` or `~/.claude/agents/` to enable them.

CLI-defined subagents (`--agents '{...}'`) accept the same fields with `prompt` in place of the markdown body.

## Tool restrictions

Allowlist or denylist; if both, denylist applies first.

```yaml
tools: Read, Grep, Glob, Bash         # allowlist; nothing else
disallowedTools: Write, Edit          # denylist; everything else inherited
```

Don't use both for the same exclusion — listing `Write, Edit` in `disallowedTools` is redundant if `tools` already omits them. Pick one.

To preload Skills, use `skills:`, not `Skill` in `tools` — `Skill` in `tools` only controls whether the Skill tool itself is available. Subagents can still discover other skills at runtime unless you deny it.

Subagents can't spawn other subagents, so `Agent(...)` syntax in `tools` only matters when the file runs as the main thread via `claude --agent`:

- `Agent` (no parens) — can spawn any subagent
- `Agent(worker, researcher)` — only these
- omit `Agent` — cannot spawn any

## Model selection

`sonnet` / `opus` / `haiku`, a full ID like `claude-opus-4-7`, or `inherit`. Resolution when invoked:

1. `CLAUDE_CODE_SUBAGENT_MODEL` env var
2. Per-invocation `model` parameter
3. Subagent's `model` frontmatter
4. Main conversation's model

Route narrow / verbose work to Haiku to control cost.

## Permission modes

| Mode | Behavior |
| --- | --- |
| `default` | Standard prompts |
| `acceptEdits` | Auto-accept edits and common fs commands inside cwd |
| `auto` | Background classifier reviews commands |
| `dontAsk` | Auto-deny prompts (allowed tools still work) |
| `bypassPermissions` | Skip all prompts — use carefully |
| `plan` | Read-only plan mode |

Parent's `bypassPermissions` or `acceptEdits` overrides the child's setting. Parent `auto` makes the child's `permissionMode` ignored entirely.

## Persistent memory

`memory: project` (recommended default) gives the subagent a directory it reads and writes across conversations. Read/Write/Edit are auto-enabled, and the first 200 lines / 25KB of `MEMORY.md` is injected into the system prompt with curation instructions.

| Scope | Path | When |
| --- | --- | --- |
| `user` | `~/.claude/agent-memory/<name>/` | Cross-project knowledge |
| `project` | `.claude/agent-memory/<name>/` | Project-specific, share via VCS |
| `local` | `.claude/agent-memory-local/<name>/` | Project-specific, untracked |

Tell the subagent in its body to consult and update its memory.

## MCP scoping

```yaml
mcpServers:
  - playwright:
      type: stdio
      command: npx
      args: ["-y", "@playwright/mcp@latest"]
  - github
```

Inline defs connect when the subagent starts and disconnect when it finishes — keeps tool descriptions out of the parent's context. String entries reuse already-configured servers.

## Hooks

Frontmatter hooks fire only while the subagent is active and clean up when it finishes. Common events: `PreToolUse`, `PostToolUse`, `Stop` (auto-converted to `SubagentStop`).

```yaml
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate.sh"
```

For main-session reactions to subagent lifecycle, use `SubagentStart` / `SubagentStop` in `settings.json` — those fire at the parent layer.

## Invocation

- **Automatic delegation** — Claude routes based on `description`. "Use proactively" earns delegation.
- **Natural language** — "use the code-reviewer subagent…"
- **`@`-mention** — `@"code-reviewer (agent)" review auth changes`. Plugin subagents appear as `<plugin>:<agent>`.
- **Whole session** — `claude --agent code-reviewer` or `"agent": "code-reviewer"` in `.claude/settings.json`. `initialPrompt` in the agent's frontmatter is auto-submitted as the first user turn.

`/agents` opens the management UI: Running tab shows live agents; Library tab creates / edits / deletes / shows overrides. `claude agents` (CLI, no session) lists everything grouped by source.

## Built-in subagents

Claude Code ships these — don't duplicate them, route to them when fitting:

| Name | Model | Tools | Use |
| --- | --- | --- | --- |
| `Explore` | Haiku | Read-only | File discovery, code search, codebase reads without changes |
| `Plan` | Inherits | Read-only | Research during plan mode |
| `general-purpose` | Inherits | All | Complex multi-step work needing both exploration and action |
| `statusline-setup` | Sonnet | Read, Edit | Invoked by `/statusline` |
| `claude-code-guide` | Haiku | Read, WebFetch, WebSearch, Bash | Invoked when users ask about Claude Code features |

When fork mode is enabled (`CLAUDE_CODE_FORK_SUBAGENT=1`), every spawn that would have gone to `general-purpose` runs as a fork instead — inheriting the parent's full conversation. Named subagents (`Explore` etc.) still spawn fresh.

## Resume vs respawn

Each `Agent(...)` call creates a fresh subagent with empty context. To continue an existing subagent's work, use `SendMessage({ to: <agent-id-or-name> })` instead. Requires `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`. The subagent picks up its full prior conversation, tool calls, and reasoning.

## Disable a subagent

```json
{
  "permissions": {
    "deny": ["Agent(Explore)", "Agent(my-agent)"]
  }
}
```

Or pass `--disallowedTools "Agent(Explore)"`.

## References

- [Subagents](https://code.claude.com/docs/en/sub-agents)
- [Hooks](https://code.claude.com/docs/en/hooks)
- [Permissions](https://code.claude.com/docs/en/permissions)
- [Skills](https://code.claude.com/docs/en/skills)
- [Plugins](https://code.claude.com/docs/en/plugins)
