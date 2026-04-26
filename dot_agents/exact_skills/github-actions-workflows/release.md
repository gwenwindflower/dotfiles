# Release workflow

Tag-triggered workflow that creates a GitHub Release with auto-generated notes. Decoupled from artifact builds — see [`release-build.md`](release-build.md) — so the release page appears immediately on tag push and artifacts attach asynchronously when the build finishes.

## Trigger

```yaml
on:
  push:
    tags: ["v*"]

permissions:
  contents: write
```

Use semver tags (`v1.2.3`). The tag is the source of truth — everything downstream reads `github.ref_name` or `github.event.release.tag_name`.

## Generating release notes with git-cliff

[git-cliff](https://git-cliff.org/) reads conventional-commit history and produces a markdown changelog. The repo needs a `cliff.toml` defining commit groups (feat, fix, etc.) and template formatting.

```yaml
- name: Checkout
  uses: actions/checkout@v4
  with:
    fetch-depth: 0  # full history + all tags for git-cliff

- name: Install git-cliff
  uses: taiki-e/install-action@v2
  with:
    tool: git-cliff
```

`fetch-depth: 0` is required — git-cliff diffs across tags, and the default shallow checkout has no tag history.

`taiki-e/install-action` installs prebuilt binaries fast (no `cargo install` compile time). It supports many CLI tools by name — check its README for the catalog.

## Capturing notes into a step output

```yaml
- name: Generate release notes
  id: notes
  env:
    TAG: ${{ github.ref_name }}
  run: |
    set -euo pipefail

    # --latest scopes to the most recent tag, --strip all drops header/footer
    notes=$(git cliff --latest --strip all --tag "$TAG")

    if [ -z "${notes//[[:space:]]/}" ]; then
      echo "::error::git-cliff produced empty release notes for $TAG"
      exit 1
    fi

    # Random heredoc delimiter avoids collision if notes contain "EOF"
    delimiter="EOF_$(openssl rand -hex 8)"
    {
      echo "notes<<${delimiter}"
      printf '%s\n' "$notes"
      echo "${delimiter}"
    } >> "$GITHUB_OUTPUT"

    # Mirror to job summary for at-a-glance review
    {
      echo "## Release notes for \`$TAG\`"
      echo ""
      printf '%s\n' "$notes"
    } >> "$GITHUB_STEP_SUMMARY"
```

Two non-obvious bits:

- **Empty-notes guard**: if a release accidentally contains no conventional commits, git-cliff returns empty output. Failing loudly here prevents publishing a release with a blank body.
- **Random heredoc delimiter**: `GITHUB_OUTPUT` uses heredoc syntax for multi-line values. Picking a random delimiter prevents the value from accidentally containing the delimiter and breaking parsing.

## Creating the release

```yaml
- name: Create GitHub release
  env:
    GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    TAG: ${{ github.ref_name }}
    NOTES: ${{ steps.notes.outputs.notes }}
  run: |
    gh release create "$TAG" \
      --title "$TAG" \
      --notes "$NOTES" \
      --verify-tag
```

`--verify-tag` ensures the tag exists and points at a commit before the release is created (catches the rare case where a tag was deleted between push and workflow start). The release is published (not draft) so `release_build.yml` fires immediately.

## Why publish before artifacts exist

Users hitting the release page get release notes right away. The artifact build (which can take 5–10 minutes for cross-compilation + Homebrew publish) attaches binaries when ready. If you'd rather not show an empty release, create a draft release here and have a downstream workflow flip it to published after artifacts upload — but draft releases don't fire `release: published`, so the trigger chain breaks. The published-first model is simpler.
