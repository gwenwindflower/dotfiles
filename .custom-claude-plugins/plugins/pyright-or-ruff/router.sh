#!/usr/bin/env bash
# Route Python LSP traffic per workspace:
#   pyrightconfig.json → pyright-langserver --stdio
#   otherwise          → ruff server (Ruff's native LSP)
#
# pyrightconfig.json is the strongest "this project wants Pyright" signal —
# pyproject.toml is too common to be a useful marker on its own. If a project
# uses Pyright via [tool.pyright] in pyproject.toml without a sidecar
# pyrightconfig.json, add an empty pyrightconfig.json to opt in.
exec "$(dirname "$0")/../../.utils/lsp-router.sh" \
  "pyrightconfig.json" "pyright-langserver --stdio" \
  "ruff server"
