# =============================================================================
# 23 — Bindings
# =============================================================================
fish_vi_key_bindings

# 'supernav'
# p = backward-kill-word, or prevd on empty cmdline
# n = forward-word (accepts autosuggestion at line end), or nextd on empty cmdline
# via supernav-prev.fish and supernav-next.fish
# cohesive with standard ctrl-n to accept full autosuggestion
# and alt-f/b token navigation
bind --user -M insert ctrl-alt-b supernav-prev
bind --user -M insert ctrl-alt-f supernav-next
bind --user ctrl-alt-b supernav-prev
bind --user ctrl-alt-f supernav-next
bind --user -M insert ctrl-super-b supernav-prev
bind --user -M insert ctrl-super-f supernav-next
bind --user ctrl-super-b supernav-prev
bind --user ctrl-super-f supernav-next
# launch yazi file explorer
bind --user -M insert super-f "ff; commandline -f repaint"
bind --user super-f "ff; commandline -f repaint"

# TUI git tools
bind --user -M insert super-g "commandline -r 'lazygit'; commandline -f execute"
bind --user super-g "commandline -r 'lazygit'; commandline -f execute"
bind --user -M insert alt-g "commandline -r 'lazygit'; commandline -f execute"
bind --user alt-g "commandline -r 'lazygit'; commandline -f execute"
bind --user -M insert ctrl-super-g "commandline -r 'git forgit log'; commandline -f execute"
bind --user ctrl-super-g "commandline -r 'git forgit log'; commandline -f execute"
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
# wrapping commands
bind --user -M insert super-P _wrap_echo
bind --user super-P _wrap_echo
# 1Password env wrapper
bind --user -M insert ctrl-o _wrap_op_interactive
bind --user ctrl-o _wrap_op_interactive
bind --user -M insert ctrl-super-o "_wrap_op_interactive -a"
bind --user ctrl-super-o "_wrap_op_interactive -a"
bind --user -M insert ctrl-alt-o "_wrap_op_interactive -a"
bind --user ctrl-alt-o "_wrap_op_interactive -a"
