# Ensure Homebrew is on PATH (checks all known install locations)
# Requires: script-log.sh included before this template

# Skip brew's per-invocation auto-update during apply. Scripts here drive brew
# declaratively; users can update interactively on their own cadence.
export HOMEBREW_NO_AUTO_UPDATE=1

if ! command -v brew >/dev/null 2>&1; then
	for brew_prefix in /opt/homebrew /usr/local; do
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
