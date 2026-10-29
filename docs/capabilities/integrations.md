# Integrations

Agents can use external services, browsers, and artifact tools through scoped interfaces without embedding credentials or assuming broad authority.

## Expected behavior

- Prefer a platform connector, plugin, or established CLI when it offers narrower and more observable access than arbitrary shell automation.
- Authenticate through the owning tool without printing, copying, or persisting tokens in config.
- Support browser automation, issue and project systems, data services, and document or visualization workflows when their capability is enabled.
- Keep optional integrations disabled until they have a real use and understood permission surface.
- Treat each external write, message, publication, or deployment according to the user's task authority.

## Safety boundary

Installing an integration grants capability, not blanket permission to use it for external effects. Unknown repositories, plugins, MCP servers, and package installers require source and permission review. Shell rules do not cover connector tool calls.

Tools whose tokens live in the keychain work in both sandboxes. Tools whose config file holds their own token (lightdash, rclone, wrangler) get write access to that directory, listed in [workspace access](workspace.md#paths-by-purpose).

## Levels

| Family | Level | Notes |
| --- | --- | --- |
| `agent-browser` capture (`screenshot`, `snapshot`, `pdf`, `close`), any profile | `host-allowed` | Chromium cannot launch inside either sandbox. |
| `agent-browser` interaction with a named non-Default profile | `auto-reviewed` | |
| `agent-browser` Default profile beyond capture; `cookies`, `storage`, `state` | `auto-reviewed` (on request) | The Default profile reaches Keychain-backed signed-in state. |
| `cap` diagnostics, capture-target listing, and local recording reads | `host-allowed` | See [video production](#video-production). |
| `cap` library and job reads (`caps list`/`get`/`context`/`status`/`wait`/`transcript`, `jobs`) | `host-allowed` | Codex: `sandboxed-unruled`, since its sandbox reaches `cap.so`. |
| `cap record`, including device and session listings | `user-reviewed` | Codex: `auto-reviewed` (on request). An agent never starts the screen or camera on its own. |
| `cap screenshot`, `export`, `caps download` | `auto-reviewed` | Screen capture happens only for the task in hand. |
| `cap upload`; Cap library, sharing, account, organization, and developer writes; `caps process`; `agents install` | `auto-reviewed` (on request) | Upload publishes a shareable link, and processing can spend credits. |
| Descript connector reads, imports, Underlord prompts, timeline exports, upload reports, job cancels | `auto-reviewed` | Routine in task scope. Prompts spend the Drive's AI credits. |
| Descript `publish_project` | `auto-reviewed` (on request) | Publishing overwrites the composition's earlier share URL. |
| `herdr` reads: `list` and `get` in every group, `pane current`/`layout`/`process-info`/`neighbor`/`edges`/`read`/`wait-output`, `agent read`/`wait`/`explain`, `session list`, `status` | `sandboxed-allowed` | Through the granted `herdr.sock`. |
| `herdr` layout: `pane split`/`resize`/`zoom`/`rename`/`swap`/`move`, `tab create`/`rename`, `workspace create`/`rename`, `worktree open`, `agent start`/`rename`, `notification show` | `sandboxed-allowed` | Adds or rearranges panes without running anything in them. |
| `herdr` input: `pane run`/`send-text`/`send-keys`, `agent prompt`/`send-keys`/`attach` | `auto-reviewed` | Pane shells run on the host, and keys sent to an agent can answer its permission prompts. |
| `herdr` close, stop, and delete for panes, tabs, workspaces, and sessions | `auto-reviewed` | Only for what the session created or the user named. |
| `herdr` focus, `report-*`, `release-agent`, `worktree create`/`remove`; server, config, and integration administration | `auto-reviewed` | Focus stays with the user, status reports belong to hooks, and worktrees go through `wt`. |
| Version-matched CLI briefings (`herdr --skill`, `hunk skill`, `agent-browser skills`) | `sandboxed-allowed` | |
| `hunk session` reads, navigation, comments, highlights, and reloads | `sandboxed-allowed` | Reaches the Hunk daemon on `127.0.0.1:47657`, so a reviewing agent can annotate a live review without a prompt each call. |
| `hunk daemon restart` | `auto-reviewed` | Hunk's briefing has the agent ask first, since a restart reattaches every open review window. |
| `linear-cli` reads | `sandboxed-unruled` | Its cache directory is writable and the keychain works in both sandboxes. |
| `linear-cli` issue, comment, bulk, and `api mutate` writes | `auto-reviewed` | Lightdash workspace. |
| `linear-cli auth status`, masked `config show`/`get`, workspace reads | `sandboxed-unruled` | Codex routes `config get` to review to check `api-key --raw` in any flag position. |
| `linear-cli` authentication, setup, and config writes | `auto-reviewed` | Routine in task scope; interactive prompts remain with the user. |
| `lightdash` compile, validate, SQL, and reads | `sandboxed-unruled` | The CLI rewrites `~/.config/lightdash` on every run. |
| `lightdash` upload, deploy, preview, refresh, set-warehouse, rename | `auto-reviewed` | Production projects are `auto-reviewed` (on request). |
| `lightdash login`, `lightdash config set-project` | `auto-reviewed` | Routine in task scope; project selection does not authorize production writes. |
| `op read`, `op inject`, `op run` | `user-reviewed` | Codex: `auto-reviewed` (on request), approved only when the user named the item and destination. |
| `op` listing, reveal, and administration | `denied` | |
| Service logins, logout, refresh, and account switching (`gcloud`, `wrangler`, `fly`/`flyctl`, `codex`/`claude`); `rclone config password`/`reconnect` | `auto-reviewed` | Routine through the owning CLI; no credential extraction. |
| Token printing and unmasked config reads | `denied` | Includes `gh auth status -t`/`--show-token`, `linear-cli config get api-key --raw`, gcloud ADC token printing, `fly`/`flyctl auth token`, and `rclone config show`/`dump`. See [remote environments](environments.md#levels) for Fly and Wrangler token output. |
| Warehouse reads (`bq query`, `dbt run`/`build`) against non-production targets | `auto-reviewed` | Warehouse hosts are unlisted, so these reach review. |
| Warehouse mutations (DDL, DML, `bq rm`/`mk`/`load`) | `auto-reviewed` (on request) | |
| `rclone` listing and copy | `auto-reviewed` | Remote hosts are unlisted. |
| `rclone sync`, `move`, `delete`, `purge` | `auto-reviewed` (on request) | |

Remote environment CLIs are covered in [remote environments](environments.md#levels).

## agent-browser

`agent-browser` is available on every harness. `~/.agent-browser` holds browser binaries, sockets, sessions, and encryption state; `~/.cache/puppeteer` is the fallback browser cache. Both are writable, and `~/.agent-browser/default.sock` is granted in both sandboxes. The command patterns guide review rather than forming a security boundary; credentials stay protected by the Default-profile gate and by never exporting session state.

## Video production

The `video-production` skill covers both tools; Cap's and Descript's own skills are its upstreams.

`cap` is the CLI bundled with Cap Desktop. Screen-recording permission belongs to the host process, so in either sandbox `doctor` reports it `denied` and `targets` lists one empty display. In Claude's sandbox, every networked `cap` command also panics inside its macOS proxy lookup before reaching the proxy, so Claude excludes the whole command and the classifier reviews whatever has no allow. Codex reaches `cap.so` from the sandbox and runs only capture on the host.

Descript is a remote MCP connector managed in the Claude and Codex desktop apps, like every other remote MCP server; neither harness config declares it, and a terminal session gets it only when launched to inherit the desktop connectors. Local-file imports `PUT` to a presigned `storage.googleapis.com` URL, which both sandboxes already list.

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | Plugins, marketplaces, optional Claude.ai MCP servers, CLI tools, and agent-browser | `host-allowed` families are excluded with an allow; service writes and authentication reach the classifier; `op` secrets are `ask`. Token output has narrow denies plus reviewer coverage for alternate forms. |
| Codex | Plugins, apps, MCP servers, browser integration, artifact skills, and command rules | Service writes and authentication reach review; token output is forbidden. `gh auth status` and `linear-cli config get` reach review for flags beyond literal-prefix coverage. Families that fail in the sandbox escalate to the reviewer with no rule. |
| OpenCode | Plugins, configured language tooling, and shell CLIs | Ordered rules allow masked auth/config reads and deny standard token-output forms. Other commands use the existing permission defaults. Alternate global-flag placement and arbitrary short-flag clusters lack reviewer coverage: OpenCode `--auto` approves every ask without an intent-sensitive review. |

## Verification

- An enabled integration can perform its documented in-scope read operation from the sandbox.
- Capture commands run without review, including with `--profile Default`.
- A non-capture Default-profile command is approved only when the current request explicitly authorizes it.
- An `op read` in Claude prompts the user; in Codex it reaches the reviewer.
- Credentials remain in their owning authentication store.
- Disabled or unknown integrations are not activated as a workaround.
