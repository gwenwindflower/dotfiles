# =============================================================================
# 19 — Finalize PATH
# =============================================================================

# Finalize PATH ordering,
# ensures mise -> .local/bin -> Homebrew
# -> language and tool-specific paths -> OS-specific paths -> nvim mason installs

# Re-add Homebrew and ~/.local/bin with -m here
# which pushes them to the front of PATH
# so they take precedence over all
# the language and tool-specific paths set above
fish_add_path -m $HOMEBREW_PREFIX/bin
fish_add_path -m $HOME/.local/bin
set -l _pre_mise_path $PATH
mise activate fish | source

# Finally, route mise's prepended dirs from PATH into fish_user_paths
# so they survive fish's user-paths-prepend step
# captures PATH before activate then diffs after
# adds the diff that mise added to fish_user_paths
# with -m flag to force move
set -l _mise_added
for p in $PATH
    contains -- $p $_pre_mise_path; or set -a _mise_added $p
end
test -n "$_mise_added"; and fish_add_path -gm $_mise_added
# This ensures mise always ends up at the front, where it needs to be
