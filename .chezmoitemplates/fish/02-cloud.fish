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
### Local embeddings — qmd reads the same Qwen3 GGUF that llama-server
### downloads into the HF hub cache for agentsview (unset until first download)
if count $HOME/.cache/huggingface/hub/models--Qwen--Qwen3-Embedding-0.6B-GGUF/snapshots/*/Qwen3-Embedding-0.6B-Q8_0.gguf >/dev/null
    set -gx QMD_EMBED_MODEL $HOME/.cache/huggingface/hub/models--Qwen--Qwen3-Embedding-0.6B-GGUF/snapshots/*/Qwen3-Embedding-0.6B-Q8_0.gguf
end
