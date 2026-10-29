#!/usr/bin/env bash
set -euo pipefail
script="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/bootstrap.sh"
sandbox="$(mktemp -d "${TMPDIR:-/tmp}/tool-bootstrap.XXXXXX")"
trap 'rm -rf "$sandbox"' EXIT
export TEST_TEMPLATE="$sandbox/template"
mkdir -p "$TEST_TEMPLATE/template/tests" "$TEST_TEMPLATE/.github/workflows" "$sandbox/bin"
printf 'template-only\n' >"$TEST_TEMPLATE/template/tests/private.sh"
printf 'template-only\n' >"$TEST_TEMPLATE/.github/workflows/template.yml"
printf 'shared\n' >"$TEST_TEMPLATE/.github/workflows/ci.yml"
printf '[tools]\nnode = "24"\n# prek = "latest"\n# >>> LANG_TOOLS <<<\n# >>> LANG_TASKS <<<\n' >"$TEST_TEMPLATE/mise.toml"
printf '[tools]\nprek = "latest"\n' >"$TEST_TEMPLATE/mise.ci.toml"
printf '# >>> LANG_IGNORES <<<\n' >"$TEST_TEMPLATE/.gitignore"
printf '{ id = "check-shebang-scripts-are-executable" },\n# >>> LANG_HOOKS <<<\n' >"$TEST_TEMPLATE/prek.toml"
cat >"$sandbox/bin/gh" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
if [[ "$1 $2" == 'repo create' ]]; then
  cp -R "$TEST_TEMPLATE" "${3##*/}"
else
  exit 1
fi
SH
printf '#!/bin/sh\nexit 0\n' >"$sandbox/bin/mise"
printf '#!/bin/sh\nexit 0\n' >"$sandbox/bin/pinact"
chmod +x "$sandbox/bin/"*
export PATH="$sandbox/bin:$PATH"

cd "$sandbox"
bash "$script" new --name widget --owner example --description 'Test tool' >"$sandbox/output"
[[ ! -e widget/template && ! -e widget/.github/workflows/template.yml ]] || {
  printf 'New project inherited template maintenance files.\n' >&2; exit 1;
}
[[ -f widget/.github/workflows/ci.yml && -f widget/src/main.rs ]]
grep -Fq 'exclude_types = ["rust"]' widget/prek.toml
[[ ! -e widget/mise.local.toml ]] || {
  printf 'Bootstrap disabled the project runtime dependency.\n' >&2; exit 1;
}
grep -Fxq 'node = "24"' widget/mise.toml
grep -Fxq '# prek = "latest"' widget/mise.toml
grep -Fxq 'prek = "latest"' widget/mise.ci.toml

mkdir -p existing/.git existing/mise-tasks/version existing/template
printf '#!/bin/sh\nprintf "1.0.0\\n"\n' >existing/mise-tasks/version/read
chmod +x existing/mise-tasks/version/read
printf 'project-owned\n' >existing/template/keep
printf 'project-owned\n' >existing/.sentinel
printf '[env]\nPROJECT_SETTING = "keep"\n' >existing/mise.local.toml
bash "$script" existing --name widget --owner example --dir "$sandbox/existing" --template-dir "$TEST_TEMPLATE" >"$sandbox/output"
[[ ! -e existing/template/tests && ! -e existing/.github/workflows/template.yml ]] || {
  printf 'Existing project inherited template maintenance files.\n' >&2; exit 1;
}
[[ -f existing/.github/workflows/ci.yml ]]
grep -Fxq project-owned existing/template/keep
grep -Fxq project-owned existing/.sentinel
grep -Fxq 'PROJECT_SETTING = "keep"' existing/mise.local.toml
if grep -q disable_tools existing/mise.local.toml; then
  printf 'Bootstrap added tool disabling to an existing local config.\n' >&2; exit 1;
fi
printf 'Bootstrap tests passed.\n'
