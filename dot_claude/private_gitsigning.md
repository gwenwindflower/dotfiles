## Git Signing Disabled in Sandbox

Commit signing is disabled in Claude Code's sandbox via a `SessionStart` hook (`~/.claude/hooks/set-git-nosign.sh`). The global gitconfig requires SSH signing through 1Password's agent, which the sandbox can't access. The hook sets `GIT_CONFIG_COUNT` env vars to override `commit.gpgsign` and `tag.gpgsign` to `false`, and sets the author name to `Claude Code (winnie)`. Winnie's normal terminal commits remain signed. Do not attempt to re-enable signing or use `--gpg-sign` flags.
