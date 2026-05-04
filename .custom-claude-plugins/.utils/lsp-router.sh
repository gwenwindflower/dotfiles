#!/usr/bin/env bash
# Generic LSP router for conditional language servers.
#
# Walks up from $PWD looking for marker files. The first conditional whose
# markers are found wins; if none match, the trailing fallback runs.
#
# Usage:
#   lsp-router.sh <markers> <cmd> [<markers> <cmd>]... <fallback-cmd>
#
# - <markers> is a comma-separated list of filenames to look for at every
#   directory from $PWD up to /. Any single match wins for that conditional.
# - <cmd> is a full command line as a single argument; it gets word-split on
#   spaces (no shell quoting, keep it simple — commands here should not need
#   it). The first word must be on $PATH.
#
# Example (per-plugin router.sh):
#   exec "$(dirname "$0")/../../.utils/lsp-router.sh" \
#     "deno.json,deno.jsonc" "deno lsp" \
#     "typescript-language-server --stdio"
#
# Failure modes are reported on stderr with enough context for an agent or
# user to fix without spelunking.

set -euo pipefail

die() {
  printf '[lsp-router] %s\n' "$@" >&2
  exit "${EXIT_CODE:-1}"
}

find_marker() {
  local markers="$1" dir="$PWD"
  while :; do
    local IFS=','
    for m in $markers; do
      [ -e "$dir/$m" ] && return 0
    done
    local parent
    parent="$(dirname "$dir")"
    [ "$parent" = "$dir" ] && return 1
    dir="$parent"
  done
}

run() {
  local cmdline="$1"
  # shellcheck disable=SC2206
  local argv=( $cmdline )
  if ! command -v "${argv[0]}" >/dev/null 2>&1; then
    EXIT_CODE=127 die \
      "LSP command not found on PATH: ${argv[0]}" \
      "             attempted: $cmdline" \
      "             cwd:       $PWD" \
      "Install the tool (or fix PATH for the Claude Code environment), then" \
      "restart Claude Code so the LSP plugin re-spawns the server."
  fi
  exec "${argv[@]}"
}

# Need an odd number of args: 2N conditionals + 1 fallback (N >= 0).
if [ "$#" -lt 1 ] || [ $(( $# % 2 )) -ne 1 ]; then
  EXIT_CODE=64 die \
    "Bad arguments. Expected pairs of <markers> <cmd>, then a final <fallback-cmd>." \
    "Got $# arg(s): $*"
fi

while [ "$#" -gt 1 ]; do
  markers="$1"
  cmdline="$2"
  shift 2
  if find_marker "$markers"; then
    run "$cmdline"
  fi
done

run "$1"
