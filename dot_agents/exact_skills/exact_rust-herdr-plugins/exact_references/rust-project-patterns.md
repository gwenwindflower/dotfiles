# Herdr Plugin Project Patterns

What a Rust Herdr plugin adds on top of the standard tool repository. The generic parts live elsewhere: repo shape and the Rust kit in `bootstrap-tool` (`references/rust.md`), the task layer in `mise-projects`, the release pipeline in `releasing-tools`, workflows in `github-actions-workflows`.

## Project Shape

Beyond the template, a plugin has:

```text
herdr-plugin.toml          manifest: build hook, actions, panes, events
scripts/install-binary.sh  exact-version installer the manifest's build hook runs
tests/
  plugin-manifest.sh       manifest contract
  install-binary.sh        installer contract
  versioning.sh            version hooks including the manifest
```

`scripts/` holds only what must run outside the task layer. The installer runs on a user's machine from Herdr's build hook, where mise is not a prerequisite; everything else is a task.

## Version hooks

The plugin's `version:write` rewrites `Cargo.toml`, resyncs `Cargo.lock`, and rewrites the top-level `version` in `herdr-plugin.toml`; `version:files` lists all three; `version:verify` checks both derived files. `tests/versioning.sh` proves detection, repair, and bumping across the three files with a fake `cargo` on `PATH`.

`[package.metadata.binstall]` disables the `compile` strategy as well as `quick-install`, so the installer's own fallback is the only path that compiles.

## Manifest Contract

The manifest build step installs the binary. Runtime entrypoints call the bare binary name:

```toml
id = "example-plugin"
name = "Example Plugin"
version = "0.1.0"
min_herdr_version = "<supported-version>"
platforms = ["linux", "macos"]

[[build]]
command = ["sh", "scripts/install-binary.sh"]

[[actions]]
id = "refresh"
title = "Refresh example state"
command = ["example-plugin", "refresh"]
contexts = ["workspace"]
```

The manifest must not assume the plugin checkout remains the process working directory beyond Herdr's documented contract. Resolve shipped assets through `HERDR_PLUGIN_ROOT` and mutable data through the config or state directory. Popup geometry lives in the manifest's `[[panes]]` entries only; the binary sends geometry-free `plugin.pane.open`.

`tests/plugin-manifest.sh` proves:

- The build command routes through the installer.
- Every runtime entrypoint calls the bare binary.
- No entrypoint references `target/`, Cargo, or a developer checkout.
- Supported platforms and required contexts are explicit.

## Exact-Version Installer

The installer establishes the runtime `PATH` contract:

1. Require `cargo` and return an error with the Rust installation URL when absent.
2. Read the package name and version from `Cargo.toml`.
3. Reuse a binary on `PATH` only when `<binary> --version` reports the exact package version.
4. Prefer `cargo binstall --manifest-path Cargo.toml --strategies crate-meta-data --locked --force --no-confirm <name>` when available.
5. Fall back to `cargo install --path . --locked --force` when Binstall is unavailable or fails.
6. Resolve the installed binary from `PATH` and verify its exact version.
7. If Cargo installed successfully but the binary is unresolved, explain that Cargo's bin directory must be on `PATH`.

Do not copy `target/release/<binary>` into the plugin source. Do not prepend project directories to runtime `PATH`. A linked plugin follows the same installed-binary contract as a marketplace installation. Keep installer output short and say whether it reused, downloaded, or compiled the binary.

## Installer Tests

Run the installer in an isolated temporary directory with fake `cargo`, `cargo-binstall`, and plugin binaries. Prove:

| Condition | Expected result |
| --- | --- |
| Exact binary already on `PATH` | Exit without installation |
| Binstall is available | Invoke it with locked manifest metadata |
| Binstall is absent | Compile from the plugin checkout |
| Binstall fails | Fall back to source installation |
| Installed version differs | Fail with expected and actual versions |
| Cargo is absent | Fail with an actionable Rust requirement |
| Cargo bin directory is absent from `PATH` | Explain how to expose the installed binary |

Assert arguments and user-facing results, not incidental shell implementation.

## Herdr tasks

Group under `herdr:` (`link`, `unlink`, `install`, `uninstall`, `status`, plus one task per action) and `dev:` (`dev` = `check` then `dev:reload`; `dev:reload` = install then link; `dev:local` and `dev:released` swap between the checkout and the published plugin). `herdr:install` targets `<owner>/<name>` on GitHub, never a local path.

## README Contract

Document supported operating systems and minimum Herdr version; requirements for Herdr, Cargo, the Cargo bin directory on `PATH`, and any integrated third-party tools; `herdr plugin install <owner>/<name>` and `herdr plugin list --plugin <name>` to verify; the actions and the workflows they own; direct binary installation with Binstall and Cargo; local development (`mise trust && mise install`, then `mise run dev:reload`); uninstall behavior and durable state cleanup. Document workflows, not the task list.

## Shared Support Boundaries

Capture a repeated pattern in this skill before copying it into another plugin. Promote code only when the same interface has survived several implementations. Likely shared components: a typed newline-delimited Herdr socket crate, runtime context parsing and source-workspace resolution, installer and manifest contract test harnesses, and common error rendering. Keep third-party workflow adapters project-specific.
