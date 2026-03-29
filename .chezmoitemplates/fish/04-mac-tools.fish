# =============================================================================
# 04 — macOS tools
# =============================================================================
#
#
# macOS GUI apps often use ~/Library/Application Support
# and some CLIs who use the technically 'correct' specification for macOS
# this makes it easier to reference
set -gx MACOS_CONFIG_HOME "$HOME/Library/Application Support"

# OrbStack is a higher-performance, lighter-weight alternative
# to Docker Desktop for macOS, it has a GUI and then a set of
# `docker` replacment CLIs we add to PATH
set -gx ORBSTACK_HOME ~/.orbstack
fish_add_path $ORBSTACK_HOME/bin

set -gx OBSIDIAN_HOME "$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents"
set -gx OBSIDIAN_DEFAULT_VAULT $OBSIDIAN_HOME/girlOS
# GUIs that have bundled CLIs located in their .app/Contents/
# we use -a to append rather than prepend as they are low-priority and don't conflict
fish_add_path -a /Applications/Obsidian.app/Contents/MacOS
fish_add_path -a /Applications/Monodraw.app/Contents/Resources/monodraw
