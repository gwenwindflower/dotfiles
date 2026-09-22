# Herdr Runtime Patterns

Use this reference for manifest entrypoints, runtime context, socket integration, popups, and long-lived reconciliation.

## Select the Integration Layer

| Need | Interface | Reason |
| --- | --- | --- |
| Ordinary Herdr command | `HERDR_BIN_PATH` | Preserves the installed CLI contract and platform behavior |
| One typed request with exact response handling | Unix socket | Avoids parsing display output |
| Several coordinated requests | Unix socket | Keeps correlation and error handling in one client |
| Long-lived event stream | Unix socket subscription | The connection is the subscription lifecycle |
| Live third-party terminal workflow | Pane or popup entrypoint | Preserves input, color, progress, and cancellation |

Do not build a socket client merely to wrap stable CLI behavior. Do not parse human-readable CLI output when a structured socket response exists.

## Select the Manifest Entrypoint

| Entrypoint | Use for | Lifecycle |
| --- | --- | --- |
| Action | Explicit commands that can finish without owning a terminal surface | One process per invocation |
| Pane | Persistent or directly focused terminal UI | Herdr-managed pane process |
| Popup | Session-modal interactive workflow | Singleton overlay, no pane ID |
| Event | Fast, idempotent notification or reconciler kick | One process per event |
| Startup | Initialization or one reconciler kick | One-shot, not supervised |

Manifest commands are argv arrays:

```toml
[actions.refresh]
title = "Refresh external state"
command = ["example-plugin", "refresh"]
contexts = ["workspace"]
platforms = ["linux", "macos"]
```

Use `sh -c` only when the workflow truly requires shell language. Keep quoting and process composition in Rust otherwise.

## Runtime Environment

Herdr provides the plugin boundary through environment variables:

- `HERDR_SOCKET_PATH`: active session socket.
- `HERDR_BIN_PATH`: the current Herdr executable.
- `HERDR_PLUGIN_ID`: manifest plugin ID.
- `HERDR_PLUGIN_ROOT`: managed source checkout or linked directory.
- `HERDR_PLUGIN_CONFIG_DIR`: user-editable plugin configuration.
- `HERDR_PLUGIN_STATE_DIR`: durable runtime state.
- `HERDR_PLUGIN_CONTEXT_JSON`: structured invocation context.
- `HERDR_PLUGIN_ACTION_ID`: invoked action.
- `HERDR_PLUGIN_ENTRYPOINT_ID`: pane or popup entrypoint when available.
- Workspace, tab, pane, and event variables relevant to the invocation.

Treat context fields as optional unless the manifest context guarantees them. Deserialize only required fields and give fallback order an explicit domain name, such as `source_workspace_cwd`.

For workspace-scoped operations, prefer the workspace root over a focused pane subdirectory. Capture the originating workspace ID and path before opening a popup; focus may change while the overlay is active.

## Storage Boundaries

| Location | Contents |
| --- | --- |
| Plugin root | Shipped assets and source-relative resources |
| Config directory | User-editable settings |
| State directory | Locks, snapshots, process metadata, and durable runtime state |
| Temporary file | One-operation directives and handoff data |

The plugin root may be replaced by installation or upgrades. Never use it for mutable state.

## Typed Socket Client

The socket protocol is newline-delimited JSON. A one-shot request opens a connection, writes one request plus a newline, reads one response, and closes. A subscription keeps its connection open and reads event lines until disconnect.

A reusable client should provide:

- A request ID or correlation ID.
- Structured `result` and `error` decoding.
- Error messages containing method, server code, and server message.
- Read and write timeouts for one-shot calls.
- An unbounded or heartbeat-aware read lifecycle for subscriptions.
- Absolute path validation before path-based requests.
- A single serialization boundary rather than scattered JSON construction.

Query `herdr api schema --json` before adding or changing methods. The installed schema is authoritative for the user's Herdr version.

## Interactive Popup Workflow

Use an action as a launcher and a popup entrypoint as the terminal owner:

```text
action invocation
  -> capture source workspace context
  -> request popup with explicit environment
  -> popup runs installed plugin binary
  -> plugin launches interactive external command
  -> plugin reconciles Herdr state from structured result
```

The popup command must invoke the installed binary by name. Do not point manifest entrypoints at `target/release`, a linked source tree, or Cargo.

For the interactive child process:

- Inherit stdin and stderr.
- Inherit stdout when output is entirely human-facing.
- Pipe stdout only when the command provides a documented machine-readable mode.
- Preserve the child's exit code and distinguish cancellation from failure.
- Treat an empty or cancelled selection as a successful no-op when that matches the external tool.

When the external tool owns creation, hooks, merge, or cleanup, let it complete its native lifecycle. Reconcile Herdr afterward using its structured result or a fresh snapshot. Avoid reimplementing the external tool's lifecycle in the plugin.

If an external command accepts a directive file or environment contract, use that instead of emitting shell code for evaluation.

## Event-Driven Reconciler

Use a reconciler when Herdr must continuously reflect another source of truth.

The event and startup entrypoints should perform a fast `kick`:

1. Derive a session key from the socket path.
2. Acquire a session-scoped lock in the plugin state directory.
3. Return immediately when the watcher is healthy.
4. Spawn the watcher through `current_exe()` when recovery is needed.

The watcher should:

- Maintain one process per Herdr session.
- Own the long-lived `events.subscribe` connection.
- Coalesce bursts before reconciling.
- Poll only state that lacks a useful event, such as focused context.
- Run a low-frequency safety pass for missed events.
- Reconnect after socket interruption.
- Exit when the session is gone.

Each reconciliation pass should snapshot required state once, calculate the desired state in memory, compare it with current state, and issue only necessary mutations. This prevents event echo loops and makes duplicate events harmless.

Stop the watcher before clearing durable state or uninstalling resources.

## Errors and Observability

Errors should identify:

- The operation that failed.
- The workspace, path, or external command involved.
- Whether the external mutation happened.
- The failed Herdr reconciliation step.
- A safe recovery command when available.

Example partial-success shape:

```text
Worktree was created at /absolute/path, but its Herdr workspace could not be opened: <server error>. Run `example-plugin reconcile /absolute/path` to finish setup.
```

Keep normal action output restrained. Add a verbose mode for request payloads, resolved context, external command lines, and reconciliation decisions without printing tokens or unrelated environment values.

## Live Smoke Checks

Verify runtime behavior from a real Herdr session:

```bash
herdr plugin status
herdr plugin action invoke <plugin>.<action>
```

Exercise invocation from the workspace root and a nested pane directory. Confirm that popup workflows preserve their source workspace even when focus changes. For subscriptions, restart Herdr or interrupt the socket and confirm recovery without duplicate watchers.
