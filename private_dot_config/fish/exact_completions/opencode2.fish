###-begin-opencode2-completions-###
#
# Static completion script for Fish
#
# Installation:
#   opencode2 --completions fish > ~/.config/fish/completions/opencode2.fish
#

complete -c opencode2 -n '__fish_use_subcommand' -f
complete -c opencode2 -n '__fish_use_subcommand' -f -a 'acp' -d 'Start an Agent Client Protocol server'
complete -c opencode2 -n '__fish_use_subcommand' -f -a 'api' -d 'Make a request to the running server'
complete -c opencode2 -n '__fish_use_subcommand' -f -a 'debug' -d 'Debugging and troubleshooting tools'
complete -c opencode2 -n '__fish_use_subcommand' -f -a 'console' -d 'Manage OpenCode Console access'
complete -c opencode2 -n '__fish_use_subcommand' -f -a 'auth' -d 'Manage authentication'
complete -c opencode2 -n '__fish_use_subcommand' -f -a 'mcp' -d 'Manage MCP (Model Context Protocol) servers'
complete -c opencode2 -n '__fish_use_subcommand' -f -a 'plugin' -d 'Manage plugins'
complete -c opencode2 -n '__fish_use_subcommand' -f -a 'migrate' -d 'Migrate v1 data to v2'
complete -c opencode2 -n '__fish_use_subcommand' -f -a 'mini' -d 'Start the minimal interactive interface'
complete -c opencode2 -n '__fish_use_subcommand' -f -a 'run' -d 'Run OpenCode with a message'
complete -c opencode2 -n '__fish_use_subcommand' -f -a 'service' -d 'Manage the background server'
complete -c opencode2 -n '__fish_use_subcommand' -f -a 'pair' -d 'Show server pairing information'
complete -c opencode2 -n '__fish_use_subcommand' -f -a 'serve' -d 'Start the v2 API server'
complete -c opencode2 -n '__fish_use_subcommand; and not __fish_contains_opt standalone no-standalone' -l standalone -d 'Run with a private server instead of the background service'
complete -c opencode2 -n '__fish_use_subcommand; and not __fish_contains_opt standalone no-standalone' -l no-standalone -d 'Disable standalone'
complete -c opencode2 -n '__fish_use_subcommand' -l server -d 'Connect to a server URL instead of the background service' -r -f
complete -c opencode2 -n '__fish_use_subcommand; and not __fish_contains_opt auto no-auto' -l auto -d 'Auto-approve permissions that are not explicitly denied'
complete -c opencode2 -n '__fish_use_subcommand; and not __fish_contains_opt auto no-auto' -l no-auto -d 'Disable auto'
complete -c opencode2 -n '__fish_use_subcommand; and not __fish_contains_opt -s c continue no-continue' -l continue -s c -d 'Continue the last session'
complete -c opencode2 -n '__fish_use_subcommand; and not __fish_contains_opt -s c continue no-continue' -l no-continue -d 'Disable continue'
complete -c opencode2 -n '__fish_use_subcommand' -l session -s s -d 'Session ID to continue' -r -f
complete -c opencode2 -n '__fish_use_subcommand' -l prompt -d 'Prompt to use' -r -f
complete -c opencode2 -n '__fish_use_subcommand; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt standalone no-standalone' -f -a '--standalone' -d 'Run with a private server instead of the background service'
complete -c opencode2 -n '__fish_use_subcommand; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt standalone no-standalone' -f -a '--no-standalone' -d 'Disable standalone'
complete -c opencode2 -n '__fish_use_subcommand; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt server' -f -a '--server' -d 'Connect to a server URL instead of the background service'
complete -c opencode2 -n '__fish_use_subcommand; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt auto no-auto' -f -a '--auto' -d 'Auto-approve permissions that are not explicitly denied'
complete -c opencode2 -n '__fish_use_subcommand; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt auto no-auto' -f -a '--no-auto' -d 'Disable auto'
complete -c opencode2 -n '__fish_use_subcommand; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s c continue no-continue' -f -a '--continue' -d 'Continue the last session'
complete -c opencode2 -n '__fish_use_subcommand; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s c continue no-continue' -f -a '--no-continue' -d 'Disable continue'
complete -c opencode2 -n '__fish_use_subcommand; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s s session' -f -a '--session' -d 'Session ID to continue'
complete -c opencode2 -n '__fish_use_subcommand; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt prompt' -f -a '--prompt' -d 'Prompt to use'
complete -c opencode2 -n '__fish_seen_subcommand_from acp' -f
complete -c opencode2 -n '__fish_seen_subcommand_from api' -f
complete -c opencode2 -n '__fish_seen_subcommand_from api; and not __fish_contains_opt standalone no-standalone' -l standalone -d 'Run with a private server instead of the background service'
complete -c opencode2 -n '__fish_seen_subcommand_from api; and not __fish_contains_opt standalone no-standalone' -l no-standalone -d 'Disable standalone'
complete -c opencode2 -n '__fish_seen_subcommand_from api' -l server -d 'Connect to a server URL instead of the background service' -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from api' -l data -s d -d 'Request body' -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from api' -l header -s H -d 'Request header in name:value form' -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from api' -l param -d 'OpenAPI path or query parameter' -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from api; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt standalone no-standalone' -f -a '--standalone' -d 'Run with a private server instead of the background service'
complete -c opencode2 -n '__fish_seen_subcommand_from api; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt standalone no-standalone' -f -a '--no-standalone' -d 'Disable standalone'
complete -c opencode2 -n '__fish_seen_subcommand_from api; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt server' -f -a '--server' -d 'Connect to a server URL instead of the background service'
complete -c opencode2 -n '__fish_seen_subcommand_from api; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s d data' -f -a '--data' -d 'Request body'
complete -c opencode2 -n '__fish_seen_subcommand_from api; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s H header' -f -a '--header' -d 'Request header in name:value form'
complete -c opencode2 -n '__fish_seen_subcommand_from api; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt param' -f -a '--param' -d 'OpenAPI path or query parameter'
complete -c opencode2 -n '__fish_seen_subcommand_from debug; and not __fish_seen_subcommand_from agents' -f
complete -c opencode2 -n '__fish_seen_subcommand_from debug; and not __fish_seen_subcommand_from agents' -f -a 'agents' -d 'List all agents'
complete -c opencode2 -n '__fish_seen_subcommand_from agents' -f
complete -c opencode2 -n '__fish_seen_subcommand_from console; and not __fish_seen_subcommand_from login' -f
complete -c opencode2 -n '__fish_seen_subcommand_from console; and not __fish_seen_subcommand_from login' -f -a 'login' -d 'Log in to OpenCode Console'
complete -c opencode2 -n '__fish_seen_subcommand_from login' -f
complete -c opencode2 -n '__fish_seen_subcommand_from auth; and not __fish_seen_subcommand_from connect' -f
complete -c opencode2 -n '__fish_seen_subcommand_from auth; and not __fish_seen_subcommand_from connect' -f -a 'connect' -d 'Connect to a wellknown authentication provider'
complete -c opencode2 -n '__fish_seen_subcommand_from connect' -f
complete -c opencode2 -n '__fish_seen_subcommand_from mcp; and not __fish_seen_subcommand_from list add auth logout' -f
complete -c opencode2 -n '__fish_seen_subcommand_from mcp; and not __fish_seen_subcommand_from list add auth logout' -f -a 'list' -d 'List configured MCP servers and their status'
complete -c opencode2 -n '__fish_seen_subcommand_from mcp; and not __fish_seen_subcommand_from list add auth logout' -f -a 'add' -d 'Add an MCP server to your configuration'
complete -c opencode2 -n '__fish_seen_subcommand_from mcp; and not __fish_seen_subcommand_from list add auth logout' -f -a 'auth' -d 'Authenticate with an OAuth-capable remote MCP server'
complete -c opencode2 -n '__fish_seen_subcommand_from mcp; and not __fish_seen_subcommand_from list add auth logout' -f -a 'logout' -d 'Remove stored OAuth credentials for an MCP server'
complete -c opencode2 -n '__fish_seen_subcommand_from list' -f
complete -c opencode2 -n '__fish_seen_subcommand_from add' -f
complete -c opencode2 -n '__fish_seen_subcommand_from add' -l url -d 'URL for a remote MCP server' -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from add' -l header -d 'HTTP header for a remote server, as name=value' -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from add' -l env -d 'Environment variable for a local server, as name=value' -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from add; and not __fish_contains_opt global no-global' -l global -d 'Write to the global config instead of the project config'
complete -c opencode2 -n '__fish_seen_subcommand_from add; and not __fish_contains_opt global no-global' -l no-global -d 'Disable global'
complete -c opencode2 -n '__fish_seen_subcommand_from add; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt url' -f -a '--url' -d 'URL for a remote MCP server'
complete -c opencode2 -n '__fish_seen_subcommand_from add; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt header' -f -a '--header' -d 'HTTP header for a remote server, as name=value'
complete -c opencode2 -n '__fish_seen_subcommand_from add; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt env' -f -a '--env' -d 'Environment variable for a local server, as name=value'
complete -c opencode2 -n '__fish_seen_subcommand_from add; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt global no-global' -f -a '--global' -d 'Write to the global config instead of the project config'
complete -c opencode2 -n '__fish_seen_subcommand_from add; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt global no-global' -f -a '--no-global' -d 'Disable global'
complete -c opencode2 -n '__fish_seen_subcommand_from auth' -f
complete -c opencode2 -n '__fish_seen_subcommand_from logout' -f
complete -c opencode2 -n '__fish_seen_subcommand_from plugin; and not __fish_seen_subcommand_from list' -f
complete -c opencode2 -n '__fish_seen_subcommand_from plugin; and not __fish_seen_subcommand_from list' -f -a 'list' -d 'List active plugins'
complete -c opencode2 -n '__fish_seen_subcommand_from list' -f
complete -c opencode2 -n '__fish_seen_subcommand_from migrate' -f
complete -c opencode2 -n '__fish_seen_subcommand_from mini' -f
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not __fish_contains_opt standalone no-standalone' -l standalone -d 'Run with a private server instead of the background service'
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not __fish_contains_opt standalone no-standalone' -l no-standalone -d 'Disable standalone'
complete -c opencode2 -n '__fish_seen_subcommand_from mini' -l server -d 'Connect to a server URL instead of the background service' -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not __fish_contains_opt -s c continue no-continue' -l continue -s c -d 'Continue the last session'
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not __fish_contains_opt -s c continue no-continue' -l no-continue -d 'Disable continue'
complete -c opencode2 -n '__fish_seen_subcommand_from mini' -l session -s s -d 'Session ID to continue' -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not __fish_contains_opt fork no-fork' -l fork -d 'Fork the session when continuing'
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not __fish_contains_opt fork no-fork' -l no-fork -d 'Disable fork'
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not __fish_contains_opt replay no-replay' -l replay -d 'Restore session history on resume and resize (disable with --no-replay)'
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not __fish_contains_opt replay no-replay' -l no-replay -d 'Disable replay'
complete -c opencode2 -n '__fish_seen_subcommand_from mini' -l replay-limit -d 'Limit replay to the newest N messages (default: 200)' -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from mini' -l model -s m -d 'Model to use in the format provider/model' -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from mini' -l agent -d 'Agent to use' -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from mini' -l prompt -d 'Prompt to use' -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt standalone no-standalone' -f -a '--standalone' -d 'Run with a private server instead of the background service'
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt standalone no-standalone' -f -a '--no-standalone' -d 'Disable standalone'
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt server' -f -a '--server' -d 'Connect to a server URL instead of the background service'
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s c continue no-continue' -f -a '--continue' -d 'Continue the last session'
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s c continue no-continue' -f -a '--no-continue' -d 'Disable continue'
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s s session' -f -a '--session' -d 'Session ID to continue'
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt fork no-fork' -f -a '--fork' -d 'Fork the session when continuing'
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt fork no-fork' -f -a '--no-fork' -d 'Disable fork'
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt replay no-replay' -f -a '--replay' -d 'Restore session history on resume and resize (disable with --no-replay)'
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt replay no-replay' -f -a '--no-replay' -d 'Disable replay'
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt replay-limit' -f -a '--replay-limit' -d 'Limit replay to the newest N messages (default: 200)'
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s m model' -f -a '--model' -d 'Model to use in the format provider/model'
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt agent' -f -a '--agent' -d 'Agent to use'
complete -c opencode2 -n '__fish_seen_subcommand_from mini; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt prompt' -f -a '--prompt' -d 'Prompt to use'
complete -c opencode2 -n '__fish_seen_subcommand_from run' -f
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not __fish_contains_opt standalone no-standalone' -l standalone -d 'Run with a private server instead of the background service'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not __fish_contains_opt standalone no-standalone' -l no-standalone -d 'Disable standalone'
complete -c opencode2 -n '__fish_seen_subcommand_from run' -l server -d 'Connect to a server URL instead of the background service' -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not __fish_contains_opt -s c continue no-continue' -l continue -s c -d 'Continue the last session'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not __fish_contains_opt -s c continue no-continue' -l no-continue -d 'Disable continue'
complete -c opencode2 -n '__fish_seen_subcommand_from run' -l session -s s -d 'Session ID to continue' -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not __fish_contains_opt fork no-fork' -l fork -d 'Fork the session before continuing'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not __fish_contains_opt fork no-fork' -l no-fork -d 'Disable fork'
complete -c opencode2 -n '__fish_seen_subcommand_from run' -l model -s m -d 'Model to use in the format provider/model#variant' -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from run' -l agent -d 'Agent to use' -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from run' -l format -d 'Output format' -r -f -a 'default json'
complete -c opencode2 -n '__fish_seen_subcommand_from run' -l file -s f -d 'File to attach to the message' -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from run' -l title -d 'Session title' -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not __fish_contains_opt thinking no-thinking' -l thinking -d 'Show thinking blocks'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not __fish_contains_opt thinking no-thinking' -l no-thinking -d 'Disable thinking'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not __fish_contains_opt auto no-auto' -l auto -d 'Auto-approve permissions that are not explicitly denied'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not __fish_contains_opt auto no-auto' -l no-auto -d 'Disable auto'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt standalone no-standalone' -f -a '--standalone' -d 'Run with a private server instead of the background service'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt standalone no-standalone' -f -a '--no-standalone' -d 'Disable standalone'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt server' -f -a '--server' -d 'Connect to a server URL instead of the background service'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s c continue no-continue' -f -a '--continue' -d 'Continue the last session'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s c continue no-continue' -f -a '--no-continue' -d 'Disable continue'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s s session' -f -a '--session' -d 'Session ID to continue'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt fork no-fork' -f -a '--fork' -d 'Fork the session before continuing'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt fork no-fork' -f -a '--no-fork' -d 'Disable fork'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s m model' -f -a '--model' -d 'Model to use in the format provider/model#variant'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt agent' -f -a '--agent' -d 'Agent to use'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt format' -f -a '--format' -d 'Output format'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt -s f file' -f -a '--file' -d 'File to attach to the message'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt title' -f -a '--title' -d 'Session title'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt thinking no-thinking' -f -a '--thinking' -d 'Show thinking blocks'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt thinking no-thinking' -f -a '--no-thinking' -d 'Disable thinking'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt auto no-auto' -f -a '--auto' -d 'Auto-approve permissions that are not explicitly denied'
complete -c opencode2 -n '__fish_seen_subcommand_from run; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt auto no-auto' -f -a '--no-auto' -d 'Disable auto'
complete -c opencode2 -n '__fish_seen_subcommand_from service; and not __fish_seen_subcommand_from start restart status stop get set unset' -f
complete -c opencode2 -n '__fish_seen_subcommand_from service; and not __fish_seen_subcommand_from start restart status stop get set unset' -f -a 'start' -d 'Start the background server'
complete -c opencode2 -n '__fish_seen_subcommand_from service; and not __fish_seen_subcommand_from start restart status stop get set unset' -f -a 'restart' -d 'Restart the background server'
complete -c opencode2 -n '__fish_seen_subcommand_from service; and not __fish_seen_subcommand_from start restart status stop get set unset' -f -a 'status' -d 'Show background server status'
complete -c opencode2 -n '__fish_seen_subcommand_from service; and not __fish_seen_subcommand_from start restart status stop get set unset' -f -a 'stop' -d 'Stop the background server'
complete -c opencode2 -n '__fish_seen_subcommand_from service; and not __fish_seen_subcommand_from start restart status stop get set unset' -f -a 'get' -d 'Get service configuration'
complete -c opencode2 -n '__fish_seen_subcommand_from service; and not __fish_seen_subcommand_from start restart status stop get set unset' -f -a 'set' -d 'Set service configuration'
complete -c opencode2 -n '__fish_seen_subcommand_from service; and not __fish_seen_subcommand_from start restart status stop get set unset' -f -a 'unset' -d 'Unset service configuration'
complete -c opencode2 -n '__fish_seen_subcommand_from start' -f
complete -c opencode2 -n '__fish_seen_subcommand_from restart' -f
complete -c opencode2 -n '__fish_seen_subcommand_from status' -f
complete -c opencode2 -n '__fish_seen_subcommand_from stop' -f
complete -c opencode2 -n '__fish_seen_subcommand_from get' -f
complete -c opencode2 -n '__fish_seen_subcommand_from set' -f
complete -c opencode2 -n '__fish_seen_subcommand_from unset' -f
complete -c opencode2 -n '__fish_seen_subcommand_from pair' -f
complete -c opencode2 -n '__fish_seen_subcommand_from serve' -f
complete -c opencode2 -n '__fish_seen_subcommand_from serve' -l hostname -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from serve' -l port -r -f
complete -c opencode2 -n '__fish_seen_subcommand_from serve; and not __fish_contains_opt service no-service' -l service
complete -c opencode2 -n '__fish_seen_subcommand_from serve; and not __fish_contains_opt service no-service' -l no-service
complete -c opencode2 -n '__fish_seen_subcommand_from serve; and not __fish_contains_opt stdio no-stdio' -l stdio
complete -c opencode2 -n '__fish_seen_subcommand_from serve; and not __fish_contains_opt stdio no-stdio' -l no-stdio
complete -c opencode2 -n '__fish_seen_subcommand_from serve; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt hostname' -f -a '--hostname'
complete -c opencode2 -n '__fish_seen_subcommand_from serve; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt port' -f -a '--port'
complete -c opencode2 -n '__fish_seen_subcommand_from serve; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt service no-service' -f -a '--service'
complete -c opencode2 -n '__fish_seen_subcommand_from serve; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt service no-service' -f -a '--no-service'
complete -c opencode2 -n '__fish_seen_subcommand_from serve; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt stdio no-stdio' -f -a '--stdio'
complete -c opencode2 -n '__fish_seen_subcommand_from serve; and not string match -q -- "-*" (commandline -ct); and not __fish_contains_opt stdio no-stdio' -f -a '--no-stdio'

###-end-opencode2-completions-###
