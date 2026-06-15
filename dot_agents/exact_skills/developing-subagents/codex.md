# Codex Agents

Codex-specific syntax and behavior. See [SKILL.md](SKILL.md) for cross-platform principles (description, body, permissions philosophy).

Codex custom agents are standalone TOML config layers for spawned sessions, not Markdown frontmatter manifests.

## File locations

| Location | Scope | Notes |
| --- | --- | --- |
| `~/.codex/agents/<name>.toml` | All your projects | Personal agents |
| `.codex/agents/<name>.toml` | Current project | Loads only when the project `.codex/` layer is trusted |

Each file defines one custom agent. `name` inside the TOML is the source of truth; matching filename to name is only a convention.

## TOML format

```toml
name = "code-reviewer"
description = "Reviews code for correctness, security, regressions, and missing tests."
model = "gpt-5.5"
model_reasoning_effort = "high"
nickname_candidates = ["Reviewer-Ruby", "Reviewer-Sapphire", "Reviewer-Emerald"]

developer_instructions = """
Review code like an owner.
Prioritize correctness, security, behavior regressions, and missing test coverage.
Return findings first, with file references and suggested direction.
"""
```

Required: `name`, `description`, `developer_instructions`.

## Fields

| Field | Values | Purpose |
| --- | --- | --- |
| `name` | string | Agent ID Codex uses when spawning or referring to this agent |
| `description` | one sentence | Human-facing guidance for when this agent should be used |
| `developer_instructions` | string | Core behavior instructions; use TOML triple-quoted strings for multi-line prompts |
| `nickname_candidates` | string array | Optional display names used to distinguish concurrent instances of the same agent type |
| `model` | model ID | Per-agent model default |
| `model_reasoning_effort` | `low` / `medium` / `high` | Per-agent reasoning default |
| `mcp_servers` | config tables | Agent-specific MCP config, same shape as `config.toml` |
| `skills.config` | config entries | Enable/disable skill config entries for this spawned session |

Custom agent files can include other supported `config.toml` keys. Omitted keys inherit from the parent session.

## Nicknames

`nickname_candidates` are display names for multiple running instances of the same custom agent type. They are not aliases, synonyms, or routing names. Use them to make concurrent subagents easy to distinguish in the UI and in handoffs.

Format: `<AgentType>-<tag>`, where `AgentType` is the visible agent role (`Dev`, `Medic`, `Manager`, etc.) and `<tag>` comes from one memorable category assigned to that role. Pick a category with at least 10 usable variations so large parallel runs stay readable.

Examples:

```toml
nickname_candidates = [
  "Dev-Blue",
  "Dev-Orange",
  "Dev-Cyan",
  "Dev-Green",
  "Dev-Red",
  "Dev-Purple",
  "Dev-Yellow",
  "Dev-Teal",
  "Dev-Indigo",
  "Dev-Violet",
]
```

Good categories are compact and visually distinct: colors for Devs, fruit for Medics, constellations for Planners, gemstones for Reviewers. Avoid similar role names like `Reviewer`, `Audit`, `Gate`; those read like alternate agent types instead of instance tags.

## Built-ins

Codex ships built-in agents:

| Name | Use |
| --- | --- |
| `default` | General-purpose fallback |
| `worker` | Implementation and fixes |
| `explorer` | Read-heavy codebase exploration |

If a custom agent uses the same `name` as a built-in, the custom agent takes precedence.

## Spawning and orchestration

Codex does not spawn subagents automatically. Ask explicitly:

```text
Review this branch with parallel subagents. Spawn one reviewer for security, one for test gaps, and one for maintainability. Wait for all three, then summarize findings by category with file references.
```

Codex orchestrates spawned agents: it starts threads, routes follow-ups, waits for results, and returns a consolidated summary. Use `/agent` in the CLI to inspect or switch between active agent threads. You can also ask Codex to steer, stop, or close running agents.

Subagent activity is visible in the Codex app and CLI; IDE Extension visibility is documented as forthcoming.

## Global subagent settings

`~/.codex/config.toml` or trusted project `.codex/config.toml`:

```toml
[agents]
max_threads = 6
max_depth = 1
job_max_runtime_seconds = 1800
```

| Field | Default | Purpose |
| --- | --- | --- |
| `agents.max_threads` | `6` | Concurrent open agent thread cap |
| `agents.max_depth` | `1` | Delegation depth; keep default unless recursive delegation is intentional |
| `agents.job_max_runtime_seconds` | per-call default | Timeout for `spawn_agents_on_csv` jobs |

Do not raise `max_depth` casually. Recursive fan-out increases cost, latency, and coordination risk even when `max_threads` caps concurrency.

## Permissions and inheritance

Subagents inherit the current workspace-based permission policy. Runtime overrides from the parent turn are reapplied when Codex spawns a child, including `/permissions` changes and `--yolo`.

Prefer configuring granular filesystem, network, and command policy in shared `config.toml` or project config. Keep agent-local permission config only when the agent genuinely needs a different posture than the parent default.

In interactive CLI sessions, approval requests can surface from inactive agent threads. The overlay labels the source thread; open the thread before approving when the request is surprising.

## Model selection

| Model / effort | Use |
| --- | --- |
| `gpt-5.5` + `high` | Demanding agents: implementation, review, security, ambiguous multi-step work |
| `gpt-5.5` + `medium` | Default serious work |
| `gpt-5.4-mini` + `low`/`medium` | Fast read-heavy scans, exploration, log/document summarization |
| Omit model fields | Let Codex balance intelligence, speed, and price |

Pin model settings only when they change behavior materially. Otherwise inherit the parent/session default.

## Skills, MCP, hooks, and rules

- **Skills:** Installed skills are discoverable by Codex. If an agent must follow a skill, say so in `developer_instructions`; `skills.config` configures skills but is not a preload list.
- **MCP:** Define `[mcp_servers.<name>]` tables using the same shape as `config.toml` when a spawned agent needs a narrower or extra tool surface.
- **Hooks:** Use active `hooks.json` / `[hooks]` config. `SubagentStart` and `SubagentStop` match subagent type; Codex does not have Claude-style per-agent frontmatter hooks.
- **Rules:** Put command approval policy in `rules/*.rules` next to an active config layer. Avoid copying global allow/deny policy into every agent.
- **AGENTS.md:** Keep durable repo behavior in `AGENTS.md` / `AGENTS.override.md`; custom agents should hold role-specific behavior, not restate project instructions.

## Best practices

- Use custom agents for repeatable roles; use direct prompts for one-off parallel fan-out.
- Prefer read-heavy parallel work first: exploration, tests, triage, summarization, review slices.
- Be cautious with parallel write-heavy work; assign explicit paths/worktrees and merge protocol.
- Keep `description` short, concrete, and human-readable. It helps users and Codex choose the right agent after explicit delegation.
- Put role, workflow, output format, and boundaries in `developer_instructions`.
- Do not duplicate global config. Agent TOML earns its lines when it changes model, reasoning, MCP, or role behavior for that agent.

## References

- [Subagents](https://developers.openai.com/codex/subagents)
- [Subagent concepts](https://developers.openai.com/codex/concepts/subagents)
- [Config basics](https://developers.openai.com/codex/config-basic)
- [Permissions](https://developers.openai.com/codex/permissions)
- [Agent Skills](https://developers.openai.com/codex/skills)
- [MCP](https://developers.openai.com/codex/mcp)
- [Hooks](https://developers.openai.com/codex/hooks)
- [Rules](https://developers.openai.com/codex/rules)
- [AGENTS.md](https://developers.openai.com/codex/guides/agents-md)
