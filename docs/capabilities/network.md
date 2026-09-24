# Network access

Agents reach routine development services through a domain list that both Claude and Codex enforce. A host off the list reaches a reviewer instead of the network.

## Expected behavior

- Reach official documentation, package registries, source-control APIs, and configured work services needed for normal tasks.
- Run local development servers and connect to explicitly granted local sockets.
- Treat web fetching, sandboxed shell networking, and connector access as separate permission surfaces.
- Send unlisted hosts and repository-controlled payloads (source archives, release assets, workflow artifacts, redirected object storage) to review.

## Safety boundary

Provider ownership does not make every path or payload safe. Prefer exact hosts serving a known function; avoid wildcards when the same domain family also serves user-generated or executable content. Host commands (`open` and approved `review-*` families) run outside both network lists.

## Hosts by purpose

Claude lists sandbox hosts in `sandbox.network.allowedDomains` and documentation hosts as `WebFetch(domain:…)` allows. Codex lists all of them in `[permissions.dev.network.domains]`, enforced through `features.network_proxy = true`.

| Purpose | Hosts | Claude | Codex |
| --- | --- | --- | --- |
| Source control | `github.com`, `api.github.com`, `raw.githubusercontent.com`, `results-receiver.actions.githubusercontent.com` | Sandbox | Profile |
| Package registries and toolchains | `registry.npmjs.org`, `jsr.io`, `deno.land`, `dl.deno.land`, `pypi.org`, `pythonhosted.org`, `files.pythonhosted.org`, `releases.astral.sh`, `index.crates.io`, `static.crates.io`, `static.rust-lang.org`, `proxy.golang.org`, `sum.golang.org`, `storage.googleapis.com`, `mise-versions.jdx.dev`, `formulae.brew.sh`, `hub.getdbt.com` | Sandbox | Profile |
| Schemas | `schemastore.org`, `json.schemastore.org`, `www.schemastore.org` | Sandbox | Profile |
| Work and personal services | `api.linear.app`, `api.lightdash.com`, `app.lightdash.cloud`, `analytics.lightdash.cloud`, `api.notion.com`, `api.attio.com`, `readwise.io`, `api.todoist.com`, `context7.com`, `backend.blacksmith.sh`, `clireleases.blacksmith.sh`, `workers.cloudflare.com`, `telemetry.astro.build` | Sandbox | Profile |
| Documentation | Tool and library doc sites (`docs.github.com`, `docs.astral.sh`, `developers.openai.com`, `worktrunk.dev`, and similar) | `WebFetch` only; a shell fetch goes to review | Profile, so shell fetches reach them too |
| Local | `localhost`, `127.0.0.1`, `::1` | `allowLocalBinding` | Listed hosts plus `allow_local_binding` |
| Deliberately unlisted | Binary payload hosts (`objects.githubusercontent.com`, `release-assets.githubusercontent.com`, `codeload.github.com`, `nodejs.org`), warehouse and Google APIs, Hugging Face | Review | Review |

Unix sockets granted in both harnesses: `~/.agent-browser/default.sock`, `~/.config/herdr/herdr.sock`, and `~/.obsidian-cli.sock`. Codex lists them as absolute paths. The Docker socket is not granted; Codex runs read-only Docker inspection as an `open` rule instead.

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | Sandbox domain allowlist, `WebFetch` permissions, local binding, and configured Unix sockets | WebFetch domain rules merge with sandbox network lists; built-in fetch and Bash remain distinct execution surfaces. An unlisted host fails in the sandbox, and the unsandboxed retry goes to the classifier. |
| Codex | `[permissions.dev.network]` domain list, local binding, and Unix sockets, enforced by the network proxy | An unlisted host goes to the auto-reviewer. Web search, apps, MCP, and browser tools keep separate controls. |
| OpenCode | Bash approval policy and tool-specific behavior | No equivalent network allowlist is expressed in the current config. |

## Verification

- `gh run list` works in both sandboxes.
- A known documentation fetch uses its dedicated fetch permission in Claude and the profile list in Codex.
- `curl -sI https://nodejs.org` fails in both sandboxes and reaches review on retry.
- A local development server can bind when the task requires it.
