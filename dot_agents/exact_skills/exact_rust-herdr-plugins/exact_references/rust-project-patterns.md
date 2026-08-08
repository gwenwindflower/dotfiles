# Rust Project and Support Patterns

Use this reference when scaffolding or aligning a portable Rust Herdr plugin.

## Project Shape

```text
.
├── .github/workflows/
│   ├── ci.yml
│   └── release-build.yml
├── scripts/
│   ├── install-binary.sh
│   ├── prepare-release.sh
│   ├── publish-release.sh
│   └── sync-release-metadata.sh
├── src/
├── tests/
│   ├── install-binary.sh
│   ├── manifest.sh
│   └── release-scripts.sh
├── Cargo.lock
├── Cargo.toml
├── README.md
├── cliff.toml
└── herdr-plugin.toml
```

Add only files the current plugin needs. Interactive command plugins may use ordinary Rust integration tests; shell tests remain useful for installer and release boundaries.

## Cargo Contract

Use a single portable binary, Rust edition 2024, and a restrained dependency set. Typical foundations are:

- `anyhow` for contextual application errors.
- `clap` with derive and wrapped help.
- `serde` and `serde_json` for Herdr and external machine output.

Optimize release artifacts:

```toml
[profile.release]
lto = true
strip = true
```

Declare Cargo Binstall metadata so published archives install without repository-specific logic:

```toml
[package.metadata.binstall]
pkg-url = "{ repo }/releases/download/v{ version }/{ name }-{ target }-v{ version }{ archive-suffix }"
bin-dir = "{ name }-{ target }-v{ version }/{ bin }{ binary-ext }"
pkg-fmt = "tgz"
disabled-strategies = ["quick-install", "compile"]
```

Use `Cargo.toml` as the version source of truth. Synchronize `Cargo.lock` and `herdr-plugin.toml` from it and fail CI when generated metadata differs.

## Manifest Contract

The manifest build step installs the binary. Runtime entrypoints call the bare binary name:

```toml
id = "example-plugin"
name = "Example Plugin"
version = "0.1.0"
min_herdr_version = "<supported-version>"
platforms = ["linux", "macos"]

[build]
command = ["sh", "scripts/install-binary.sh"]

[actions.refresh]
title = "Refresh example state"
command = ["example-plugin", "refresh"]
contexts = ["workspace"]
platforms = ["linux", "macos"]
```

The manifest must not assume the plugin checkout remains the process working directory beyond Herdr's documented contract. Resolve shipped assets through `HERDR_PLUGIN_ROOT` and mutable data through the config or state directory.

Add a manifest test that proves:

- The build command routes through the installer.
- Every runtime entrypoint calls the bare binary.
- No entrypoint references `target/`, Cargo, or a developer checkout.
- Supported platforms and required context are explicit.

## Exact-Version Installer

The installer establishes the runtime `PATH` contract:

1. Require `cargo` and return an error with the Rust installation URL when absent.
2. Read the package name and version from `Cargo.toml`.
3. Reuse a binary on `PATH` only when `<binary> --version` reports the exact package version.
4. Prefer `cargo binstall --manifest-path Cargo.toml --strategies crate-meta-data --locked --force --no-confirm <name>` when available.
5. Fall back to `cargo install --path . --locked --force` when Binstall is unavailable or fails.
6. Resolve the installed binary from `PATH` and verify its exact version.
7. If Cargo installed successfully but the binary is unresolved, explain that Cargo's bin directory must be on `PATH`.

Do not copy `target/release/<binary>` into the plugin source. Do not prepend project directories to runtime `PATH`. A linked plugin follows the same installed-binary contract as a marketplace installation.

Keep installer output short and identify whether it reused, downloaded, or compiled the binary.

## Installer Tests

Run the installer in an isolated temporary directory with fake `cargo`, `cargo-binstall`, and plugin binaries. Prove these behaviors:

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

## Continuous Integration

Run fast static checks before the operating-system matrix:

1. `cargo fmt --check`
2. Release metadata synchronization check
3. `cargo clippy --all-targets --all-features -- -D warnings`
4. Manifest contract test
5. Installer test
6. Release script test when release automation exists

Run `cargo test --all-targets --all-features` on current Ubuntu and macOS runners. Cache only through a maintained Rust-aware action when the repository already uses one.

Pin third-party GitHub Actions to full commit SHAs. Set `persist-credentials: false` on checkout jobs that do not push. Grant the smallest workflow permissions required.

## Release Artifacts

Build release archives for:

- Linux x86_64.
- macOS arm64.
- macOS x86_64 while Intel support remains part of the family contract.

Name archives to match Cargo Binstall metadata:

```text
<name>-<target>-v<version>.tgz
<name>-<target>-v<version>.tgz.sha256
```

Each archive contains a same-named directory with the executable inside. Generate checksums beside the archives and attach both to the GitHub release.

A release preparation script should:

1. Require a clean branch in sync with the release base.
2. Validate the requested semantic version.
3. Update `Cargo.toml`.
4. Refresh the lockfile and plugin manifest.
5. Run project checks.
6. Generate release notes with git-cliff.

A publishing script should verify the prepared version, create the signed commit and tag through the repository's normal signing configuration, push them, and create the GitHub release. Never disable signing as a fallback.

Trigger artifact builds from the published GitHub release or tag contract used by the repository. Upload platform outputs as workflow artifacts, combine them in one job, and attach them to the existing release.

## README Contract

Document:

- Supported operating systems and minimum Herdr version.
- Requirements for Herdr, Cargo, the plugin binary's Cargo bin directory on `PATH`, and integrated third-party tools.
- Marketplace installation and status verification.
- Available actions and the workflows they own.
- Direct binary installation with Cargo Binstall and Cargo.
- Local development: install the binary, link the plugin, reinstall after Rust changes, and relink after manifest changes.
- The exact local check commands.
- Uninstall behavior and durable state cleanup when applicable.

Keep command help sufficient for agents and users to discover workflow requirements without opening the README.

## Shared Support Boundaries

Capture a repeated pattern in this skill before copying it into another plugin. Promote code only when the same interface has survived several implementations.

Likely shared components are:

- A typed newline-delimited Herdr socket crate.
- Runtime context parsing and source-workspace resolution.
- Installer and manifest contract test harnesses.
- Version synchronization and release scripts.
- Common error rendering, color policy, and verbose diagnostics.

Keep third-party workflow adapters project-specific. Their commands, hooks, output schemas, and partial-success semantics are the plugin's domain, not generic Herdr infrastructure.
