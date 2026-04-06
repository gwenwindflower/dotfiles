# =============================================================================
# 00 — Core environment
# =============================================================================

#  PATH
# Construct fish_user_paths as a global (not universal) to avoid stale accumulation
set -e fish_user_paths
set -gx fish_user_paths $HOME/.local/bin
fish_add_path -g $HOME/.local/bin

#  Terminal and Shell
set -gx SHELL $HOMEBREW_PREFIX/bin/fish

#  GPG
set -gx GPG_TTY (tty)

#  XDG
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config

# For tools that look for $TEMP instead of $TMPDIR
# e.g. PyTest
set -gx TEMP $TMPDIR

#  Pager, docs, man
# moor as bat's pager, bat as global pager, themed man pages
set -gx MOOR "\
--quit-if-one-screen \
--wrap \
--no-linenumbers \
--style=catppuccin-frappe \
"
set -gx PAGER $HOMEBREW_PREFIX/bin/bat
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
# tldr client config
set -gx TLRC_CONFIG $XDG_CONFIG_HOME/tlrc/tlrc.toml

#  tmux
set -gx TMUX_PLUGIN_MANAGER_PATH $XDG_CONFIG_HOME/tmux/plugins
set -gx TMUX_PLUGIN_MANAGER_INSTALL $HOMEBREW_PREFIX/opt/tpm/share/tpm

#  1Password env dir
set -gx OP_ENV_DIR $XDG_CONFIG_HOME/op/environments

#  Project Bookmarks
set -gx PROJECTS $HOME/dev

#  Fish configs
set -gx fish_greeting
set -a fish_lsp_ignore_paths \
    '**/.git/**', \
    '**/node_modules/**', \
    '**/vendor/**', \
    '**/__pycache__/**', \
    '**/docker/**', \
    '**/containerized/**', \
    '**/*.log', \
    "**/*.tmpl"
