#!/usr/bin/env bash
# Bootstrap a tool repository from the gwenwindflower/_tool template.
#
#   bootstrap.sh new      --name NAME --description TEXT [--owner O] [--binary B] [--author A] [--lang rust] [--dir D] [--dry-run]
#   bootstrap.sh existing --name NAME [--owner O] [--binary B] [--author A] [--lang rust] [--dir D] [--template-dir T]

set -euo pipefail

TEMPLATE_REPO="gwenwindflower/_tool"
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
	sed -n '2,6p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}

die() {
	printf 'error: %s\n' "$1" >&2
	exit 1
}

mode="${1:-}"
[[ "$mode" == new || "$mode" == existing ]] || {
	usage
	exit 2
}
shift

name="" binary="" owner="gwenwindflower" author="Gwyneth Windflower" lang="rust"
description="" dir="" template_dir="" dry_run=0
while [[ $# -gt 0 ]]; do
	case "$1" in
	--name) name="$2" ;;
	--binary) binary="$2" ;;
	--owner) owner="$2" ;;
	--author) author="$2" ;;
	--lang) lang="$2" ;;
	--description) description="$2" ;;
	--dir) dir="$2" ;;
	--template-dir) template_dir="$2" ;;
	--dry-run) dry_run=1; shift; continue ;;
	-h | --help) usage; exit 0 ;;
	*) die "unknown argument: $1" ;;
	esac
	shift 2
done

[[ -n "$name" ]] || die "--name is required"
[[ "$name" =~ ^[a-z0-9][a-z0-9-]*$ ]] || die "--name must be kebab-case: $name"
[[ -n "$binary" ]] || binary="$name"
kit="$SKILL_DIR/assets/$lang"
[[ -d "$kit" ]] || die "no language kit for '$lang' at $kit"
year="$(date +%Y)"

if [[ "$mode" == new ]]; then
	[[ -n "$description" ]] || die "--description is required for a new repository"
	[[ -n "$dir" ]] || dir="$PWD/$name"
	[[ ! -e "$dir" ]] || die "target already exists: $dir"
else
	[[ -n "$dir" ]] || dir="$PWD"
	[[ -d "$dir/.git" ]] || die "not a git repository: $dir"
fi

log() { printf '%s\n' "$*"; }
plan() { printf '  → %s\n' "$*"; }

# Fill placeholders in one file: {{NAME}} in Markdown, @@NAME@@ elsewhere.
fill() {
	local file="$1" content
	[[ -s "$file" ]] || return 0
	content="$(cat "$file")"
	for pair in "TOOL_NAME=$name" "TOOL_BINARY=$binary" "GH_OWNER=$owner" "AUTHOR=$author" "YEAR=$year" "DESCRIPTION=$description"; do
		local key="${pair%%=*}" value="${pair#*=}"
		[[ -n "$value" ]] || continue
		content="${content//\{\{${key}\}\}/$value}"
		content="${content//@@${key}@@/$value}"
	done
	printf '%s\n' "$content" >"$file"
}

# Replace a marker line with the contents of a file.
splice() {
	local file="$1" marker="$2" insert="$3" out
	grep -qF "$marker" "$file" || return 0
	out="$(awk -v marker="$marker" -v insert="$insert" '
		index($0, marker) { while ((getline line < insert) > 0) print line; next }
		{ print }
	' "$file")"
	printf '%s\n' "$out" >"$file"
}

