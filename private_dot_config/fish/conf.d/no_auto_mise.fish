# mise gets auto-activated by default with a brew+fish install,
# but this means my subsequent fish_add_path calls in my fish config
# get prepended above mise, exactly what we DON'T want, so we turn this off
# then manually activate mise in project dirs as needed
# so it correctly pops to the front of PATH
set -gx MISE_FISH_AUTO_ACTIVATE 0
