# Session runtime

Agent sessions provide subprocesses with stable environment behavior and report meaningful lifecycle state without leaking machine secrets or confusing child activity with the root session.

## Expected behavior

- Inherit the core shell environment while excluding secrets and unstable session variables.
- Provide writable temporary and cache locations through normal platform configuration.
- Prevent Git inspection from taking unnecessary locks and use an explicit agent identity for agent-authored commits.
- Report working, blocked, and idle state to Herdr or Worktrunk when their integrations are active.
- Keep child-agent events from replacing or reviving the root pane's state.
- Notify when a turn completes or user input is required, and prevent idle sleep during long-running work where supported.

## Safety boundary

Lifecycle hooks enforce durable invariants or report state; they do not become a second configuration system. Integration failures are non-fatal unless the guarded invariant itself is safety-critical.

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | SessionStart and PreToolUse hooks, environment file, notifications, and Herdr session reporting | Most explicit lifecycle enforcement, including sandbox temp and Git behavior. |
| Codex | Shell environment policy, hooks, notifier, idle-sleep feature, and Herdr reporting | Strong environment filtering and native lifecycle configuration. |
| OpenCode | Herdr and Worktrunk plugins reacting to session and permission events | Strong event reporting; environment shaping is mostly inherited from the launching shell. |

## Verification

- A build uses the harness-provided writable temp location without ad hoc environment overrides.
- Sensitive environment variables are not propagated into subprocesses unnecessarily.
- Root and child sessions report the correct pane state.
- A completed or blocked turn produces the expected notification or status marker.
