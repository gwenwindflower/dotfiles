#!/bin/sh

frappe_text="#c6d0f5"
frappe_mauve="#ca9ee6"
frappe_green="#a6d189"
frappe_surface0="#414559"

choose_option() {
  header=$1
  shift

  gum choose \
    --header "$header" \
    --height "$#" \
    --cursor "❯ " \
    --no-show-help \
    --cursor.foreground "$frappe_mauve" \
    --cursor.background "$frappe_surface0" \
    --header.foreground "$frappe_mauve" \
    --item.foreground "$frappe_text" \
    --selected.foreground "$frappe_green" \
    "$@"
}

shell_quote() {
  case $1 in
    '' | *[!A-Za-z0-9_./:@%+=,-]*)
      printf "'%s'" "$(printf '%s' "$1" | sed "s/'/'\\\\''/g")"
      ;;
    *)
      printf '%s' "$1"
      ;;
  esac
}

build_agent_command() {
  agent_command=$(shell_quote "$1")
  shift

  for agent_argument in "$@"; do
    agent_command="$agent_command $(shell_quote "$agent_argument")"
  done

  printf '%s\n' "$agent_command"
}

launch_agent() {
  kind=$1
  shift

  herdr_bin=${HERDR_BIN_PATH:-herdr}
  workspace=${HERDR_ACTIVE_WORKSPACE_ID:?missing active workspace}
  cwd=${HERDR_ACTIVE_PANE_CWD:-$PWD}

  created=$(
    "$herdr_bin" tab create \
      --workspace "$workspace" \
      --cwd "$cwd" \
      --focus
  )
  pane=$(printf '%s\n' "$created" | jq -er '.result.root_pane.pane_id')
  agent_command=$(build_agent_command "$kind" "$@")

  "$herdr_bin" pane run "$pane" "$agent_command" >/dev/null
}
