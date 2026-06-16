# =============================================================================
# 04 — macOS tools
# =============================================================================

# SSH (macOS only — on Linux, ssh agent forwarding handles this)
set -gx SSH_AUTH_SOCK "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

#  OrbStack
# OrbStack has this gnarly setup script
# but all it does is add OrbStack's bin dir to PATH
# this is cleaner for fish
set -gx ORBSTACK_HOME ~/.orbstack
fish_add_path $ORBSTACK_HOME/bin

#  macOS GUI apps
# often use ~/Library/Application Support
# and some CLIs who use the technically 'correct' specification for macOS
# this makes it easier to reference
set -gx MACOS_CONFIG_HOME "$HOME/Library/Application Support"
#  GUIs that have bundled CLIs located in their .app/Contents/
## 󰸌 Monodraw
fish_add_path /Applications/Monodraw.app/Contents/Resources/
##  Obsidian
### This isn't an internal env var
### just a convenient way to get to the buried mobile iCloud path
### that iCloud-synced Obsidian lives at
set -gx OBSIDIAN_HOME "$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents"
set -gx OBSIDIAN_DEFAULT_VAULT $OBSIDIAN_HOME/girlOS
fish_add_path /Applications/Obsidian.app/Contents/MacOS
