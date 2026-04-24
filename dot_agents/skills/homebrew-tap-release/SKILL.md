---
name: github-actions-workflows
description: Author and maintain GitHub Actions workflows. Use when creating or editing .github/workflows/*.yml, picking runner images, selecting marketplace actions, or debugging workflow failures.
---

# GitHub Actions Workflows

Guidance for writing solid GitHub Actions workflows. Two non-negotiable rules apply before writing or editing any workflow YAML.

## Rule 1: Verify the runner image

**Always** check the current state of GitHub-hosted runner images before picking a `runs-on:` value or relying on preinstalled software. Image contents (preinstalled tool versions, OS support windows, deprecation notices) change frequently.

Fetch with WebFetch:

```text
https://github.com/actions/runner-images?tab=readme-ov-file
```

From there, follow links to the per-image manifests (e.g. `images/ubuntu/Ubuntu2404-Readme.md`, `images/macos/macos-15-Readme.md`) when you need to confirm a specific tool/version is preinstalled, or whether an image is in beta / scheduled for deprecation.

Do this even if the user's existing workflow already pins a runner — `ubuntu-latest` and `macos-latest` aliases shift, and older labels get removed on a published schedule.

## Rule 2: Verify marketplace action versions

**Always** look up the current latest version of any third-party action (and confirm first-party `actions/*` versions) before adding or bumping a `uses:` line. Do not rely on training data — action majors get cut regularly and old versions get deprecated (Node 16/20 runtime sunsets, etc.).

Search the marketplace with WebFetch:

```text
https://github.com/marketplace?query={QUERY+TERMS}&type=actions
```

Then fetch the action's repo `releases` or `tags` page to confirm the current version and read release notes for breaking changes. Pin to a major (`@v4`) for first-party `actions/*`; for third-party actions consider pinning to a full SHA when supply-chain risk matters.

If a search turns up multiple actions doing the same thing, prefer: official `actions/*` > vendor-maintained > popular community action with recent commits. Note "last published" dates — abandoned actions are a liability.

## Workflow authoring basics

- **Triggers**: be specific. `on: push` without a branch filter runs on every branch. Common patterns: `on: { push: { branches: [main] }, pull_request: {} }`, `on: { release: { types: [published] } }`, `on: workflow_dispatch:` for manual runs.
- **Permissions**: default to least privilege. Set `permissions: {}` at the workflow level and grant per-job (e.g. `permissions: { contents: write }` only on the job that needs it). The default `GITHUB_TOKEN` is broad — narrow it.
- **Concurrency**: for deploy/release jobs, add a `concurrency:` group to prevent overlapping runs. For PR CI, use `concurrency: { group: ${{ github.workflow }}-${{ github.ref }}, cancel-in-progress: true }` to cancel superseded runs.
- **Matrix builds**: prefer `strategy.matrix` over copy-pasting jobs. Use `fail-fast: false` when you want all matrix legs to complete even if one fails.
- **Caching**: most language setup actions (`actions/setup-node`, `setup-python`, `setup-go`) have a built-in `cache:` input — use it instead of hand-rolling `actions/cache`.
- **Secrets**: never `echo` a secret. GitHub redacts known secrets in logs but not derived values. Pass via `env:` at the step level, not job level, to limit exposure.
- **Step outputs**: use `echo "key=value" >> "$GITHUB_OUTPUT"` (not the deprecated `::set-output`).
- **Job outputs / dependencies**: `needs: [build]` to sequence; `needs.build.outputs.foo` to read.

## Debugging failing workflows

- Re-run with debug logging: set repo secrets `ACTIONS_RUNNER_DEBUG=true` and `ACTIONS_STEP_DEBUG=true`, then re-run the failed job.
- Use `gh run view <run-id> --log-failed` to pull just the failing step output.
- For "works locally, fails in CI" issues, check the runner image manifest (Rule 1) — a tool version may differ from your local.
- For action-specific failures, read the action's recent issues on GitHub before assuming it's your config.

## Common pitfalls

- **`ubuntu-latest` drift**: pinning to a specific version (e.g. `ubuntu-24.04`) makes workflows reproducible across the latest-alias rollover window.
- **Shell defaults**: bash on Linux runs with `-eo pipefail`; on Windows the default is pwsh. Set `defaults: { run: { shell: bash } }` for cross-platform consistency.
- **`GITHUB_TOKEN` and forks**: PRs from forks get a read-only token. Workflows that need write access on PRs should use `pull_request_target` (carefully — it runs against base branch code with a privileged token, easy to introduce code-injection risk).
- **Composite vs reusable workflows**: composite actions package steps; reusable workflows (`uses: ./.github/workflows/foo.yml`) package whole jobs. Pick reusable when you need separate jobs / matrix; composite for shared step sequences.

## References

- `homebrew-releaser.md` — personal Homebrew tap release flow using `Justintime50/homebrew-releaser`. Load this when setting up or debugging Homebrew distribution for a project that should publish to `g15r/homebrew-tap`.
