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

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | Plugins, marketplaces, optional Claude.ai MCP servers, CLI tools, and agent-browser | Current config favors language tooling and Worktrunk; general Claude.ai MCP access is disabled. |
| Codex | Plugins, apps, MCP servers, browser integration, and artifact skills | Broadest native integration catalog; individual apps and servers retain enablement state. |
| OpenCode | Plugins, configured language tooling, and shell CLIs | Smaller native integration surface; external capabilities primarily arrive through plugins and established CLIs. |

## Verification

- An enabled integration can perform its documented in-scope read operation.
- Credentials remain in their owning authentication store.
- An external write still requires task authority even when the connector is enabled.
- Disabled or unknown integrations are not activated as a workaround.
