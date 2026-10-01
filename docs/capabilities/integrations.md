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
| `agent-browser` capture (`screenshot`, `snapshot`, `pdf`, `close`), any profile | `open` | Chromium cannot launch inside either sandbox. |
| `agent-browser` interaction with a named non-Default profile | `review` | |
| `agent-browser` Default profile beyond capture; `cookies`, `storage`, `state` | `review` (on request) | The Default profile reaches Keychain-backed signed-in state. |
| `herdr` reads (lists, `pane read`, `status`) | `sandboxed` | Through the granted `herdr.sock`. |
| `herdr` pane, tab, and agent control; server, config, and integration administration | `review` | Control covers panes and agents the session created or the user named. |
| `linear-cli` reads | `sandboxed` | Its cache directory is writable and the keychain works in both sandboxes. |
| `linear-cli` issue, comment, bulk, and `api mutate` writes | `review` | Lightdash workspace. |
| `linear-cli auth status`, masked `config show`/`get`, workspace reads | `sandboxed` | Codex routes `config get` to review to check `api-key --raw` in any flag position. |
| `linear-cli` authentication, setup, and config writes | `review` | Routine in task scope; interactive prompts remain with the user. |
| `lightdash` compile, validate, SQL, and reads | `sandboxed` | The CLI rewrites `~/.config/lightdash` on every run. |
| `lightdash` upload, deploy, preview, refresh, set-warehouse, rename | `review` | Production projects are `review` (on request). |
| `lightdash login`, `lightdash config set-project` | `review` | Routine in task scope; project selection does not authorize production writes. |
| `op read`, `op inject`, `op run` | `user-open` | Codex: `review` (on request), approved only when the user named the item and destination. |
| `op` listing, reveal, and administration | `deny` | |
| Service logins, logout, refresh, and account switching (`gcloud`, `wrangler`, `fly`/`flyctl`, `codex`/`claude`); `rclone config password`/`reconnect` | `review` | Routine through the owning CLI; no credential extraction. |
| Token printing and unmasked config reads | `deny` | Includes `gh auth status -t`/`--show-token`, `linear-cli config get api-key --raw`, gcloud ADC token printing, `fly`/`flyctl auth token`, and `rclone config show`/`dump`. See [remote environments](environments.md#levels) for Fly and Wrangler token output. |
| Warehouse reads (`bq query`, `dbt run`/`build`) against non-production targets | `review` | Warehouse hosts are unlisted, so these reach review. |
| Warehouse mutations (DDL, DML, `bq rm`/`mk`/`load`) | `review` (on request) | |
| `rclone` listing and copy | `review` | Remote hosts are unlisted. |
| `rclone sync`, `move`, `delete`, `purge` | `review` (on request) | |

Remote environment CLIs are covered in [remote environments](environments.md#levels).

## agent-browser

`agent-browser` is available on every harness. `~/.agent-browser` holds browser binaries, sockets, sessions, and encryption state; `~/.cache/puppeteer` is the fallback browser cache. Both are writable, and `~/.agent-browser/default.sock` is granted in both sandboxes. The command patterns guide review rather than forming a security boundary; credentials stay protected by the Default-profile gate and by never exporting session state.

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | Plugins, marketplaces, optional Claude.ai MCP servers, CLI tools, and agent-browser | `open` families are excluded with an allow; service writes and authentication reach the classifier; `op` secrets are `ask`. Token output has narrow denies plus reviewer coverage for alternate forms. |
| Codex | Plugins, apps, MCP servers, browser integration, artifact skills, and command rules | Service writes and authentication reach review; token output is forbidden. `gh auth status` and `linear-cli config get` reach review for flags beyond literal-prefix coverage. Families that fail in the sandbox escalate to the reviewer with no rule. |
| OpenCode | Plugins, configured language tooling, and shell CLIs | Ordered rules allow masked auth/config reads and deny standard token-output forms. Other commands use the existing permission defaults. Alternate global-flag placement and arbitrary short-flag clusters lack reviewer coverage: OpenCode `--auto` approves every ask without an intent-sensitive review. |

## Verification

- An enabled integration can perform its documented in-scope read operation from the sandbox.
- Capture commands run without review, including with `--profile Default`.
- A non-capture Default-profile command is approved only when the current request explicitly authorizes it.
- An `op read` in Claude prompts the user; in Codex it reaches the reviewer.
- Credentials remain in their owning authentication store.
- Disabled or unknown integrations are not activated as a workaround.
