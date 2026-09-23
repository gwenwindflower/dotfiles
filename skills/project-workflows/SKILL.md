---
name: project-workflows
description: Tool project pattern from scaffold to release - gwenwindflower/_tool template, mise toolchain and tasks, prek hooks, release pipeline, install paths, gitignore, Rust and Herdr plugin variants.
---

# Project workflows

Every tool project follows one pattern. The template (`gwenwindflower/_tool`) carries everything language-neutral: GitHub surfaces, mise-driven CI and release build, the human-gated release pipeline, repo provisioning tasks, SPOT planning files, and the agent hub. A language kit from `assets/` adds the toolchain; Rust is the only kit today. Variants such as Herdr plugins layer on top without changing the base.

## Guarantees

- `mise run check` is the local gate and the only place a check is defined; CI runs the same tasks.
- Releases go through `mise run release` from a clean `main`; `release:rehearse` is the dry run.
- Every `uses:` is SHA-pinned with a version comment; `mise run ci-audit` runs zizmor and pinact. Workflow authoring lives in `github-actions-workflows`.
- prek hooks guard every commit (file hygiene on staged files, Conventional Commit subjects); `.config/wt.toml` guards `wt merge` with `lint:*` and `release:check`. Formatters and validators live in `prek.toml`, semantic checks in mise tasks.
- The language toolchain is never a mise tool. Rust comes from rustup on `PATH`, declared by `rust-toolchain.toml`; CI uses the runner image's rustup.
- The version has one source of truth read through `version:read`; kits provide `read`, `write`, `files`, and optionally `verify`.
- Release archives are `<name>-<target>-v<version>.tgz` with Rust-style target triples for every language.

## Docs

| Job | Doc |
| --- | --- |
| Create a repo from the template, or audit one against it | [bootstrap](bootstrap.md) |
| Design tasks and toolchain, hooks and merge gates, CI wiring | [mise](mise.md) |
| Cut a release, install paths per language | [releasing](releasing.md) |
| Set up or debug the Homebrew tap | [homebrew-tap](homebrew-tap.md) |
| Add ignore rules | [gitignore](gitignore.md) |
| Rust kit and Cargo contract | [rust](rust.md) |
| Build a Rust Herdr plugin | [herdr-plugins/workflow](herdr-plugins/workflow.md), with [runtime](herdr-plugins/runtime.md) and [project-shape](herdr-plugins/project-shape.md) |

Planning (specs, Phases) belongs to `spot-project-management`; Herdr CLI control belongs to `herdr`.
