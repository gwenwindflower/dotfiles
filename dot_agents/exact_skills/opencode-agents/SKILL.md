---
name: opencode-agents
description: Create and configure OpenCode agents in markdown or JSON. Use when adding files under .opencode/agents/ or ~/.config/opencode/agents/, editing the `agent` block in opencode.json/opencode.jsonc, or setting an agent's mode, model, permissions, or tools.
---

# OpenCode Agents

Specialized assistants with custom system prompt, model, and per-tool permissions. Two surfaces: markdown files (one agent per file) or the `agent` block in `opencode.json`.

## Modes

| Mode | Behavior |
| --- | --- |
| `primary` | Tab-cycled main agents (Build, Plan) |
| `subagent` | Invoked by primaries or `@mention` (General, Explore) |
| `all` | Both. **Default** when `mode` is omitted |

Built-ins: **Build** (primary, full tools), **Plan** (primary, edits/bash gated to `ask`), **General** (subagent, full tools except todo), **Explore** (subagent, read-only).

If a primary should never be Tab-selected by the user, mark it `subagent`. If a subagent should be invocable only by other agents (not in `@` autocomplete), add `hidden: true` — Task tool can still reach it.

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

System prompt body. Role, workflow, constraints.
```

## Frontmatter / config fields

Required: **description** (one sentence; this routes invocation — no examples, no multi-paragraph).

Common optional:

- **mode** — `primary` | `subagent` | `all` (default `all`)
- **model** — `provider/model-id`. Primaries default to global model; subagents inherit the invoking primary's model.
- **temperature** — 0.0–1.0 (low = focused, high = creative)
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

### Last matching rule wins

Put `*` first, specific overrides after:

```yaml
permission:
  bash:
    "*": ask
    "git status *": allow
    "git diff *": allow
  task:
    "*": deny
    "explore": allow
    "code-reviewer": ask
```

Setting a `task` entry to `deny` removes that subagent from the Task tool description entirely. Users can still invoke any subagent via `@` autocomplete regardless of `task` permissions.

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

## Writing the description

The `description` is the only field the routing model sees when deciding whether to invoke a subagent. Treat it like a skill description.

- One sentence, third person. Never "I can…" / "You can…".
- Lead with a verb phrase (what it does), then concrete triggers (file types, CLI names, domain terms users actually say).
- Slightly directive — agents under-trigger by default.
- Add `Skip when …` only if an adjacent agent would otherwise mistrigger.
- Skip: numbered "(1)…(2)…" lists, "always load", time-stamped guidance, restating the agent name.

**Vague →** `Reviews code.`
**Triggered →** `Reviews TypeScript/React PRs for type safety, accessibility, and dead code. Use when asked to review a diff, audit a PR, or check changed files.`

## Writing the system prompt body

The markdown body (or `prompt:` file) becomes the agent's system prompt — every line loads on every invocation, so be ruthless about terseness.

**Structure:**

1. Role + expertise — one paragraph
2. Workflow — numbered phases or steps
3. Constraints — explicit do / don't
4. Narrow scope beats grab-bag

**Density tools** — prefer the format that conveys the most per token:

- **Tables** for parallel comparisons (modes, options, decision matrices)
- **Code blocks** for exact syntax, commands, config snippets
- **Tight bullets** with bolded leads for scannable rules
- **Short examples** showing *unique* behavior — one good before/after beats four redundant ones

**Cut:**

- Filler: "just", "really", "make sure to", "it's important to note"
- Pleasantries and hedging
- Restating the role across sections
- Multiple examples that demonstrate the same pattern
- "When to use" guidance and invocation patterns — those belong in `description`, not the body

If a sentence wouldn't change the agent's behavior, delete it.

## Quick scaffold

```bash
opencode agent create
```

Interactive: pick scope (global/project), describe purpose, select allowed permissions; everything unselected is denied.

## Common mistakes

- **Bloated description.** It's routing metadata, not docs. One sentence.
- **Examples in `description`.** Belongs in the body or project docs.
- **Wrong mode.** Tab-cycled = `primary`, invoked-only = `subagent`. Don't leave at `all` if the agent shouldn't be both.
- **Overpermissive defaults.** Start restrictive, open as needed. A reviewer doesn't need `edit`.
- **Wildcard ordering.** `*` rule must come before specific overrides — last match wins.
- **Legacy fields.** `tools` and `maxSteps` are deprecated; use `permission` and `steps`.

## References

- [Agents](https://opencode.ai/docs/agents/) — full reference
- [Permissions](https://opencode.ai/docs/permissions/) — permission system details
- [Config schema](https://opencode.ai/config.json)
