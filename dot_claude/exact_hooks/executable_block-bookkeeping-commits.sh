#!/usr/bin/env bash
# PreToolUse on Bash: in SPOT repos (SPEC.md + TODO.md at root), block commits
# whose content is only plan/spec bookkeeping (TODO.md, DONE.md, SPEC.md,
# specs/). Checkoffs ride inside behavior commits; the Phase close amends into
# the last commit. Deliberate planning-only commits use SPOT_PLAN_COMMIT=1.

set -euo pipefail

source "$(dirname "$0")/lib/hook-common.sh"

hook_read_input

command="$(hook_field '.tool_input.command')"
cwd="$(hook_field '.cwd')"
[ -z "$command" ] && exit 0

case "$command" in
  *"git commit"*) ;;
  *) exit 0 ;;
esac

# Amending is the sanctioned close path; SPOT_PLAN_COMMIT is the deliberate
# planning-only escape hatch.
case "$command" in
  *--amend* | *SPOT_PLAN_COMMIT=1*) exit 0 ;;
esac
[ "${SPOT_PLAN_COMMIT:-}" = "1" ] && exit 0

root="$(cd "$cwd" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null || true)"
[ -z "$root" ] && exit 0
[ -f "$root/SPEC.md" ] && [ -f "$root/TODO.md" ] || exit 0

cd "$root"
staged="$(git diff --cached --name-only)"
if [ -z "$staged" ]; then
  # `git commit -a` commits modified tracked files without prior staging.
  case "$command" in
    *" -a"* | *--all*) staged="$(git diff --name-only)" ;;
  esac
fi
[ -z "$staged" ] && exit 0

while IFS= read -r file; do
  case "$file" in
    TODO.md | DONE.md | SPEC.md | specs/*) ;;
    *) exit 0 ;;
  esac
done <<<"$staged"

cat >&2 <<EOF
BLOCKED: bookkeeping-only commit in a SPOT project.

Staged changes touch only plan/spec files:
$(echo "$staged" | sed 's/^/  /')

TODO checkoffs ride inside the behavior commit for their Objective, and the
Phase-close TODO→DONE move amends into the Phase's last commit:

  git commit --amend --no-edit

If this is deliberate planning-only work (scoping a multi-Phase plan, a
retrospective ADR alongside spec edits), re-run with the escape hatch:

  SPOT_PLAN_COMMIT=1 git commit ...
EOF
exit 2
