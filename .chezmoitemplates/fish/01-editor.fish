# =============================================================================
# 01 — Editor
# =============================================================================
set -gx EDITOR nvim
set -gx NVIM_PLUGIN_DIR $XDG_DATA_HOME/nvim
set -gx NVIM_MASON_INSTALL $NVIM_PLUGIN_DIR/mason/packages
fish_add_path $NVIM_PLUGIN_DIR/mason/bin
