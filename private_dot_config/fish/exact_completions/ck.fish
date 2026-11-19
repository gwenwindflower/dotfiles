/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/agentsview.fish:
    # completions must be prefixed with the flag
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/agentsview.fish:
        __agentsview_debug "No completions, probably due to a failure"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/agentsview.fish:
    __agentsview_debug "Performed completions and set __agentsview_perform_completion_once_result"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/agentsview.fish:
# this function is used to clear the $__agentsview_perform_completion_once_result variable after completions are run
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/agentsview.fish:
# - Obtain the completions and store them in the global __agentsview_comp_results
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/agentsview.fish:
function __agentsview_prepare_completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/agentsview.fish:
    # we need to count the number of valid completions.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/agentsview.fish:
    # To do so, we will filter on prefix as the completions we have received
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/agentsview.fish:
        set -l completions (string match -r -- "^$prefix.*" $__agentsview_comp_results)
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/agentsview.fish:
        set --global __agentsview_comp_results $completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/agentsview.fish:
        __agentsview_debug "Filtered completions are: $__agentsview_comp_results"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/agentsview.fish:
            # completion when there are no other completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/agentsview.fish:
# Since Fish completions are only loaded once the user triggers them, we trigger them ourselves
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/agentsview.fish:
# so we can properly delete any completions provided by another script.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/agentsview.fish:
# the existing completions will only be loaded if the program can be found.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/agentsview.fish:
# Remove any pre-existing completions for the program since we will be handling all of them.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/agentsview.fish:
# The call to __agentsview_prepare_completions will setup __agentsview_comp_results
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/agentsview.fish:
complete -c agentsview -n 'not __agentsview_requires_order_preservation && __agentsview_prepare_completions' -f -a '$__agentsview_comp_results'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/agentsview.fish:
complete -k -c agentsview -n '__agentsview_requires_order_preservation && __agentsview_prepare_completions' -f -a '$__agentsview_comp_results'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_needs_command" -f -a "completions" -d 'Generate shell completion scripts'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand completions" -l log-level -r -f -a "trace\t''
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand completions" -l json -d 'Emit machine-readable JSON to stdout (overrides each command\'s --format)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand completions" -s h -l help -d 'Print help'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "export" -d 'Export a \'.cap\' project to a video file'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "export-preview" -d 'Render an export preview frame'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "project" -d 'Inspect or validate a \'.cap\' project'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "record" -d 'Start a recording or list available capture targets and devices'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "screenshot" -d 'Capture a still screenshot of a screen or window'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "recordings" -d 'List recordings discovered in the desktop library (or a custom directory)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "upload" -d 'Upload a recording or video file and get a shareable link'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "update" -d 'Update Cap Desktop and the bundled CLI'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "auth" -d 'Show how `cap upload` will authenticate (env key or Cap Desktop login)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "caps" -d 'Read and manage Caps in your personal library'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "account" -d 'Read or update the authenticated Cap account'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "organizations" -d 'Inspect Cap organizations, members, billing, and storage connections'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "library" -d 'Manage folders, spaces, and space membership'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "notifications" -d 'Read and manage account notifications'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "analytics" -d 'Read organization, space, or Cap analytics'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "developers" -d 'Inspect developer apps, domains, usage, and credits'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "jobs" -d 'Inspect or wait for asynchronous Cap operations'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "mcp" -d 'Run Cap\'s local Model Context Protocol server'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "agents" -d 'Install Cap integrations for one explicitly selected agent'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "targets" -d 'List available capture targets and devices'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "doctor" -d 'Report CLI environment and capture-readiness diagnostics'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "selftest" -d 'Run end-to-end diagnostics that verify Cap works on this machine'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "version" -d 'Print CLI version and execution context'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "desktop" -d 'Inspect or manage the desktop-installed `cap` shim'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "guide" -d 'Print the machine-readable capability & JSON-schema manifest for agents'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "automations" -d 'List automation rules shared with Cap Desktop'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "completions" -d 'Generate shell completion scripts'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "completions" -d 'Generate shell completion scripts'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/cap.fish:
complete -c cap -n "__fish_cap_using_subcommand help; and not __fish_seen_subcommand_from export export-preview project record screenshot recordings upload update auth caps account organizations library notifications analytics developers jobs mcp agents targets doctor selftest version desktop guide automations completions help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/claude.fish:
# Main command completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/dbt.fish:
# Autogenerated dbt fish completions from NDJSON map
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_needs_command" -a "completions" -d 'Output shell completion script to standard output.    deno completions bash > /usr/local/etc/bash_completion.d/deno.bash   source /usr/local/etc/bash_completion.d/deno.bash'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_needs_command" -a "completions" -d 'Output shell completion script to standard output.    deno completions bash > /usr/local/etc/bash_completion.d/deno.bash   source /usr/local/etc/bash_completion.d/deno.bash'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -s h -l help -r -f -a "unstable\t''
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -s L -l log-level -d 'Set log level' -r -f -a "trace\t''
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable -d 'The `--unstable` flag has been deprecated. Use granular `--unstable-*` flags instead   To view the list of individual unstable feature flags, run this command again with --help=unstable'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-bundle -d 'Enable unstable bundle runtime API'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-byonm -d ''
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-cron -d 'Enable unstable `Deno.cron` API'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-detect-cjs -d 'Treats ambiguous .js, .jsx, .ts, .tsx files as CommonJS modules in more cases'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-ffi -d 'Enable unstable FFI APIs'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-fs -d 'Enable unstable file system APIs'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-http -d 'Enable unstable HTTP APIs'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-kv -d 'Enable unstable KV APIs'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-lazy-dynamic-imports -d 'Lazily loads statically analyzable dynamic imports when not running with type checking. Warning: This may change the order of semver specifier resolution.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-lockfile-v5 -d 'Enable unstable lockfile v5'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-net -d 'enable unstable net APIs'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-no-legacy-abort -d 'Enable abort signal in Deno.serve without legacy behavior. This will not abort the server when the request is handled successfully.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-node-globals -d 'Prefer Node.js globals over Deno globals - currently this refers to `setTimeout` and `setInterval` APIs.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-npm-lazy-caching -d 'Enable unstable lazy caching of npm dependencies, downloading them only as needed (disabled: all npm packages in package.json are installed on startup; enabled: only npm packages that are actually referenced in an import are installed'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-otel -d 'Enable unstable OpenTelemetry features'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-process -d 'Enable unstable process APIs'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-raw-imports -d 'Enable unstable \'bytes\' and \'text\' imports.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-subdomain-wildcards -d 'Enable subdomain wildcards support for the `--allow-net` flag'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-temporal -d 'Enable unstable Temporal API'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-tsgo -d 'Enable unstable TypeScript Go integration'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-vsock -d 'Enable unstable VSOCK APIs'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-webgpu -d 'Enable unstable WebGPU APIs'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -s q -l quiet -d 'Suppress diagnostic output'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l dynamic -d 'Generate dynamic completions for the given shell (unstable), currently this only provides available tasks for `deno task`.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand completions" -l dynamic -d 'Generate dynamic completions for the given shell (unstable), currently this only provides available tasks for `deno task`.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -s h -l help -r -f -a "unstable\t''
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -s L -l log-level -d 'Set log level' -r -f -a "trace\t''
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable -d 'The `--unstable` flag has been deprecated. Use granular `--unstable-*` flags instead   To view the list of individual unstable feature flags, run this command again with --help=unstable'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-bare-node-builtins -d 'Enable unstable bare node builtins feature'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-broadcast-channel -d 'Enable unstable `BroadcastChannel` API'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-bundle -d 'Enable unstable bundle runtime API'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-byonm -d ''
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-cron -d 'Enable unstable `Deno.cron` API'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-detect-cjs -d 'Treats ambiguous .js, .jsx, .ts, .tsx files as CommonJS modules in more cases'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-ffi -d 'Enable unstable FFI APIs'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-fs -d 'Enable unstable file system APIs'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-http -d 'Enable unstable HTTP APIs'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-kv -d 'Enable unstable KV APIs'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-lazy-dynamic-imports -d 'Lazily loads statically analyzable dynamic imports when not running with type checking. Warning: This may change the order of semver specifier resolution.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-lockfile-v5 -d 'Enable unstable lockfile v5'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-net -d 'enable unstable net APIs'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-no-legacy-abort -d 'Enable abort signal in Deno.serve without legacy behavior. This will not abort the server when the request is handled successfully.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-node-globals -d 'Prefer Node.js globals over Deno globals - currently this refers to `setTimeout` and `setInterval` APIs.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-npm-lazy-caching -d 'Enable unstable lazy caching of npm dependencies, downloading them only as needed (disabled: all npm packages in package.json are installed on startup; enabled: only npm packages that are actually referenced in an import are installed'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-otel -d 'Enable unstable OpenTelemetry features'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-process -d 'Enable unstable process APIs'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-raw-imports -d 'Enable unstable \'bytes\' and \'text\' imports.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-sloppy-imports -d 'Enable unstable resolving of specifiers by extension probing, .js to .ts, and directory probing'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-subdomain-wildcards -d 'Enable subdomain wildcards support for the `--allow-net` flag'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-temporal -d 'Enable unstable Temporal API'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-tsgo -d 'Enable unstable TypeScript Go integration'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-unsafe-proto -d 'Enable unsafe __proto__ support. This is a security risk.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-vsock -d 'Enable unstable VSOCK APIs'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-webgpu -d 'Enable unstable WebGPU APIs'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -l unstable-worker-options -d 'Enable unstable Web Worker APIs'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -s q -l quiet -d 'Suppress diagnostic output'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "run"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "serve"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "add"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "audit"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "remove"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "bench"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "bundle"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "cache"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "check"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "clean"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "compile"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "completions"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "completions"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "coverage"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "doc"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "deploy"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "sandbox"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "eval"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "fmt"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "init"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "info"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "install"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "json_reference"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "jupyter"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "approve-scripts"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "uninstall"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "outdated"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "lsp"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "lint"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "publish"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "repl"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "task"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "test"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "types"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "update"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "upgrade"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "vendor"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and not __fish_seen_subcommand_from run serve add audit remove bench bundle cache check clean compile completions coverage doc deploy sandbox eval fmt init info install json_reference jupyter approve-scripts uninstall outdated lsp lint publish repl task test types update upgrade vendor x" -f -a "x"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from completions" -s h -l help -r -f -a "unstable\t''
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from completions" -s L -l log-level -d 'Set log level' -r -f -a "trace\t''
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/deno.fish:
complete -c deno -n "__fish_deno_using_subcommand help; and __fish_seen_subcommand_from completions" -s q -l quiet -d 'Suppress diagnostic output'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/depop.fish:
complete -c depop -n "__fish_depop_needs_command" -a "completions" -d 'Print a shell completion script to stdout'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/depop.fish:
complete -c depop -n "__fish_depop_using_subcommand completions" -s h -l help -d 'Print help'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/lfk.fish:
    # completions must be prefixed with the flag
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/lfk.fish:
        __lfk_debug "No completions, probably due to a failure"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/lfk.fish:
    __lfk_debug "Performed completions and set __lfk_perform_completion_once_result"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/lfk.fish:
# this function is used to clear the $__lfk_perform_completion_once_result variable after completions are run
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/lfk.fish:
# - Obtain the completions and store them in the global __lfk_comp_results
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/lfk.fish:
function __lfk_prepare_completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/lfk.fish:
    # we need to count the number of valid completions.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/lfk.fish:
    # To do so, we will filter on prefix as the completions we have received
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/lfk.fish:
        set -l completions (string match -r -- "^$prefix.*" $__lfk_comp_results)
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/lfk.fish:
        set --global __lfk_comp_results $completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/lfk.fish:
        __lfk_debug "Filtered completions are: $__lfk_comp_results"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/lfk.fish:
            # completion when there are no other completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/lfk.fish:
# Since Fish completions are only loaded once the user triggers them, we trigger them ourselves
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/lfk.fish:
# so we can properly delete any completions provided by another script.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/lfk.fish:
# the existing completions will only be loaded if the program can be found.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/lfk.fish:
# Remove any pre-existing completions for the program since we will be handling all of them.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/lfk.fish:
# The call to __lfk_prepare_completions will setup __lfk_comp_results
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/lfk.fish:
complete -c lfk -n 'not __lfk_requires_order_preservation && __lfk_prepare_completions' -f -a '$__lfk_comp_results'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/lfk.fish:
complete -k -c lfk -n '__lfk_requires_order_preservation && __lfk_prepare_completions' -f -a '$__lfk_comp_results'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli-dynamic.fish:
# Dynamic completions for linear-cli (fish)
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli-dynamic.fish:
# Source this file or save to ~/.config/fish/completions/linear-cli-dynamic.fish:
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli-dynamic.fish:
#   linear-cli completions dynamic fish > ~/.config/fish/completions/linear-cli-dynamic.fish
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli-dynamic.fish:
#   linear-cli completions dynamic fish > ~/.config/fish/completions/linear-cli-dynamic.fish
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli-dynamic.fish:
# Team completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli-dynamic.fish:
# Status completions (tries to pick up --team from current command line)
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli-dynamic.fish:
# Project completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli-dynamic.fish:
# Label completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli-dynamic.fish:
# User completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli-dynamic.fish:
# Issue ID completions for subcommands that take an issue
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_needs_command" -f -a "completions" -d 'Generate shell completions'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_needs_command" -f -a "completions" -d 'Generate shell completions'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -s o -l output -d 'Output format (table or json)' -r -f -a "table\t'Display results as formatted tables (default)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l color-mode -d 'Color output: auto, always, or never' -r -f -a "auto\t''
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l width -d 'Max column width for table output (default: 50)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l fields -d 'Limit JSON output to specific fields (comma-separated, supports dot paths)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l sort -d 'Sort JSON array output by a field (default: identifier/id when available)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l order -d 'Sort order for JSON array output' -r -f -a "asc\t''
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l profile -d 'Override workspace profile for this invocation' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l format -d 'Output using a template (e.g. \'{{identifier}} {{title}}\')' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l filter -d 'Filter results (field=value, field!=value, field~=value). Supports dot-notation for nested fields (e.g. state.name=Done). ~= is a case-insensitive "contains" match. All comparisons are case-insensitive. Multiple --filter flags are combined with AND logic' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l limit -d 'Max results to return for list/search commands' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l after -d 'Pagination cursor to start after' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l before -d 'Pagination cursor to end before' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l page-size -d 'Page size per request for list/search commands' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l cache-ttl -d 'Override cache TTL in seconds' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l retry -d 'Number of retries for failed API requests (with exponential backoff)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -s q -l quiet -d 'Suppress decorative output (headers, separators, tips) - for scripting'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l id-only -d 'Only output IDs of created/updated resources - for chaining commands'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l no-color -d 'Disable color output'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l no-truncate -d 'Disable truncation for table output'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l compact -d 'Emit compact JSON without pretty formatting'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l fail-on-empty -d 'Exit with non-zero status when a list is empty'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l all -d 'Fetch all pages for list/search commands'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l no-cache -d 'Disable cache usage for this invocation'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l dry-run -d 'Preview without making changes where supported'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l yes -d 'Auto-confirm all prompts (deletes, destructive operations)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l schema -d 'Print JSON schema version info and exit'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -l no-pager -d 'Disable pager for output (default: auto-detect from terminal)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -s h -l help -d 'Print help (see more with \'--help\')'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -f -a "static" -d 'Generate static shell completions (command names and flags)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -f -a "static" -d 'Generate static shell completions (command names and flags)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -f -a "dynamic" -d 'Generate dynamic shell completions (argument values from Linear API)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -f -a "dynamic" -d 'Generate dynamic shell completions (argument values from Linear API)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and not __fish_seen_subcommand_from static dynamic help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -s o -l output -d 'Output format (table or json)' -r -f -a "table\t'Display results as formatted tables (default)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l color-mode -d 'Color output: auto, always, or never' -r -f -a "auto\t''
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l width -d 'Max column width for table output (default: 50)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l fields -d 'Limit JSON output to specific fields (comma-separated, supports dot paths)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l sort -d 'Sort JSON array output by a field (default: identifier/id when available)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l order -d 'Sort order for JSON array output' -r -f -a "asc\t''
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l profile -d 'Override workspace profile for this invocation' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l format -d 'Output using a template (e.g. \'{{identifier}} {{title}}\')' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l filter -d 'Filter results (field=value, field!=value, field~=value). Supports dot-notation for nested fields (e.g. state.name=Done). ~= is a case-insensitive "contains" match. All comparisons are case-insensitive. Multiple --filter flags are combined with AND logic' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l limit -d 'Max results to return for list/search commands' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l after -d 'Pagination cursor to start after' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l before -d 'Pagination cursor to end before' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l page-size -d 'Page size per request for list/search commands' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l cache-ttl -d 'Override cache TTL in seconds' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l retry -d 'Number of retries for failed API requests (with exponential backoff)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -s q -l quiet -d 'Suppress decorative output (headers, separators, tips) - for scripting'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l id-only -d 'Only output IDs of created/updated resources - for chaining commands'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l no-color -d 'Disable color output'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l no-truncate -d 'Disable truncation for table output'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l compact -d 'Emit compact JSON without pretty formatting'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l fail-on-empty -d 'Exit with non-zero status when a list is empty'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l all -d 'Fetch all pages for list/search commands'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l no-cache -d 'Disable cache usage for this invocation'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l dry-run -d 'Preview without making changes where supported'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l yes -d 'Auto-confirm all prompts (deletes, destructive operations)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l schema -d 'Print JSON schema version info and exit'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -l no-pager -d 'Disable pager for output (default: auto-detect from terminal)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from static" -s h -l help -d 'Print help (see more with \'--help\')'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -s o -l output -d 'Output format (table or json)' -r -f -a "table\t'Display results as formatted tables (default)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l color-mode -d 'Color output: auto, always, or never' -r -f -a "auto\t''
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l width -d 'Max column width for table output (default: 50)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l fields -d 'Limit JSON output to specific fields (comma-separated, supports dot paths)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l sort -d 'Sort JSON array output by a field (default: identifier/id when available)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l order -d 'Sort order for JSON array output' -r -f -a "asc\t''
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l profile -d 'Override workspace profile for this invocation' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l format -d 'Output using a template (e.g. \'{{identifier}} {{title}}\')' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l filter -d 'Filter results (field=value, field!=value, field~=value). Supports dot-notation for nested fields (e.g. state.name=Done). ~= is a case-insensitive "contains" match. All comparisons are case-insensitive. Multiple --filter flags are combined with AND logic' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l limit -d 'Max results to return for list/search commands' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l after -d 'Pagination cursor to start after' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l before -d 'Pagination cursor to end before' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l page-size -d 'Page size per request for list/search commands' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l cache-ttl -d 'Override cache TTL in seconds' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l retry -d 'Number of retries for failed API requests (with exponential backoff)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -s q -l quiet -d 'Suppress decorative output (headers, separators, tips) - for scripting'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l id-only -d 'Only output IDs of created/updated resources - for chaining commands'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l no-color -d 'Disable color output'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l no-truncate -d 'Disable truncation for table output'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l compact -d 'Emit compact JSON without pretty formatting'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l fail-on-empty -d 'Exit with non-zero status when a list is empty'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l all -d 'Fetch all pages for list/search commands'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l no-cache -d 'Disable cache usage for this invocation'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l dry-run -d 'Preview without making changes where supported'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l yes -d 'Auto-confirm all prompts (deletes, destructive operations)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l schema -d 'Print JSON schema version info and exit'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -l no-pager -d 'Disable pager for output (default: auto-detect from terminal)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from dynamic" -s h -l help -d 'Print help (see more with \'--help\')'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from help" -f -a "static" -d 'Generate static shell completions (command names and flags)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from help" -f -a "static" -d 'Generate static shell completions (command names and flags)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from help" -f -a "dynamic" -d 'Generate dynamic shell completions (argument values from Linear API)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from help" -f -a "dynamic" -d 'Generate dynamic shell completions (argument values from Linear API)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand completions; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand _complete" -l team -d 'Team context for scoped completions (e.g. statuses)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -s o -l output -d 'Output format (table or json)' -r -f -a "table\t'Display results as formatted tables (default)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l color-mode -d 'Color output: auto, always, or never' -r -f -a "auto\t''
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l width -d 'Max column width for table output (default: 50)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l fields -d 'Limit JSON output to specific fields (comma-separated, supports dot paths)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l sort -d 'Sort JSON array output by a field (default: identifier/id when available)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l order -d 'Sort order for JSON array output' -r -f -a "asc\t''
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l profile -d 'Override workspace profile for this invocation' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l format -d 'Output using a template (e.g. \'{{identifier}} {{title}}\')' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l filter -d 'Filter results (field=value, field!=value, field~=value). Supports dot-notation for nested fields (e.g. state.name=Done). ~= is a case-insensitive "contains" match. All comparisons are case-insensitive. Multiple --filter flags are combined with AND logic' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l limit -d 'Max results to return for list/search commands' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l after -d 'Pagination cursor to start after' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l before -d 'Pagination cursor to end before' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l page-size -d 'Page size per request for list/search commands' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l cache-ttl -d 'Override cache TTL in seconds' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l retry -d 'Number of retries for failed API requests (with exponential backoff)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -s q -l quiet -d 'Suppress decorative output (headers, separators, tips) - for scripting'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l id-only -d 'Only output IDs of created/updated resources - for chaining commands'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l no-color -d 'Disable color output'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l no-truncate -d 'Disable truncation for table output'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l compact -d 'Emit compact JSON without pretty formatting'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l fail-on-empty -d 'Exit with non-zero status when a list is empty'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l all -d 'Fetch all pages for list/search commands'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l no-cache -d 'Disable cache usage for this invocation'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l dry-run -d 'Preview without making changes where supported'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l yes -d 'Auto-confirm all prompts (deletes, destructive operations)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l schema -d 'Print JSON schema version info and exit'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -l no-pager -d 'Disable pager for output (default: auto-detect from terminal)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -s h -l help -d 'Print help (see more with \'--help\')'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -f -a "set-key" -d 'Set API key'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -f -a "get" -d 'Get a configuration value'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -f -a "set" -d 'Set a configuration value'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -f -a "show" -d 'Show current configuration'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -f -a "completions" -d 'Generate shell completions'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -f -a "completions" -d 'Generate shell completions'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -f -a "completions" -d 'Generate shell completions'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -f -a "workspace-add" -d 'Add a new workspace'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -f -a "workspace-list" -d 'List all workspaces'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -f -a "workspace-switch" -d 'Switch to a different workspace'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -f -a "workspace-current" -d 'Show current workspace'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -f -a "workspace-remove" -d 'Remove a workspace'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and not __fish_seen_subcommand_from set-key get set show completions workspace-add workspace-list workspace-switch workspace-current workspace-remove help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -s o -l output -d 'Output format (table or json)' -r -f -a "table\t'Display results as formatted tables (default)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l color-mode -d 'Color output: auto, always, or never' -r -f -a "auto\t''
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l width -d 'Max column width for table output (default: 50)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l fields -d 'Limit JSON output to specific fields (comma-separated, supports dot paths)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l sort -d 'Sort JSON array output by a field (default: identifier/id when available)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l order -d 'Sort order for JSON array output' -r -f -a "asc\t''
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l profile -d 'Override workspace profile for this invocation' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l format -d 'Output using a template (e.g. \'{{identifier}} {{title}}\')' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l filter -d 'Filter results (field=value, field!=value, field~=value). Supports dot-notation for nested fields (e.g. state.name=Done). ~= is a case-insensitive "contains" match. All comparisons are case-insensitive. Multiple --filter flags are combined with AND logic' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l limit -d 'Max results to return for list/search commands' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l after -d 'Pagination cursor to start after' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l before -d 'Pagination cursor to end before' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l page-size -d 'Page size per request for list/search commands' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l cache-ttl -d 'Override cache TTL in seconds' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l retry -d 'Number of retries for failed API requests (with exponential backoff)' -r
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -s q -l quiet -d 'Suppress decorative output (headers, separators, tips) - for scripting'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l id-only -d 'Only output IDs of created/updated resources - for chaining commands'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l no-color -d 'Disable color output'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l no-truncate -d 'Disable truncation for table output'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l compact -d 'Emit compact JSON without pretty formatting'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l fail-on-empty -d 'Exit with non-zero status when a list is empty'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l all -d 'Fetch all pages for list/search commands'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l no-cache -d 'Disable cache usage for this invocation'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l dry-run -d 'Preview without making changes where supported'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l yes -d 'Auto-confirm all prompts (deletes, destructive operations)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l schema -d 'Print JSON schema version info and exit'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -l no-pager -d 'Disable pager for output (default: auto-detect from terminal)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from completions" -s h -l help -d 'Print help (see more with \'--help\')'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from help" -f -a "completions" -d 'Generate shell completions'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand config; and __fish_seen_subcommand_from help" -f -a "completions" -d 'Generate shell completions'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "common" -d 'Show common tasks and examples'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "agent" -d 'Show agent-focused capabilities and examples'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "update" -d 'Check for and install the latest released version of linear-cli'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "attachments" -d 'Manage issue attachments - list, create, update, delete, link URLs'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "auth" -d 'Authenticate and manage API keys'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "doctor" -d 'Diagnose configuration and connectivity'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "api" -d 'Execute raw GraphQL queries and mutations against the Linear API'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "projects" -d 'Manage projects - list, create, update, delete projects'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "project-updates" -d 'Manage project status updates - list, create, update, archive'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "issues" -d 'Manage issues - list, create, update, assign, track issues'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "labels" -d 'Manage labels - create and organize project/issue labels'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "teams" -d 'Manage teams - list and view team details'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "users" -d 'Manage users - list workspace users and view profiles'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "cycles" -d 'Manage cycles - view sprint cycles and current cycle'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "comments" -d 'Manage comments - add and view issue comments'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "documents" -d 'Manage documents - create, update, delete documentation'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "search" -d 'Search across Linear - find issues and projects'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "sync" -d 'Sync operations - compare local folders with Linear'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "statuses" -d 'Manage issue statuses - view workflow states'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "git" -d 'Git branch operations - checkout branches, create PRs'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "bulk" -d 'Bulk operations - update multiple issues at once'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "cache" -d 'Manage cache - clear cached data or view status'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "notifications" -d 'Manage notifications - view and mark as read'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "templates" -d 'Manage issue templates - create and use templates'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "time" -d 'Time tracking - log and view time entries'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "uploads" -d 'Fetch uploads from Linear with authentication'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "interactive" -d 'Interactive mode - TUI for browsing and managing issues'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "context" -d 'Detect current Linear issue from git branch - for AI agents'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "favorites" -d 'Manage favorites - quick access to issues/projects'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "roadmaps" -d 'Manage roadmaps - view and manage roadmap planning'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "initiatives" -d 'Manage initiatives - create, update, and track initiatives'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "triage" -d 'Triage inbox - manage unassigned issues'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "metrics" -d 'View metrics - velocity, burndown, progress'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "milestones" -d 'Manage project milestones - list, create, update, delete milestones'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "export" -d 'Export issues to CSV, JSON, or Markdown'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "import" -d 'Import issues from CSV or JSON files'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "history" -d 'View issue history and activity'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "views" -d 'Manage custom views - create, apply, and manage saved views'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "webhooks" -d 'Manage webhooks - create, update, delete, listen for events'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "watch" -d 'Watch for updates (polling)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "relations" -d 'Manage issue relationships - parent/child, blocking, related'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "whoami" -d 'Show current authenticated user (alias for `users me`)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "done" -d 'Mark the current branch\'s issue as Done'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "setup" -d 'Guided onboarding wizard - configure auth, team, and output format'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "sprint" -d 'Sprint planning - manage cycle-based sprints'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "completions" -d 'Generate shell completions'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "completions" -d 'Generate shell completions'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "completions" -d 'Generate shell completions'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "_complete" -d 'Internal: provide dynamic completion values (hidden from help)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "config" -d 'Configure CLI settings - API keys, default team, and workspaces'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and not __fish_seen_subcommand_from common agent update attachments auth doctor api projects project-updates issues labels teams users cycles comments documents search sync statuses git bulk cache notifications templates time uploads interactive context favorites roadmaps initiatives triage metrics milestones export import history views webhooks watch relations whoami done setup sprint completions _complete config help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and __fish_seen_subcommand_from completions" -f -a "static" -d 'Generate static shell completions (command names and flags)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and __fish_seen_subcommand_from completions" -f -a "static" -d 'Generate static shell completions (command names and flags)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and __fish_seen_subcommand_from completions" -f -a "dynamic" -d 'Generate dynamic shell completions (argument values from Linear API)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and __fish_seen_subcommand_from completions" -f -a "dynamic" -d 'Generate dynamic shell completions (argument values from Linear API)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and __fish_seen_subcommand_from config" -f -a "completions" -d 'Generate shell completions'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/linear-cli.fish:
complete -c linear-cli -n "__fish_linear_cli_using_subcommand help; and __fish_seen_subcommand_from config" -f -a "completions" -d 'Generate shell completions'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/mermaid-ascii.fish:
    # completions must be prefixed with the flag
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/mermaid-ascii.fish:
# - Obtain the completions and store them in the global __mermaid_ascii_comp_results
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/mermaid-ascii.fish:
function __mermaid_ascii_prepare_completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/mermaid-ascii.fish:
    # we need to count the number of valid completions.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/mermaid-ascii.fish:
    # To do so, we will filter on prefix as the completions we have received
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/mermaid-ascii.fish:
        set -l completions (string match -r -- "^$prefix.*" $__mermaid_ascii_comp_results)
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/mermaid-ascii.fish:
        set --global __mermaid_ascii_comp_results $completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/mermaid-ascii.fish:
        __mermaid_ascii_debug "Filtered completions are: $__mermaid_ascii_comp_results"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/mermaid-ascii.fish:
            # completion when there are no other completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/mermaid-ascii.fish:
# Since Fish completions are only loaded once the user triggers them, we trigger them ourselves
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/mermaid-ascii.fish:
# so we can properly delete any completions provided by another script.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/mermaid-ascii.fish:
# the existing completions will only be loaded if the program can be found.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/mermaid-ascii.fish:
# Remove any pre-existing completions for the program since we will be handling all of them.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/mermaid-ascii.fish:
# The call to __mermaid_ascii_prepare_completions will setup __mermaid_ascii_comp_results
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/mermaid-ascii.fish:
complete -c mermaid-ascii -n '__mermaid_ascii_prepare_completions' -f -a '$__mermaid_ascii_comp_results'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/mise.fish:
    echo "Error: usage CLI not found. This is required for completions to work in mise." >&2
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/moshi.fish:
    # completions must be prefixed with the flag
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/moshi.fish:
        __moshi_hook_debug "No completions, probably due to a failure"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/moshi.fish:
    __moshi_hook_debug "Performed completions and set __moshi_hook_perform_completion_once_result"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/moshi.fish:
# this function is used to clear the $__moshi_hook_perform_completion_once_result variable after completions are run
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/moshi.fish:
# - Obtain the completions and store them in the global __moshi_hook_comp_results
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/moshi.fish:
function __moshi_hook_prepare_completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/moshi.fish:
    # we need to count the number of valid completions.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/moshi.fish:
    # To do so, we will filter on prefix as the completions we have received
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/moshi.fish:
        set -l completions (string match -r -- "^$prefix.*" $__moshi_hook_comp_results)
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/moshi.fish:
        set --global __moshi_hook_comp_results $completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/moshi.fish:
        __moshi_hook_debug "Filtered completions are: $__moshi_hook_comp_results"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/moshi.fish:
            # completion when there are no other completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/moshi.fish:
# Since Fish completions are only loaded once the user triggers them, we trigger them ourselves
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/moshi.fish:
# so we can properly delete any completions provided by another script.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/moshi.fish:
# the existing completions will only be loaded if the program can be found.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/moshi.fish:
# Remove any pre-existing completions for the program since we will be handling all of them.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/moshi.fish:
# The call to __moshi_hook_prepare_completions will setup __moshi_hook_comp_results
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/moshi.fish:
complete -c moshi-hook -n 'not __moshi_hook_requires_order_preservation && __moshi_hook_prepare_completions' -f -a '$__moshi_hook_comp_results'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/moshi.fish:
complete -k -c moshi-hook -n '__moshi_hook_requires_order_preservation && __moshi_hook_prepare_completions' -f -a '$__moshi_hook_comp_results'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/notesmd-cli.fish:
    # completions must be prefixed with the flag
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/notesmd-cli.fish:
        __notesmd_cli_debug "No completions, probably due to a failure"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/notesmd-cli.fish:
    __notesmd_cli_debug "Performed completions and set __notesmd_cli_perform_completion_once_result"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/notesmd-cli.fish:
# this function is used to clear the $__notesmd_cli_perform_completion_once_result variable after completions are run
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/notesmd-cli.fish:
# - Obtain the completions and store them in the global __notesmd_cli_comp_results
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/notesmd-cli.fish:
function __notesmd_cli_prepare_completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/notesmd-cli.fish:
    # we need to count the number of valid completions.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/notesmd-cli.fish:
    # To do so, we will filter on prefix as the completions we have received
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/notesmd-cli.fish:
        set -l completions (string match -r -- "^$prefix.*" $__notesmd_cli_comp_results)
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/notesmd-cli.fish:
        set --global __notesmd_cli_comp_results $completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/notesmd-cli.fish:
        __notesmd_cli_debug "Filtered completions are: $__notesmd_cli_comp_results"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/notesmd-cli.fish:
            # completion when there are no other completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/notesmd-cli.fish:
# Since Fish completions are only loaded once the user triggers them, we trigger them ourselves
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/notesmd-cli.fish:
# so we can properly delete any completions provided by another script.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/notesmd-cli.fish:
# the existing completions will only be loaded if the program can be found.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/notesmd-cli.fish:
# Remove any pre-existing completions for the program since we will be handling all of them.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/notesmd-cli.fish:
# The call to __notesmd_cli_prepare_completions will setup __notesmd_cli_comp_results
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/notesmd-cli.fish:
complete -c notesmd-cli -n 'not __notesmd_cli_requires_order_preservation && __notesmd_cli_prepare_completions' -f -a '$__notesmd_cli_comp_results'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/notesmd-cli.fish:
complete -k -c notesmd-cli -n '__notesmd_cli_requires_order_preservation && __notesmd_cli_prepare_completions' -f -a '$__notesmd_cli_comp_results'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/pinact.fish:
# Clear existing completions for pinact
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rem.fish:
    # completions must be prefixed with the flag
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rem.fish:
        __rem_debug "No completions, probably due to a failure"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rem.fish:
    __rem_debug "Performed completions and set __rem_perform_completion_once_result"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rem.fish:
# this function is used to clear the $__rem_perform_completion_once_result variable after completions are run
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rem.fish:
# - Obtain the completions and store them in the global __rem_comp_results
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rem.fish:
function __rem_prepare_completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rem.fish:
    # we need to count the number of valid completions.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rem.fish:
    # To do so, we will filter on prefix as the completions we have received
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rem.fish:
        set -l completions (string match -r -- "^$prefix.*" $__rem_comp_results)
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rem.fish:
        set --global __rem_comp_results $completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rem.fish:
        __rem_debug "Filtered completions are: $__rem_comp_results"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rem.fish:
            # completion when there are no other completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rem.fish:
# Since Fish completions are only loaded once the user triggers them, we trigger them ourselves
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rem.fish:
# so we can properly delete any completions provided by another script.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rem.fish:
# the existing completions will only be loaded if the program can be found.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rem.fish:
# Remove any pre-existing completions for the program since we will be handling all of them.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rem.fish:
# The call to __rem_prepare_completions will setup __rem_comp_results
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rem.fish:
complete -c rem -n 'not __rem_requires_order_preservation && __rem_prepare_completions' -f -a '$__rem_comp_results'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rem.fish:
complete -k -c rem -n '__rem_requires_order_preservation && __rem_prepare_completions' -f -a '$__rem_comp_results'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rotz.fish:
complete -c rotz -n "__fish_rotz_needs_command" -f -a "completions" -d 'Adds completions to shell'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rotz.fish:
complete -c rotz -n "__fish_rotz_needs_command" -f -a "completions" -d 'Adds completions to shell'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rotz.fish:
complete -c rotz -n "__fish_rotz_using_subcommand completions" -s h -l help -d 'Print help (see more with \'--help\')'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rotz.fish:
complete -c rotz -n "__fish_rotz_using_subcommand help; and not __fish_seen_subcommand_from clone init link install completions help" -f -a "clone" -d 'Clones a dotfiles git repository'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rotz.fish:
complete -c rotz -n "__fish_rotz_using_subcommand help; and not __fish_seen_subcommand_from clone init link install completions help" -f -a "init" -d 'Creates a dotfiles git repository and config'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rotz.fish:
complete -c rotz -n "__fish_rotz_using_subcommand help; and not __fish_seen_subcommand_from clone init link install completions help" -f -a "link" -d 'Links dotfiles to the filesystem'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rotz.fish:
complete -c rotz -n "__fish_rotz_using_subcommand help; and not __fish_seen_subcommand_from clone init link install completions help" -f -a "install" -d 'Installs applications using the provided commands'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rotz.fish:
complete -c rotz -n "__fish_rotz_using_subcommand help; and not __fish_seen_subcommand_from clone init link install completions help" -f -a "completions" -d 'Adds completions to shell'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rotz.fish:
complete -c rotz -n "__fish_rotz_using_subcommand help; and not __fish_seen_subcommand_from clone init link install completions help" -f -a "completions" -d 'Adds completions to shell'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rotz.fish:
complete -c rotz -n "__fish_rotz_using_subcommand help; and not __fish_seen_subcommand_from clone init link install completions help" -f -a "completions" -d 'Adds completions to shell'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rotz.fish:
complete -c rotz -n "__fish_rotz_using_subcommand help; and not __fish_seen_subcommand_from clone init link install completions help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_needs_command" -a "completions" -d 'Generate tab-completion scripts for your shell'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand completions" -s h -l help -d 'Print help'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand help; and not __fish_seen_subcommand_from install uninstall dump-testament toolchain default show update check target component override run which doc man self set completions help" -f -a "install" -d 'Install or update the given toolchains, or by default the active toolchain'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand help; and not __fish_seen_subcommand_from install uninstall dump-testament toolchain default show update check target component override run which doc man self set completions help" -f -a "uninstall" -d 'Uninstall the given toolchains'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand help; and not __fish_seen_subcommand_from install uninstall dump-testament toolchain default show update check target component override run which doc man self set completions help" -f -a "dump-testament" -d 'Dump information about the build'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand help; and not __fish_seen_subcommand_from install uninstall dump-testament toolchain default show update check target component override run which doc man self set completions help" -f -a "toolchain" -d 'Install, uninstall, or list toolchains'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand help; and not __fish_seen_subcommand_from install uninstall dump-testament toolchain default show update check target component override run which doc man self set completions help" -f -a "default" -d 'Set the default toolchain'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand help; and not __fish_seen_subcommand_from install uninstall dump-testament toolchain default show update check target component override run which doc man self set completions help" -f -a "show" -d 'Show the active and installed toolchains or profiles'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand help; and not __fish_seen_subcommand_from install uninstall dump-testament toolchain default show update check target component override run which doc man self set completions help" -f -a "update" -d 'Update Rust toolchains and rustup'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand help; and not __fish_seen_subcommand_from install uninstall dump-testament toolchain default show update check target component override run which doc man self set completions help" -f -a "check" -d 'Check for updates to Rust toolchains and rustup'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand help; and not __fish_seen_subcommand_from install uninstall dump-testament toolchain default show update check target component override run which doc man self set completions help" -f -a "target" -d 'Modify a toolchain\'s supported targets'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand help; and not __fish_seen_subcommand_from install uninstall dump-testament toolchain default show update check target component override run which doc man self set completions help" -f -a "component" -d 'Modify a toolchain\'s installed components'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand help; and not __fish_seen_subcommand_from install uninstall dump-testament toolchain default show update check target component override run which doc man self set completions help" -f -a "override" -d 'Modify toolchain overrides for directories'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand help; and not __fish_seen_subcommand_from install uninstall dump-testament toolchain default show update check target component override run which doc man self set completions help" -f -a "run" -d 'Run a command with an environment configured for a given toolchain'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand help; and not __fish_seen_subcommand_from install uninstall dump-testament toolchain default show update check target component override run which doc man self set completions help" -f -a "which" -d 'Display which binary will be run for a given command'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand help; and not __fish_seen_subcommand_from install uninstall dump-testament toolchain default show update check target component override run which doc man self set completions help" -f -a "doc" -d 'Open the documentation for the current toolchain'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand help; and not __fish_seen_subcommand_from install uninstall dump-testament toolchain default show update check target component override run which doc man self set completions help" -f -a "man" -d 'View the man page for a given command'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand help; and not __fish_seen_subcommand_from install uninstall dump-testament toolchain default show update check target component override run which doc man self set completions help" -f -a "self" -d 'Modify the rustup installation'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand help; and not __fish_seen_subcommand_from install uninstall dump-testament toolchain default show update check target component override run which doc man self set completions help" -f -a "set" -d 'Alter rustup settings'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand help; and not __fish_seen_subcommand_from install uninstall dump-testament toolchain default show update check target component override run which doc man self set completions help" -f -a "completions" -d 'Generate tab-completion scripts for your shell'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand help; and not __fish_seen_subcommand_from install uninstall dump-testament toolchain default show update check target component override run which doc man self set completions help" -f -a "completions" -d 'Generate tab-completion scripts for your shell'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/rustup.fish:
complete -c rustup -n "__fish_rustup_using_subcommand help; and not __fish_seen_subcommand_from install uninstall dump-testament toolchain default show update check target component override run which doc man self set completions help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/supabase.fish:
###-begin-supabase-completions-###
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/supabase.fish:
#   supabase --completions fish > ~/.config/fish/completions/supabase.fish
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/supabase.fish:
#   supabase --completions fish > ~/.config/fish/completions/supabase.fish
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/supabase.fish:
###-end-supabase-completions-###
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/symlink_docker.fish:
/Applications/OrbStack.app/Contents/MacOS/../Resources/completions/fish/docker.fish
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/symlink_kubectl.fish:
/Applications/OrbStack.app/Contents/MacOS/../Resources/completions/fish/kubectl.fish
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/symlink_orbctl.fish:
/Applications/OrbStack.app/Contents/MacOS/../Resources/completions/fish/orbctl.fish
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/termframe.fish:
complete -c termframe -l shell-completions -d 'Completions' -r -f -a "bash\t''
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
  set -l cmds __vt __vt_profile __vt_upgrade __vt_clone __vt_push __vt_pull __vt_status __vt_branch __vt_checkout __vt_watch __vt_browse __vt_create __vt_remix __vt_config __vt_config_set __vt_config_get __vt_config_ignore __vt_config_where __vt_config_options __vt_delete __vt_list __vt_tail __vt_login __vt_logout __vt_completions __vt_completions_bash __vt_completions_fish __vt_completions_zsh
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
  set -l cmds __vt __vt_profile __vt_upgrade __vt_clone __vt_push __vt_pull __vt_status __vt_branch __vt_checkout __vt_watch __vt_browse __vt_create __vt_remix __vt_config __vt_config_set __vt_config_get __vt_config_ignore __vt_config_where __vt_config_options __vt_delete __vt_list __vt_tail __vt_login __vt_logout __vt_completions __vt_completions_bash __vt_completions_fish __vt_completions_zsh
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
  set -l cmds __vt __vt_profile __vt_upgrade __vt_clone __vt_push __vt_pull __vt_status __vt_branch __vt_checkout __vt_watch __vt_browse __vt_create __vt_remix __vt_config __vt_config_set __vt_config_get __vt_config_ignore __vt_config_where __vt_config_options __vt_delete __vt_list __vt_tail __vt_login __vt_logout __vt_completions __vt_completions_bash __vt_completions_fish __vt_completions_zsh
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
  set -l cmds __vt __vt_profile __vt_upgrade __vt_clone __vt_push __vt_pull __vt_status __vt_branch __vt_checkout __vt_watch __vt_browse __vt_create __vt_remix __vt_config __vt_config_set __vt_config_get __vt_config_ignore __vt_config_where __vt_config_options __vt_delete __vt_list __vt_tail __vt_login __vt_logout __vt_completions __vt_completions_bash __vt_completions_fish __vt_completions_zsh
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_upgrade' -l version -k -f -r -a '(vt completions complete version upgrade 2>/dev/null)' -d 'The version to upgrade to.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_clone' -k -f -a '(vt completions complete string clone 2>/dev/null)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_branch' -s D -l delete -k -f -r -a '(vt completions complete string branch 2>/dev/null)' -d 'Delete a branch'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_checkout' -k -f -a '(vt completions complete string checkout 2>/dev/null)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_watch' -s d -l debounce-delay -k -f -r -a '(vt completions complete number watch 2>/dev/null)' -d 'Debounce delay in milliseconds'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_create' -k -f -a '(vt completions complete string create 2>/dev/null)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_create' -l org-name -k -f -r -a '(vt completions complete string create 2>/dev/null)' -d 'Create the Val under an organization you are a member of, or "me" for your personal account'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_create' -s d -l description -k -f -r -a '(vt completions complete string create 2>/dev/null)' -d 'Val description'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_remix' -k -f -a '(vt completions complete string remix 2>/dev/null)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_remix' -s d -l description -k -f -r -a '(vt completions complete string remix 2>/dev/null)' -d 'Val description'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_config_set' -k -f -a '(vt completions complete string config set 2>/dev/null)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_config_get' -k -f -a '(vt completions complete string config get 2>/dev/null)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_list' -k -f -a '(vt completions complete number list 2>/dev/null)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_tail' -k -f -a '(vt completions complete string tail 2>/dev/null)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_tail' -l poll-frequency -k -f -r -a '(vt completions complete number tail 2>/dev/null)' -d 'Polling frequency in milliseconds'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt' -k -f -a completions -d 'Generate shell completions.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt' -k -f -a completions -d 'Generate shell completions.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_completions' -s h -l help -x -k -f -d 'Show this help.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_completions' -k -f -a bash -d 'Generate shell completions for bash.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_completions' -k -f -a bash -d 'Generate shell completions for bash.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_completions_bash' -s h -l help -x -k -f -d 'Show this help.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_completions_bash' -s n -l name -k -f -r -a '(vt completions complete string completions bash 2>/dev/null)' -d 'The name of the main command.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_completions_bash' -s n -l name -k -f -r -a '(vt completions complete string completions bash 2>/dev/null)' -d 'The name of the main command.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_completions_bash' -s n -l name -k -f -r -a '(vt completions complete string completions bash 2>/dev/null)' -d 'The name of the main command.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_completions' -k -f -a fish -d 'Generate shell completions for fish.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_completions' -k -f -a fish -d 'Generate shell completions for fish.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_completions_fish' -s h -l help -x -k -f -d 'Show this help.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_completions_fish' -s n -l name -k -f -r -a '(vt completions complete string completions fish 2>/dev/null)' -d 'The name of the main command.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_completions_fish' -s n -l name -k -f -r -a '(vt completions complete string completions fish 2>/dev/null)' -d 'The name of the main command.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_completions_fish' -s n -l name -k -f -r -a '(vt completions complete string completions fish 2>/dev/null)' -d 'The name of the main command.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_completions' -k -f -a zsh -d 'Generate shell completions for zsh.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_completions' -k -f -a zsh -d 'Generate shell completions for zsh.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_completions_zsh' -s h -l help -x -k -f -d 'Show this help.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_completions_zsh' -s n -l name -k -f -r -a '(vt completions complete string completions zsh 2>/dev/null)' -d 'The name of the main command.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_completions_zsh' -s n -l name -k -f -r -a '(vt completions complete string completions zsh 2>/dev/null)' -d 'The name of the main command.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/vt.fish:
complete -c vt -n '__fish_vt_using_command __vt_completions_zsh' -s n -l name -k -f -r -a '(vt completions complete string completions zsh 2>/dev/null)' -d 'The name of the main command.'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/wrangler.fish:
    # completions must be prefixed with the flag
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/wrangler.fish:
        __wrangler_debug "No completions, probably due to a failure"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/wrangler.fish:
    __wrangler_debug "Performed completions and set __wrangler_perform_completion_once_result"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/wrangler.fish:
# This function is used to clear the cached result after completions are run
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/wrangler.fish:
# - Obtain the completions and store them in the global __wrangler_comp_results
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/wrangler.fish:
function __wrangler_prepare_completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/wrangler.fish:
    # we need to count the number of valid completions.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/wrangler.fish:
    # To do so, we will filter on prefix as the completions we have received
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/wrangler.fish:
        set -l completions (string match -r -- "^$prefix.*" $__wrangler_comp_results)
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/wrangler.fish:
        set --global __wrangler_comp_results $completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/wrangler.fish:
        __wrangler_debug "Filtered completions are: $__wrangler_comp_results"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/wrangler.fish:
            # completion when there are no other completions
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/wrangler.fish:
# Since Fish completions are only loaded once the user triggers them, we trigger them ourselves
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/wrangler.fish:
# so we can properly delete any completions provided by another script.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/wrangler.fish:
# the existing completions will only be loaded if the program can be found.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/wrangler.fish:
# Remove any pre-existing completions for the program since we will be handling all of them.
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/wrangler.fish:
# The call to __wrangler_prepare_completions will setup __wrangler_comp_results
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/wrangler.fish:
complete -c wrangler -n 'not __wrangler_requires_order_preservation && __wrangler_prepare_completions' -f -a '$__wrangler_comp_results'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/wrangler.fish:
complete -k -c wrangler -n '__wrangler_requires_order_preservation && __wrangler_prepare_completions' -f -a '$__wrangler_comp_results'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/wt.fish:
# worktrunk completions for fish
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_completions/zizmor.fish:
complete -c zizmor -l completions -d 'Generate tab completion scripts for the specified shell' -r -f -a "bash\t'Bourne Again `SHell` (bash)'
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_functions/compgen.fish:
function compgen -d "Probe a CLI for fish completion output and install to ~/.config/fish/completions/"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_functions/compgen.fish:
        logirl help_flag f/force "Overwrite existing completions file"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_functions/compgen.fish:
    set -l completions_dir "$HOME/.local/share/chezmoi/private_dot_config/fish/exact_completions"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_functions/compgen.fish:
    set -l completions_dir "$HOME/.local/share/chezmoi/private_dot_config/fish/exact_completions"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_functions/compgen.fish:
    set -l target "$completions_dir/$cmd_name.fish"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_functions/compgen.fish:
    if not test -d $completions_dir
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_functions/compgen.fish:
        mkdir -p $completions_dir
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_functions/compgen.fish:
            logirl error "Could not create $completions_dir"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_functions/compgen.fish:
        "completions fish" \
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_functions/compgen.fish:
        "--completions fish" \
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_functions/compgen.fish:
        "completions generate fish" \
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_functions/compgen.fish:
        "generate-completions fish" \
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_functions/compgen.fish:
        "--completions=fish" \
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_functions/compgen.fish:
        "completions --shell fish" \
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_functions/compgen.fish:
                logirl success "$cmd_name wrote completions to $target via '$probe'"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/exact_functions/compgen.fish:
        logirl success "Wrote completions for $cmd_name via '$probe'"
/Users/winnie/.local/share/chezmoi/private_dot_config/fish/tacklebox.yaml:
      - completions/fzf_configure_bindings.fish
