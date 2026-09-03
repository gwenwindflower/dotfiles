---
name: releasing-tools
description: Cut and distribute releases of OSS dev tools through the standard mise-gated pipeline, git-cliff notes, GitHub-created tags, and per-language install paths (cargo-binstall, uv tool, go install, mise, npm) plus an optional Homebrew tap. Use when releasing a tool, editing release or version tasks, writing install docs, or setting up the Homebrew tap.
---

# Releasing tools

A release is a commit on `main` that sets the version, followed by a GitHub release that creates the tag. Humans run it; agents rehearse it.

## The pipeline

`mise run release [tag]` resolves the tag once (default: `version:next` from git-cliff) and runs, in order:

| Step | Does | Fails when |
| --- | --- | --- |
| `release:preflight` | Tools, `gh` auth, `origin` present, `cliff.toml` owner matches `origin`, on `main`, clean, not behind, tag free locally and remotely | Reports every problem, then exits |
| `version:bump` | `version:write <version>`, then `version:check <tag>` | Derived files disagree |
| `release:check` | `check` plus `ci-audit` | Any check or audit |
| `release:commit` | Commits only the files `version:files` lists as `chore(release): prepare <tag>` | Anything else is dirty |
| `release:notes` | `git cliff --unreleased --tag <tag> --strip all` | A commit is not Conventional |
| `release:push` | `git push origin main` behind `confirm` | — |
| `release:create` | `gh release create <tag>` from `origin/main` head behind `confirm`; GitHub creates the tag | `HEAD != origin/main` |

Publishing fires `release-build.yml`: one archive per target triple, checksums, assets attached, and the Homebrew job when `HOMEBREW_TAP` is `true`. `release:verify` shows the result.

`release:rehearse` runs preflight, `version:check`, `release:check`, and notes, and writes nothing. It is the only release step an agent runs unasked.

## Rules

- **One source of truth for the version.** `version:read` reports it; `version:write` derives everything else. No hand edits to lockfiles or manifests.
- **Conventional Commits or the notes fail.** `cliff.toml` sets `require_conventional` and `fail_on_unmatched_commit`. Types: feat, fix, perf, refactor, test, agent, docs, build, ci, style, chore. `docs(todo)`, `chore(release):`, and `chore(specs)` are skipped. The prek `commit-msg` hook (`scripts/check-commit-message`) rejects unparseable subjects at commit time; keep its type list and `cliff.toml` in sync.
- **Bumps are patch unless forced.** `breaking_always_bump_major` and `features_always_bump_minor` are off; pass an explicit tag to `mise run release v0.2.0` for a minor or major.
- **No CHANGELOG.md.** Notes live on the GitHub release.
- **GitHub creates the tag.** Never push a tag; `release:push` and `release:create` are two gates on purpose.
- **Archives are `<name>-<target>-v<version>.tgz` + `.tgz.sha256`** with Rust-style triples for every language, containing one directory with the binary inside.
- **Signing stays on.** The release commit signs through the normal config; never disable signing to get a release out.

## Distribution by language

Lead the README with the native path, add Homebrew for standalone CLIs, and always list the release archive.

| Language | Native install | Also | Homebrew |
| --- | --- | --- | --- |
| Rust | `cargo binstall <name>` (`--git` before crates.io) | `cargo install --git ... --locked` | Yes, formula from release archives |
| Python | `uv tool install <name>` | `pipx install <name>` | No; the dependency barrel is not worth it |
| Go | `go install github.com/<owner>/<name>@latest` | release archive | Yes |
| TypeScript (Deno) | `deno install -g jsr:@<owner>/<name>` | `mise use -g jsr:...` | Compiled binary only |
| TypeScript (Node/Bun) | `bun install -g <name>` / `npm i -g <name>` | `mise use -g npm:<name>` | Compiled binary only |

Herdr plugins install through `herdr plugin install <owner>/<name>`; the plugin's build hook runs the exact-version installer, so they never publish to Homebrew.

Only the Rust kit exists today; other rows describe the target and get kits as tools move over.

## Homebrew tap

See [references/homebrew-tap.md](references/homebrew-tap.md) for the tap repository, the PAT, the formula template, and how the `homebrew` job renders and pushes it.

## Cutting a release, as the human

```bash
mise run release:rehearse      # read-only; fix anything it reports
mise run release               # or: mise run release v0.2.0
mise run release:verify        # after the build workflow finishes
```

Then install through the native path on a clean `PATH` and confirm `<binary> --version` matches the tag.
