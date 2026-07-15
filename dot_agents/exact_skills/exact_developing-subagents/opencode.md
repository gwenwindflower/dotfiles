# OpenCode Agents

OpenCode-specific syntax and behavior. See [SKILL.md](SKILL.md) for cross-platform principles (description, body, permissions philosophy).

Two surfaces: markdown files (one agent per file) or the `agent` block in `opencode.json`.

## Modes

| Mode | Behavior |
| --- | --- |
| `primary` | Tab-cycled main agents (Build, Plan) |
| `subagent` | Invoked by primaries or `@mention` (General, Explore) |
| `all` | Both. **Default** when `mode` is omitted |

Built-ins: **Build** (primary, full tools), **Plan** (primary, edits/bash gated to `ask`), **General** (subagent, full tools except todo), **Explore** (subagent, read-only).

If a primary should never be Tab-selected by the user, mark it `subagent`. If a subagent should be invocable only by other agents (not in `@` autocomplete), add `hidden: true` — the Task tool can still reach it.

## Markdown format

`~/.config/opencode/agents/<name>.md` (global) or `.opencode/agents/<name>.md` (project). Filename is the agent name.

```yaml
---
description: One sentence — model uses this to decide when to invoke a subagent
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
permission:
  edit: deny
  bash:
    "*": ask
    "git diff *": allow
  webfetch: deny
---

System prompt body.
```

## Frontmatter / config fields

Required: **description** (one sentence; routes invocation).

Common optional:

- **mode** — `primary` | `subagent` | `all` (default `all`)
- **model** — `provider/model-id`. Primaries default to the global model; subagents inherit the invoking primary's model.
- **temperature** — 0.0–1.0
- **top_p** — alternative to temperature
- **steps** — max agentic iterations before forced text response. (`maxSteps` is **deprecated** — use `steps`.)
- **disable** — `true` disables without deleting
- **prompt** — `{file:./path/to/prompt.txt}` for an external system prompt; path is relative to the config file
- **hidden** — `true` to hide a subagent from `@` autocomplete (Task tool still works)
- **color** — hex (`#FF5733`) or theme name (`primary`, `accent`, `success`, `warning`, `error`, `info`)

Anything else is **passed through to the model provider** (e.g. `reasoningEffort`, `textVerbosity` for OpenAI reasoning models).

## Permissions

Per-tool gating. Values: `allow` | `ask` | `deny`. The deprecated `tools` field still works (`true`/`false` ≡ `"allow"`/`"deny"`); migrate new agents to `permission`.

### Keys

| Key | Gates | Pattern support |
| --- | --- | --- |
| `read` | `read` | glob |
| `edit` | `write`, `edit`, `apply_patch` | glob |
| `glob` | `glob` | glob |
| `grep` | `grep` | glob |
| `list` | `list` | glob |
| `bash` | `bash` | command-pattern |
| `task` | which subagents this agent can invoke | glob |
| `external_directory` | any tool reading/writing outside the project worktree | glob |
| `lsp` | `lsp` | glob |
| `skill` | `skill` | glob |
| `webfetch` / `websearch` | self | shorthand only |
| `todowrite` | `todowrite`, `todoread` | shorthand only |
| `question` / `doom_loop` | self | shorthand only |

Pattern keys also accept the bare shorthand (`edit: deny`).

Keys are matched as wildcards against tool names — applies to built-ins, custom tools, and MCP tools (e.g. `mymcp_*: deny` disables an MCP server, `mymcp_search: ask` targets one tool).

### Last matching rule wins — the cascade pattern

Within a permission block, rules are evaluated in order and the **last matching pattern wins**. The idiomatic use is the **deny-list cascade**: a sweeping rule first, then specific exceptions:

```yaml
permission:
  task:
    "*": deny           # default: nothing taskable
    "explore": allow    # except these
    "code-reviewer": ask
```

Reverse the order and the trailing `*: deny` clobbers every allow above it — silently breaks the agent. Always sanity-check that the broad wildcard sits *above* the specifics that override it.

The cascade is only worth writing when **the global config doesn't already establish it.** OpenCode's typical bash global is itself a cascade (`*: ask` plus a long allowlist plus a few denies); restating `*: ask` in an agent is dead config — that part already merges in.

Setting a `task` entry to `deny` removes that subagent from the Task tool description entirely. Users can still invoke any subagent via `@` autocomplete regardless of `task` permissions.

## Permissions merge with global

Agent permission keys **merge** with the global config from `~/.config/opencode/opencode.jsonc` (or project `opencode.json`) — agent rules take precedence on the patterns they specify, but unlisted patterns still inherit. Setting `bash` in an agent does **not** wipe the global `bash` allowlist; both apply.

Keep agent frontmatter small and let the global do the heavy lifting.

## Built-in subagents

Two built-ins ship as subagents (taskable): **General** and **Explore**. Build and Plan are **primaries** — they can't be invoked via the Task tool, so listing `"build": allow` or `"plan": allow` under `task:` does nothing. User-defined agents listed under `task:` need to be `mode: subagent` (or `mode: all`) — pure `mode: primary` agents can't be tasked either.

## JSON form

Same fields under `agent.<name>` in `opencode.json`. Agent config overrides top-level config:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": { "edit": "deny" },
  "agent": {
    "build": {
      "permission": { "edit": "ask" }
    },
    "code-reviewer": {
      "description": "Reviews code for best practices and risks",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-20250514",
      "permission": { "edit": "deny" }
    }
  }
}
```

## Quick scaffold

```bash
opencode agent create
```

Interactive: pick scope (global/project), describe purpose, select allowed permissions; everything unselected is denied.

## References

- [Agents](https://opencode.ai/docs/agents/)
- [Permissions](https://opencode.ai/docs/permissions/)
- [Config schema](https://opencode.ai/config.json)
