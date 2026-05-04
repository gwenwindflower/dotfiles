#!/usr/bin/env bash
# Route TS/JS LSP traffic per workspace:
#   deno.json/deno.jsonc → `deno lsp`
#   otherwise            → typescript-language-server --stdio
exec "$(dirname "$0")/../../.utils/lsp-router.sh" \
  "deno.json,deno.jsonc" "deno lsp" \
  "typescript-language-server --stdio"
