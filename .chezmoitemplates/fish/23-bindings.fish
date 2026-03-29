# =============================================================================
# 23 — Bindings
# =============================================================================
fish_vi_key_bindings

# bracket nav <-[ ]->
bind --user -M insert alt-h prevd-or-backward-word
bind --user -M insert alt-l nextd-or-forward-word
bind --user alt-h prevd-or-backward-word
bind --user alt-l nextd-or-forward-word

bind --user -M insert alt-H backward-kill-word
bind --user -M insert alt-L kill-word-vi
bind --user alt-H backward-kill-word
bind --user alt-L kill-word-vi

# launch yazi file explorer
bind --user -M insert super-f "ff; commandline -f repaint"
bind --user super-f "ff; commandline -f repaint"
bind --user -M insert alt-f "ff; commandline -f repaint"
bind --user alt-f "ff; commandline -f repaint"

# TUI git tools
bind --user -M insert super-g "commandline -r 'lazygit'; commandline -f execute"
bind --user super-g "commandline -r 'lazygit'; commandline -f execute"
bind --user -M insert alt-g "commandline -r 'lazygit'; commandline -f execute"
bind --user alt-g "commandline -r 'lazygit'; commandline -f execute"
bind --user -M insert ctrl-alt-g "commandline -r 'git forgit log'; commandline -f execute"
bind --user ctrl-alt-g "commandline -r 'git forgit log'; commandline -f execute"
bind --user -M insert super-G "commandline -r 'gh dash'; commandline -f execute"
bind --user super-G "commandline -r 'gh dash'; commandline -f execute"
bind --user -M insert alt-G "commandline -r 'gh dash'; commandline -f execute"
bind --user alt-G "commandline -r 'gh dash'; commandline -f execute"

# clearing and reloading
bind --user -M insert super-r "fresh -r"
bind --user super-r "fresh -r"
bind --user -M insert alt-r "fresh -r"
bind --user alt-r "fresh -r"
bind --user -M insert super-e "fresh -c"
bind --user super-e "fresh -c"
# alt-e defaults to edit commandline in $EDITOR
# but thankfully has an alt binding as alt-v ($VISUAL)
# which is what I would remap it to
bind --user -M insert alt-e "fresh -c"
bind --user alt-e "fresh -c"
bind --user -M insert super-R "fresh; commandline -f repaint"
bind --user super-R "fresh; commandline -f repaint"
bind --user -M insert alt-R "fresh; commandline -f repaint"
bind --user alt-R "fresh; commandline -f repaint"
bind --user -M insert ctrl-super-r "fresh -g; commandline -f repaint"
bind --user ctrl-super-r "fresh -g; commandline -f repaint"
bind --user -M insert ctrl-alt-r "fresh -g; commandline -f repaint"
bind --user ctrl-alt-r "fresh -g; commandline -f repaint"

# print, list, pager
bind --user -M insert super-p "commandline -r 'lsd -lAg .'; commandline -f execute"
bind --user super-p "commandline -r 'lsd -lAg .'; commandline -f execute"
bind --user -M insert alt-p "commandline -r 'lsd -lAg .'; commandline -f execute"
bind --user alt-p "commandline -r 'lsd -lAg .'; commandline -f execute"
# wrapping commands
bind --user -M insert alt-P _wrap_echo
bind --user alt-P _wrap_echo
bind --user -M insert super-P _wrap_echo
bind --user super-P _wrap_echo
# 1Password env wrapper
bind --user -M insert ctrl-o "_wrap_op_interactive -a"
bind --user ctrl-o "_wrap_op_interactive -a"
bind --user -M insert ctrl-alt-o _wrap_op_interactive
bind --user ctrl-alt-o _wrap_op_interactive
