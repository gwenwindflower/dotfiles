# =============================================================================
# 19 — Finalize PATH
# =============================================================================

# Finalize static PATH ordering before mise adds the active toolset.
{{ if eq .chezmoi.os "darwin" -}}
## Brew priorities over macOS builtins
###  SQLite
fish_add_path $HOMEBREW_PREFIX/opt/sqlite/bin
### 󰘂 curl
fish_add_path /opt/homebrew/opt/curl/bin
fish_add_path -m $HOMEBREW_PREFIX/bin
{{ end -}}
fish_add_path -m $HOME/.local/bin

if status is-interactive
    mise activate fish | source
else
    mise activate fish --shims | source
end
