# =============================================================================
# 11 — TypeScript (Bun, pnpm, Deno)
# =============================================================================

# mise is handled separately in 19-finalize.fish

# Something weird about the Homebrew install of bun
# causes bun to set its root orientation to ~/.cache/
# everything it normally does under ~/.bun gets stacked there,
# in addition to its actual ~/.cache/bun dir
# I've tried clearing and reinstalling
# I've swept for env vars that might be installing it
# no idea, so I've just fallen back to setting it explicitly to fix it
set -gx BUN_INSTALL $HOME/.bun
fish_add_path $BUN_INSTALL/bin

# DENO_DIR sets cache dir
# DENO_INSTALL_ROOT changes where installs go
# the default unset location is the path added below
fish_add_path ~/.deno/bin

# pnpm is nice and polite and actually puts their store
# in the right location instead of dropping it in a dot dir
# in HOME
set -gx PNPM_HOME $XDG_DATA_HOME/pnpm
fish_add_path $PNPM_HOME/bin
