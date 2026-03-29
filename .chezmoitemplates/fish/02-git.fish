# =============================================================================
# 02 — Git
# =============================================================================
set -gx GIT_PAGER delta
set -gx DFT_DISPLAY inline
set -gx GH_USER gwenwindflower
set -gx FORGIT_NO_ALIASES 1
set -gx FORGIT_GLO_FORMAT "%C(green)%h %C(reset)%d %s %C(magenta)%cr%C(reset)"
set -gx FORGIT_STASH_FZF_OPTS '--bind="ctrl-d:reload(git stash drop $(cut -d: -f1 <<<{}) 1>/dev/null && git stash list)"'
if test -f $HOMEBREW_PREFIX/share/forgit/forgit.plugin.fish
    source $HOMEBREW_PREFIX/share/forgit/forgit.plugin.fish
end
fish_add_path $FORGIT_INSTALL_DIR/bin
