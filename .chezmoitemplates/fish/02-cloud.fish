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
### AGENTSVIEW
set -gx AGENTSVIEW_DATA_DIR $XDG_DATA_HOME/agentsview
### zvec-grep — default model for new workspace indexes; existing indexes keep theirs
set -gx ZVEC_GREP_EMBEDDING local/potion-code-16m-v2
