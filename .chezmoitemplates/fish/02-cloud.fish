# =============================================================================
# 02 — Cloud
# =============================================================================

## Platforms
set -gx GCLOUD_HOME $HOMEBREW_PREFIX/share/google-cloud-sdk
fish_add_path $GCLOUD_HOME/bin

## AI
set -gx CLAUDE_HOME $HOME/.claude
set -gx OPENCODE_ENABLE_EXA 1
