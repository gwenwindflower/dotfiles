---
name: github-actions-workflows
description: Author, audit, and scaffold GitHub Actions workflows. Use when editing .github/workflows/*.yml, picking runners or marketplace actions, debugging workflow failures, adding CI annotations, or checking a repo's workflows against the standard CI and release-build pipeline.
---

# GitHub Actions Workflows

Three non-negotiable rules apply before writing or editing any workflow YAML, then the standard pipeline every tool repo runs.

## Rule 1: Verify the runner image

**Always** check the current runner images before picking a `runs-on:` value or relying on preinstalled software. Fetch with WebFetch:

```text
https://github.com/actions/runner-images?tab=readme-ov-file
```

Follow the per-image manifests (`images/ubuntu/Ubuntu2404-Readme.md`, `images/macos/macos-15-Readme.md`) to confirm a tool version or a deprecation window. Pin concrete labels (`ubuntu-24.04`, `ubuntu-24.04-arm`, `macos-15`, `macos-15-intel`); the `-latest` aliases shift on a published schedule.

## Rule 2: Verify marketplace action versions

**Always** look up the current version of any action before adding or bumping a `uses:` line. Search with WebFetch:

```text
https://github.com/marketplace?query={QUERY+TERMS}&type=actions
```

Then read the repo's releases or tags page for breaking changes. **Confirm the major-only tag exists**: `denoland/setup-deno` and `astral-sh/setup-uv` publish only full semver tags, and `@v2` fails at run time with "unable to resolve action". Prefer official `actions/*` > vendor-maintained > community actions with recent commits.

## Rule 3: Audit with zizmor, pin with pinact

- **[zizmor](https://docs.zizmor.sh)** audits for template injection, excessive permissions, `pull_request_target` misuse, cache poisoning, unpinned actions. `zizmor .` from the repo root; `--format github` in CI emits annotations.
- **[pinact](https://github.com/suzuki-shunsuke/pinact)** rewrites `uses:` to full commit SHAs with a version comment. `pinact run` edits in place, `pinact run --check --verify-comment` reports, `pinact run -update` bumps. Export `GITHUB_TOKEN` (fall back to `gh auth token`); anonymous callers get 60 API calls an hour.

Policy: hash-pin everything; ref-pin is acceptable only for `actions/*`. [`assets/zizmor.yml`](assets/zizmor.yml) and [`assets/pinact.yml`](assets/pinact.yml) encode it; they live in `.github/` next to the workflows. Every tool repo has `mise run ci-audit` running both.

## The standard pipeline

The template (`gwenwindflower/_tool`) ships two workflows; `bootstrap-tool` installs them and `mise-projects` explains the task layer they call.

**`ci.yml`** on push to `main` and every PR. Jobs `check` (register problem matchers, `mise run version:check`, `mise run 'lint:*'`), `test` (`mise run 'test:*'` on Ubuntu and macOS), and `audit` (`zizmor --format github .`, `mise run ci-audit:pinact`). Every job carries `if: ${{ !github.event.repository.is_template }}` so the template repository itself never runs them.

**`release-build.yml`** on `release: published` (and `workflow_dispatch` with a tag to build without uploading). A four-leg matrix of native runners maps to Rust-style target triples, runs `mise run version:check "$RELEASE_TAG"` and `mise run release:package "$TARGET"`, uploads artifacts; `publish` attaches them to the release; `homebrew` renders and pushes the formula when `vars.HOMEBREW_TAP == 'true'` (a job-level `if` cannot read `secrets`, which is why a variable gates it).

Workflow files carry no language-specific content; the toolchain comes from `mise.toml` through `jdx/mise-action`. `MISE_TRUSTED_CONFIG_PATHS: ${{ github.workspace }}` at workflow level trusts the checkout. Publishing workflows set `cache: false` on mise-action, because a cache hit skips verification of the toolchain that produces user-facing artifacts.

## Annotations

Failures must land on the diff as file-and-line annotations. See [references/annotations.md](references/annotations.md) for problem matchers (registered with `::add-matcher::` from `.github/matchers/*.json`), tools with native GitHub output, and the limits.

## Authoring basics

- **Triggers**: be specific. `push` without a branch filter runs everywhere. Common: `on: { push: { branches: [main] }, pull_request: {} }`, `on: { release: { types: [published] } }`, `workflow_dispatch`.
- **Permissions**: `permissions: { contents: read }` at workflow level; grant `contents: write` per job only where it uploads or pushes.
- **Concurrency**: cancel superseded PR runs, never `main`: `cancel-in-progress: ${{ github.ref != 'refs/heads/main' }}`. Release builds group by tag with `cancel-in-progress: false`.
- **Checkout**: `persist-credentials: false` on every checkout that does not push.
- **Matrix**: `fail-fast: false` when every leg should report.
- **Secrets**: never `echo` one; pass at step level via `env:`; job-level `if` can read `vars` and `github`, not `secrets`.
- **Outputs**: `echo "key=value" >> "$GITHUB_OUTPUT"`; multi-line values use a random heredoc delimiter.
- **Shell**: bash on Linux and macOS runs with `-eo pipefail`; set `defaults: { run: { shell: bash } }` if Windows ever joins the matrix.

## Debugging

- `gh run view <run-id> --log-failed` for just the failing step.
- Re-run with `ACTIONS_RUNNER_DEBUG=true` and `ACTIONS_STEP_DEBUG=true` repo secrets.
- "Works locally, fails in CI" usually means a runner-image version differs (Rule 1) or `mise.toml` pins are stale.
- Fork PRs get a read-only token; anything needing write on PRs must avoid `pull_request_target` or treat it as privileged.

## Auditing a repo

Read each workflow, then check: runner labels current, actions pinned with comments, `permissions` present and minimal, `concurrency` set, `persist-credentials: false`, no job-level secrets, `cache: false` on publishing workflows, `fail-fast: false` where the matrix should finish, matchers registered. Run `mise run ci-audit`. Compare against the template's two workflows; `bootstrap-tool existing` reports the diff.
