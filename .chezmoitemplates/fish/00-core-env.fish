# =============================================================================
# 00 — Core environment
# =============================================================================

#  PATH
# Instantiate fish_user_paths as a fresh global (not universal) variable
# this avoids stale paths accumulating and tracking hidden state
set -e fish_user_paths
set -gx fish_user_paths $HOME/.local/bin

#  Terminal and Shell
set -gx SHELL (command --search fish)

#  Editor
set -gx EDITOR nvim

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
if command -q moor
    set -gx PAGER (command --search moor)
else if command -q bat
    set -gx PAGER (command --search bat)
end
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
# tldr client config
set -gx TLRC_CONFIG $XDG_CONFIG_HOME/tlrc/tlrc.toml

#  tmux
set -gx TMUX_PLUGIN_MANAGER_PATH $XDG_CONFIG_HOME/tmux/plugins
{{ if eq .chezmoi.os "darwin" -}}
set -gx TMUX_PLUGIN_MANAGER_INSTALL $HOMEBREW_PREFIX/opt/tpm/share/tpm
{{ end -}}

#  1Password
set -gx OP_ACCOUNT my.1password.com
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

#    Mason - Neovim tooling (formatter, linter, DAP, LSP, etc.) package manager
# No strict need to have mason's bin directory on PATH
# they are primarily wired up through Neovim plugins
# but it can be helpful to easily run LSPs and formatters, etc. directly on-the-fly
# without an extra project-local install
fish_add_path $XDG_DATA_HOME/nvim/mason/bin