install_kit() {
	local root="$1"
	log "Installing the $lang kit"
	splice "$root/mise.toml" "# >>> LANG_TOOLS <<<" "$kit/mise.tools.toml"
	splice "$root/mise.toml" "# >>> LANG_TASKS <<<" "$kit/mise.tasks.toml"
	splice "$root/.gitignore" "# >>> LANG_IGNORES <<<" "$kit/gitignore"
	splice "$root/prek.toml" "# >>> LANG_HOOKS <<<" "$kit/prek.hooks.toml"
	mkdir -p "$root/mise-tasks/version" "$root/.github/matchers"
	for hook in read write files verify; do
		[[ -f "$kit/mise-tasks/version/$hook" ]] || continue
		cp "$kit/mise-tasks/version/$hook" "$root/mise-tasks/version/$hook"
		chmod +x "$root/mise-tasks/version/$hook"
	done
	cp "$kit/matchers.json" "$root/.github/matchers/$lang.json"
	for f in "$kit"/root/*; do
		local base
		base="$(basename "$f")"
		if [[ -e "$root/$base" ]]; then
			plan "kept existing $base (kit copy at $f)"
		else
			cp -R "$f" "$root/$base"
		fi
	done
	if [[ -d "$kit/src" && ! -d "$root/src" ]]; then
		cp -R "$kit/src" "$root/src"
	fi
	while IFS= read -r file; do
		fill "$file"
	done < <(find "$root/mise.toml" "$root/mise-tasks" "$root/src" "$root"/Cargo.toml "$root/.github/matchers" -type f 2>/dev/null)
}

fill_tree() {
	local root="$1"
	log "Filling placeholders"
	while IFS= read -r file; do
		fill "$file"
	done < <(find "$root" -type f -not -path '*/.git/*' -not -name 'bootstrap.md')
}

refresh_pins() {
	local root="$1" tools=(git-cliff pinact zizmor shellcheck prek)
	while IFS= read -r tool; do
		tools+=("$tool")
	done < <(awk -F'[ =]' '/^[a-z0-9_-]+ *=/ { print $1 }' "$kit/mise.tools.toml")
	log "Pinning tools: ${tools[*]}"
	(
		cd "$root"
		mise trust --quiet . 2>/dev/null || true
		mise use --pin "${tools[@]/%/@latest}" || plan "mise use failed; pin tools by hand"
		mise install --quiet || plan "mise install failed; run it by hand"
		if [[ -x "$kit/post-install" ]]; then
			mise exec -- "$kit/post-install" || plan "kit post-install failed; see $kit/post-install"
		fi
		mise run hooks:install || plan "prek install failed; run mise run hooks:install by hand"
		GITHUB_TOKEN="${GITHUB_TOKEN:-$(gh auth token 2>/dev/null || true)}" pinact run -update || plan "pinact update failed; run mise run ci-audit:pinact later"
	)
}

report() {
	local root="$1"
	log ""
	log "Remaining placeholders:"
	(cd "$root" && grep -rnIE '\{\{[A-Z_]+|@@[A-Z_]+@@' --exclude-dir=.git --exclude-dir=target --exclude-dir=dist --exclude-dir=node_modules --exclude=bootstrap.md . || true) | sed 's/^/  /'
	log ""
	log "Next: fill those, commit, push main, then follow docs/bootstrap.md."
}

if [[ "$mode" == new ]]; then
	if [[ "$dry_run" -eq 1 ]]; then
		log "Dry run for $owner/$name ($lang) in $dir"
		plan "gh repo create $owner/$name --template $TEMPLATE_REPO --public --clone"
		plan "fill placeholders: TOOL_NAME=$name TOOL_BINARY=$binary GH_OWNER=$owner AUTHOR=$author YEAR=$year"
		plan "install kit from $kit (mise tools and tasks, version hooks, matchers, root files, src/)"
		plan "mise use --pin git-cliff pinact zizmor shellcheck; mise install; pinact run -update"
		plan "report remaining placeholders"
		exit 0
	fi
	log "Creating $owner/$name from $TEMPLATE_REPO"
	gh repo create "$owner/$name" --template "$TEMPLATE_REPO" --public --clone --description "$description"
	[[ "$dir" == "$PWD/$name" ]] || mv "$PWD/$name" "$dir"
	fill_tree "$dir"
	install_kit "$dir"
	refresh_pins "$dir"
	report "$dir"
	exit 0
fi

# existing: copy missing template files, report differing ones, install the kit without overwriting.
if [[ -z "$template_dir" ]]; then
	template_dir="$(mktemp -d "${TMPDIR:-/tmp}/tool-template.XXXXXX")"
	trap 'rm -rf "$template_dir"' EXIT
	gh repo clone "$TEMPLATE_REPO" "$template_dir" -- --quiet --depth 1
fi
log "Aligning $dir with the template at $template_dir"
missing=() differing=()
while IFS= read -r rel; do
	src="$template_dir/$rel"
	dst="$dir/$rel"
	if [[ ! -e "$dst" ]]; then
		mkdir -p "$(dirname "$dst")"
		cp -P "$src" "$dst"
		[[ -L "$dst" ]] || fill "$dst"
		missing+=("$rel")
	elif [[ -L "$src" ]]; then
		continue
	else
		filled="$(mktemp)"
		cp "$src" "$filled"
		fill "$filled"
		cmp -s "$filled" "$dst" || differing+=("$rel")
		rm -f "$filled"
	fi
done < <(cd "$template_dir" && { git ls-files 2>/dev/null || find . \( -type f -o -type l \) -not -path './.git/*' | sed 's|^\./||'; } | sort)

if [[ ! -x "$dir/mise-tasks/version/read" ]]; then
	install_kit "$dir"
fi
refresh_pins "$dir"

log ""
log "Added from the template (${#missing[@]}):"
printf '  + %s\n' "${missing[@]:-none}"
log ""
log "Present in both and different (${#differing[@]}); reconcile by hand:"
for rel in "${differing[@]:-}"; do
	[[ -n "$rel" ]] || continue
	printf '  ~ %s\n' "$rel"
done
report "$dir"
