# Rust kit

What `assets/rust/` installs and the contract a Rust tool keeps with the template.

## Files

| Kit file | Lands at | Purpose |
| --- | --- | --- |
| `mise.tools.toml` | `mise.toml` `[tools]` | `rust` (stable, minimal profile, clippy + rustfmt) and `cargo-binstall`; pinned by `mise use --pin` at bootstrap |
| `mise.tasks.toml` | `mise.toml` | `build`, `install`, `fmt`, `lint:fmt`, `lint:clippy`, `test:rust` |
| `mise-tasks/version/*` | same | `read`, `write`, `files`, `verify` hooks over `Cargo.toml` and `Cargo.lock` |
| `matchers.json` | `.github/matchers/rust.json` | rustfmt, cargo, and test-panic annotations |
| `root/Cargo.toml` | `Cargo.toml` | Package metadata, lints, release profile, binstall metadata |
| `root/rustfmt.toml` | same | Edition 2024 formatting |
| `src/main.rs` | same | Clap entrypoint so the first CI run is green |

## Cargo contract

- Edition 2024, single binary, restrained dependencies: `anyhow` for errors, `clap` derive with wrapped help, `serde` + `serde_json` only when machine output exists.
- `[lints.clippy] pedantic = "warn"` with `lint:clippy` passing `-D warnings`, so pedantic lints fail CI. Allow individual lints at the crate root when they fight the code; do not drop the group.
- `[profile.release]` sets `lto`, `strip`, and `codegen-units = 1`.
- `Cargo.toml` is the version's source of truth. `version:write` rewrites it and runs `cargo update --workspace --offline`; `version:verify` fails when `Cargo.lock` disagrees. Never hand-edit the lockfile version.
- `build` leaves the binary at `dist/bin/<binary>`; `release:package` tars it from there.

## Distribution

`[package.metadata.binstall]` matches the release archive layout exactly, so `cargo binstall <name>` resolves the GitHub release once the crate is on crates.io, and `cargo binstall <name> --git https://github.com/<owner>/<name>` works before that. `quick-install` is disabled; source compilation stays available as a fallback for targets the release build does not cover.

README install order for a standalone CLI: Homebrew (when the tap is on), `cargo binstall`, `cargo install --git ... --locked`, release archive. `releasing-tools` has the matrix for every language.

## Herdr plugins

Plugins add `herdr-plugin.toml` to `version:files` and a manifest rewrite to `version:write`, keep the exact-version installer from `rust-herdr-plugins`, and disable the `compile` binstall strategy so the installer's fallback owns compilation.
