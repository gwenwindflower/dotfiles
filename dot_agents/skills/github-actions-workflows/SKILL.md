---
name: github-actions-workflows
description: Author, audit, and scaffold GitHub Actions workflows. Use when editing .github/workflows/*.yml, picking runners or marketplace actions, debugging workflow failures, or scaffolding CI/release workflows for Supermodel Labs projects.
---

# GitHub Actions Workflows

Guidance for writing solid GitHub Actions workflows, plus templates and a scaffold script specifically for Supermodel Labs projects. Two non-negotiable rules apply before writing or editing any workflow YAML.

## Rule 1: Verify the runner image

**Always** check the current state of GitHub-hosted runner images before picking a `runs-on:` value or relying on preinstalled software. Image contents (preinstalled tool versions, OS support windows, deprecation notices) change frequently.

Fetch with WebFetch:

```text
https://github.com/actions/runner-images?tab=readme-ov-file
```

From there, follow links to the per-image manifests (e.g. `images/ubuntu/Ubuntu2404-Readme.md`, `images/macos/macos-15-Readme.md`) when you need to confirm a specific tool/version is preinstalled, or whether an image is in beta or scheduled for deprecation.

Do this even when an existing workflow already pins a runner — `ubuntu-latest` and `macos-latest` aliases shift, and older labels get removed on a published schedule.

## Rule 2: Verify marketplace action versions

**Always** look up the current latest version of any third-party action (and confirm first-party `actions/*` versions) before adding or bumping a `uses:` line. Don't rely on training data — action majors get cut regularly and old versions get deprecated (Node 16/20 runtime sunsets, etc.).

Search the marketplace with WebFetch:

```text
https://github.com/marketplace?query={QUERY+TERMS}&type=actions
```

Then fetch the action's repo `releases` or `tags` page to confirm the current version and read release notes for breaking changes. Pin to a major (`@v4`) for first-party `actions/*`; for third-party actions consider pinning to a full SHA when supply-chain risk matters.

When multiple actions do the same thing, prefer: official `actions/*` > vendor-maintained > popular community action with recent commits. Note "last published" dates — abandoned actions are a liability.

## Authoring basics

- **Triggers**: be specific. `on: push` without a branch filter runs on every branch. Common patterns: `on: { push: { branches: [main] }, pull_request: {} }`, `on: { release: { types: [published] } }`, `on: workflow_dispatch:` for manual runs.
- **Permissions**: default to least privilege. Set `permissions: { contents: read }` at the workflow level and grant per-job (e.g. `permissions: { contents: write }` only on the job that needs it). The default `GITHUB_TOKEN` is broad — narrow it.
- **Concurrency**: for deploy/release jobs, add a `concurrency:` group to prevent overlapping runs. For PR CI, cancel superseded runs but never cancel `main`: `cancel-in-progress: ${{ github.ref != 'refs/heads/main' }}`.
- **Matrix builds**: prefer `strategy.matrix` over copy-pasting jobs. Use `fail-fast: false` when you want all matrix legs to complete even if one fails.
- **Caching**: most language setup actions (`actions/setup-node`, `setup-python`, `setup-go`, `denoland/setup-deno`) have a built-in `cache:` input — use it instead of hand-rolling `actions/cache`.
- **Secrets**: never `echo` a secret. GitHub redacts known secrets in logs but not derived values. Pass via `env:` at the step level, not job level, to limit exposure.
- **Step outputs**: use `echo "key=value" >> "$GITHUB_OUTPUT"` (not the deprecated `::set-output`). For multi-line values use a random heredoc delimiter to avoid collisions.
- **Job dependencies**: `needs: [build]` to sequence; `needs.build.outputs.foo` to read a prior job's output.

## Debugging

- Re-run with debug logging: set repo secrets `ACTIONS_RUNNER_DEBUG=true` and `ACTIONS_STEP_DEBUG=true`, then re-run the failed job.
- `gh run view <run-id> --log-failed` pulls just the failing step output.
- For "works locally, fails in CI" issues, check the runner image manifest (Rule 1) — a tool version may differ from your local.
- For action-specific failures, read the action's recent issues on GitHub before assuming it's your config.

## Common pitfalls

- **`ubuntu-latest` drift**: pinning to a specific version (e.g. `ubuntu-24.04`) makes workflows reproducible across the latest-alias rollover window.
- **Shell defaults**: bash on Linux runs with `-eo pipefail`; on Windows the default is pwsh. Set `defaults: { run: { shell: bash } }` for cross-platform consistency.
- **`GITHUB_TOKEN` and forks**: PRs from forks get a read-only token. Workflows that need write access on PRs should use `pull_request_target` carefully — it runs base-branch code with a privileged token, easy to introduce code-injection risk.
- **Composite vs reusable workflows**: composite actions package steps; reusable workflows (`uses: ./.github/workflows/foo.yml`) package whole jobs. Pick reusable when you need separate jobs or matrix; composite for shared step sequences.

## Release pipeline (Supermodel Labs)

Supermodel Labs CLIs distribute via the `supermodellabs/homebrew-tap` Homebrew tap and ship as single portable binaries. The standard pipeline is three workflows that flow into each other:

1. **`ci.yml`** — runs on push to `main` and on PRs. Lints, tests, and dry-runs cross-compilation.
2. **`release.yml`** — runs on `v*` tag push. Generates release notes with git-cliff and creates a GitHub Release.
3. **`release_build.yml`** — runs on `release: published`. Builds artifacts, uploads to the release, and updates the Homebrew tap.

Splitting release-creation from artifact-build means tag pushes give you a release page immediately and artifacts attach as soon as the build finishes. Draft releases don't fire `release: published`, so the build stays gated on an intentional publish.

References:

- [`ci.md`](ci.md) — CI workflow patterns: serial check → test → build, OS matrices, concurrency, cross-compile verification.
- [`release.md`](release.md) — tag-triggered release-notes generation with git-cliff and `gh release create`.
- [`release-build.md`](release-build.md) — building cross-platform binaries, packaging tarballs + checksums, and publishing to `supermodellabs/homebrew-tap` via `Justintime50/homebrew-releaser`.

## Using this skill

### Audit existing workflows

When asked to audit `.github/workflows/`: read each file, then check against the rules and pitfalls above. Common audit findings: stale runner pins, outdated action versions, missing `permissions:` (defaults to overly broad), missing `concurrency:`, secrets passed at job level, deprecated `::set-output`, no `fail-fast: false` on matrices that should keep running. For a release pipeline, compare against [`ci.md`](ci.md) / [`release.md`](release.md) / [`release-build.md`](release-build.md).

### Scaffold a workflow into a project

`assets/` holds three templates with `@@PLACEHOLDER@@` substitution markers and `>>> TOOLCHAIN_SETUP <<<` blocks for language-specific bits. `scripts/install-workflow.sh` copies a template, substitutes the placeholders it knows about, and reports what's left for the agent to finish.

```bash
SKILL=~/.agents/skills/github-actions-workflows

# Generic — single workflow, agent fills toolchain by hand
"$SKILL/scripts/install-workflow.sh" --workflow ci --binary <name>

# Supermodel Labs full release pipeline (defaults --owner to supermodellabs)
"$SKILL/scripts/install-workflow.sh" --workflow all --binary <name> --repo <repo>
```

After running, replace every `>>> TOOLCHAIN_SETUP <<<` and `>>> *_COMMAND <<<` block with the project's actual setup action and build/test/lint commands (detect toolchain from `deno.json`, `go.mod`, `package.json`, `Cargo.toml`, etc). The script's stdout lists exactly which markers remain.

The `release.yml` template is toolchain-agnostic and ships ready to use.

### Use-case mapping

| Request | Action |
| --- | --- |
| "audit my GitHub Actions workflows" | Read existing files; check against rules/pitfalls and reference docs. |
| "add a ci/build/release workflow" | Run script with `--workflow ci\|release\|release-build`; fill toolchain markers. |
| "add release + build for the supermodel homebrew tap" | Run script with `--workflow all --binary <name> --repo <repo>`; fill toolchain markers; ensure source repo has `HOMEBREW_TAP_GITHUB_TOKEN` secret (see [`release-build.md`](release-build.md)). |
