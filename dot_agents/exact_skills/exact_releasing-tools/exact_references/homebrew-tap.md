# Homebrew tap

Standalone CLIs publish a formula to `<owner>/homebrew-tap` so users run `brew install <owner>/tap/<name>`. Herdr plugins and libraries skip this.

## One-time setup per owner

1. Create `<owner>/homebrew-tap` (public, empty README, `Formula/` directory).
2. Create a fine-grained PAT scoped to that repository with **Contents: read and write**. Name it for the tap; rotate yearly.

## Per repository

1. `mise run repo:settings --homebrew` sets the `HOMEBREW_TAP` repository variable to `true`; the `homebrew` job in `release-build.yml` is gated on it.
2. `gh secret set HOMEBREW_TAP_TOKEN` with the PAT.
3. The repository description doubles as the formula `desc`; set it before the first release.

## How the job works

After assets upload, the `homebrew` job checks out the release tag, runs `mise run release:formula <tag>`, and pushes `dist/Formula/<name>.rb` to the tap.

`release:formula` downloads every `*.tgz.sha256` from the release, renders `.github/homebrew/formula.rb.tmpl` with the four target URLs and checksums, the version, the repo description, and a class name derived from the tool name (`my-tool` becomes `MyTool`), and writes the formula. It runs locally too, which is how to debug a rendering problem:

```bash
mise run release:formula v0.1.0 && cat dist/Formula/<name>.rb
brew install --formula dist/Formula/<name>.rb && <binary> --version
```

The formula uses `on_macos`/`on_linux` with `on_arm`/`on_intel` blocks, so all four archives must exist. Homebrew extracts the archive's single top-level directory and `bin.install` picks the binary out of it.

## Troubleshooting

| Symptom | Cause |
| --- | --- |
| Job skipped | `HOMEBREW_TAP` variable unset or not `true` |
| `No checksum uploaded for ...` | A build leg failed or the archive name differs from `<name>-<target>-v<version>.tgz` |
| Push rejected | PAT lacks contents write on the tap, or expired |
| `brew install` audit failure | Description empty (set the repo description) or version mismatch with `--version` output |
