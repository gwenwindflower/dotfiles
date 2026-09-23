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

## agent-browser

`agent-browser` is an available browser-automation CLI on every harness. Its state/cache roots are writable: `~/.agent-browser` owns browser binaries, sockets, sessions, and encryption state, while `~/.cache/puppeteer` is the fallback browser cache.

Claude Code runs `agent-browser` as an excluded host command because Chromium needs macOS services outside its Bash sandbox. Codex grants host execution only to allowlisted operations for the same reason. OpenCode already runs shell commands on the host.

Commands ask by default. Screenshot, snapshot, PDF, and close operations are allowed without review, including with `--profile Default`. Other commands using a named non-Default profile are generally routine for development work. The Default profile can access Keychain-backed signed-in browser state, so other commands using it are approved automatically only when the user's current request explicitly authorizes that use; otherwise they prompt.

These command patterns guide review rather than forming a security boundary. Credentials remain protected by auth proxies, sandbox isolation, and remote execution environments.

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | Plugins, marketplaces, optional Claude.ai MCP servers, CLI tools, and agent-browser | Safe operations are static allows; auto-mode generally approves named non-Default profiles and conditionally reviews other Default-profile commands against the current request. |
| Codex | Plugins, apps, MCP servers, browser integration, artifact skills, and command rules | Safe operations run outside the sandbox; other commands use Auto-review, which follows the profile guidance and current task authority. |
| OpenCode | Plugins, configured language tooling, and shell CLIs | Ordered rules ask by default, allow named profiles, ask again for Default, then allow safe operations. OpenCode `--auto` approves every ask without an intent-sensitive review. |

## Verification

- An enabled integration can perform its documented in-scope read operation.
- Screenshot, snapshot, PDF, and close commands match the safe allow rules.
- Named non-Default profiles are approved for in-scope development work.
- A non-safe Default-profile command is approved only when the current request explicitly authorizes it; otherwise it prompts.
- Credentials remain in their owning authentication store.
- An external write still requires task authority even when the connector is enabled.
- Disabled or unknown integrations are not activated as a workaround.
