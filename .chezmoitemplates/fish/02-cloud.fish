# =============================================================================
# 02 — Cloud
# =============================================================================

## Platforms
{{ if eq .chezmoi.os "darwin" -}}
set -gx GCLOUD_HOME $HOMEBREW_PREFIX/share/google-cloud-sdk
fish_add_path $GCLOUD_HOME/bin
{{ end -}}

## AI
### Claude
set -gx CLAUDE_HOME $HOME/.claude
### OpenCode
set -gx OPENCODE_ENABLE_EXA 1
