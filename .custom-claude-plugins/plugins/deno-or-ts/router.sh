#!/usr/bin/env bash
# Route TS/JS LSP traffic per workspace:
#   deno.json/deno.jsonc → `deno lsp`
#   otherwise            → typescript-language-server --stdio
exec if-up \
  "deno.json,deno.jsonc" "deno lsp" \
  --else "typescript-language-server --stdio"
