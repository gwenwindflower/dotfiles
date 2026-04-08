---
name: develop-opencode-agents
description: Create and configure OpenCode agents (markdown or JSON). Use when creating new agents, fixing agent definitions, or configuring agent options like permissions, mode, model, tools.
---

# OpenCode Agent Development

Create and maintain specialized agents for OpenCode. Agents are AI assistants with custom prompts, models, tool access, and permissions.

## Agent Types

| Type | Mode | Behavior |
| --- | --- | --- |
| Primary | `primary` | Main conversation agents, cycle with Tab |
| Subagent | `subagent` | Invoked by primary agents or via `@mention` |
| All | `all` (default) | Available as both primary and subagent |

Built-in: **Build** (primary, full tools), **Plan** (primary, read-only), **General** (subagent, full tools), **Explore** (subagent, read-only).

## Markdown Agent Format

Place in `~/.config/opencode/agents/` (global) or `.opencode/agents/` (project). Filename becomes the agent name (`librarian.md` -> `librarian` agent).

```yaml
---
description: One concise sentence on what this agent does
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

System prompt content goes here as markdown.
Focus on role, constraints, and workflow.
```

### Frontmatter Fields

Required:

- **description** — Brief sentence. This is what the model sees to decide when to invoke subagents. Keep it short and precise — one sentence, no examples, no multi-paragraph explanations.

Optional:

- **mode** — `primary`, `subagent`, or `all` (default: `all`)
- **model** — Override model (`provider/model-id` format)
- **temperature** — 0.0–1.0 (lower = deterministic, higher = creative)
- **steps** — Max agentic iterations before forced text response
- **disable** — `true` to disable without deleting
- **prompt** — `{file:./path/to/prompt.txt}` for external prompt file
- **hidden** — `true` to hide subagent from `@` autocomplete (still invocable via Task tool)
- **color** — Hex (`#FF5733`) or theme name (`primary`, `accent`, `error`, etc.)
- **top_p** — 0.0–1.0, alternative to temperature

### Permissions

Control tool access per-agent. Values: `allow`, `ask`, `deny`.

```yaml
permission:
  edit: deny
  bash:
    "*": ask
    "git status *": allow
    "git diff *": allow
  webfetch: deny
  task:
    "*": deny
    "explore": allow
```

Rules are evaluated in order — **last matching rule wins**. Put `*` wildcards first, specific overrides after.

The deprecated `tools` field (`write: false`, `edit: false`, etc.) still works but prefer `permission` for new agents.

### Task Permissions

Control which subagents an agent can invoke:

```yaml
permission:
  task:
    "*": deny
    "explore": allow
    "code-reviewer": ask
```

When set to `deny`, the subagent is removed from the Task tool description entirely.

## System Prompt Best Practices

The markdown body below the frontmatter is the system prompt. Write it as instructions to the agent:

1. **Open with role and expertise** — one paragraph establishing who the agent is
2. **Define the workflow** — numbered phases or steps the agent follows
3. **Set constraints** — what the agent should and should not do
4. **Keep it focused** — an agent that tries to do everything does nothing well

Avoid putting examples, invocation patterns, or "when to use" guidance in the system prompt. That belongs in the description (for model routing) or in project context files (for user reference).

## JSON Configuration

Agents can also be configured in `opencode.json`:

```json
{
  "agent": {
    "review": {
      "description": "Reviews code for best practices",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-20250514",
      "permission": {
        "edit": "deny",
        "bash": {
          "*": "ask"
        }
      }
    }
  }
}
```

Agent-specific config overrides global config. Additional provider-specific options (like `reasoningEffort`) pass through directly to the model.

## Common Mistakes

- **Bloated descriptions**: The description field is for model routing, not documentation. One sentence.
- **Examples in frontmatter**: Description should not contain example user/assistant exchanges. Those belong in the system prompt or project docs if needed at all.
- **Wrong mode**: If an agent should only be invoked by other agents or `@mention`, use `subagent`. If users should Tab to it, use `primary`.
- **Overpermissive tools**: Start restrictive, grant access as needed. A review agent shouldn't have write access.
- **No permission field**: Using the deprecated `tools` field instead of `permission`. Migrate to `permission` for new agents.

## Additional Resources

- [OpenCode Agents docs](https://opencode.ai/docs/agents/) — full reference
- [OpenCode Permissions docs](https://opencode.ai/docs/permissions/) — permission system details
