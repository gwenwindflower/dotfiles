---
name: agent-config
description: Coding agent harness config - Claude Code hooks and settings, Codex config.toml layers, sandbox and approvals, permission profiles, MCP, plugins.
---

# Agent config

Runtime settings for coding agent harnesses in this dotfiles repo. `docs/agent-config.md` is the semantic contract (sandbox access, approval policy, and agent guidance as three separate controls); read it before changing any agent's settings.

| Platform | Doc |
| --- | --- |
| Claude Code hooks, helpers, JSON output | [claude-code-hooks](claude-code-hooks.md) |
| Codex layers, sources, workflow, guardrails | [codex](codex.md) |
| Codex sandbox profiles, execution rules, and the auto-review policy fork | [codex-permission-profiles](codex-permission-profiles.md) |

## Permission changes

In this dotfiles repo, allow, ask, deny, sandbox, network, rule, and reviewer changes follow the loop in `docs/agent-config.md` under "Changing agent configuration": contract docs first, then a probe in `.utils/agency.toml`, then each native config, then `agency` must pass.

## Shared rules

- Edit chezmoi sources, never deployed targets. Symlinked settings (`symsources/claude/settings.json`, `symsources/codex/config.toml`) are written by the tools too; keep their generated tables.
- Behavior instructions belong in AGENTS.md, rules, or skills (see `agent-context-engineering`); config holds runtime settings only.
- Never weaken sandboxing, approvals, hook trust, or secret filtering without an explicit request.
- Refresh official docs before changing active syntax; hook events, keys, and profile fields move between releases.
