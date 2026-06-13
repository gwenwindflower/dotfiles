# sprite-bootstrap

Bootstrap a fresh Fly.io Sprite from this dotfiles repo. Pulls the repo tarball,
copies the files listed in `manifest.ts` into place, configures git identity,
and switches the login shell to fish. Designed to be invoked via `sprite exec`
and discarded after running — leaves no source tree or extra binaries on disk.

## Source

- `sprite-bootstrap.ts` (entry point)
- `assets/sprite-bootstrap/manifest.ts` (file/dir/copy lists)
- No tests — the integration target is a live Fly machine.

## Run

Don't invoke locally. Triggered from the `spritecan` fish function which calls
`sprite exec` with the raw GitHub URL:

```text
deno run \
  --allow-net=codeload.github.com \
  --allow-read \
  --allow-write=$HOME,$TMPDIR,/tmp \
  --allow-env=HOME,TMPDIR \
  --allow-run=git,tar,sudo,chsh,which,id \
  https://raw.githubusercontent.com/gwenwindflower/dotfiles/main/.utils/sprite-bootstrap.ts
```

The branch is hardcoded to `main` and the repo to `gwenwindflower/dotfiles`.

## Auth

Out-of-band: run `gh auth login -p https -w` once on the Sprite before bootstrap.
gh registers itself as a git credential helper, so authenticated HTTPS
clone/push/pull works for the lifetime of the Sprite without a token in env.

## Manifest

`assets/sprite-bootstrap/manifest.ts` exports three lists:

- `dirs` — directories to create
- `files` — files to write (path + content)
- `copies` — repo-relative source paths copied into `$HOME`

Edit the manifest, not the bootstrap script, when adding what gets provisioned.
