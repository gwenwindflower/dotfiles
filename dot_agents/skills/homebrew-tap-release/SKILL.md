---
name: homebrew-tap-release
description: Publish tools to the personal Homebrew tap at g15r/homebrew-tap via homebrew-releaser. Use when setting up Homebrew distribution for a new project, debugging a failed tap release, or reviewing the release workflow.
---

# Homebrew Tap Release

Publish compiled binaries to the personal Homebrew tap at [g15r/homebrew-tap](https://github.com/g15r/homebrew-tap) using the [homebrew-releaser](https://github.com/Justintime50/homebrew-releaser) GitHub Action.

## Tap details

- **Owner**: `g15r` (GitHub org used for public packages)
- **Tap repo**: `g15r/homebrew-tap`
- **Formula folder**: `Formula/`
- **Users install via**: `brew install g15r/tap/<formula>`

## How it works

The release pipeline has two jobs triggered by `on: release: types: [published]`:

1. **build** -- compile cross-platform binaries, package tarballs, upload as release assets
2. **homebrew** -- `homebrew-releaser@v3` clones the tap repo, generates a Ruby formula from the release assets, and pushes it

homebrew-releaser auto-generates the formula file (named after the repo), computes checksums, and commits to the tap. It also updates the tap README table when `update_readme_table: true`.

## Tarball naming convention

homebrew-releaser expects release assets matching this exact pattern (version has **no** leading `v`):

```text
{repo}-{version}-{os}-{arch}.tar.gz
```

Example for repo `winline`, tag `v0.4.0`:

```text
winline-0.4.0-darwin-arm64.tar.gz
winline-0.4.0-darwin-amd64.tar.gz
winline-0.4.0-linux-arm64.tar.gz
winline-0.4.0-linux-amd64.tar.gz
```

The download URL pattern homebrew-releaser constructs:

```text
https://github.com/{owner}/{repo}/releases/download/{tag}/{repo}-{version}-{os}-{arch}.tar.gz
```

## Target platforms

Enable per-platform with boolean flags. All four are typically enabled:

| Flag | Platform |
| --- | --- |
| `target_darwin_amd64` | macOS Intel |
| `target_darwin_arm64` | macOS Apple Silicon |
| `target_linux_amd64` | Linux x86_64 |
| `target_linux_arm64` | Linux ARM |

## Workflow template

```yaml
name: release

on:
  release:
    types: [published]

jobs:
  build:
    name: Build and upload binaries
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - uses: actions/checkout@v6

      # -- language-specific setup and build steps go here --

      - name: Package tarballs
        run: |
          VERSION="${{ github.event.release.tag_name }}"
          VERSION_CLEAN="${VERSION#v}"

          for TARGET in darwin-arm64 darwin-amd64 linux-arm64 linux-amd64; do
            BINARY="dist/<binary-name>-${TARGET}"
            ARCHIVE="<binary-name>-${VERSION_CLEAN}-${TARGET}.tar.gz"
            tar -czf "${ARCHIVE}" -C dist "<binary-name>-${TARGET}"
            echo "Created ${ARCHIVE}"
          done

      - name: Upload release assets
        env:
          GH_TOKEN: ${{ github.token }}
        run: |
          VERSION="${{ github.event.release.tag_name }}"
          VERSION_CLEAN="${VERSION#v}"

          for TARGET in darwin-arm64 darwin-amd64 linux-arm64 linux-amd64; do
            ARCHIVE="<binary-name>-${VERSION_CLEAN}-${TARGET}.tar.gz"
            gh release upload "${VERSION}" "${ARCHIVE}"
          done

  homebrew:
    name: Update Homebrew tap
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Release to Homebrew tap
        uses: Justintime50/homebrew-releaser@v3
        with:
          homebrew_owner: g15r
          homebrew_tap: homebrew-tap
          formula_folder: Formula
          github_token: ${{ secrets.HOMEBREW_TAP_GITHUB_TOKEN }}
          commit_owner: github-actions[bot]
          commit_email: github-actions[bot]@users.noreply.github.com
          install: 'bin.install "<binary-name>"'
          test: 'assert_match("USAGE", shell_output("#{bin}/<binary-name> --help"))'
          target_darwin_amd64: true
          target_darwin_arm64: true
          target_linux_amd64: true
          target_linux_arm64: true
          update_readme_table: true
          skip_commit: false
```

Replace `<binary-name>` with the actual binary name (should match the repo name for homebrew-releaser to work correctly).

## Required secret

`HOMEBREW_TAP_GITHUB_TOKEN` -- a GitHub PAT with `repo` scope, stored as a repository secret on the **source** repo (not the tap). It needs write access to `g15r/homebrew-tap`.

## Key homebrew-releaser options

| Option | Purpose |
| --- | --- |
| `depends_on` | Ruby DSL for formula deps, e.g. `"bash" => :build` |
| `test` | Ruby block for `brew test`, receives `bin`, `testpath` |
| `skip_commit` | Set `true` for dry-run on first setup |
| `debug` | Enable verbose logging |
| `update_readme_table` | Auto-generates a project table in the tap README (requires `<!-- project_table_start -->` / `<!-- project_table_end -->` comment tags) |
| `version` | Override auto-detected version (rarely needed) |
| `custom_require` | Add `require_relative` at top of formula (for custom download strategies) |

## First-time setup checklist

1. Ensure `g15r/homebrew-tap` repo exists with a `Formula/` directory
2. Create a GitHub PAT with `repo` scope
3. Add it as `HOMEBREW_TAP_GITHUB_TOKEN` secret on the source repo
4. Add the release workflow (template above) with `skip_commit: true` and `debug: true`
5. Cut a release, verify the generated formula looks correct in the action logs
6. Set `skip_commit: false`, cut another release
7. Verify: `brew tap g15r/tap && brew install <formula>`

## Troubleshooting

- **Checksum mismatch**: tarball naming doesn't match the expected pattern -- verify `{repo}-{version}-{os}-{arch}.tar.gz` with no `v` prefix on version
- **Formula not updating**: check that `HOMEBREW_TAP_GITHUB_TOKEN` has write access to the tap repo
- **`brew audit` failures**: ensure semver tags (`v1.2.3`), valid `install` and `test` blocks
- **Binary not found after install**: the `install` block must reference the exact filename inside the tarball
