# Rust Project and Support Patterns

Use this reference when scaffolding or aligning a portable Rust Herdr plugin.

## Project Shape

```text
.
├── .github/workflows/
│   ├── ci.yml
│   └── release-build.yml
├── mise-tasks/
│   ├── release/
│   │   ├── _default
│   │   ├── commit
│   │   ├── create
│   │   ├── notes
│   │   ├── preflight
│   │   └── rehearse
│   └── version/
│       ├── bump
│       ├── cargo
│       ├── check
│       ├── lock
│       ├── manifest
│       ├── next
│       └── sync
├── scripts/
│   └── install-binary.sh
├── src/
├── tests/
│   ├── install-binary.sh
│   ├── manifest.sh
│   └── versioning.sh
├── Cargo.lock
├── Cargo.toml
├── README.md
├── cliff.toml
├── herdr-plugin.toml
└── mise.toml
```

Add only files the current plugin needs. Interactive command plugins may use ordinary Rust integration tests; shell tests remain useful for installer and version boundaries.

`scripts/` holds only what must run outside the task layer. The installer is invoked by Herdr's build hook on a user's machine, where mise is not a prerequisite; everything else is a task.

## Task Layer

[mise](https://mise.jdx.dev) owns the toolchain and the task list. Pin Rust and every release tool in `mise.toml` — `git-cliff`, `zizmor`, `pinact`, and `cargo-binstall` are all in the mise registry — so contributors and CI resolve identical versions from one file. Onboarding becomes `mise trust && mise install`.

Split definitions by weight:

- `mise.toml` holds tool versions, one-line wrappers around a single command, pipelines, and aliases.
- `mise-tasks/` holds anything with logic, as ordinary bash. Directories become task prefixes, so `mise-tasks/version/check` is `version:check`.

Task scripts must run standalone. Open each with `cd "${MISE_PROJECT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"` so `./mise-tasks/version/check` works with no mise in the loop, and compose by calling siblings through those paths. Reserve `mise run` for pipelines, where it is also what fires confirm gates.

Group by prefix — `dev:`, `herdr:`, `test:`, `ci-audit:`, `version:`, `release:` — and alias the everyday ones. Shell completion over `mise run` makes descriptions the discovery surface, so every task needs one and the README stops enumerating commands.

Four mise behaviors shape the design:

- `depends` runs in parallel. Anything order-sensitive belongs in a sequential `run` array instead.
- `confirm` prompts, defaults to no, and reads the tty, so it cannot be piped past. Use it for every step that leaves the machine rather than hand-rolling prompts.
- `#USAGE arg "[tag]" env="TAG"` declares an argument that falls back to an environment variable. That is how a pipeline resolves a version once and shares it with every step.
- `deny_net` and `deny_write` are honored only on TOML tasks. mise warns and ignores them in `#MISE` file-task headers. Declare them for third-party tools that should never write to the checkout, and skip them for anything that needs the network and a cache.

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

Use `Cargo.toml` as the version source of truth. `version:sync` repairs `Cargo.lock` and `herdr-plugin.toml` from it and never touches Cargo's own version, so it stays idempotent and safe to run at any time. `version:check` reports drift without writing and runs in CI.

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

Test the version tasks the same way, in `tests/versioning.sh`: build sandbox repositories with drifted `Cargo.toml`, `Cargo.lock`, and manifest versions, then prove detection, repair, and bumping. Because task scripts are standalone bash, the test invokes them directly by path with a fake `cargo` on `PATH`, so the suite needs no mise. Do not write end-to-end tests for the mutating release steps; `release:rehearse` covers that ground against the real repository.

## Continuous Integration

Install the toolchain with `jdx/mise-action`, then run one task per step. The Actions UI keeps its granularity while the task definition stays the only place a check lives, so local and CI cannot drift. Set `MISE_TRUSTED_CONFIG_PATHS: ${{ github.workspace }}` at workflow level so mise trusts the checkout without a separate step.

Order the check job fast-first: `fmt`, version drift, `clippy`, manifest contract, installer, versioning. Run the Rust test suite on current Ubuntu and macOS runners.

Disable mise-action's caching in any workflow that publishes artifacts:

```yaml
- uses: jdx/mise-action@<sha> # vX.Y.Z
  with:
    cache: false # This workflow publishes release artifacts; a poisoned cache would reach users.
```

The action caches `~/.local/share/mise`, which holds the installed tool binaries rather than build intermediates. A cache hit skips mise's checksum and attestation verification, so a poisoned entry substitutes the compilers that produce a published artifact. The Actions cache carries no provenance and is writable from lower-privilege contexts than the ones that read it, which is why zizmor's `cache-poisoning` audit treats caching in a publishing workflow as high severity.

Pin third-party GitHub Actions to full commit SHAs. Set `persist-credentials: false` on checkout jobs that do not push. Grant the smallest workflow permissions required.

Use this `.github/pinact.yml` policy:

```yaml
# yaml-language-server: $schema=https://raw.githubusercontent.com/suzuki-shunsuke/pinact/refs/heads/main/json-schema/pinact.json
# pinact - https://github.com/suzuki-shunsuke/pinact
version: 3
min_age:
  value: 7
  always: true
rules:
  - ignore: true
    conditions:
      - expr: |
          ActionName == "slsa-framework/slsa-github-generator/.github/workflows/generator_generic_slsa3.yml" && ActionVersion matches "v\\d+\\.\\d+\\.\\d+"
  - min_age: 0
    conditions:
      - expr: |
          ActionName matches "actions/.*"
      - expr: |
          ActionRepoOwner == "github"
      - expr: |
          ActionRepoOwner == "astral-sh" && ActionVersion == "main"
```

`pinact --verify-comment` resolves every pinned SHA through the GitHub API, where anonymous callers share 60 requests an hour per machine. A repository with a dozen action references exhausts that in a few runs, and the failure surfaces as `get a commit hash: ...`, which reads like a connectivity problem. Have the task export `GITHUB_TOKEN`, falling back to `gh auth token`, and warn when neither is available.

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

Decompose the release into steps that each run on their own, then compose them into one pipeline:

| Task | Responsibility |
| --- | --- |
| `version:next` | The tag git-cliff derives from the commits since the last release |
| `version:bump` | Set `Cargo.toml`, then sync the lockfile and manifest to it |
| `release:preflight` | Tooling, authentication, a clean `main` containing its remote, an unused tag |
| `release:check` | Every CI check plus both workflow audits |
| `release:commit` | Commit only the version files, refusing any other change |
| `release:notes` | The notes git-cliff will publish |
| `release:push` | Push the release commit, behind a `confirm` gate |
| `release:create` | Publish the release, behind a `confirm` gate |
| `release:rehearse` | Every read-only step plus the notes that would ship |
| `release` | The pipeline, resolving the tag once and exporting it |

`release:preflight` and `version:check` should report every problem they find rather than stopping at the first, since both answer "is this repository releasable" and a partial answer wastes a round trip. Everything else fails fast; the error names the task that repairs it, and that message is the recovery path.

Ship `release:rehearse` as the dry run. It is the only way to exercise the pipeline without side effects, and it makes end-to-end tests of the mutating steps unnecessary.

Let GitHub create the tag at the default-branch head when it publishes the release. Do not create or push a separate tag. The release commit must therefore land on the default branch before publishing, which is what makes `release:push` and `release:create` two distinct gates. Sign the release commit through the repository's normal signing configuration, and never disable signing as a fallback.

Trigger artifact builds from the published GitHub release or tag contract used by the repository. Upload platform outputs as workflow artifacts, combine them in one job, and attach them to the existing release.

## README Contract

Document:

- Supported operating systems and minimum Herdr version.
- Requirements for Herdr, Cargo, the plugin binary's Cargo bin directory on `PATH`, and integrated third-party tools.
- Marketplace installation and status verification.
- Available actions and the workflows they own.
- Direct binary installation with Cargo Binstall and Cargo.
- Local development: `mise trust && mise install`, then the task that puts the checkout in front of Herdr.
- Uninstall behavior and durable state cleanup when applicable.

Document workflows, not the task list. `mise tasks` and `mise tasks info <task>` enumerate the tasks with their descriptions, so a README that repeats them only creates a second place to drift.

Keep command help sufficient for agents and users to discover workflow requirements without opening the README.

## Shared Support Boundaries

Capture a repeated pattern in this skill before copying it into another plugin. Promote code only when the same interface has survived several implementations.

Likely shared components are:

- A typed newline-delimited Herdr socket crate.
- Runtime context parsing and source-workspace resolution.
- Installer and manifest contract test harnesses.
- The version and release task tree, which is nearly identical across plugins.
- Common error rendering, color policy, and verbose diagnostics.

Keep third-party workflow adapters project-specific. Their commands, hooks, output schemas, and partial-success semantics are the plugin's domain, not generic Herdr infrastructure.
