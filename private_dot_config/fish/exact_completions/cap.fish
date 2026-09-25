# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_cap_global_optspecs
	string join \n log-level= json h/help V/version
end

function __fish_cap_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_cap_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_cap_using_subcommand
	set -l cmd (__fish_cap_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd[1] $argv
end

complete -c cap -n "__fish_cap_needs_command" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_needs_command" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_needs_command" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c cap -n "__fish_cap_needs_command" -s V -l version -d 'Print version'
complete -c cap -n "__fish_cap_needs_command" -f -a "export" -d 'Export a \'.cap\' project to a video file'
complete -c cap -n "__fish_cap_needs_command" -f -a "export-preview" -d 'Render an export preview frame'
complete -c cap -n "__fish_cap_needs_command" -f -a "project" -d 'Inspect or validate a \'.cap\' project'
complete -c cap -n "__fish_cap_needs_command" -f -a "record" -d 'Start a recording or list available capture targets and devices'
complete -c cap -n "__fish_cap_needs_command" -f -a "screenshot" -d 'Capture a still screenshot of a screen or window'
complete -c cap -n "__fish_cap_needs_command" -f -a "recordings" -d 'List recordings discovered in the desktop library (or a custom directory)'
complete -c cap -n "__fish_cap_needs_command" -f -a "upload" -d 'Upload a recording or video file and get a shareable link'
complete -c cap -n "__fish_cap_needs_command" -f -a "update" -d 'Update Cap Desktop and the bundled CLI'
complete -c cap -n "__fish_cap_needs_command" -f -a "auth" -d 'Show how `cap upload` will authenticate (env key or Cap Desktop login)'
complete -c cap -n "__fish_cap_needs_command" -f -a "caps" -d 'Read and manage Caps in your personal library'
complete -c cap -n "__fish_cap_needs_command" -f -a "account" -d 'Read or update the authenticated Cap account'
complete -c cap -n "__fish_cap_needs_command" -f -a "organizations" -d 'Inspect Cap organizations, members, billing, and storage connections'
complete -c cap -n "__fish_cap_needs_command" -f -a "library" -d 'Manage folders, spaces, and space membership'
complete -c cap -n "__fish_cap_needs_command" -f -a "notifications" -d 'Read and manage account notifications'
complete -c cap -n "__fish_cap_needs_command" -f -a "analytics" -d 'Read organization, space, or Cap analytics'
complete -c cap -n "__fish_cap_needs_command" -f -a "developers" -d 'Inspect developer apps, domains, usage, and credits'
complete -c cap -n "__fish_cap_needs_command" -f -a "jobs" -d 'Inspect or wait for asynchronous Cap operations'
complete -c cap -n "__fish_cap_needs_command" -f -a "mcp" -d 'Run Cap\'s local Model Context Protocol server'
complete -c cap -n "__fish_cap_needs_command" -f -a "agents" -d 'Install Cap integrations for one explicitly selected agent'
complete -c cap -n "__fish_cap_needs_command" -f -a "targets" -d 'List available capture targets and devices'
complete -c cap -n "__fish_cap_needs_command" -f -a "doctor" -d 'Report CLI environment and capture-readiness diagnostics'
complete -c cap -n "__fish_cap_needs_command" -f -a "selftest" -d 'Run end-to-end diagnostics that verify Cap works on this machine'
complete -c cap -n "__fish_cap_needs_command" -f -a "version" -d 'Print CLI version and execution context'
complete -c cap -n "__fish_cap_needs_command" -f -a "desktop" -d 'Inspect or manage the desktop-installed `cap` shim'
complete -c cap -n "__fish_cap_needs_command" -f -a "guide" -d 'Print the machine-readable capability & JSON-schema manifest for agents'
complete -c cap -n "__fish_cap_needs_command" -f -a "automations" -d 'List automation rules shared with Cap Desktop'
complete -c cap -n "__fish_cap_needs_command" -f -a "completions" -d 'Generate shell completion scripts'
complete -c cap -n "__fish_cap_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand export" -s o -l output -d 'Output file to write the export to' -r -F
complete -c cap -n "__fish_cap_using_subcommand export" -l format -d 'Container to export: mp4 (default), gif, or mov. NOT the output mode — use --json for JSON' -r -f -a "mp4\t''
gif\t''
mov\t''"
complete -c cap -n "__fish_cap_using_subcommand export" -l fps -d 'Frames per second to render' -r
complete -c cap -n "__fish_cap_using_subcommand export" -l resolution -d 'Output resolution as WIDTHxHEIGHT, e.g. 1920x1080' -r
complete -c cap -n "__fish_cap_using_subcommand export" -l quality -d 'Compression preset (mp4 only)' -r -f -a "maximum\t''
social\t''
web\t''
potato\t''"
complete -c cap -n "__fish_cap_using_subcommand export" -l settings-json -d 'Full export settings as JSON, e.g. {"format":"Mp4","fps":60,"resolution_base":{"x":1920,"y":1080},"compression":"Maximum","custom_bpp":null} (mutually exclusive with the flags above)' -r
complete -c cap -n "__fish_cap_using_subcommand export" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand export" -l optimize-filesize -d 'Optimise for smaller files using CRF (mp4 only)'
complete -c cap -n "__fish_cap_using_subcommand export" -l force-ffmpeg-decoder -d 'Decode source video with FFmpeg instead of the platform hardware decoder'
complete -c cap -n "__fish_cap_using_subcommand export" -l progress-json -d 'Stream newline-delimited JSON progress events to stdout ({"type":"Progress","rendered_count":N,"total_frames":N}; also emits a terminal {"type":"Error","error":"..."} on failure). Implied by --json'
complete -c cap -n "__fish_cap_using_subcommand export" -l completion-json -d 'Emit a final JSON completion event to stdout ({"type":"Completed","path":"..."}). Implied by --json'
complete -c cap -n "__fish_cap_using_subcommand export" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand export" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand export-preview" -l frame-time -r
complete -c cap -n "__fish_cap_using_subcommand export-preview" -l settings-json -r
complete -c cap -n "__fish_cap_using_subcommand export-preview" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand export-preview" -l force-ffmpeg-decoder
complete -c cap -n "__fish_cap_using_subcommand export-preview" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand export-preview" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand project; and not __fish_seen_subcommand_from inspect validate config help" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand project; and not __fish_seen_subcommand_from inspect validate config help" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand project; and not __fish_seen_subcommand_from inspect validate config help" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand project; and not __fish_seen_subcommand_from inspect validate config help" -f -a "inspect" -d 'Print project metadata and editor configuration'
complete -c cap -n "__fish_cap_using_subcommand project; and not __fish_seen_subcommand_from inspect validate config help" -f -a "validate" -d 'Verify a project\'s metadata and expected media files exist'
complete -c cap -n "__fish_cap_using_subcommand project; and not __fish_seen_subcommand_from inspect validate config help" -f -a "config" -d 'Read or write a project\'s editor configuration (project-config.json)'
complete -c cap -n "__fish_cap_using_subcommand project; and not __fish_seen_subcommand_from inspect validate config help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand project; and __fish_seen_subcommand_from inspect" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand project; and __fish_seen_subcommand_from inspect" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand project; and __fish_seen_subcommand_from inspect" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand project; and __fish_seen_subcommand_from inspect" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand project; and __fish_seen_subcommand_from validate" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand project; and __fish_seen_subcommand_from validate" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand project; and __fish_seen_subcommand_from validate" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand project; and __fish_seen_subcommand_from validate" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand project; and __fish_seen_subcommand_from config" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand project; and __fish_seen_subcommand_from config" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand project; and __fish_seen_subcommand_from config" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand project; and __fish_seen_subcommand_from config" -f -a "get" -d 'Print the project\'s editor configuration as JSON'
complete -c cap -n "__fish_cap_using_subcommand project; and __fish_seen_subcommand_from config" -f -a "set" -d 'Replace the project\'s editor configuration from a full JSON document'
complete -c cap -n "__fish_cap_using_subcommand project; and __fish_seen_subcommand_from config" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand project; and __fish_seen_subcommand_from help" -f -a "inspect" -d 'Print project metadata and editor configuration'
complete -c cap -n "__fish_cap_using_subcommand project; and __fish_seen_subcommand_from help" -f -a "validate" -d 'Verify a project\'s metadata and expected media files exist'
complete -c cap -n "__fish_cap_using_subcommand project; and __fish_seen_subcommand_from help" -f -a "config" -d 'Read or write a project\'s editor configuration (project-config.json)'
complete -c cap -n "__fish_cap_using_subcommand project; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -l screen -d 'ID of the screen to capture' -r
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -l window -d 'ID of the window to capture' -r
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -l mode -d 'Recording mode to use' -r -f -a "studio\t''
instant\t''"
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -l camera -d 'Capture from the camera with this device id (see `cap targets cameras`)' -r
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -l mic -d 'Capture from the microphone with this device name (see `cap targets mics`)' -r
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -l path -d 'New \'.cap\' project path (defaults to <recordingId>.cap in the working directory). The path must not already exist, including an empty directory.' -r -F
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -l fps -d 'Maximum fps to record at (clamped to 1-120; camera recordings follow the desktop camera cap)' -r
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -l duration -d 'Stop automatically after N seconds' -r
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -l format -d 'Output format for status events' -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -l system-audio -d 'Whether to capture system audio'
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -l detach -d 'Record in the background and return immediately; stop later with `cap record stop`'
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -f -a "start" -d 'Start a recording (use --detach to run in the background and stop later)'
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -f -a "stop" -d 'Stop a detached recording started with `cap record start --detach`'
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -f -a "status" -d 'List active and recent detached recording sessions'
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -f -a "__session-run" -d 'Internal: background worker for detached recordings (do not call directly)'
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -f -a "screens" -d 'List screens available for capturing'
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -f -a "windows" -d 'List windows available for capturing'
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -f -a "cameras" -d 'List cameras available for capturing'
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -f -a "mics" -d 'List microphones available for capturing'
complete -c cap -n "__fish_cap_using_subcommand record; and not __fish_seen_subcommand_from start stop status __session-run screens windows cameras mics help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from start" -l screen -d 'ID of the screen to capture' -r
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from start" -l window -d 'ID of the window to capture' -r
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from start" -l mode -d 'Recording mode to use' -r -f -a "studio\t''
instant\t''"
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from start" -l camera -d 'Capture from the camera with this device id (see `cap targets cameras`)' -r
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from start" -l mic -d 'Capture from the microphone with this device name (see `cap targets mics`)' -r
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from start" -l path -d 'New \'.cap\' project path (defaults to <recordingId>.cap in the working directory). The path must not already exist, including an empty directory.' -r -F
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from start" -l fps -d 'Maximum fps to record at (clamped to 1-120; camera recordings follow the desktop camera cap)' -r
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from start" -l duration -d 'Stop automatically after N seconds' -r
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from start" -l format -d 'Output format for status events' -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from start" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from start" -l system-audio -d 'Whether to capture system audio'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from start" -l detach -d 'Record in the background and return immediately; stop later with `cap record stop`'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from start" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from start" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from stop" -l id -d 'recordingId returned by `cap record start --detach`' -r
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from stop" -l path -d 'The \'.cap\' project path of the recording to stop (alternative to --id)' -r -F
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from stop" -l timeout -d 'Seconds to wait for the recording to finalize before giving up' -r
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from stop" -l format -d 'Output format for status events' -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from stop" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from stop" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from stop" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from status" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from status" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from status" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from status" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from __session-run" -l screen -d 'ID of the screen to capture' -r
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from __session-run" -l window -d 'ID of the window to capture' -r
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from __session-run" -l mode -d 'Recording mode to use' -r -f -a "studio\t''
instant\t''"
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from __session-run" -l camera -d 'Capture from the camera with this device id (see `cap targets cameras`)' -r
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from __session-run" -l mic -d 'Capture from the microphone with this device name (see `cap targets mics`)' -r
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from __session-run" -l path -d 'New \'.cap\' project path (defaults to <recordingId>.cap in the working directory). The path must not already exist, including an empty directory.' -r -F
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from __session-run" -l fps -d 'Maximum fps to record at (clamped to 1-120; camera recordings follow the desktop camera cap)' -r
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from __session-run" -l duration -d 'Stop automatically after N seconds' -r
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from __session-run" -l session-id -r
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from __session-run" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from __session-run" -l system-audio -d 'Whether to capture system audio'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from __session-run" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from __session-run" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from screens" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from screens" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from screens" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from screens" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from windows" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from windows" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from windows" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from windows" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from cameras" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from cameras" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from cameras" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from cameras" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from mics" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from mics" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from mics" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from mics" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from help" -f -a "start" -d 'Start a recording (use --detach to run in the background and stop later)'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from help" -f -a "stop" -d 'Stop a detached recording started with `cap record start --detach`'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from help" -f -a "status" -d 'List active and recent detached recording sessions'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from help" -f -a "__session-run" -d 'Internal: background worker for detached recordings (do not call directly)'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from help" -f -a "screens" -d 'List screens available for capturing'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from help" -f -a "windows" -d 'List windows available for capturing'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from help" -f -a "cameras" -d 'List cameras available for capturing'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from help" -f -a "mics" -d 'List microphones available for capturing'
complete -c cap -n "__fish_cap_using_subcommand record; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand screenshot" -l screen -d 'ID of the screen to capture (see `cap targets screens`)' -r
complete -c cap -n "__fish_cap_using_subcommand screenshot" -l window -d 'ID of the window to capture (see `cap targets windows`)' -r
complete -c cap -n "__fish_cap_using_subcommand screenshot" -l path -d 'Output image path (format inferred from extension, e.g. .png)' -r -F
complete -c cap -n "__fish_cap_using_subcommand screenshot" -l format -d 'Output format for the result (json emits {"path","width","height"})' -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand screenshot" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand screenshot" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand screenshot" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand recordings; and not __fish_seen_subcommand_from list help" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand recordings; and not __fish_seen_subcommand_from list help" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand recordings; and not __fish_seen_subcommand_from list help" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand recordings; and not __fish_seen_subcommand_from list help" -f -a "list" -d 'List \'.cap\' recordings discovered on disk'
complete -c cap -n "__fish_cap_using_subcommand recordings; and not __fish_seen_subcommand_from list help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand recordings; and __fish_seen_subcommand_from list" -l dir -d 'Directory to scan (defaults to the desktop recordings library)' -r -F
complete -c cap -n "__fish_cap_using_subcommand recordings; and __fish_seen_subcommand_from list" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand recordings; and __fish_seen_subcommand_from list" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand recordings; and __fish_seen_subcommand_from list" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand recordings; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand recordings; and __fish_seen_subcommand_from help" -f -a "list" -d 'List \'.cap\' recordings discovered on disk'
complete -c cap -n "__fish_cap_using_subcommand recordings; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand upload" -l name -d 'Title for the uploaded video' -r
complete -c cap -n "__fish_cap_using_subcommand upload" -l video-id -d 'Reuse an existing video id instead of creating a new one' -r
complete -c cap -n "__fish_cap_using_subcommand upload" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand upload" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand upload" -l export -d 'If the input is a \'.cap\' project with no exported video yet, export it first'
complete -c cap -n "__fish_cap_using_subcommand upload" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand upload" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand update" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand update" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand update" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand update" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand auth; and not __fish_seen_subcommand_from status login logout help" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand auth; and not __fish_seen_subcommand_from status login logout help" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand auth; and not __fish_seen_subcommand_from status login logout help" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand auth; and not __fish_seen_subcommand_from status login logout help" -f -a "status" -d 'Report whether a credential is available and where it comes from (never prints the secret)'
complete -c cap -n "__fish_cap_using_subcommand auth; and not __fish_seen_subcommand_from status login logout help" -f -a "login" -d 'Authorize Cap CLI in the browser using PKCE'
complete -c cap -n "__fish_cap_using_subcommand auth; and not __fish_seen_subcommand_from status login logout help" -f -a "logout" -d 'Revoke and remove the Cap CLI credential'
complete -c cap -n "__fish_cap_using_subcommand auth; and not __fish_seen_subcommand_from status login logout help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand auth; and __fish_seen_subcommand_from status" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand auth; and __fish_seen_subcommand_from status" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand auth; and __fish_seen_subcommand_from status" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand auth; and __fish_seen_subcommand_from status" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand auth; and __fish_seen_subcommand_from login" -l profile -r -f -a "creator\t''
admin\t''
full\t''"
complete -c cap -n "__fish_cap_using_subcommand auth; and __fish_seen_subcommand_from login" -l timeout -r
complete -c cap -n "__fish_cap_using_subcommand auth; and __fish_seen_subcommand_from login" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand auth; and __fish_seen_subcommand_from login" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand auth; and __fish_seen_subcommand_from login" -l no-open
complete -c cap -n "__fish_cap_using_subcommand auth; and __fish_seen_subcommand_from login" -l allow-file-credential -d 'Allow a permission-restricted file fallback on macOS or Linux when the OS credential store is unavailable'
complete -c cap -n "__fish_cap_using_subcommand auth; and __fish_seen_subcommand_from login" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand auth; and __fish_seen_subcommand_from login" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand auth; and __fish_seen_subcommand_from logout" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand auth; and __fish_seen_subcommand_from logout" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand auth; and __fish_seen_subcommand_from logout" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand auth; and __fish_seen_subcommand_from logout" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand auth; and __fish_seen_subcommand_from help" -f -a "status" -d 'Report whether a credential is available and where it comes from (never prints the secret)'
complete -c cap -n "__fish_cap_using_subcommand auth; and __fish_seen_subcommand_from help" -f -a "login" -d 'Authorize Cap CLI in the browser using PKCE'
complete -c cap -n "__fish_cap_using_subcommand auth; and __fish_seen_subcommand_from help" -f -a "logout" -d 'Revoke and remove the Cap CLI credential'
complete -c cap -n "__fish_cap_using_subcommand auth; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "list"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "get"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "context"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "status"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "wait"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "process"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "import"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "transcript"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "transcript-replace"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "download"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "duplicate"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "delete"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "password"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "unlock"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "comments"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "reactions"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "update"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "sharing"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "settings"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "date"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "move"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "shares"
complete -c cap -n "__fish_cap_using_subcommand caps; and not __fish_seen_subcommand_from list get context status wait process import transcript transcript-replace download duplicate delete password unlock comments reactions update sharing settings date move shares help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from list" -l scope -r -f -a "all\t''
owned\t''
shared\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from list" -l organization -r
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from list" -l folder -r
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from list" -l search -r
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from list" -l updated-after -r
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from list" -l cursor -r
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from list" -l limit -r
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from list" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from list" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from list" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from get" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from get" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from get" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from get" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from context" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from context" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from context" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from context" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from status" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from status" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from status" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from status" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from wait" -l for -r -f -a "transcript\t''
ai\t''
all\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from wait" -l timeout -r
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from wait" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from wait" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from wait" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from wait" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from process" -l target -r -f -a "transcript\t''
ai\t''
all\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from process" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from process" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from process" -l retry
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from process" -l yes
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from process" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from process" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from import" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from import" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from import" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from import" -f -a "loom"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from import" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from transcript" -l format -r -f -a "text\t''
json\t''
vtt\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from transcript" -l output -r -F
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from transcript" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from transcript" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from transcript" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from transcript-replace" -l input -r -F
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from transcript-replace" -l expected-revision -r
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from transcript-replace" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from transcript-replace" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from transcript-replace" -l yes
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from transcript-replace" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from transcript-replace" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from download" -l output -r -F
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from download" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from download" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from download" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from duplicate" -l timeout -r
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from duplicate" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from duplicate" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from duplicate" -l wait
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from duplicate" -l yes
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from duplicate" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from duplicate" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from delete" -l timeout -r
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from delete" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from delete" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from delete" -l wait
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from delete" -l yes
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from delete" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from delete" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from password" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from password" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from password" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from password" -f -a "set"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from password" -f -a "clear"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from password" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from unlock" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from unlock" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from unlock" -l password-stdin
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from unlock" -l allow-file-credential -d 'Allow a permission-restricted file fallback on macOS or Linux when the OS credential store is unavailable'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from unlock" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from unlock" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from comments" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from comments" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from comments" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from comments" -f -a "add"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from comments" -f -a "reply"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from comments" -f -a "delete"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from comments" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from reactions" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from reactions" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from reactions" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from reactions" -f -a "add"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from reactions" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from update" -l title -r
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from update" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from update" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from update" -l yes
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from update" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from update" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from sharing" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from sharing" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from sharing" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from sharing" -f -a "set"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from sharing" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from settings" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from settings" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from settings" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from settings" -f -a "get"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from settings" -f -a "set"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from settings" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from date" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from date" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from date" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from date" -f -a "set"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from date" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from move" -l container -r -f -a "personal\t''
organization\t''
space\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from move" -l organization -r
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from move" -l space -r
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from move" -l folder -r
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from move" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from move" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from move" -l root
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from move" -l yes
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from move" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from move" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from shares" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from shares" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from shares" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from shares" -f -a "list"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from shares" -f -a "organization"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from shares" -f -a "space"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from shares" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "list"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "get"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "context"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "status"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "wait"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "process"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "import"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "transcript"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "transcript-replace"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "download"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "duplicate"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "delete"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "password"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "unlock"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "comments"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "reactions"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "update"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "sharing"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "settings"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "date"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "move"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "shares"
complete -c cap -n "__fish_cap_using_subcommand caps; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand account; and not __fish_seen_subcommand_from get update image referrals sign-out-all help" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand account; and not __fish_seen_subcommand_from get update image referrals sign-out-all help" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand account; and not __fish_seen_subcommand_from get update image referrals sign-out-all help" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand account; and not __fish_seen_subcommand_from get update image referrals sign-out-all help" -f -a "get"
complete -c cap -n "__fish_cap_using_subcommand account; and not __fish_seen_subcommand_from get update image referrals sign-out-all help" -f -a "update"
complete -c cap -n "__fish_cap_using_subcommand account; and not __fish_seen_subcommand_from get update image referrals sign-out-all help" -f -a "image"
complete -c cap -n "__fish_cap_using_subcommand account; and not __fish_seen_subcommand_from get update image referrals sign-out-all help" -f -a "referrals"
complete -c cap -n "__fish_cap_using_subcommand account; and not __fish_seen_subcommand_from get update image referrals sign-out-all help" -f -a "sign-out-all"
complete -c cap -n "__fish_cap_using_subcommand account; and not __fish_seen_subcommand_from get update image referrals sign-out-all help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from get" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from get" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from get" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from get" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from update" -l name -r
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from update" -l last-name -r
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from update" -l default-organization -r
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from update" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from update" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from update" -l clear-name
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from update" -l clear-last-name
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from update" -l clear-default-organization
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from update" -l yes
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from update" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from update" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from image" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from image" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from image" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from image" -f -a "set"
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from image" -f -a "remove"
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from image" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from referrals" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from referrals" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from referrals" -l no-open
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from referrals" -l yes
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from referrals" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from referrals" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from sign-out-all" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from sign-out-all" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from sign-out-all" -l yes
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from sign-out-all" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from sign-out-all" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from help" -f -a "get"
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from help" -f -a "update"
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from help" -f -a "image"
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from help" -f -a "referrals"
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from help" -f -a "sign-out-all"
complete -c cap -n "__fish_cap_using_subcommand account; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and not __fish_seen_subcommand_from list create get members invites billing storage update icon shareable-icon settings invite member domain delete help" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and not __fish_seen_subcommand_from list create get members invites billing storage update icon shareable-icon settings invite member domain delete help" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and not __fish_seen_subcommand_from list create get members invites billing storage update icon shareable-icon settings invite member domain delete help" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand organizations; and not __fish_seen_subcommand_from list create get members invites billing storage update icon shareable-icon settings invite member domain delete help" -f -a "list"
complete -c cap -n "__fish_cap_using_subcommand organizations; and not __fish_seen_subcommand_from list create get members invites billing storage update icon shareable-icon settings invite member domain delete help" -f -a "create"
complete -c cap -n "__fish_cap_using_subcommand organizations; and not __fish_seen_subcommand_from list create get members invites billing storage update icon shareable-icon settings invite member domain delete help" -f -a "get"
complete -c cap -n "__fish_cap_using_subcommand organizations; and not __fish_seen_subcommand_from list create get members invites billing storage update icon shareable-icon settings invite member domain delete help" -f -a "members"
complete -c cap -n "__fish_cap_using_subcommand organizations; and not __fish_seen_subcommand_from list create get members invites billing storage update icon shareable-icon settings invite member domain delete help" -f -a "invites"
complete -c cap -n "__fish_cap_using_subcommand organizations; and not __fish_seen_subcommand_from list create get members invites billing storage update icon shareable-icon settings invite member domain delete help" -f -a "billing"
complete -c cap -n "__fish_cap_using_subcommand organizations; and not __fish_seen_subcommand_from list create get members invites billing storage update icon shareable-icon settings invite member domain delete help" -f -a "storage"
complete -c cap -n "__fish_cap_using_subcommand organizations; and not __fish_seen_subcommand_from list create get members invites billing storage update icon shareable-icon settings invite member domain delete help" -f -a "update"
complete -c cap -n "__fish_cap_using_subcommand organizations; and not __fish_seen_subcommand_from list create get members invites billing storage update icon shareable-icon settings invite member domain delete help" -f -a "icon"
complete -c cap -n "__fish_cap_using_subcommand organizations; and not __fish_seen_subcommand_from list create get members invites billing storage update icon shareable-icon settings invite member domain delete help" -f -a "shareable-icon"
complete -c cap -n "__fish_cap_using_subcommand organizations; and not __fish_seen_subcommand_from list create get members invites billing storage update icon shareable-icon settings invite member domain delete help" -f -a "settings"
complete -c cap -n "__fish_cap_using_subcommand organizations; and not __fish_seen_subcommand_from list create get members invites billing storage update icon shareable-icon settings invite member domain delete help" -f -a "invite"
complete -c cap -n "__fish_cap_using_subcommand organizations; and not __fish_seen_subcommand_from list create get members invites billing storage update icon shareable-icon settings invite member domain delete help" -f -a "member"
complete -c cap -n "__fish_cap_using_subcommand organizations; and not __fish_seen_subcommand_from list create get members invites billing storage update icon shareable-icon settings invite member domain delete help" -f -a "domain"
complete -c cap -n "__fish_cap_using_subcommand organizations; and not __fish_seen_subcommand_from list create get members invites billing storage update icon shareable-icon settings invite member domain delete help" -f -a "delete"
complete -c cap -n "__fish_cap_using_subcommand organizations; and not __fish_seen_subcommand_from list create get members invites billing storage update icon shareable-icon settings invite member domain delete help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from list" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from list" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from list" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from create" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from create" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from create" -l yes
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from create" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from get" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from get" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from get" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from get" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from members" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from members" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from members" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from members" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from invites" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from invites" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from invites" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from invites" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from billing" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from billing" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from billing" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from billing" -f -a "get"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from billing" -f -a "checkout"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from billing" -f -a "portal"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from billing" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from storage" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from storage" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from storage" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from storage" -f -a "list"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from storage" -f -a "s3"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from storage" -f -a "provider"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from storage" -f -a "google-drive"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from storage" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from update" -l name -r
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from update" -l allowed-email-domain -r
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from update" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from update" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from update" -l clear-allowed-email-domain
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from update" -l yes
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from update" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from update" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from icon" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from icon" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from icon" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from icon" -f -a "set"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from icon" -f -a "remove"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from icon" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from shareable-icon" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from shareable-icon" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from shareable-icon" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from shareable-icon" -f -a "set"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from shareable-icon" -f -a "remove"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from shareable-icon" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from settings" -l disable-summary -r -f -a "true\t''
false\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from settings" -l disable-captions -r -f -a "true\t''
false\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from settings" -l disable-chapters -r -f -a "true\t''
false\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from settings" -l disable-reactions -r -f -a "true\t''
false\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from settings" -l disable-transcript -r -f -a "true\t''
false\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from settings" -l disable-comments -r -f -a "true\t''
false\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from settings" -l hide-shareable-link-cap-logo -r -f -a "true\t''
false\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from settings" -l shareable-link-use-organization-icon -r -f -a "true\t''
false\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from settings" -l ai-generation-language -r
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from settings" -l default-playback-speed -r
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from settings" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from settings" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from settings" -l yes
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from settings" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from settings" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from invite" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from invite" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from invite" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from invite" -f -a "add"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from invite" -f -a "remove"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from invite" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from member" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from member" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from member" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from member" -f -a "role"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from member" -f -a "seat"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from member" -f -a "remove"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from member" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from domain" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from domain" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from domain" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from domain" -f -a "set"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from domain" -f -a "remove"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from domain" -f -a "verify"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from domain" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from delete" -l timeout -r
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from delete" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from delete" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from delete" -l wait
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from delete" -l yes
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from delete" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from delete" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from help" -f -a "list"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from help" -f -a "create"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from help" -f -a "get"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from help" -f -a "members"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from help" -f -a "invites"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from help" -f -a "billing"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from help" -f -a "storage"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from help" -f -a "update"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from help" -f -a "icon"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from help" -f -a "shareable-icon"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from help" -f -a "settings"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from help" -f -a "invite"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from help" -f -a "member"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from help" -f -a "domain"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from help" -f -a "delete"
complete -c cap -n "__fish_cap_using_subcommand organizations; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand library; and not __fish_seen_subcommand_from folders spaces help" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand library; and not __fish_seen_subcommand_from folders spaces help" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand library; and not __fish_seen_subcommand_from folders spaces help" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand library; and not __fish_seen_subcommand_from folders spaces help" -f -a "folders"
complete -c cap -n "__fish_cap_using_subcommand library; and not __fish_seen_subcommand_from folders spaces help" -f -a "spaces"
complete -c cap -n "__fish_cap_using_subcommand library; and not __fish_seen_subcommand_from folders spaces help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from folders" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from folders" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from folders" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from folders" -f -a "list"
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from folders" -f -a "create"
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from folders" -f -a "update"
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from folders" -f -a "public-page"
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from folders" -f -a "logo"
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from folders" -f -a "delete"
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from folders" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from spaces" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from spaces" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from spaces" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from spaces" -f -a "list"
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from spaces" -f -a "create"
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from spaces" -f -a "update"
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from spaces" -f -a "public-page"
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from spaces" -f -a "logo"
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from spaces" -f -a "delete"
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from spaces" -f -a "members"
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from spaces" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from help" -f -a "folders"
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from help" -f -a "spaces"
complete -c cap -n "__fish_cap_using_subcommand library; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand notifications; and not __fish_seen_subcommand_from list preferences read help" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand notifications; and not __fish_seen_subcommand_from list preferences read help" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand notifications; and not __fish_seen_subcommand_from list preferences read help" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand notifications; and not __fish_seen_subcommand_from list preferences read help" -f -a "list"
complete -c cap -n "__fish_cap_using_subcommand notifications; and not __fish_seen_subcommand_from list preferences read help" -f -a "preferences"
complete -c cap -n "__fish_cap_using_subcommand notifications; and not __fish_seen_subcommand_from list preferences read help" -f -a "read"
complete -c cap -n "__fish_cap_using_subcommand notifications; and not __fish_seen_subcommand_from list preferences read help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from list" -l cursor -r
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from list" -l limit -r
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from list" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from list" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from list" -l unread
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from list" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from preferences" -l pause-comments -r -f -a "true\t''
false\t''"
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from preferences" -l pause-replies -r -f -a "true\t''
false\t''"
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from preferences" -l pause-views -r -f -a "true\t''
false\t''"
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from preferences" -l pause-reactions -r -f -a "true\t''
false\t''"
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from preferences" -l pause-anonymous-views -r -f -a "true\t''
false\t''"
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from preferences" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from preferences" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from preferences" -l yes
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from preferences" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from preferences" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from preferences" -f -a "get"
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from preferences" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from read" -l ids -r
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from read" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from read" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from read" -l all
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from read" -l yes
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from read" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from read" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from help" -f -a "list"
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from help" -f -a "preferences"
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from help" -f -a "read"
complete -c cap -n "__fish_cap_using_subcommand notifications; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand analytics" -l organization -r
complete -c cap -n "__fish_cap_using_subcommand analytics" -l space -r
complete -c cap -n "__fish_cap_using_subcommand analytics" -l cap -r
complete -c cap -n "__fish_cap_using_subcommand analytics" -l range -r -f -a "day\t''
week\t''
month\t''
year\t''"
complete -c cap -n "__fish_cap_using_subcommand analytics" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand analytics" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand analytics" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand analytics" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand developers; and not __fish_seen_subcommand_from list get create update delete domains keys auto-top-up credits videos transactions help" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and not __fish_seen_subcommand_from list get create update delete domains keys auto-top-up credits videos transactions help" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand developers; and not __fish_seen_subcommand_from list get create update delete domains keys auto-top-up credits videos transactions help" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand developers; and not __fish_seen_subcommand_from list get create update delete domains keys auto-top-up credits videos transactions help" -f -a "list"
complete -c cap -n "__fish_cap_using_subcommand developers; and not __fish_seen_subcommand_from list get create update delete domains keys auto-top-up credits videos transactions help" -f -a "get"
complete -c cap -n "__fish_cap_using_subcommand developers; and not __fish_seen_subcommand_from list get create update delete domains keys auto-top-up credits videos transactions help" -f -a "create"
complete -c cap -n "__fish_cap_using_subcommand developers; and not __fish_seen_subcommand_from list get create update delete domains keys auto-top-up credits videos transactions help" -f -a "update"
complete -c cap -n "__fish_cap_using_subcommand developers; and not __fish_seen_subcommand_from list get create update delete domains keys auto-top-up credits videos transactions help" -f -a "delete"
complete -c cap -n "__fish_cap_using_subcommand developers; and not __fish_seen_subcommand_from list get create update delete domains keys auto-top-up credits videos transactions help" -f -a "domains"
complete -c cap -n "__fish_cap_using_subcommand developers; and not __fish_seen_subcommand_from list get create update delete domains keys auto-top-up credits videos transactions help" -f -a "keys"
complete -c cap -n "__fish_cap_using_subcommand developers; and not __fish_seen_subcommand_from list get create update delete domains keys auto-top-up credits videos transactions help" -f -a "auto-top-up"
complete -c cap -n "__fish_cap_using_subcommand developers; and not __fish_seen_subcommand_from list get create update delete domains keys auto-top-up credits videos transactions help" -f -a "credits"
complete -c cap -n "__fish_cap_using_subcommand developers; and not __fish_seen_subcommand_from list get create update delete domains keys auto-top-up credits videos transactions help" -f -a "videos"
complete -c cap -n "__fish_cap_using_subcommand developers; and not __fish_seen_subcommand_from list get create update delete domains keys auto-top-up credits videos transactions help" -f -a "transactions"
complete -c cap -n "__fish_cap_using_subcommand developers; and not __fish_seen_subcommand_from list get create update delete domains keys auto-top-up credits videos transactions help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from list" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from list" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from list" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from get" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from get" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from get" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from get" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from create" -l environment -r -f -a "development\t''
production\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from create" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from create" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from create" -l yes
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from create" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from update" -l name -r
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from update" -l environment -r -f -a "development\t''
production\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from update" -l logo-url -r
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from update" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from update" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from update" -l clear-logo
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from update" -l yes
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from update" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from update" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from delete" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from delete" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from delete" -l yes
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from delete" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from delete" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from domains" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from domains" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from domains" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from domains" -f -a "add"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from domains" -f -a "remove"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from domains" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from keys" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from keys" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from keys" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from keys" -f -a "rotate"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from keys" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from auto-top-up" -l threshold-micro-credits -r
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from auto-top-up" -l amount-cents -r
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from auto-top-up" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from auto-top-up" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from auto-top-up" -l enable
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from auto-top-up" -l disable
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from auto-top-up" -l yes
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from auto-top-up" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from auto-top-up" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from credits" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from credits" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from credits" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from credits" -f -a "purchase"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from credits" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from videos" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from videos" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from videos" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from videos" -f -a "list"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from videos" -f -a "delete"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from videos" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from transactions" -l cursor -r
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from transactions" -l limit -r
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from transactions" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from transactions" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from transactions" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from transactions" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from help" -f -a "list"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from help" -f -a "get"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from help" -f -a "create"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from help" -f -a "update"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from help" -f -a "delete"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from help" -f -a "domains"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from help" -f -a "keys"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from help" -f -a "auto-top-up"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from help" -f -a "credits"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from help" -f -a "videos"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from help" -f -a "transactions"
complete -c cap -n "__fish_cap_using_subcommand developers; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand jobs; and not __fish_seen_subcommand_from get wait help" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand jobs; and not __fish_seen_subcommand_from get wait help" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand jobs; and not __fish_seen_subcommand_from get wait help" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand jobs; and not __fish_seen_subcommand_from get wait help" -f -a "get"
complete -c cap -n "__fish_cap_using_subcommand jobs; and not __fish_seen_subcommand_from get wait help" -f -a "wait"
complete -c cap -n "__fish_cap_using_subcommand jobs; and not __fish_seen_subcommand_from get wait help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand jobs; and __fish_seen_subcommand_from get" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand jobs; and __fish_seen_subcommand_from get" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand jobs; and __fish_seen_subcommand_from get" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand jobs; and __fish_seen_subcommand_from get" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand jobs; and __fish_seen_subcommand_from wait" -l timeout -r
complete -c cap -n "__fish_cap_using_subcommand jobs; and __fish_seen_subcommand_from wait" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand jobs; and __fish_seen_subcommand_from wait" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand jobs; and __fish_seen_subcommand_from wait" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand jobs; and __fish_seen_subcommand_from wait" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand jobs; and __fish_seen_subcommand_from help" -f -a "get"
complete -c cap -n "__fish_cap_using_subcommand jobs; and __fish_seen_subcommand_from help" -f -a "wait"
complete -c cap -n "__fish_cap_using_subcommand jobs; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand mcp; and not __fish_seen_subcommand_from serve help" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand mcp; and not __fish_seen_subcommand_from serve help" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand mcp; and not __fish_seen_subcommand_from serve help" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand mcp; and not __fish_seen_subcommand_from serve help" -f -a "serve"
complete -c cap -n "__fish_cap_using_subcommand mcp; and not __fish_seen_subcommand_from serve help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand mcp; and __fish_seen_subcommand_from serve" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand mcp; and __fish_seen_subcommand_from serve" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand mcp; and __fish_seen_subcommand_from serve" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand mcp; and __fish_seen_subcommand_from help" -f -a "serve"
complete -c cap -n "__fish_cap_using_subcommand mcp; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand agents; and not __fish_seen_subcommand_from install help" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand agents; and not __fish_seen_subcommand_from install help" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand agents; and not __fish_seen_subcommand_from install help" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand agents; and not __fish_seen_subcommand_from install help" -f -a "install"
complete -c cap -n "__fish_cap_using_subcommand agents; and not __fish_seen_subcommand_from install help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand agents; and __fish_seen_subcommand_from install" -l target -r -f -a "codex\t''
claude\t''
cursor\t''"
complete -c cap -n "__fish_cap_using_subcommand agents; and __fish_seen_subcommand_from install" -l component -r -f -a "skill\t''
mcp\t''
all\t''"
complete -c cap -n "__fish_cap_using_subcommand agents; and __fish_seen_subcommand_from install" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand agents; and __fish_seen_subcommand_from install" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand agents; and __fish_seen_subcommand_from install" -l dry-run
complete -c cap -n "__fish_cap_using_subcommand agents; and __fish_seen_subcommand_from install" -l yes
complete -c cap -n "__fish_cap_using_subcommand agents; and __fish_seen_subcommand_from install" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand agents; and __fish_seen_subcommand_from install" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand agents; and __fish_seen_subcommand_from help" -f -a "install"
complete -c cap -n "__fish_cap_using_subcommand agents; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand targets; and not __fish_seen_subcommand_from screens windows cameras mics help" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand targets; and not __fish_seen_subcommand_from screens windows cameras mics help" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand targets; and not __fish_seen_subcommand_from screens windows cameras mics help" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand targets; and not __fish_seen_subcommand_from screens windows cameras mics help" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand targets; and not __fish_seen_subcommand_from screens windows cameras mics help" -f -a "screens" -d 'List screens available for capturing'
complete -c cap -n "__fish_cap_using_subcommand targets; and not __fish_seen_subcommand_from screens windows cameras mics help" -f -a "windows" -d 'List windows available for capturing'
complete -c cap -n "__fish_cap_using_subcommand targets; and not __fish_seen_subcommand_from screens windows cameras mics help" -f -a "cameras" -d 'List cameras available for capturing'
complete -c cap -n "__fish_cap_using_subcommand targets; and not __fish_seen_subcommand_from screens windows cameras mics help" -f -a "mics" -d 'List microphones available for capturing'
complete -c cap -n "__fish_cap_using_subcommand targets; and not __fish_seen_subcommand_from screens windows cameras mics help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from screens" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from screens" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from screens" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from screens" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from windows" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from windows" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from windows" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from windows" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from cameras" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from cameras" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from cameras" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from cameras" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from mics" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from mics" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from mics" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from mics" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from help" -f -a "screens" -d 'List screens available for capturing'
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from help" -f -a "windows" -d 'List windows available for capturing'
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from help" -f -a "cameras" -d 'List cameras available for capturing'
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from help" -f -a "mics" -d 'List microphones available for capturing'
complete -c cap -n "__fish_cap_using_subcommand targets; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand doctor" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand doctor" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand doctor" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand doctor" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand selftest; and not __fish_seen_subcommand_from av-sync playback analyze help" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand selftest; and not __fish_seen_subcommand_from av-sync playback analyze help" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand selftest; and not __fish_seen_subcommand_from av-sync playback analyze help" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand selftest; and not __fish_seen_subcommand_from av-sync playback analyze help" -f -a "av-sync" -d 'Record a test pattern and verify audio/video sync end-to-end'
complete -c cap -n "__fish_cap_using_subcommand selftest; and not __fish_seen_subcommand_from av-sync playback analyze help" -f -a "playback" -d 'Verify the editor playback path preserves audio/video sync'
complete -c cap -n "__fish_cap_using_subcommand selftest; and not __fish_seen_subcommand_from av-sync playback analyze help" -f -a "analyze" -d 'Internal: measure flash/beep onsets in an existing recording or export'
complete -c cap -n "__fish_cap_using_subcommand selftest; and not __fish_seen_subcommand_from av-sync playback analyze help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from av-sync" -l duration -d 'Seconds of test pattern to record (longer = more sensitive to drift)' -r
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from av-sync" -l mode -d 'Which recording pipeline to test: studio, instant, or both' -r -f -a "studio\t''
instant\t''
both\t''"
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from av-sync" -l fps -d 'Maximum fps to record at (defaults to the standard recording fps)' -r
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from av-sync" -l mic-name -d 'Microphone device name to use with --mic (defaults to the default mic)' -r
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from av-sync" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from av-sync" -l mic -d 'Also record a microphone and verify its sync acoustically (the mic must be able to hear the test beeps through your speakers). Applies to the studio leg only; the instant leg records system audio alone'
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from av-sync" -l skip-export -d 'Skip exporting the recording (tests only the recording stage)'
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from av-sync" -l keep -d 'Keep the recorded project on disk for inspection'
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from av-sync" -l discard-recordings -d 'Always delete the recorded project, even when the check fails. The desktop apps pass this: they surface the report, not the recording'
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from av-sync" -l progress-json -d 'Emit newline-delimited JSON progress on stdout: one message per stage transition, then the final report. Human logs stay on stderr'
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from av-sync" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from av-sync" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from playback" -l project -d 'Existing flash+beep .cap project to measure (defaults to generating a synthetic fixture through the real recording pipeline)' -r -F
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from playback" -l duration -d 'Seconds of synthetic fixture pattern to generate' -r
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from playback" -l fps -d 'Frame rate to drive editor playback at' -r
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from playback" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from playback" -l skip-export -d 'Skip exporting the project (tests only the playback stage)'
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from playback" -l keep -d 'Keep the generated fixture project on disk for inspection'
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from playback" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from playback" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from analyze" -l audio -d 'Separate audio file (defaults to the video file\'s audio track)' -r -F
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from analyze" -l voffset -d 'Added to flash times (track start offset)' -r
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from analyze" -l aoffset -d 'Added to beep times (track start offset)' -r
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from analyze" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from analyze" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from analyze" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from help" -f -a "av-sync" -d 'Record a test pattern and verify audio/video sync end-to-end'
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from help" -f -a "playback" -d 'Verify the editor playback path preserves audio/video sync'
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from help" -f -a "analyze" -d 'Internal: measure flash/beep onsets in an existing recording or export'
complete -c cap -n "__fish_cap_using_subcommand selftest; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand version" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand version" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand version" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand version" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand desktop; and not __fish_seen_subcommand_from status install-cli uninstall-cli help" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand desktop; and not __fish_seen_subcommand_from status install-cli uninstall-cli help" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand desktop; and not __fish_seen_subcommand_from status install-cli uninstall-cli help" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand desktop; and not __fish_seen_subcommand_from status install-cli uninstall-cli help" -f -a "status" -d 'Show whether the `cap` shim is installed and on PATH'
complete -c cap -n "__fish_cap_using_subcommand desktop; and not __fish_seen_subcommand_from status install-cli uninstall-cli help" -f -a "install-cli" -d 'Install the `cap` shim onto your PATH'
complete -c cap -n "__fish_cap_using_subcommand desktop; and not __fish_seen_subcommand_from status install-cli uninstall-cli help" -f -a "uninstall-cli" -d 'Remove the `cap` shim from your PATH'
complete -c cap -n "__fish_cap_using_subcommand desktop; and not __fish_seen_subcommand_from status install-cli uninstall-cli help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand desktop; and __fish_seen_subcommand_from status" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand desktop; and __fish_seen_subcommand_from status" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand desktop; and __fish_seen_subcommand_from status" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand desktop; and __fish_seen_subcommand_from status" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand desktop; and __fish_seen_subcommand_from install-cli" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand desktop; and __fish_seen_subcommand_from install-cli" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand desktop; and __fish_seen_subcommand_from install-cli" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand desktop; and __fish_seen_subcommand_from install-cli" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand desktop; and __fish_seen_subcommand_from uninstall-cli" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand desktop; and __fish_seen_subcommand_from uninstall-cli" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand desktop; and __fish_seen_subcommand_from uninstall-cli" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand desktop; and __fish_seen_subcommand_from uninstall-cli" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand desktop; and __fish_seen_subcommand_from help" -f -a "status" -d 'Show whether the `cap` shim is installed and on PATH'
complete -c cap -n "__fish_cap_using_subcommand desktop; and __fish_seen_subcommand_from help" -f -a "install-cli" -d 'Install the `cap` shim onto your PATH'
complete -c cap -n "__fish_cap_using_subcommand desktop; and __fish_seen_subcommand_from help" -f -a "uninstall-cli" -d 'Remove the `cap` shim from your PATH'
complete -c cap -n "__fish_cap_using_subcommand desktop; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand guide" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand guide" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand guide" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand guide" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand automations; and not __fish_seen_subcommand_from list help" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand automations; and not __fish_seen_subcommand_from list help" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand automations; and not __fish_seen_subcommand_from list help" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand automations; and not __fish_seen_subcommand_from list help" -f -a "list" -d 'List the automation rules configured in Cap Desktop'
complete -c cap -n "__fish_cap_using_subcommand automations; and not __fish_seen_subcommand_from list help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand automations; and __fish_seen_subcommand_from list" -l format -r -f -a "text\t''
json\t''"
complete -c cap -n "__fish_cap_using_subcommand automations; and __fish_seen_subcommand_from list" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand automations; and __fish_seen_subcommand_from list" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand automations; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand automations; and __fish_seen_subcommand_from help" -f -a "list" -d 'List the automation rules configured in Cap Desktop'
complete -c cap -n "__fish_cap_using_subcommand automations; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand completions" -l log-level -r -f -a "trace\t''
debug\t''
info\t''
warn\t''
error\t''"
complete -c cap -n "__fish_cap_using_subcommand completions" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
complete -c cap -n "__fish_cap_using_subcommand completions" -s h -l help -d 'Print help'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "export" -d 'Export a \'.cap\' project to a video file'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "export-preview" -d 'Render an export preview frame'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "project" -d 'Inspect or validate a \'.cap\' project'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "record" -d 'Start a recording or list available capture targets and devices'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "screenshot" -d 'Capture a still screenshot of a screen or window'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "recordings" -d 'List recordings discovered in the desktop library (or a custom directory)'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "upload" -d 'Upload a recording or video file and get a shareable link'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "update" -d 'Update Cap Desktop and the bundled CLI'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "auth" -d 'Show how `cap upload` will authenticate (env key or Cap Desktop login)'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "caps" -d 'Read and manage Caps in your personal library'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "account" -d 'Read or update the authenticated Cap account'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "organizations" -d 'Inspect Cap organizations, members, billing, and storage connections'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "library" -d 'Manage folders, spaces, and space membership'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "notifications" -d 'Read and manage account notifications'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "analytics" -d 'Read organization, space, or Cap analytics'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "developers" -d 'Inspect developer apps, domains, usage, and credits'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "jobs" -d 'Inspect or wait for asynchronous Cap operations'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "mcp" -d 'Run Cap\'s local Model Context Protocol server'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "agents" -d 'Install Cap integrations for one explicitly selected agent'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "targets" -d 'List available capture targets and devices'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "doctor" -d 'Report CLI environment and capture-readiness diagnostics'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "selftest" -d 'Run end-to-end diagnostics that verify Cap works on this machine'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "version" -d 'Print CLI version and execution context'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "desktop" -d 'Inspect or manage the desktop-installed `cap` shim'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "guide" -d 'Print the machine-readable capability & JSON-schema manifest for agents'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "automations" -d 'List automation rules shared with Cap Desktop'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "completions" -d 'Generate shell completion scripts'
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from project" -f -a "inspect" -d 'Print project metadata and editor configuration'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from project" -f -a "validate" -d 'Verify a project\'s metadata and expected media files exist'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from project" -f -a "config" -d 'Read or write a project\'s editor configuration (project-config.json)'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from record" -f -a "start" -d 'Start a recording (use --detach to run in the background and stop later)'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from record" -f -a "stop" -d 'Stop a detached recording started with `cap record start --detach`'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from record" -f -a "status" -d 'List active and recent detached recording sessions'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from record" -f -a "__session-run" -d 'Internal: background worker for detached recordings (do not call directly)'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from record" -f -a "screens" -d 'List screens available for capturing'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from record" -f -a "windows" -d 'List windows available for capturing'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from record" -f -a "cameras" -d 'List cameras available for capturing'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from record" -f -a "mics" -d 'List microphones available for capturing'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from recordings" -f -a "list" -d 'List \'.cap\' recordings discovered on disk'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from auth" -f -a "status" -d 'Report whether a credential is available and where it comes from (never prints the secret)'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from auth" -f -a "login" -d 'Authorize Cap CLI in the browser using PKCE'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from auth" -f -a "logout" -d 'Revoke and remove the Cap CLI credential'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "list"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "get"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "context"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "status"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "wait"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "process"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "import"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "transcript"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "transcript-replace"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "download"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "duplicate"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "delete"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "password"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "unlock"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "comments"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "reactions"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "update"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "sharing"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "settings"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "date"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "move"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from caps" -f -a "shares"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from account" -f -a "get"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from account" -f -a "update"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from account" -f -a "image"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from account" -f -a "referrals"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from account" -f -a "sign-out-all"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from organizations" -f -a "list"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from organizations" -f -a "create"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from organizations" -f -a "get"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from organizations" -f -a "members"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from organizations" -f -a "invites"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from organizations" -f -a "billing"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from organizations" -f -a "storage"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from organizations" -f -a "update"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from organizations" -f -a "icon"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from organizations" -f -a "shareable-icon"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from organizations" -f -a "settings"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from organizations" -f -a "invite"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from organizations" -f -a "member"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from organizations" -f -a "domain"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from organizations" -f -a "delete"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from library" -f -a "folders"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from library" -f -a "spaces"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from notifications" -f -a "list"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from notifications" -f -a "preferences"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from notifications" -f -a "read"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from developers" -f -a "list"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from developers" -f -a "get"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from developers" -f -a "create"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from developers" -f -a "update"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from developers" -f -a "delete"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from developers" -f -a "domains"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from developers" -f -a "keys"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from developers" -f -a "auto-top-up"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from developers" -f -a "credits"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from developers" -f -a "videos"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from developers" -f -a "transactions"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from jobs" -f -a "get"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from jobs" -f -a "wait"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from mcp" -f -a "serve"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from agents" -f -a "install"
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from targets" -f -a "screens" -d 'List screens available for capturing'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from targets" -f -a "windows" -d 'List windows available for capturing'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from targets" -f -a "cameras" -d 'List cameras available for capturing'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from targets" -f -a "mics" -d 'List microphones available for capturing'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from selftest" -f -a "av-sync" -d 'Record a test pattern and verify audio/video sync end-to-end'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from selftest" -f -a "playback" -d 'Verify the editor playback path preserves audio/video sync'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from selftest" -f -a "analyze" -d 'Internal: measure flash/beep onsets in an existing recording or export'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from desktop" -f -a "status" -d 'Show whether the `cap` shim is installed and on PATH'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from desktop" -f -a "install-cli" -d 'Install the `cap` shim onto your PATH'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from desktop" -f -a "uninstall-cli" -d 'Remove the `cap` shim from your PATH'
complete -c cap -n "__fish_cap_using_subcommand help; and __fish_seen_subcommand_from automations" -f -a "list" -d 'List the automation rules configured in Cap Desktop'
