---
name: codex-config
description: Configure Codex CLI/app/IDE settings. Use when editing Codex config.toml, project .codex layers, permissions, sandbox/approvals, MCP servers, hooks, plugins, skills, TUI settings, models, shell environment policy, or Codex troubleshooting defaults.
---

# Codex Config

Change Codex behavior through the narrowest durable surface. Treat Codex config as layered, security-sensitive TOML; verify active syntax when model, permissions, MCP, hook, or plugin keys matter.

## Chezmoi Sources

Edit chezmoi source, not deployed targets:

| Purpose | Source |
| --- | --- |
| User config | `symsource_codex/config.toml` |
| Hooks | `dot_codex/hooks.json`, `dot_codex/executable_herdr-agent-state.sh` |
| Guidance | `.chezmoitemplates/agents/AGENTS.md`, `.chezmoitemplates/agents/rules/*.md` |
| Shared skills | `dot_agents/exact_skills/<skill>/` |

`symsource_codex/config.toml` is symlinked because Codex writes trust, hook state, plugin, marketplace, and skill-enable state. Do not prune generated tables such as `[projects]`, `[hooks.state]`, `[marketplaces]`, `[plugins]`, or `[[skills.config]]` unless cleanup is the task.

## Layers

Use the smallest surface that matches the request:

| Need | Surface |
| --- | --- |
| One run | CLI flags like `--model` or `-c key=value` |
| Repo-specific behavior | Trusted project `.codex/config.toml` |
| Named local mode | `~/.codex/<profile>.config.toml` with `--profile` |
| Personal defaults | `symsource_codex/config.toml` |
| Organization policy | Managed config or `requirements.toml` |
| Behavioral instructions | `AGENTS.md`, rules, or a skill |
| External tools/data | MCP server or plugin config |
| Lifecycle enforcement | `hooks.json` or inline `[hooks]` |

Precedence is CLI overrides, trusted project config from root to cwd, selected profile file, user config, system config, then built-in defaults. Project `.codex/` layers only load after the project is trusted.

Keep provider auth, credential redirection, notifications, telemetry, profiles, and machine-local commands out of project config; Codex ignores several of those keys there.

## Workflow

1. Identify the scope: one-off, project, profile, user, plugin, or managed.
2. Read current source plus adjacent hook, plugin, or skill files.
3. Refresh official docs before changing active syntax or behavior. Prefer `openai-docs`, then targeted Codex docs.
4. Edit TOML structurally; preserve section order where practical.
5. Validate parse and deployment shape:

```bash
python3 -c 'import sys,tomllib; tomllib.load(open(sys.argv[1], "rb"))' symsource_codex/config.toml
chezmoi --dry-run --no-pager diff
```

## Config Notes

- Prefer documented keys over remembered names.
- Use beta permission profiles or legacy `sandbox_mode` plus `[sandbox_workspace_write]`, never both in one loaded config.
- Load [Permission Profiles](permission-profiles.md) for `default_permissions`, `[permissions.<name>]`, filesystem/network policies, or Claude-style sandbox translation.
- For hooks, use `dot_codex/hooks.json` or inline `[hooks]`; prefer one representation per layer. Codex requires trust review for changed command hooks.
- Use `AGENTS.md`, rules, or skills for behavior instructions; use config for runtime settings.

## Patterns

Use secret indirection, not secret values:

```toml
[mcp_servers.docs]
command = "pnpm"
args = ["dlx", "@example/docs-mcp"]
env_vars = ["DOCS_TOKEN"]
enabled = true
default_tools_approval_mode = "prompt"
```

Keep project defaults portable:

```toml
# .codex/config.toml
model_reasoning_effort = "high"
approval_policy = "on-request"
default_permissions = "project-edit"
```

## Guardrails

- Do not edit `~/.codex/auth.json`, access tokens, API keys, keychains, or copied target files.
- Do not weaken sandboxing, approval prompts, filesystem permissions, network access, hook trust, or secret filtering without explicit user request.
- Do not move caches, logs, or state directories to bypass sandbox failures.
- Do not encode behavior rules as config keys; use `AGENTS.md`, rules, or skills.
- Do not add global package-manager commands or MCP servers from unknown maintainers without reading their source, docs, and install surface.
- Do not assume deprecated model, feature, hook, or MCP names still work.

## Official References

- Codex manual: `https://developers.openai.com/codex/codex-manual.md`
- Config basics: `https://developers.openai.com/codex/config-basic`
- Advanced config: `https://developers.openai.com/codex/config-advanced`
- MCP: `https://developers.openai.com/codex/mcp`
- Hooks: `https://developers.openai.com/codex/hooks`
- Permissions: `https://developers.openai.com/codex/permissions`
