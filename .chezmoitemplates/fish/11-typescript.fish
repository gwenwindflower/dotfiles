# =============================================================================
# 11 — TypeScript (Bun, pnpm, Deno)
# =============================================================================

# These are intentionally not special env vars
# and do not configure the tools
# these are set to the default locations for each
# to ensure the smoothest operation across upgrades
# at the sacrifice of unified global store paths
# bun and deno use the ~/.<tool> pattern like npm
# whereas pnpm more correctly uses $XDG_DATA_HOME
# I used to force them all into $XDG_DATA_HOME
# but it's not worth the trouble
set -gx BUN_HOME $HOME/.bun
set -gx DENO_HOME $HOME/.deno
set -gx PNPM_HOME $XDG_DATA_HOME/pnpm

fish_add_path $BUN_HOME/bin
fish_add_path $DENO_HOME/bin
fish_add_path $PNPM_HOME/bin
