# Integrations

Agents can use external services, browsers, and artifact tools through scoped interfaces without embedding credentials or assuming broad authority.

## Expected behavior

- Prefer a platform connector, plugin, or established CLI when it offers narrower and more observable access than arbitrary shell automation.
- Use authenticated sessions and environment indirection without printing, copying, or persisting tokens in config.
- Support browser automation, issue and project systems, data services, and document or visualization workflows when their capability is enabled.
- Keep optional integrations disabled until they have a real use and understood permission surface.
- Treat each external write, message, publication, or deployment according to the user's task authority.

## Safety boundary

Installing an integration grants capability, not blanket permission to use it for external effects. Unknown repositories, plugins, MCP servers, and package installers require source and permission review.

Broad CLI grants such as `linear-cli *`, `blacksmith *`, or `herdr *` do not authorize messages, ticket changes, remote job execution, or control of another agent. Check the operation and the user's requested scope; shell rules do not cover connector tool calls. Never run `op` or `gh auth token` to expose credentials. Codex's explicit credential-command prohibitions supplement its environment filtering without claiming to block every possible secret reader.

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | Plugins, marketplaces, optional Claude.ai MCP servers, CLI tools, and agent-browser | Current config favors language tooling and Worktrunk; general Claude.ai MCP access is disabled. |
| Codex | Plugins, apps, MCP servers, browser integration, artifact skills, and scoped command rules | Broadest native integration catalog; host-only CLIs may allow routine reads while routing destructive or bulk mutations through Auto-review. |
| OpenCode | Plugins, configured language tooling, and shell CLIs | Smaller native integration surface; external capabilities primarily arrive through plugins and established CLIs. |

## Verification

- An enabled integration can perform its documented in-scope read operation.
- Credentials remain in their owning authentication store.
- An external write still requires task authority even when the connector is enabled.
- Disabled or unknown integrations are not activated as a workaround.
