---
name: rust-herdr-plugins
description: Build, extend, test, distribute, and release portable Rust plugins for Herdr using Gwen Windflower's preferred patterns. Use when working on a Rust-based Herdr plugin she maintains to keep Herdr-specific functionality cohesive on top of the standard tool repository from bootstrap-tool.
---

# Rust Herdr Plugins

Build Herdr plugins as portable tools with a stable binary interface. Keep Herdr integration in typed Rust boundaries instead of shell glue.

## Establish Current Authority

1. Load the core `herdr` skill and follow its CLI, schema, runtime-safety, and workspace-control guidance throughout the task.
2. Read the repository instructions and existing project docs.
3. Inspect `herdr-plugin.toml`, `Cargo.toml`, `mise.toml`, `mise-tasks/`, the binary entrypoint, installer, tests, and workflows.
4. Run `mise tasks` before running anything else. The task list is the project's command surface; prefer a task over the command it wraps, and add a task rather than running a one-off.
5. Check the installed CLI before changing integration behavior:

   ```bash
   herdr --help
   herdr api schema --json
   ```

6. Consult the official [plugin guide](https://herdr.dev/docs/plugins/) and [socket API](https://herdr.dev/docs/socket-api/) for behavior not expressed by the installed schema.
7. Read [references/herdr-runtime.md](references/herdr-runtime.md) when changing manifests, actions, panes, events, context, storage, or socket behavior.
8. Read [references/rust-project-patterns.md](references/rust-project-patterns.md) when changing the manifest, installer, version hooks, or plugin tasks. The repository itself comes from `bootstrap-tool`; the task layer, release pipeline, and workflows are covered by `mise-projects`, `releasing-tools`, and `github-actions-workflows`.

## Choose the Runtime Shape

Use the smallest topology that owns the required lifecycle:

- Use an action or pane command for explicit, short-lived user workflows.
- Use an action that launches a popup when the user must interact with live terminal output.
- Use an event-driven reconciler when Herdr state must continuously reflect external state.
- Use the Herdr CLI through `HERDR_BIN_PATH` for ordinary commands.
- Use a typed socket client for exact request/response control, batching, or long-lived event subscriptions.

Keep domain decisions independent from Herdr and third-party command execution. Represent those systems as narrow adapters so tests can prove the user-visible workflow without launching a live Herdr session.

## Build the Feature

1. Sharpen the workflow vocabulary before naming commands, actions, modules, or state.
2. Write a failing test for each user-visible requirement.
3. Add the smallest manifest surface and binary command that can satisfy the workflow.
4. Parse only the context fields the command needs and preserve useful fallbacks.
5. Let interactive child processes inherit the terminal. Capture only machine-readable output used for reconciliation.
6. Make reconciliation idempotent: snapshot once, calculate desired state, and emit only necessary changes.
7. Return actionable errors that name the failed operation, relevant workspace or path, and recovery command when one exists.
8. Update install, manifest, and live-smoke tests with the behavior.
9. Give every task a description and document workflows in the README, not the task list.

## Preserve the Plugin Contract

- Treat manifest commands as argument arrays. Do not rely on implicit shell parsing.
- Invoke the installed binary by its bare name at runtime. The installer owns making it resolvable on `PATH`.
- Keep local development explicit: install or build the binary, then link the plugin. `plugin link` does not run build commands.
- Use `HERDR_PLUGIN_CONFIG_DIR` for user-editable configuration and `HERDR_PLUGIN_STATE_DIR` for durable runtime state. Do not persist data in `HERDR_PLUGIN_ROOT`.
- Use `HERDR_BIN_PATH` when invoking Herdr from a plugin process.
- Capture source workspace context before opening a popup. A popup is session-modal and has no pane identity.
- Keep startup hooks one-shot. Recover long-running processes through idempotent event hooks, locking, and subscription reconnects.
- Use absolute paths in path-based API requests.
- Report partial success precisely when the external operation succeeded but Herdr reconciliation failed.

## Verify in Layers

Run the repository's own gate rather than the underlying commands:

```bash
mise run check
```

That composes formatting, lints, version drift, and every test suite. `mise run ci-audit` adds the workflow audits, and `mise run release:check` is both together. Then verify the installed boundary:

1. Install the binary and confirm `<binary> --version` matches `Cargo.toml`.
2. Link or install the plugin and inspect `herdr plugin status`.
3. Invoke each action from a real workspace.
4. Confirm popup interaction, cancellation, success, and partial-failure behavior.
5. For reconcilers, confirm cold start, duplicate events, reconnect, cleanup, and already-correct state.

## Consolidate Family Patterns

Treat this skill as the default design contract for the plugin family. Record a proven shared pattern here before copying it into another repository. Keep intentional project differences local and documented.

Promote repeated code into a shared crate, script, or template only when its interface is stable across several plugins. Good candidates include the newline-delimited socket client, manifest validation, exact-version installation, and release metadata synchronization.
