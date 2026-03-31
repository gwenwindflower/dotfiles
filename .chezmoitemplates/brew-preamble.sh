# Ensure Homebrew is on PATH (checks all known install locations)
# Requires: {{ template "script-log.sh" }} included before this template
if ! command -v brew >/dev/null 2>&1; then
	for brew_prefix in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew; do
		if [ -x "$brew_prefix/bin/brew" ]; then
			eval "$("$brew_prefix/bin/brew" shellenv)"
			break
		fi
	done
fi

if ! command -v brew >/dev/null 2>&1; then
	log_error "Homebrew not found on PATH after checking all known locations"
	exit 1
fi
