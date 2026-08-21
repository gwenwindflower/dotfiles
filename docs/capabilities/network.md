# Network access

Agents can use routine development services while network permission remains narrower than general internet access.

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
| Claude Code | Sandbox domain allowlist, `WebFetch` permissions, local binding, and the agent-browser socket | Separates shell networking from built-in fetching; unlisted destinations retain the approval path. |
| Codex | Workspace networking, permission-profile domains, local binding, and Unix sockets | Sandboxed commands use the domain policy; web search, apps, MCP, and browser tools have separate controls. |
| OpenCode | Bash approval policy and tool-specific behavior | No equivalent network allowlist is expressed in the current config. |

## Verification

- Official CLI metadata requests such as `gh run list` work in the sandbox.
- A known documentation fetch uses its dedicated fetch permission rather than a shell-network wildcard.
- A redirect to an unlisted artifact or object-storage host is not silently approved.
- A local development server can bind when the task requires it.
