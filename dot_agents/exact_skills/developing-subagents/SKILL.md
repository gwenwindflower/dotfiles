---
name: developing-subagents
description: Design subagents — specialized assistants with their own system prompt, model, and permissions. Use when adding or modifying subagents for Claude Code, OpenCode, Codex, or equivalent coding agent platforms.
---

# Developing Subagents

Subagents isolate verbose work from parent context, encode repeated workflows, and route narrower tasks to cheaper models. Prefer orchestration from the main conversation; nested delegation is platform-specific, harder to predict, and more expensive. Compose reusable workflow knowledge with Skills.

## Platforms

- [Claude Code](claude-code.md) — `.claude/agents/`, frontmatter fields, permission modes, hooks, skills, memory, MCP scoping
- [OpenCode](opencode.md) — `.opencode/agents/`, primary/subagent modes, per-tool allow/ask/deny, cascade rules, JSON form
- [Codex](codex.md) — `.codex/agents/`, TOML custom agents, explicit parallel spawning, inherited sandbox/config, global `[agents]` limits

## When to make a subagent

- A workflow keeps repeating with the same instructions — encode it once.
- A task floods main context (large searches, log processing, full-file reads).
- The job needs a different system prompt, model, or permissions than the parent.

If a Skill carries the same instructions, prefer the Skill — Skills compose across agents and platforms.

## Description: selection metadata

The description is the first field agents and users see when deciding what to invoke. Treat it like a Skill description.

- One sentence, third person. Never "I can…" / "You can…".
- Lead with a verb phrase, then concrete triggers — file types, CLI names, domain terms users actually say.
- Slightly directive — agents under-trigger by default.
- Add `Skip when …` only when an adjacent agent in the same project would otherwise mistrigger.
- In YAML frontmatter, avoid colons in descriptions so the value can stay unquoted. Use em dashes, semicolons, or a second sentence for separation.

**Cut:** numbered `(1)…(2)…` lists, long repetitive variations, "always load", time-stamped guidance, restating the agent name, comparisons to platforms or tools the user isn't using.

**Vague →** `Reviews code.`
**Triggered →** `Reviews TypeScript/React PRs for type safety, accessibility, and dead code. Use when asked to review a diff, audit a PR, or check changed files.`

## System prompt body / developer instructions

The body (or Codex `developer_instructions`) is the agent's behavioral prompt — every line loads on every invocation.

**Structure:**

1. Role + expertise — one paragraph
2. Workflow — numbered phases
3. Output format — what the parent gets back, especially what *not* to include
4. Constraints — explicit do / don't

**Density tools:** tables for parallel comparisons, code blocks for exact syntax, tight bullets with bolded leads, short examples that show *unique* behavior — one good before/after beats four redundant ones.

**Cut:** filler ("just", "really", "make sure to"), pleasantries, hedging, repeated role statements, multiple examples of the same pattern, "when to use" guidance (that's the description's job).

If a sentence wouldn't change behavior, delete it.

## Permissions: block risk, don't strangle the agent

Default to **blocking risk**, not allowlisting the smallest possible tool surface. A subagent with too few tools is worse than one with default permissions — it gets stuck and surfaces brittle "I can't" messages instead of doing the job.

Reach for tight allowlists when:

- The agent's purpose involves **destructive operations** (deletion, force-push, irreversible state).
- The agent handles **secrets, credentials, or sensitive data** where a wandering tool call could leak.
- The agent must produce **read-only output** (reviewer, auditor, planner).

Otherwise:

- Inherit defaults, then deny the specific things this agent shouldn't do.
- Block specific risky operations rather than allow only the narrowest set.
- Don't strip tools because the agent "shouldn't need them" — a reviewer may want `WebFetch` for docs or `Bash` for `git log`. Strip only what creates real risk.

### Don't echo platform settings

Manifest config earns its line when it does something the platform's global settings don't already do. Read the global config before adding any permission entry — restating rules already in `~/.claude/settings.json`, `~/.config/opencode/opencode.jsonc`, or `~/.codex/config.toml` is dead config that drifts from source.

What belongs:

- **Tightening past the global default** — denying SPEC edits for an executor, narrowing `task` to one or two subagents.
- **Loosening for this agent only** — `git rebase *` for a Manager when global only allows read-only git, domain CLIs not on the global allowlist.
- **Routing fields the global can't express** — model, mode, memory, hooks, isolation, MCP filters.

What to leave out:

- Patterns already on the global allow/denylist.
- Defaults already in force at the platform level.
- Defensive restrictions that don't remove real risk.
