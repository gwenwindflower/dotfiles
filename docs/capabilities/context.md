# Context and extensions

Agents receive the same durable operating guidance and can discover specialized capabilities without loading every detail into every session.

## Expected behavior

- Render shared global rules into each platform's native root context file.
- Keep platform-specific supplements beside the shared context when a harness needs unique guidance.
- Store reusable skills in the shared agent hub and expose them through each platform's supported discovery mechanism.
- Load project and domain docs progressively from clear indexes or instruction paths.
- Keep agent roles semantically aligned while expressing permissions, models, and prompts in native formats.

## Safety boundary

Context files contain durable behavior-changing guidance, not config inventories or session history. Skills and plugins are loaded for relevant tasks, and unknown third-party extensions are reviewed before installation or execution.

Manage external skills through `gh skill`: install/add, update, search, preview, and list are routine within task scope, including user scope. Review destructive removal or forced replacement; raw skill publishing follows the project release-task boundary. Specify the shared agent destination and track approved content back into chezmoi. Do not use package-runner `skills` commands or alternative skill installers.

OpenCode discovers project `AGENTS.md` and `~/.config/opencode/AGENTS.md` natively. No additional instruction paths are needed; root guidance links to domain docs for deliberate loading. See [OpenCode rule discovery](https://opencode.ai/docs/rules/).

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | Rendered `CLAUDE.md`, shared skills symlink, rules, plugins, and agent Markdown | Adds Claude-specific keybinding and hook guidance beside shared rules. |
| Codex | Rendered `AGENTS.md`, shared skills, plugins, apps, MCP servers, and TOML agents | Supports capability packages and connected apps through native registries. |
| OpenCode | Native project/global `AGENTS.md`, shared skills, plugins, and Markdown agents | Loads root guidance directly and follows its documentation links on demand. |

## Verification

- A shared rule change renders into every platform root without duplicating its prose.
- A platform-specific rule affects only the harness that needs it.
- A relevant skill is discoverable without globally loading its full instructions.
- Role names and triggers retain the same meaning across native agent formats.
