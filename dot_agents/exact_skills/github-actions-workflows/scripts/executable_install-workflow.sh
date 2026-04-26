#!/usr/bin/env bash
# Install a Supermodel Labs GitHub Actions workflow template into a project.
#
# Substitutes @@BINARY@@, @@REPO@@, @@HOMEBREW_OWNER@@ in the templates.
# Toolchain setup blocks (>>> TOOLCHAIN_SETUP <<<, etc.) remain for the agent
# to fill in based on the project's language.

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  install-workflow.sh --workflow TYPE [options]

Required:
  --workflow TYPE     One of: ci, release, release-build, all

Options:
  --project DIR       Target project root (default: cwd)
  --binary NAME       Installed binary name (e.g. "rei")
  --repo NAME         Source repo name (e.g. "reishi")
  --owner NAME        Homebrew tap owner (default: "supermodellabs")
  --force             Overwrite existing workflow files
  -h, --help          Show this help

Examples:
  install-workflow.sh --workflow ci --binary rei
  install-workflow.sh --workflow all --binary rei --repo reishi
  install-workflow.sh --workflow release-build --binary rei --repo reishi --force

Notes:
- The "release" workflow is fully toolchain-agnostic and needs no substitutions.
- "ci" and "release-build" leave >>> TOOLCHAIN_SETUP <<< / >>> *_COMMAND <<<
  markers in place. The agent must replace these with the project's actual
  setup action and build/test/lint commands after install.
EOF
}

WORKFLOW=""
PROJECT="$PWD"
BINARY=""
REPO=""
OWNER="supermodellabs"
FORCE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --workflow) WORKFLOW="$2"; shift 2 ;;
    --project)  PROJECT="$2"; shift 2 ;;
    --binary)   BINARY="$2"; shift 2 ;;
    --repo)     REPO="$2"; shift 2 ;;
    --owner)    OWNER="$2"; shift 2 ;;
    --force)    FORCE=1; shift ;;
    -h|--help)  usage; exit 0 ;;
    *)          echo "Unknown arg: $1" >&2; usage >&2; exit 2 ;;
  esac
done

[[ -n "$WORKFLOW" ]] || { echo "error: --workflow required" >&2; usage >&2; exit 2; }

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ASSETS="$SKILL_DIR/assets"
DEST="$PROJECT/.github/workflows"

[[ -d "$ASSETS" ]] || { echo "error: assets dir not found at $ASSETS" >&2; exit 1; }

mkdir -p "$DEST"

install_one() {
  local name="$1"
  local src="$ASSETS/${name}.yml.template"
  local out_name="${name}.yml"

  # Match reishi convention: release_build.yml (underscore) on disk
  [[ "$name" == "release-build" ]] && out_name="release_build.yml"

  local out="$DEST/$out_name"

  [[ -f "$src" ]] || { echo "error: template not found: $src" >&2; exit 1; }

  if [[ -e "$out" && $FORCE -ne 1 ]]; then
    echo "skip: $out already exists (use --force to overwrite)" >&2
    return
  fi

  local content
  content="$(cat "$src")"
  [[ -n "$BINARY" ]] && content="${content//@@BINARY@@/$BINARY}"
  [[ -n "$REPO" ]]   && content="${content//@@REPO@@/$REPO}"
  [[ -n "$OWNER" ]]  && content="${content//@@HOMEBREW_OWNER@@/$OWNER}"

  printf '%s' "$content" > "$out"
  echo "installed: $out"

  # Surface unresolved work the agent must finish
  local remaining
  remaining=$(grep -nE '@@[A-Z_]+@@' "$out" || true)
  if [[ -n "$remaining" ]]; then
    echo "  ! unfilled placeholders — provide --binary/--repo/--owner or edit by hand:"
    sed 's/^/    /' <<< "$remaining"
  fi

  if grep -qE '>>> (TOOLCHAIN_SETUP|[A-Z_]+_COMMAND[S]?) <<<' "$out"; then
    echo "  ! toolchain markers remain — replace >>> ... <<< blocks with project's setup/build/test/lint steps"
  fi
}

case "$WORKFLOW" in
  ci|release|release-build) install_one "$WORKFLOW" ;;
  all) install_one ci; install_one release; install_one release-build ;;
  *) echo "error: invalid --workflow: $WORKFLOW (expected ci|release|release-build|all)" >&2; exit 2 ;;
esac
