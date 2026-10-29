# GitHub Actions

How [CI practices](practices.md) map onto GitHub Actions. The template (`gwenwindflower/_tool`) ships `ci.yml` and `release-build.yml`; annotation setup is in [github-actions-annotations](github-actions-annotations.md).

## Before editing any workflow

1. **Check the runner image.** Fetch <https://github.com/actions/runner-images?tab=readme-ov-file> and follow the per-image manifests (`images/ubuntu/Ubuntu2404-Readme.md`, `images/macos/macos-15-Readme.md`) for tool versions and deprecation windows. Use concrete labels: `ubuntu-24.04`, `ubuntu-24.04-arm`, `macos-15`, `macos-15-intel`.
2. **Check every action version.** Search `https://github.com/marketplace?query={QUERY+TERMS}&type=actions`, then read the repo's releases or tags for breaking changes. Confirm the major-only tag exists: `denoland/setup-deno` and `astral-sh/setup-uv` publish only full semver tags, and `@v2` fails at run time with "unable to resolve action".
3. **Audit and pin.** Run `mise run ci-audit` before calling the change done.

## Auditing and pinning tools

- **[zizmor](https://docs.zizmor.sh)** audits for template injection, excessive permissions, `pull_request_target` misuse, cache poisoning, and unpinned actions. The prek hook runs `zizmor --offline`; the CI `audit` job supplies a read-only `GH_TOKEN` and runs `zizmor --format github .`. For the mise task's cache write allowance, see [mise](../mise.md).
- **[pinact](https://github.com/suzuki-shunsuke/pinact)** rewrites `uses:` to full commit SHAs with a version comment. `pinact run` edits in place, `pinact run --check --verify-comment` reports, `pinact run -update` bumps. Export `GITHUB_TOKEN` (fall back to `gh auth token`); anonymous callers get 60 API calls an hour.

[`zizmor.yml`](../assets/github-actions/zizmor.yml) and [`pinact.yml`](../assets/github-actions/pinact.yml) encode the pinning policy and live in `.github/` next to the workflows: hash-pin everything, ref-pin `actions/*` and `astral-sh/*`, seven-day `min_age` except for those.

## The template workflows

**`ci.yml`**: job `audit` runs zizmor and `mise run ci-audit:pinact`; `check` has `needs: audit` and registers problem matchers, then runs `mise run version:check` and `mise run 'lint:*'`; `test` has `needs: check` and runs `mise run 'test:*'` on Ubuntu and macOS. Every job carries `if: ${{ !github.event.repository.is_template }}`.

**`release-build.yml`**: triggered by `release: published`, plus `workflow_dispatch` with a tag. A four-leg matrix maps native runners to target triples and runs `mise run version:check "$RELEASE_TAG"` and `mise run release:package "$TARGET"`, then uploads artifacts. `publish` attaches them to the release. `homebrew` runs when `vars.HOMEBREW_TAP == 'true'`; a variable gates it because a job-level `if` cannot read `secrets`. See [homebrew-tap](../homebrew-tap.md).

## mise in workflows

- `jdx/mise-action` installs the toolchain. Set `MISE_ENV: ci` and `MISE_TRUSTED_CONFIG_PATHS: ${{ github.workspace }}` at workflow level; the second trusts the checkout without a separate step.
- The action caches mise's data directory keyed on the platform and the mise config hash, and never re-saves on a hit. `ci.yml` writes `MISE_CACHE_WEEK` from `date +%G-%V` and passes `cache_key: "{{default}}-{{env.MISE_CACHE_WEEK}}"`.
- Publishing workflows set `cache: false` on the action.
- `actions/cache` allows 10 GB per repo, evicts entries unused for 7 days, and saves only on a key miss.
- Actions that need no setup are JavaScript actions with a bundled `dist/`, which run on the runner's own node. A Docker action pulls its image every job.

## Authoring

- **Triggers**: be specific; `push` without a branch filter runs everywhere. Common: `on: { push: { branches: [main] }, pull_request: {} }`, `on: { release: { types: [published] } }`, `workflow_dispatch`.
- **Permissions**: `permissions: { contents: read }` at workflow level; `contents: write` per job only where it uploads or pushes.
- **Concurrency**: `cancel-in-progress: ${{ github.ref != 'refs/heads/main' }}`. Release builds group by tag with `cancel-in-progress: false`.
- **Checkout**: `persist-credentials: false` on every checkout that does not push.
- **Matrix**: `fail-fast: false`.
- **Secrets**: pass at step level via `env:`. A job-level `if` can read `vars` and `github`, not `secrets`.
- **Outputs**: `echo "key=value" >> "$GITHUB_OUTPUT"`; multi-line values use a random heredoc delimiter.
- **Shell**: bash on Linux and macOS runs with `-eo pipefail`. Set `defaults: { run: { shell: bash } }` if Windows ever joins the matrix.
- **Fork PRs** get a read-only token. Anything that needs write access on PRs avoids `pull_request_target` or treats it as privileged.

## Debugging

- `gh run view <run-id> --log-failed` shows just the failing step.
- Re-run with the `ACTIONS_RUNNER_DEBUG=true` and `ACTIONS_STEP_DEBUG=true` repo secrets for verbose logs.

## Auditing a repo

Beyond the checklist in [practices](practices.md#auditing): runner labels are concrete and current, every `uses:` has a SHA and version comment, `permissions` is present, `concurrency` is set, matchers are registered, and publishing workflows set `cache: false`.
