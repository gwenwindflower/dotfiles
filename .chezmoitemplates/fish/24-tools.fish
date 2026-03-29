# =============================================================================
# 24 — Tools (fzf, ripgrep)
# =============================================================================

# fzf — read config file using fish builtins (avoids cat | tr subprocess)
set -gx FZF_DEFAULT_OPTS (string join ' ' < ~/.config/fzf/fzf.conf)
# fzf opts for interactive zoxide
set -gx _ZO_FZF_OPTS $FZF_DEFAULT_OPTS"\
--layout=reverse \
--height=90% \
--preview-window=wrap\
"
# fzf.fish plugin config
set -gx fzf_fd_opts --hidden
set -gx fzf_preview_file_cmd bat --style=numbers,changes --color always
set -gx fzf_preview_dir_cmd lsd --color=always --group-directories-first --tree --depth=2
set -gx fzf_diff_highlighter delta --paging=never --width=20
set -gx fzf_variables_opts --bind "\
ctrl-y:execute-silent( \
  echo {} \
  | xargs -I{} sh -c '"'eval printf '%s' \$$0'"' {} \
  | fish_clipboard_copy \
)+abort"
set -gx fzf_directory_opts --bind 'enter:become($EDITOR {} &>/dev/tty)'
fzf_configure_bindings --variables='ctrl-alt-v' --git_log= --git_status=

# ripgrep
set -gx RIPGREP_CONFIG_PATH "$HOME/.config/ripgrep/ripgrep.conf"
