# Shared logging helpers for chezmoi scripts
# Include with: {{ template "script-log.sh" }}
#
# Colors: blue/cyan=info, yellow=warn, red=error, green=success, magenta=step/progress

_log_reset='\033[0m'
_log_red='\033[0;31m'
_log_green='\033[0;32m'
_log_yellow='\033[0;33m'
_log_blue='\033[0;34m'
_log_magenta='\033[0;35m'
_log_cyan='\033[0;36m'
_log_bold='\033[1m'

log_info() { printf "${_log_cyan}[INFO]${_log_reset}    %s\n" "$1"; }
log_warn() { printf "${_log_yellow}[WARN]${_log_reset}    %s\n" "$1"; }
log_error() { printf "${_log_red}[ERROR]${_log_reset}   %s\n" "$1" >&2; }
log_success() { printf "${_log_green}[OK]${_log_reset}      %s\n" "$1"; }
log_step() { printf "\n${_log_bold}${_log_magenta}=> %s${_log_reset}\n" "$1"; }
