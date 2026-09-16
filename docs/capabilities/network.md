# Network access

Agents should reach routine development services through scoped network access. Current harness coverage differs; enabled networking is not equivalent to a domain allowlist.

## Expected behavior

- Reach official documentation, package registries, source-control APIs, and configured work services needed for normal tasks.
- Run local development servers and connect to explicitly approved local sockets.
- Use GitHub metadata endpoints for repository, pull request, and workflow inspection.
- Treat web fetching, browser navigation, sandboxed shell networking, and connector access as separate permission surfaces.
- Request approval for unlisted hosts and repository-controlled payloads such as source archives, release assets, workflow artifacts, and redirected object storage.

## Safety boundary

Provider ownership does not make every path or payload safe. Prefer exact hosts serving a known function; avoid broad wildcards when the same domain family also serves user-generated or executable content.

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | Sandbox domain allowlist, `WebFetch` permissions, local binding, and configured Unix sockets | WebFetch domain rules merge with sandbox network lists; built-in fetch and Bash remain distinct execution surfaces. Excluded host commands are outside the network sandbox. |
| Codex | `sandbox_workspace_write.network_access = true` | Outbound networking is enabled without a configured domain proxy or Unix-socket allowlist. Task authority and automatic review govern network use. Web search, apps, MCP, and browser tools retain separate controls. |
| OpenCode | Bash approval policy and tool-specific behavior | No equivalent network allowlist is expressed in the current config. |

## Verification

- Official CLI metadata requests such as `gh run list` work in the sandbox.
- A known documentation fetch uses its dedicated fetch permission rather than a shell-network wildcard.
- Verify redirects and artifact downloads against task authority. Claude enforces its domain policy; Codex and OpenCode have no equivalent configured domain gate.
- A local development server can bind when the task requires it.
