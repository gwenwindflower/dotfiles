# Ensure Homebrew is on PATH (checks all known install locations)
if ! command -v brew >/dev/null 2>&1; then
  for brew_prefix in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew; do
    if [ -x "$brew_prefix/bin/brew" ]; then
      eval "$("$brew_prefix/bin/brew" shellenv)"
      break
    fi
  done
fi

if ! command -v brew >/dev/null 2>&1; then
  printf '\033[0;31m[ERROR]\033[0m %s\n' "Homebrew not found on PATH after checking all known locations"
  exit 1
fi
