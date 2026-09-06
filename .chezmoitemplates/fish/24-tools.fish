# =============================================================================
# 24 — Tools (fzf, ripgrep)
# =============================================================================

# fzf — read config file using fish builtins (avoids cat | tr subprocess)
set -gx FZF_DEFAULT_OPTS (string join ' ' < ~/.config/fzf/fzf.conf)
# fd as the default source for bare fzf — including dirs and dot dirs
set -gx FZF_DEFAULT_COMMAND "fd --color=always --hidden"
# fzf.fish plugin config
set -gx fzf_fd_opts --hidden
set -gx fzf_preview_file_cmd bat --style=numbers,changes --color always
set -gx fzf_preview_dir_cmd lsd --color=always --group-directories-first --tree --depth=2
set -gx fzf_diff_highlighter delta --paging=never --width=20
# fzf.fish wrappers capture fzf stdout — override our global enter:become so
# the wrapper actually receives a selection and can rewrite the command line.
set -gx fzf_history_opts --bind 'enter:accept'
set -gx fzf_processes_opts --bind 'enter:accept'
# Variables: enter inserts $NAME (plugin default)
# ctrl-y copies the value to clipboard then aborts.
set -gx fzf_variables_opts \
    --bind 'enter:accept' \
    --bind "\
ctrl-y:execute-silent( \
  echo {} \
  | xargs -I{} sh -c '"'eval printf '%s' \$$0'"' {} \
  | fish_clipboard_copy \
)+abort"
set -gx fzf_directory_opts --bind 'enter:become($EDITOR {} &>/dev/tty)'
# reassign variables so that all active fzf.fish commands 
# are ctrl-alt-<mnemonic {s(tatus)/v(ariables)/p(rocesses)/f(files and dirs)}>
# strip git_log binding as forgit's it's nicer, so it uses the above pattern
# with g as binding - ctrl-alt-g
fzf_configure_bindings --variables='ctrl-alt-v' --git_log=

# yazi built-in fzf and zoxide
set -gx YAZI_ZOXIDE_OPTS '--bind=enter:accept'

# ripgrep — deliberately not exported: RIPGREP_CONFIG_PATH is inherited by every
# tool that shells out to rg, and --pretty breaks machine-parsed output. The rg
# function applies the config for interactive use only.

# qmd
set -gx QMD_EDITOR_URI "obsidian://open?path={path}"

# linear
set -gx LINEAR_CLI_TRUST_PAGER 1
