# Agent configuration intent

Claude Code, Codex, and OpenCode should provide the same practical capabilities where their harnesses permit it. Their configs are authored independently with platform-native controls; parity means equivalent observable behavior and safety boundaries, not matching settings or generated entries.

## Contract layers

Every capability distinguishes three controls:

1. **Sandbox access** — what a local process can technically reach.
2. **Approval policy** — what can happen automatically, what requires review, and what is blocked.
3. **Agent guidance** — what the agent should choose within its technical permissions.

A domain allowed by the sandbox is not automatically trusted content. A command approved by policy is not automatically the right action.

## Evidence

- Claude Code has the broadest configuration surface and is the first inventory source, not the canonical implementation.
- Behavior represented across multiple agents is the strongest evidence of shared intent.
- A capability present in one agent still belongs here when it is useful beyond that harness.
- Harness-only mechanics belong in platform notes unless they express a shared user-facing goal.
- Unknown or partial parity is recorded directly instead of hidden behind similar-looking config entries.

## Configuration surfaces

| Platform | Primary config | Supporting surfaces |
| --- | --- | --- |
| Claude Code | `symsources/claude/settings.json` | `dot_claude/exact_hooks/`, `dot_claude/exact_agents/`, `dot_claude/CLAUDE.md.tmpl` |
| Codex | `symsources/codex/config.toml` | `dot_codex/hooks.json`, `dot_codex/exact_agents/`, `dot_codex/AGENTS.md.tmpl` |
| OpenCode | `private_dot_config/opencode/opencode.jsonc` | `private_dot_config/opencode/plugins/`, `private_dot_config/opencode/exact_agents/`, `private_dot_config/opencode/tui.jsonc` |
| Shared | `.chezmoitemplates/agents/` | `dot_agents/exact_skills/`, `dot_agents/exact_rules/` |

## Capabilities

| Domain | Goal |
| --- | --- |
| [Workspace access](capabilities/workspace.md) | Work freely in the active project while protecting credentials and unrelated user state. |
| [Network access](capabilities/network.md) | Reach routine service and documentation endpoints without treating hosted content as inherently trusted. |
| [Development workflows](capabilities/development.md) | Run normal inspection, formatting, validation, test, and build loops with minimal friction. |
| [Git and worktrees](capabilities/git.md) | Inspect and change repositories safely, with clear ownership for commits, remotes, and parallel work. |
| [Delegation](capabilities/delegation.md) | Use specialized helpers without losing scope, context, or ownership boundaries. |
| [Context and extensions](capabilities/context.md) | Discover shared guidance and reusable capabilities through each platform's native mechanisms. |
| [Integrations](capabilities/integrations.md) | Use browsers, services, and artifact tools without embedding credentials or broad implicit authority. |
| [Session runtime](capabilities/session.md) | Give subprocesses stable environment, lifecycle, and state-reporting behavior. |
| [Interaction](capabilities/interaction.md) | Preserve a consistent terminal interaction model across different agent interfaces. |

## Changing agent configuration

- Start from the capability and expected behavior, then inspect every applicable platform.
- Separate sandbox access, approval posture, and guidance before choosing settings.
- Prefer each harness's native mechanism; do not add translation machinery solely to make configs resemble one another.
- Record deliberate differences and missing enforcement in the relevant capability file.
- Verify both the useful path and its safety boundary with a realistic task.
- Update these docs only when intended behavior changes; mechanical config edits do not need documentation churn.
