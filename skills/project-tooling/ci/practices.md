# CI practices

What CI does in every tool project, independent of the platform that runs it. A platform module implements these; [github-actions](github-actions.md) is the only one today.

## CI runs the local tasks

- CI calls `mise run` tasks and nothing else. A check is defined once, as a mise task, and `mise run check` locally is the same gate CI runs. See [mise](../mise.md) for the task layer and the `mise.ci.toml` overlay.
- Pipeline definitions carry no language-specific content. The toolchain comes from the mise config, so a language kit never touches CI files.
- Every tool CI uses is declared in mise. Anything installed another way (a hook with its own runtime, `npm install`, `cargo install`) skips the toolchain cache and is paid in full every run.
- The template repository never runs its own pipelines; every job is gated off there.

## The standard pipeline

| Pipeline | Trigger | Runs |
| --- | --- | --- |
| CI | Push to `main`, every PR | `audit` (workflow audit and pin check), then `check` (annotation setup, `version:check`, `lint:*`), then `test` (`test:*` on Linux and macOS) |
| Release build | A published release; a manual run with a tag builds without uploading | One leg per target triple on native runners: `version:check <tag>`, `release:package <target>`; then attach archives and checksums to the release, then the Homebrew formula when the repo opts in |

- Stages run in order and a failed stage skips the rest, so audit failures block checks and tests. Keep the audit in the same pipeline so the ordering is enforced.
- Cancel superseded PR runs; never cancel runs on `main` or a release build.
- Matrix legs all finish and report, rather than stopping at the first failure.
- The release flow itself (version, notes, tag, gates) is in [releasing](../releasing.md); CI only builds and publishes from the release it is handed.

## Pinning

- Pin every third-party CI dependency (actions, reusable pipelines, images) to an immutable commit SHA with a version comment. Platform-owned components may pin to a ref.
- New versions wait a seven-day cooldown before adoption, except platform-owned components.
- Look up the current version and confirm the exact tag exists before adding or bumping a dependency. Prefer platform-owned, then vendor-maintained, then community components with recent commits.
- Pin runner images to concrete labels, not floating `latest` aliases, and check the image's published manifest before relying on preinstalled software.

## Auditing

Workflow files are code with credentials attached, so they get a security audit in three places:

| Where | How |
| --- | --- |
| Every commit | An offline audit as a prek hook |
| `mise run ci-audit` | The full audit plus the pin check; part of `release:check` |
| First CI stage | The full audit with a read-only platform token, so online checks such as known vulnerabilities run |

A workflow change is not finished until `ci-audit` passes. When auditing a repo by hand, check against these:

- Token permissions are read-only by default, with write granted per job only where it uploads or pushes.
- Checkouts that don't push don't persist credentials.
- Secrets reach steps, never whole jobs, and are never echoed.
- Pipelines that publish artifacts skip the toolchain cache, because a cache hit skips verifying the toolchain that builds user-facing files.
- Concurrency, matrix, and runner labels follow the rules above.

Then compare against the template's pipelines; the bootstrap script's `existing` mode reports the diff.

## Annotating results

Failures land on the PR diff as file-and-line annotations, not only in logs.

- Prefer a tool's native output format for the platform; otherwise parse its plain output with a matcher the repo ships.
- Tools print paths relative to the repo root, which is why task scripts `cd` to `MISE_PROJECT_ROOT`.
- Platforms cap annotations per step. Keep findings at zero rather than accumulating them.
- After bootstrapping, push a throwaway branch with a deliberate lint failure to confirm annotations land.

## Caching

Every job starts clean, so only the platform cache and per-run artifacts carry state. Cache the mise data directory keyed on the platform and the mise config hash. Tools float on `latest`, so add a weekly component to the key; otherwise a cache hit never picks up moved versions.

## Debugging

"Works locally, fails in CI" usually means one of:

- A runner-image tool version differs from the local one.
- A local mise override hides a tool CI installs fresh.
- A floating tool moved this week.
- A fork PR runs with a read-only token.
