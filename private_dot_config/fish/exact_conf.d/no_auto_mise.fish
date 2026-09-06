# Homebrew's Fish hook runs before config.fish. Let the assembled config
# activate mise after its static PATH entries are in place.
set -gx MISE_FISH_AUTO_ACTIVATE 0
