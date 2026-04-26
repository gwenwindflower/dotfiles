# CI workflow

The standard Supermodel CI workflow runs on push to `main` and every PR. Three jobs run serially — `check → test → build` — to fail fast on cheap signals and avoid burning runner minutes on a build the linter would have caught.

## Triggers and concurrency

```yaml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

concurrency:
  group: ci-${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: ${{ github.ref != 'refs/heads/main' }}

permissions:
  contents: read
```

The `cancel-in-progress` expression cancels superseded PR runs (every push to a PR branch supersedes the previous one) but never cancels `main` runs. Cancelling `main` would leave an unverified commit history.

## Job 1: check

Runs lint, format, and typecheck. Cheapest job, fails fastest. No matrix — these checks don't vary by OS.

```yaml
check:
  name: Lint, format, typecheck
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4
    - uses: denoland/setup-deno@v2
      with:
        deno-version: v2.x
    - run: deno fmt --check
    - run: deno lint
    - run: deno task check
```

## Job 2: test (with OS matrix)

Runs the test suite on every supported OS. `needs: check` gates on the lint job. `fail-fast: false` so a Linux-only failure doesn't mask a separate macOS-only failure.

```yaml
test:
  name: Test suite
  needs: check
  runs-on: ${{ matrix.os }}
  strategy:
    fail-fast: false
    matrix:
      os: [ubuntu-latest, macos-latest]
  steps:
    - uses: actions/checkout@v4
    - uses: denoland/setup-deno@v2
      with:
        deno-version: v2.x
    - run: deno task test:all
```

For Go projects, swap `denoland/setup-deno` for `actions/setup-go`; for Node, `actions/setup-node` (with `cache: pnpm`); for Rust, `dtolnay/rust-toolchain`. Each setup action has its own `cache:` input — use it.

## Job 3: build (cross-compile dry run)

Catches compilation errors for release targets *before* a tag is cut, so a failed release build never blocks a release. Runs on a single Linux runner — cross-compilation produces all four target binaries from one host.

```yaml
build:
  name: Test cross-compile across targets
  needs: test
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4
    - uses: denoland/setup-deno@v2
      with:
        deno-version: v2.x
    - name: Cross-compile
      run: deno task compile:all
    - name: Verify binaries
      run: |
        set -euo pipefail
        for target in darwin-arm64 darwin-amd64 linux-arm64 linux-amd64; do
          test -f "bin/<binary>-${target}" || { echo "Missing bin/<binary>-${target}"; exit 1; }
        done
        ls -la bin/
```

The verify step exists because some build tools exit 0 even when a target silently failed to produce output. An explicit `test -f` per target turns silent failure into loud failure.

## When to deviate

- **Pure library project** (no binary): drop the `build` job.
- **No cross-compilation supported**: replace the `build` job with a matrix that runs the build on each target OS natively.
- **Long test suite**: split into a fast unit-test job that gates the full integration suite.
