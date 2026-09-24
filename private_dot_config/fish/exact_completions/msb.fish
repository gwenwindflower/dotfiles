# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_msb_global_optspecs
    string join \n tree error warn info debug trace h/help V/version
end

function __fish_msb_needs_command
    # Figure out if the current invocation already has a command.
    set -l cmd (commandline -opc)
    set -e cmd[1]
    argparse -s (__fish_msb_global_optspecs) -- $cmd 2>/dev/null
    or return
    if set -q argv[1]
        # Also print the command, so this can be used to figure out what it is.
        echo $argv[1]
        return 1
    end
    return 0
end

function __fish_msb_using_subcommand
    set -l cmd (__fish_msb_needs_command)
    test -z "$cmd"
    and return 1
    contains -- $cmd[1] $argv
end

complete -c msb -n "__fish_msb_needs_command" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_needs_command" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_needs_command" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_needs_command" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_needs_command" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_needs_command" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_needs_command" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_needs_command" -s V -l version -d 'Print version'
complete -c msb -n "__fish_msb_needs_command" -f -a "machine" -d 'Run the VM process (internal)'
complete -c msb -n "__fish_msb_needs_command" -f -a "__launch-protocol" -d 'Report launch wire capabilities without initializing a backend'
complete -c msb -n "__fish_msb_needs_command" -f -a "sandbox" -d 'Manage sandboxes (also available as top-level commands)'
complete -c msb -n "__fish_msb_needs_command" -f -a "sbx" -d 'Manage sandboxes (also available as top-level commands)'
complete -c msb -n "__fish_msb_needs_command" -f -a "run" -d 'Create a sandbox from an image and run a command in it'
complete -c msb -n "__fish_msb_needs_command" -f -a "create" -d 'Create a sandbox and boot it in the background'
complete -c msb -n "__fish_msb_needs_command" -f -a "restore" -d 'Restore a snapshot into a new detached sandbox'
complete -c msb -n "__fish_msb_needs_command" -f -a "modify" -d 'Modify sandbox configuration'
complete -c msb -n "__fish_msb_needs_command" -f -a "mod" -d 'Modify sandbox configuration'
complete -c msb -n "__fish_msb_needs_command" -f -a "start" -d 'Start a stopped sandbox'
complete -c msb -n "__fish_msb_needs_command" -f -a "stop" -d 'Stop one or more running sandboxes'
complete -c msb -n "__fish_msb_needs_command" -f -a "pause" -d 'Suspend a resident sandbox without creating a snapshot'
complete -c msb -n "__fish_msb_needs_command" -f -a "branch" -d 'Branch running execution into a new local CoW child without a durable full snapshot'
complete -c msb -n "__fish_msb_needs_command" -f -a "resume" -d 'Resume a user-paused resident sandbox'
complete -c msb -n "__fish_msb_needs_command" -f -a "restart" -d 'Restart one or more sandboxes'
complete -c msb -n "__fish_msb_needs_command" -f -a "ping" -d 'Check whether one or more sandbox agents are reachable'
complete -c msb -n "__fish_msb_needs_command" -f -a "touch" -d 'Refresh idle activity for one or more running sandboxes'
complete -c msb -n "__fish_msb_needs_command" -f -a "list" -d 'List all sandboxes'
complete -c msb -n "__fish_msb_needs_command" -f -a "ls" -d 'List all sandboxes'
complete -c msb -n "__fish_msb_needs_command" -f -a "status" -d 'Show sandbox status'
complete -c msb -n "__fish_msb_needs_command" -f -a "ps" -d 'Show sandbox status'
complete -c msb -n "__fish_msb_needs_command" -f -a "metrics" -d 'Show live metrics for a running sandbox'
complete -c msb -n "__fish_msb_needs_command" -f -a "remove" -d 'Remove one or more sandboxes'
complete -c msb -n "__fish_msb_needs_command" -f -a "rm" -d 'Remove one or more sandboxes'
complete -c msb -n "__fish_msb_needs_command" -f -a "exec" -d 'Run a command in a running sandbox'
complete -c msb -n "__fish_msb_needs_command" -f -a "copy" -d 'Copy files between the host and a sandbox'
complete -c msb -n "__fish_msb_needs_command" -f -a "cp" -d 'Copy files between the host and a sandbox'
complete -c msb -n "__fish_msb_needs_command" -f -a "logs" -d 'Show captured output from a sandbox'
complete -c msb -n "__fish_msb_needs_command" -f -a "inspect" -d 'Show detailed sandbox configuration and status'
complete -c msb -n "__fish_msb_needs_command" -f -a "__schema-baseline" -d 'Print the schema baseline owned by this binary (internal)'
complete -c msb -n "__fish_msb_needs_command" -f -a "context" -d 'Show the active backend and its selection source'
complete -c msb -n "__fish_msb_needs_command" -f -a "ctx" -d 'Show the active backend and its selection source'
complete -c msb -n "__fish_msb_needs_command" -f -a "image" -d 'Manage OCI images'
complete -c msb -n "__fish_msb_needs_command" -f -a "pull" -d 'Download an image from a registry'
complete -c msb -n "__fish_msb_needs_command" -f -a "load" -d 'Load an image archive from tar'
complete -c msb -n "__fish_msb_needs_command" -f -a "save" -d 'Save one or more cached images to a tar archive'
complete -c msb -n "__fish_msb_needs_command" -f -a "registry" -d 'Manage registry credentials'
complete -c msb -n "__fish_msb_needs_command" -f -a "ssh" -d 'Connect to a sandbox over SSH'
complete -c msb -n "__fish_msb_needs_command" -f -a "images" -d 'List cached images (alias for `image ls`)'
complete -c msb -n "__fish_msb_needs_command" -f -a "volumes" -d 'List named volumes (alias for `volume ls`)'
complete -c msb -n "__fish_msb_needs_command" -f -a "snapshots" -d 'List disk snapshots (alias for `snapshot ls`)'
complete -c msb -n "__fish_msb_needs_command" -f -a "registries" -d 'List configured registries (alias for `registry ls`)'
complete -c msb -n "__fish_msb_needs_command" -f -a "rmi" -d 'Remove a cached image (alias for `image rm`)'
complete -c msb -n "__fish_msb_needs_command" -f -a "volume" -d 'Manage named volumes'
complete -c msb -n "__fish_msb_needs_command" -f -a "vol" -d 'Manage named volumes'
complete -c msb -n "__fish_msb_needs_command" -f -a "snapshot" -d 'Manage disk snapshots'
complete -c msb -n "__fish_msb_needs_command" -f -a "snap" -d 'Manage disk snapshots'
complete -c msb -n "__fish_msb_needs_command" -f -a "install" -d 'Install a sandbox as a system command'
complete -c msb -n "__fish_msb_needs_command" -f -a "uninstall" -d 'Remove an installed sandbox command'
complete -c msb -n "__fish_msb_needs_command" -f -a "doctor" -d 'Check local runtime and host virtualization prerequisites'
complete -c msb -n "__fish_msb_needs_command" -f -a "update" -d 'Update msb and libkrunfw to the latest release (alias for `self update`)'
complete -c msb -n "__fish_msb_needs_command" -f -a "upgrade" -d 'Update msb and libkrunfw to the latest release (alias for `self update`)'
complete -c msb -n "__fish_msb_needs_command" -f -a "downgrade" -d 'Downgrade msb and local state to an older supported release (alias for `self downgrade`)'
complete -c msb -n "__fish_msb_needs_command" -f -a "self" -d 'Manage the msb installation'
complete -c msb -n "__fish_msb_needs_command" -f -a "completion" -d 'Generate a shell completion script'
complete -c msb -n "__fish_msb_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand machine" -l agent-transport -d 'Override automatic internal host/guest agent transport selection' -r
complete -c msb -n "__fish_msb_using_subcommand machine" -s n -l name -d 'Name of the sandbox' -r
complete -c msb -n "__fish_msb_using_subcommand machine" -l sandbox-id -d 'Database ID of the sandbox' -r
complete -c msb -n "__fish_msb_using_subcommand machine" -l log-level -d 'Log verbosity for the sandbox runtime (error, warn, info, debug, trace)' -r
complete -c msb -n "__fish_msb_using_subcommand machine" -l parent-watch-fd -d 'Read end of the attached-parent watchdog pipe' -r
complete -c msb -n "__fish_msb_using_subcommand machine" -l startup-fd -d 'Write end of the startup JSON pipe' -r
complete -c msb -n "__fish_msb_using_subcommand machine" -l lifecycle-lock-fd -d 'Inherited descriptor owning this sandbox\'s lifecycle lock' -r
complete -c msb -n "__fish_msb_using_subcommand machine" -l vcpus -d 'Number of virtual CPUs' -r
complete -c msb -n "__fish_msb_using_subcommand machine" -l memory-mib -d 'Memory in MiB' -r
complete -c msb -n "__fish_msb_using_subcommand machine" -l max-vcpus -d 'Maximum possible virtual CPUs (defaults to `--vcpus`)' -r
complete -c msb -n "__fish_msb_using_subcommand machine" -l max-memory-mib -d 'Maximum hotpluggable memory in MiB (defaults to `--memory-mib`)' -r
complete -c msb -n "__fish_msb_using_subcommand machine" -l config-fd -d 'Inherited fd carrying the JSON [`LaunchConfig`] (set by the SDK)' -r
complete -c msb -n "__fish_msb_using_subcommand machine" -l config-file -d 'Path to a JSON [`LaunchConfig`] file (manual invocation / debugging)' -r -F
complete -c msb -n "__fish_msb_using_subcommand machine" -l restore -d 'Require captured execution; runtimes without this protocol reject the invocation'
complete -c msb -n "__fish_msb_using_subcommand machine" -l forward -d 'Forward VM console output to stdout'
complete -c msb -n "__fish_msb_using_subcommand machine" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand machine" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand machine" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand machine" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand machine" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand machine" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand machine" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand __launch-protocol" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand __launch-protocol" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand __launch-protocol" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand __launch-protocol" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand __launch-protocol" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand __launch-protocol" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand __launch-protocol" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "run" -d 'Create a sandbox from an image and run a command in it'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "create" -d 'Create a sandbox and boot it in the background'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "restore" -d 'Restore a snapshot into a new detached sandbox'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "modify" -d 'Modify sandbox configuration'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "mod" -d 'Modify sandbox configuration'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "start" -d 'Start a stopped sandbox'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "stop" -d 'Stop one or more running sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "pause" -d 'Suspend a resident sandbox without creating a snapshot'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "branch" -d 'Branch running execution into a new local CoW child without a durable full snapshot'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "resume" -d 'Resume a user-paused resident sandbox'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "restart" -d 'Restart one or more sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "ping" -d 'Check whether one or more sandbox agents are reachable'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "touch" -d 'Refresh idle activity for one or more running sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "list" -d 'List all sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "ls" -d 'List all sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "status" -d 'Show sandbox status'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "ps" -d 'Show sandbox status'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "metrics" -d 'Show live metrics for a running sandbox'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "remove" -d 'Remove one or more sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "rm" -d 'Remove one or more sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "exec" -d 'Run a command in a running sandbox'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "copy" -d 'Copy files between the host and a sandbox'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "cp" -d 'Copy files between the host and a sandbox'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "logs" -d 'Show captured output from a sandbox'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "inspect" -d 'Show detailed sandbox configuration and status'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l timeout -d 'Kill the command after this duration (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l rlimit -d 'Set a POSIX resource limit (e.g. nofile=1024, nproc=64, as=1073741824)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l detach-keys -d 'Key sequence to detach from interactive session (default: ctrl-])' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l conf -d 'Load a sparse single-sandbox configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l net-conf -d 'Load an unwrapped network configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l resource-conf -d 'Load an unwrapped resource and lifecycle configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l runtime-conf -d 'Load an unwrapped runtime configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l fs-conf -d 'Load an unwrapped filesystem configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l secret-conf -d 'Load an unwrapped secret-name map' -r -F
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l script-conf -d 'Load an unwrapped script-name map' -r -F
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -s n -l name -d 'Name for the sandbox. Auto-generated if omitted. Maximum 128 UTF-8 bytes' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -s c -l cpus -d 'Number of virtual CPUs to allocate' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l max-cpus -d 'Boot-time maximum possible virtual CPUs' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l cpu-placement -d 'Host CPU placement policy (inherit, auto, spread, compact)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l placement-profile -d 'Host-defined placement profile name' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -s m -l memory -d 'Amount of memory to allocate (e.g. 512M, 1G)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l max-memory -d 'Boot-time maximum hotpluggable memory (e.g. 1G, 8G)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l thp -d 'Guest transparent huge-page policy selected at boot' -r -f -a "always\t''
madvise\t''
never\t''"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -s v -l volume -d 'Mount a host path or named volume into the sandbox (`SOURCE:DEST[:OPTIONS]`). OPTIONS may include paired `uid=<N>,gid=<N>` for directory-backed mounts' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l mount-dir -d 'Explicitly mount a host directory into the sandbox (`SOURCE:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l mount-file -d 'Explicitly mount a host file into the sandbox (`SOURCE:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l mount-disk -d 'Explicitly mount a disk image into the sandbox (`SOURCE:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l mount-named -d 'Explicitly mount a named volume into the sandbox (`NAME:DEST[:OPTIONS]`). OPTIONS may include paired `uid=<N>,gid=<N>` when the volume is a directory' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l mount-owned -d 'Create a private volume removed with this sandbox (`DEST[:OPTIONS]`). Defaults to a directory; use `kind=disk,size=10G` for an ext4 disk' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -s w -l workdir -d 'Set the default working directory for commands' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l shell -d 'Shell to use for interactive sessions (default: /bin/sh)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -s e -l env -d 'Set an environment variable (KEY=value)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l label -d 'Attach a label to the sandbox for metrics attribution (`KEY=VALUE`, or bare `KEY` for a valueless marker). Repeatable. Surfaced as attributes on the sandbox\'s metrics' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l replace-with-timeout -d 'Timeout the existing sandbox gets after SIGTERM before it is SIGKILLed during a replace. Accepts `0`, `500ms`, `5s`, `2m`. Implies `--replace`. Default 10s when `--replace` is set on its own. An expired timeout force-kills the prior sandbox; the `create` call still proceeds' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l tmpfs -d 'Mount a temporary in-memory filesystem (PATH, PATH:SIZE, or PATH:SIZE:OPTIONS)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l security -d 'In-guest security profile (default or restricted)' -r -f -a "default\t''
restricted\t''"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l deployment-profile -d 'Host-runtime deployment profile (single-tenant or multi-tenant). Managed backends may enforce their own profile' -r -f -a "single-tenant\t''
multi-tenant\t''"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l script -d 'Register a shell snippet as a named script (NAME=BODY). The body supports `\\n`, `\\t`, `\\r`, `\\\\`, `\\"`, `\\\'` escapes; unknown escapes are preserved verbatim. The snippet is wrapped with a shebang derived from `--shell` (default `/bin/sh`) and made executable at `/.msb/scripts/<name>`; the directory is on `PATH`' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l script-raw -d 'Register exact inline script contents (NAME=BODY). No escape decoding or shebang is added, so the caller must include a `#!` line if the script should be directly executable' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l script-path -d 'Register a script from a host file (NAME:PATH). Same destination as `--script`; the file\'s contents are read verbatim at launch time' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l copy -d 'Copy a host file or directory into the guest rootfs before boot (SRC:DST)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l copy-file -d 'Copy a host file into the guest rootfs before boot (SRC:DST)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l copy-dir -d 'Copy a host directory into the guest rootfs before boot (SRC:DST)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l mkdir -d 'Create a directory in the guest rootfs before boot' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l rm -d 'Hide/remove a path from the guest rootfs before boot' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l entrypoint -d 'Override the image\'s default entrypoint command' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l init -d 'Hand off PID 1 to this init binary inside the guest after agentd finishes setup. Use `auto` to honor a known init at the start of the image ENTRYPOINT (for example /init in s6-overlay images), preserving attached init-entrypoint commands when needed, or to probe common distro init paths when the image does not declare one' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l init-arg -d 'Append an argv entry to the handoff init. Repeatable. Defaults to `[<--init>]` when empty' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l init-env -d 'Set an env var for the handoff init (KEY=VALUE). Repeatable. Merged on top of the inherited env' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -s H -l hostname -d 'Set the guest hostname (defaults to a sandbox-name-derived hostname)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -s u -l user -d 'Run commands as the specified user (e.g. nobody, 1000, 1000:1000)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l pull -d 'When to pull the image: always, if-missing (default), never' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l root-disk -d 'Root disk for OCI images (e.g. 8G, tmpfs:2G, flat:8G, ./scratch.img, ./scratch.qcow2:format=qcow2,fstype=ext4)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l oci-upper-size -d 'Deprecated alias for `--root-disk <SIZE>`' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l log-level -d 'Log verbosity for the sandbox runtime (error, warn, info, debug, trace)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l max-duration -d 'Kill the sandbox after this duration (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l idle-timeout -d 'Stop the sandbox after this period of inactivity (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l vsock -d 'Expose a host local-IPC endpoint on a guest-to-host vsock port' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -s p -l port -d 'Forward a host port to the sandbox (HOST:GUEST, BIND_ADDR:HOST:GUEST, and /udp variants)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l net -d 'High-level network profile. Repeatable and comma-separated. Profiles (`public`, `private`, `host`) compose and automatically enable gateway DNS. `all` and `none` are terminal policies and cannot be combined with profiles. Explicit `--net-rule` entries take precedence' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l dns-nameserver -d 'Nameserver to forward DNS queries to (repeatable). Overrides the nameservers in the host\'s `/etc/resolv.conf`. Accepts `IP` (port defaults to 53) or `IP:PORT`' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l dns-query-timeout-ms -d 'Per-DNS-query timeout in milliseconds. Default: 5000' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l net-ipv4-pool -d 'IPv4 pool used for per-sandbox /30 guest subnets. Default: 172.16.0.0/12' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l net-ipv6-pool -d 'IPv6 pool used for per-sandbox /64 guest prefixes. Default: fd42:6d73:62::/48' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l net-rule -d 'Network rule. Repeatable; each value is a comma-separated list of rule tokens. Token grammar: `<action>[:<direction>]@<target>[:<proto>[:<ports>]]`' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l net-default -d 'Default action for traffic in both directions that doesn\'t match any `--net-rule`. Sets egress and ingress symmetrically; use `--net-default-egress` / `--net-default-ingress` to set them independently' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l net-default-egress -d 'Default action for egress traffic that doesn\'t match any `--net-rule`. Default: deny (with an implicit allow@public rule when no other rules are present)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l net-default-ingress -d 'Default action for ingress traffic that doesn\'t match any `--net-rule`. Default: allow (preserves today\'s unfiltered published-port behavior when no ingress rules are set)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l net-egress-bandwidth -d 'Limit outbound (egress) bandwidth, e.g. 1M/1s. SIZE accepts raw bytes plus K, M, and G suffixes; the interval defaults to one second when omitted. Applies on the next sandbox start' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l net-egress-bandwidth-burst -d 'One-time startup burst for the egress bandwidth limit, e.g. 512K. Requires --net-egress-bandwidth' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l net-egress-ops -d 'Limit outbound (egress) packet rate, e.g. 1000/1s. The interval defaults to one second when omitted' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l net-egress-ops-burst -d 'One-time startup burst for the egress packet-rate limit. Requires --net-egress-ops' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l net-ingress-bandwidth -d 'Limit inbound (ingress) bandwidth, e.g. 1M/1s. Same syntax as --net-egress-bandwidth' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l net-ingress-bandwidth-burst -d 'One-time startup burst for the ingress bandwidth limit. Requires --net-ingress-bandwidth' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l net-ingress-ops -d 'Limit inbound (ingress) packet rate, e.g. 1000/1s' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l net-ingress-ops-burst -d 'One-time startup burst for the ingress packet-rate limit. Requires --net-ingress-ops' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l max-connections -d 'Deprecated alias for --max-tcp-connections' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l max-tcp-connections -d 'Limit TCP connections; zero means unlimited' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l max-udp-connections -d 'Limit UDP relay sessions (default: unlimited single-tenant, 1024 multi-tenant; zero means unlimited)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l proxy -d 'Dial all outbound sandbox connections through this proxy. Supports the socks4:// and socks5:// protocols' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l socks4-user-id -d 'Optional user ID for a SOCKS4 proxy' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l socks5-username -d 'Username for SOCKS5 username/password authentication' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l socks5-password-env -d 'Host environment variable containing the SOCKS5 password' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l tls-intercept-port -d 'TCP port to apply TLS interception on (default: 443)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l tls-bypass -d 'Skip TLS interception for this domain (e.g. *.internal.com)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l tls-intercept-ca-cert -d 'Use a custom CA certificate for TLS interception (PEM file)' -r -F
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l tls-intercept-ca-key -d 'Use a custom CA private key for TLS interception (PEM file)' -r -F
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l tls-upstream-ca-cert -d 'Trust an additional CA certificate for upstream server verification (PEM file). Can be specified multiple times' -r -F
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l tls-upstream-ca-cert-for -d 'Trust an additional CA certificate only for matching upstream hosts (PATTERN=PATH). Can be specified multiple times' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l tls-no-verify-upstream-for -d 'Disable upstream certificate verification for matching upstream hosts. Can be specified multiple times' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l secret -d 'Configure a protected secret (`ENV[:OPTIONS]@HOST[,HOST...]`). The value is read from the host environment variable ENV at start time and stored only as a source reference, never inlined in the sandbox config. Inline `ENV=VALUE@HOST` is rejected; export the value and use `ENV[:OPTIONS]@HOST[,HOST...]`' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l secret-violation-action -d 'Action when a secret placeholder is blocked (block, block-and-log, block-and-terminate)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -s d -l detach -d 'Run the resolved image command in the background and print the sandbox name'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -s t -l tty -d 'Allocate a pseudo-terminal (enables colors, line editing)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l no-tty -d 'Disable pseudo-terminal allocation and run non-interactively'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l replace -d 'Replace an existing sandbox with the same name'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l no-net -d 'Disable all network access by default. Sugar for `--net-default deny`. Combine with `--net-rule allow@<target>` entries to build an allowlist; without rules, the guest has no network reachability'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l no-dns-rebind-protection -d 'Allow DNS responses pointing to private/internal IP addresses'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l net-strict -d 'Require hostname-based network allows to use inspectable request authority'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l trust-host-cas -d 'Ship the host\'s trusted root CAs into the guest. Opt in to make outbound TLS work behind corporate MITM proxies (Warp Zero Trust, Zscaler, etc.) whose gateway CA is installed on the host but unknown to the guest\'s stock Mozilla bundle'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l tls-intercept -d 'Intercept and inspect HTTPS traffic via a built-in TLS proxy'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l no-block-quic -d 'Allow QUIC/HTTP3 traffic (blocked by default when TLS interception is on)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from run" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l conf -d 'Load a sparse single-sandbox configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l net-conf -d 'Load an unwrapped network configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l resource-conf -d 'Load an unwrapped resource and lifecycle configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l runtime-conf -d 'Load an unwrapped runtime configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l fs-conf -d 'Load an unwrapped filesystem configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l secret-conf -d 'Load an unwrapped secret-name map' -r -F
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l script-conf -d 'Load an unwrapped script-name map' -r -F
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -s n -l name -d 'Name for the sandbox. Auto-generated if omitted. Maximum 128 UTF-8 bytes' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -s c -l cpus -d 'Number of virtual CPUs to allocate' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l max-cpus -d 'Boot-time maximum possible virtual CPUs' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l cpu-placement -d 'Host CPU placement policy (inherit, auto, spread, compact)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l placement-profile -d 'Host-defined placement profile name' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -s m -l memory -d 'Amount of memory to allocate (e.g. 512M, 1G)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l max-memory -d 'Boot-time maximum hotpluggable memory (e.g. 1G, 8G)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l thp -d 'Guest transparent huge-page policy selected at boot' -r -f -a "always\t''
madvise\t''
never\t''"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -s v -l volume -d 'Mount a host path or named volume into the sandbox (`SOURCE:DEST[:OPTIONS]`). OPTIONS may include paired `uid=<N>,gid=<N>` for directory-backed mounts' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l mount-dir -d 'Explicitly mount a host directory into the sandbox (`SOURCE:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l mount-file -d 'Explicitly mount a host file into the sandbox (`SOURCE:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l mount-disk -d 'Explicitly mount a disk image into the sandbox (`SOURCE:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l mount-named -d 'Explicitly mount a named volume into the sandbox (`NAME:DEST[:OPTIONS]`). OPTIONS may include paired `uid=<N>,gid=<N>` when the volume is a directory' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l mount-owned -d 'Create a private volume removed with this sandbox (`DEST[:OPTIONS]`). Defaults to a directory; use `kind=disk,size=10G` for an ext4 disk' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -s w -l workdir -d 'Set the default working directory for commands' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l shell -d 'Shell to use for interactive sessions (default: /bin/sh)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -s e -l env -d 'Set an environment variable (KEY=value)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l label -d 'Attach a label to the sandbox for metrics attribution (`KEY=VALUE`, or bare `KEY` for a valueless marker). Repeatable. Surfaced as attributes on the sandbox\'s metrics' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l replace-with-timeout -d 'Timeout the existing sandbox gets after SIGTERM before it is SIGKILLed during a replace. Accepts `0`, `500ms`, `5s`, `2m`. Implies `--replace`. Default 10s when `--replace` is set on its own. An expired timeout force-kills the prior sandbox; the `create` call still proceeds' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l tmpfs -d 'Mount a temporary in-memory filesystem (PATH, PATH:SIZE, or PATH:SIZE:OPTIONS)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l security -d 'In-guest security profile (default or restricted)' -r -f -a "default\t''
restricted\t''"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l deployment-profile -d 'Host-runtime deployment profile (single-tenant or multi-tenant). Managed backends may enforce their own profile' -r -f -a "single-tenant\t''
multi-tenant\t''"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l script -d 'Register a shell snippet as a named script (NAME=BODY). The body supports `\\n`, `\\t`, `\\r`, `\\\\`, `\\"`, `\\\'` escapes; unknown escapes are preserved verbatim. The snippet is wrapped with a shebang derived from `--shell` (default `/bin/sh`) and made executable at `/.msb/scripts/<name>`; the directory is on `PATH`' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l script-raw -d 'Register exact inline script contents (NAME=BODY). No escape decoding or shebang is added, so the caller must include a `#!` line if the script should be directly executable' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l script-path -d 'Register a script from a host file (NAME:PATH). Same destination as `--script`; the file\'s contents are read verbatim at launch time' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l copy -d 'Copy a host file or directory into the guest rootfs before boot (SRC:DST)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l copy-file -d 'Copy a host file into the guest rootfs before boot (SRC:DST)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l copy-dir -d 'Copy a host directory into the guest rootfs before boot (SRC:DST)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l mkdir -d 'Create a directory in the guest rootfs before boot' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l rm -d 'Hide/remove a path from the guest rootfs before boot' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l entrypoint -d 'Override the image\'s default entrypoint command' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l init -d 'Hand off PID 1 to this init binary inside the guest after agentd finishes setup. Use `auto` to honor a known init at the start of the image ENTRYPOINT (for example /init in s6-overlay images), preserving attached init-entrypoint commands when needed, or to probe common distro init paths when the image does not declare one' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l init-arg -d 'Append an argv entry to the handoff init. Repeatable. Defaults to `[<--init>]` when empty' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l init-env -d 'Set an env var for the handoff init (KEY=VALUE). Repeatable. Merged on top of the inherited env' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -s H -l hostname -d 'Set the guest hostname (defaults to a sandbox-name-derived hostname)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -s u -l user -d 'Run commands as the specified user (e.g. nobody, 1000, 1000:1000)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l pull -d 'When to pull the image: always, if-missing (default), never' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l root-disk -d 'Root disk for OCI images (e.g. 8G, tmpfs:2G, flat:8G, ./scratch.img, ./scratch.qcow2:format=qcow2,fstype=ext4)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l oci-upper-size -d 'Deprecated alias for `--root-disk <SIZE>`' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l log-level -d 'Log verbosity for the sandbox runtime (error, warn, info, debug, trace)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l max-duration -d 'Kill the sandbox after this duration (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l idle-timeout -d 'Stop the sandbox after this period of inactivity (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l vsock -d 'Expose a host local-IPC endpoint on a guest-to-host vsock port' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -s p -l port -d 'Forward a host port to the sandbox (HOST:GUEST, BIND_ADDR:HOST:GUEST, and /udp variants)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l net -d 'High-level network profile. Repeatable and comma-separated. Profiles (`public`, `private`, `host`) compose and automatically enable gateway DNS. `all` and `none` are terminal policies and cannot be combined with profiles. Explicit `--net-rule` entries take precedence' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l dns-nameserver -d 'Nameserver to forward DNS queries to (repeatable). Overrides the nameservers in the host\'s `/etc/resolv.conf`. Accepts `IP` (port defaults to 53) or `IP:PORT`' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l dns-query-timeout-ms -d 'Per-DNS-query timeout in milliseconds. Default: 5000' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l net-ipv4-pool -d 'IPv4 pool used for per-sandbox /30 guest subnets. Default: 172.16.0.0/12' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l net-ipv6-pool -d 'IPv6 pool used for per-sandbox /64 guest prefixes. Default: fd42:6d73:62::/48' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l net-rule -d 'Network rule. Repeatable; each value is a comma-separated list of rule tokens. Token grammar: `<action>[:<direction>]@<target>[:<proto>[:<ports>]]`' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l net-default -d 'Default action for traffic in both directions that doesn\'t match any `--net-rule`. Sets egress and ingress symmetrically; use `--net-default-egress` / `--net-default-ingress` to set them independently' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l net-default-egress -d 'Default action for egress traffic that doesn\'t match any `--net-rule`. Default: deny (with an implicit allow@public rule when no other rules are present)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l net-default-ingress -d 'Default action for ingress traffic that doesn\'t match any `--net-rule`. Default: allow (preserves today\'s unfiltered published-port behavior when no ingress rules are set)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l net-egress-bandwidth -d 'Limit outbound (egress) bandwidth, e.g. 1M/1s. SIZE accepts raw bytes plus K, M, and G suffixes; the interval defaults to one second when omitted. Applies on the next sandbox start' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l net-egress-bandwidth-burst -d 'One-time startup burst for the egress bandwidth limit, e.g. 512K. Requires --net-egress-bandwidth' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l net-egress-ops -d 'Limit outbound (egress) packet rate, e.g. 1000/1s. The interval defaults to one second when omitted' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l net-egress-ops-burst -d 'One-time startup burst for the egress packet-rate limit. Requires --net-egress-ops' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l net-ingress-bandwidth -d 'Limit inbound (ingress) bandwidth, e.g. 1M/1s. Same syntax as --net-egress-bandwidth' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l net-ingress-bandwidth-burst -d 'One-time startup burst for the ingress bandwidth limit. Requires --net-ingress-bandwidth' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l net-ingress-ops -d 'Limit inbound (ingress) packet rate, e.g. 1000/1s' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l net-ingress-ops-burst -d 'One-time startup burst for the ingress packet-rate limit. Requires --net-ingress-ops' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l max-connections -d 'Deprecated alias for --max-tcp-connections' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l max-tcp-connections -d 'Limit TCP connections; zero means unlimited' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l max-udp-connections -d 'Limit UDP relay sessions (default: unlimited single-tenant, 1024 multi-tenant; zero means unlimited)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l proxy -d 'Dial all outbound sandbox connections through this proxy. Supports the socks4:// and socks5:// protocols' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l socks4-user-id -d 'Optional user ID for a SOCKS4 proxy' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l socks5-username -d 'Username for SOCKS5 username/password authentication' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l socks5-password-env -d 'Host environment variable containing the SOCKS5 password' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l tls-intercept-port -d 'TCP port to apply TLS interception on (default: 443)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l tls-bypass -d 'Skip TLS interception for this domain (e.g. *.internal.com)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l tls-intercept-ca-cert -d 'Use a custom CA certificate for TLS interception (PEM file)' -r -F
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l tls-intercept-ca-key -d 'Use a custom CA private key for TLS interception (PEM file)' -r -F
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l tls-upstream-ca-cert -d 'Trust an additional CA certificate for upstream server verification (PEM file). Can be specified multiple times' -r -F
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l tls-upstream-ca-cert-for -d 'Trust an additional CA certificate only for matching upstream hosts (PATTERN=PATH). Can be specified multiple times' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l tls-no-verify-upstream-for -d 'Disable upstream certificate verification for matching upstream hosts. Can be specified multiple times' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l secret -d 'Configure a protected secret (`ENV[:OPTIONS]@HOST[,HOST...]`). The value is read from the host environment variable ENV at start time and stored only as a source reference, never inlined in the sandbox config. Inline `ENV=VALUE@HOST` is rejected; export the value and use `ENV[:OPTIONS]@HOST[,HOST...]`' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l secret-violation-action -d 'Action when a secret placeholder is blocked (block, block-and-log, block-and-terminate)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l replace -d 'Replace an existing sandbox with the same name'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l no-net -d 'Disable all network access by default. Sugar for `--net-default deny`. Combine with `--net-rule allow@<target>` entries to build an allowlist; without rules, the guest has no network reachability'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l no-dns-rebind-protection -d 'Allow DNS responses pointing to private/internal IP addresses'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l net-strict -d 'Require hostname-based network allows to use inspectable request authority'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l trust-host-cas -d 'Ship the host\'s trusted root CAs into the guest. Opt in to make outbound TLS work behind corporate MITM proxies (Warp Zero Trust, Zscaler, etc.) whose gateway CA is installed on the host but unknown to the guest\'s stock Mozilla bundle'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l tls-intercept -d 'Intercept and inspect HTTPS traffic via a built-in TLS proxy'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l no-block-quic -d 'Allow QUIC/HTTP3 traffic (blocked by default when TLS interception is on)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -s n -l name -d 'Unique name of the destination sandbox' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l snapshot-base -d 'Exact base snapshot or archive for a dependent export' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l vsock -d 'Bind a host socket/named pipe to a guest-to-host vsock port: PATH:PORT[/stream|/dgram]' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -s v -l volume -d 'Map `SOURCE:GUEST[:OPTIONS]`, or select a captured private disk with GUEST alone' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -s p -l port -d 'Publish a child listener: `[BIND:]HOST:GUEST[/tcp|udp]`' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -s u -l user -d 'Default user for new exec commands; captured processes keep their credentials' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l external-mount-policy -d 'Validate explicitly mapped filesystems strictly or allow supported stale resources' -r -f -a "strict\t''
relaxed\t''"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -s c -l cpus -d 'Guest CPU count for disk boot; full restore requires the captured count' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -s m -l memory -d 'Guest memory for disk boot; full restore requires the captured size' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l security -d 'Guest security profile for disk boot; rejected for full execution restore' -r -f -a "default\t''
restricted\t''"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l max-duration -d 'Maximum lifetime of the destination sandbox (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l idle-timeout -d 'Stop after this much inactivity in the destination sandbox' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l net-default -d 'Default action for both traffic directions in the destination host policy' -r -f -a "allow\t''
deny\t''"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l net-rule -d 'Destination host policy rules, using the same syntax as create/run (repeatable). Requires --net-default or --no-net so the complete replacement policy is explicit' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l max-connections -d 'Deprecated alias for --max-tcp-connections' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l max-tcp-connections -d 'Concurrent TCP limit; zero explicitly selects unlimited' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l max-udp-connections -d 'Concurrent UDP session limit; zero explicitly selects unlimited' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l forked -d 'Restore captured RAM using private copy-on-write mappings'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l disk-only -d 'Cold-boot only the captured disk, without restoring processes or RAM'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l allow-missing-resources -d 'Allow missing full-restore resources with warnings instead of refusing activation'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l dangerously-inherit-resources -d 'Fill unspecified bindings from validated source-local records; may share host resources'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l no-net -d 'Deny traffic by default; combine with --net-rule to allow selected destinations'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -s q -l quiet -d 'Suppress progress output, but not unavailable-resource warnings'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restore" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l layers -d 'Merge up to N oldest sealed physical layers per disk, including the base (minimum 2)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l disk -d 'Compact only this owned disk\'s guest mount path (`/` selects the root)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -s c -l cpus -d 'Desired effective vCPU count' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l max-cpus -d 'Desired boot-time maximum possible vCPU count' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -s m -l memory -d 'Desired effective guest memory size, such as `512M` or `4G`' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l max-memory -d 'Desired boot-time maximum hotpluggable memory, such as `4G` or `16G`' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l root-disk -d 'Desired root disk size, such as `8G` (managed: grow-only; tmpfs: any direction, next boot)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l oci-upper-size -d 'Deprecated alias for `--root-disk <SIZE>`' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -s e -l env -d 'Set an environment variable for future execs (`KEY=VALUE`)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l env-rm -d 'Remove an environment variable by key' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l label -d 'Set a label (`KEY=VALUE`)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l label-rm -d 'Remove a label by key' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -s w -l workdir -d 'Working directory for future execs' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l secret -d 'Add or rotate a secret from a host environment variable (`NAME@HOST[,HOST...]`)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l secret-rm -d 'Remove a secret by name' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l format -d 'Output format' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l compact -d 'Compact sealed layers of the root and sandbox-owned data disks without changing snapshots'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l root-disk-only -d 'Compact only the root disk'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l dry-run -d 'Show the plan without applying anything'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l next-start -d 'Save changes for the next start without mutating a running VM'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l restart -d 'Restart if needed so restart-required changes become active now'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from modify" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l layers -d 'Merge up to N oldest sealed physical layers per disk, including the base (minimum 2)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l disk -d 'Compact only this owned disk\'s guest mount path (`/` selects the root)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -s c -l cpus -d 'Desired effective vCPU count' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l max-cpus -d 'Desired boot-time maximum possible vCPU count' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -s m -l memory -d 'Desired effective guest memory size, such as `512M` or `4G`' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l max-memory -d 'Desired boot-time maximum hotpluggable memory, such as `4G` or `16G`' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l root-disk -d 'Desired root disk size, such as `8G` (managed: grow-only; tmpfs: any direction, next boot)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l oci-upper-size -d 'Deprecated alias for `--root-disk <SIZE>`' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -s e -l env -d 'Set an environment variable for future execs (`KEY=VALUE`)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l env-rm -d 'Remove an environment variable by key' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l label -d 'Set a label (`KEY=VALUE`)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l label-rm -d 'Remove a label by key' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -s w -l workdir -d 'Working directory for future execs' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l secret -d 'Add or rotate a secret from a host environment variable (`NAME@HOST[,HOST...]`)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l secret-rm -d 'Remove a secret by name' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l format -d 'Output format' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l compact -d 'Compact sealed layers of the root and sandbox-owned data disks without changing snapshots'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l root-disk-only -d 'Compact only the root disk'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l dry-run -d 'Show the plan without applying anything'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l next-start -d 'Save changes for the next start without mutating a running VM'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l restart -d 'Restart if needed so restart-required changes become active now'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from mod" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from start" -l label -d 'Start every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from start" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from start" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from start" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from start" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from start" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from start" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from start" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from start" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from stop" -l label -d 'Stop every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from stop" -s t -l timeout -d 'Graceful completion budget in seconds; timeout fails without killing. Omit to wait indefinitely' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from stop" -s f -l force -d 'Immediately kill the sandbox without graceful shutdown. Pending writes that the workload hasn\'t `fsync`\'d may be lost'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from stop" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from stop" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from stop" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from stop" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from stop" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from stop" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from stop" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from stop" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from pause" -l guest-flush -d 'Optional guest writeback: auto, required, or skip. Required establishes a flushed pause' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from pause" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from pause" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from pause" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from pause" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from pause" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from pause" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from pause" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from pause" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from branch" -l guest-flush -d 'Optional guest writeback: auto, required, or skip. Auto preserves dirty RAM' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from branch" -s n -l name -d 'Name of the new child sandbox' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from branch" -l names -d 'Capture once for these independent children, in input order' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from branch" -l vsock -d 'Bind a host socket/named pipe to a guest-to-host vsock port: PATH:PORT[/stream|/dgram]' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from branch" -s v -l volume -d 'Map `SOURCE:GUEST[:OPTIONS]`, or select a captured private disk with GUEST alone' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from branch" -s p -l port -d 'Publish a child listener: `[BIND:]HOST:GUEST[/tcp|udp]`' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from branch" -s u -l user -d 'Default user for new exec commands; captured processes keep their credentials' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from branch" -l external-mount-policy -d 'Validate explicitly mapped filesystems strictly or allow supported stale resources' -r -f -a "strict\t''
relaxed\t''"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from branch" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from branch" -l integrity -d 'Compute and record disk content integrity for the captured layers'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from branch" -l dangerously-inherit-resources -d 'Fill unspecified bindings from validated source-local records; may share host resources'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from branch" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from branch" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from branch" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from branch" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from branch" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from branch" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from branch" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from resume" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from resume" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from resume" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from resume" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from resume" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from resume" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from resume" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from resume" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restart" -l label -d 'Restart every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restart" -s t -l timeout -d 'Total graceful-completion budget in seconds; expiry fails without killing' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restart" -s f -l force -d 'Immediately kill the sandbox without graceful shutdown. Pending writes that the workload hasn\'t `fsync`\'d may be lost'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restart" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restart" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restart" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restart" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restart" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restart" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restart" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from restart" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ping" -l label -d 'Ping every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ping" -l touch -d 'Refresh the sandbox idle timer after a successful ping'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ping" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ping" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ping" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ping" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ping" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ping" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ping" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ping" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from touch" -l label -d 'Touch every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from touch" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from touch" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from touch" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from touch" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from touch" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from touch" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from touch" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from touch" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from list" -l label -d 'Show only sandboxes carrying this label (`KEY=VALUE`). Repeatable; AND-matched' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from list" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from list" -l running -d 'Show only running sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from list" -l stopped -d 'Show only stopped sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Show only sandbox names'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from list" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from list" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from list" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from list" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from list" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from list" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ls" -l label -d 'Show only sandboxes carrying this label (`KEY=VALUE`). Repeatable; AND-matched' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ls" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ls" -l running -d 'Show only running sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ls" -l stopped -d 'Show only stopped sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Show only sandbox names'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ls" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ls" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ls" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ls" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ls" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ls" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from status" -l label -d 'Show only sandboxes carrying this label (`KEY=VALUE`). Repeatable; AND-matched' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from status" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from status" -s a -l all -d 'Show all sandboxes, not just running ones'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from status" -s q -l quiet -d 'Show only sandbox names'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from status" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from status" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from status" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from status" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from status" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from status" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from status" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ps" -l label -d 'Show only sandboxes carrying this label (`KEY=VALUE`). Repeatable; AND-matched' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ps" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ps" -s a -l all -d 'Show all sandboxes, not just running ones'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ps" -s q -l quiet -d 'Show only sandbox names'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ps" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ps" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ps" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ps" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ps" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ps" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from ps" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from metrics" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from metrics" -l interval -d 'Refresh interval for --watch/--follow (e.g. 500ms, 2s)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from metrics" -l sort -d 'Sort rows by column' -r -f -a "name\t''
cpu\t''
mem\t''"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from metrics" -s w -l watch -d 'Continuously refresh the table in place. Ctrl-C to quit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from metrics" -s f -l follow -d 'Stream one JSON Lines object per sandbox per interval to stdout'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from metrics" -s a -l all -d 'Include exited sandboxes whose terminal metrics are still recorded'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from metrics" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from metrics" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from metrics" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from metrics" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from metrics" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from metrics" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from metrics" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from remove" -l label -d 'Remove every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from remove" -s f -l force -d 'Stop the sandbox if running, then remove it'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from remove" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from remove" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from remove" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from remove" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from remove" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from remove" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from remove" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from remove" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from rm" -l label -d 'Remove every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from rm" -s f -l force -d 'Stop the sandbox if running, then remove it'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from rm" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from rm" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from rm" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from rm" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from rm" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from rm" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from rm" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from rm" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from exec" -s e -l env -d 'Set an environment variable (KEY=value)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from exec" -s w -l workdir -d 'Set the working directory for the command' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from exec" -s u -l user -d 'Run the command as the specified guest user' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from exec" -l timeout -d 'Kill the command after this duration (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from exec" -l rlimit -d 'Set a POSIX resource limit (e.g. nofile=1024, nproc=64, as=1073741824)' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from exec" -s t -l tty -d 'Allocate a pseudo-terminal (enables colors, line editing)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from exec" -l no-tty -d 'Disable pseudo-terminal allocation and run non-interactively'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from exec" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from exec" -l stream -d 'Stream stdin/stdout bidirectionally without a PTY (no echo/CRLF translation — safe for JSON lines)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from exec" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from exec" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from exec" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from exec" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from exec" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from exec" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from exec" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from copy" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from copy" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from copy" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from copy" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from copy" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from copy" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from copy" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from copy" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from cp" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from cp" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from cp" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from cp" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from cp" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from cp" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from cp" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from cp" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from logs" -l tail -d 'Show only the last N entries' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from logs" -l since -d 'Show only entries at or after this point. Accepts an RFC 3339 timestamp or a relative duration like `5m`, `2h`, `1d`' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from logs" -l until -d 'Show only entries strictly before this point. Same accepted formats as `--since`' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from logs" -l source -d 'Sources to include. Repeat or comma-separate to include multiple. Defaults to `stdout,stderr` (the captured user-program output)' -r -f -a "stdout\t'Captured stdout from the primary exec session (pipe mode)'
stderr\t'Captured stderr from the primary exec session (pipe mode)'
output\t'Merged stdout+stderr from the primary session running in pty mode (pty allocation merges streams in the kernel before they leave the guest)'
system\t'Synthetic system entries injected by the host writer (lifecycle markers) plus runtime/kernel diagnostics merged at read time'
all\t'All sources: `stdout`, `stderr`, `output`, and `system`'"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from logs" -l grep -d 'Filter entries to those whose body matches this regex' -r
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from logs" -l color -d 'ANSI color handling' -r -f -a "auto\t'Pass ANSI through to TTYs, strip on pipes'
always\t'Always pass ANSI through'
never\t'Always strip ANSI'"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from logs" -s f -l follow -d 'Follow the log: keep reading new entries as they are written. Exits cleanly when the sandbox stops or on Ctrl-C'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from logs" -l timestamps -d 'Prefix each line with the entry\'s timestamp'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from logs" -l json -d 'Emit JSON Lines to stdout without decoding (one entry per line)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from logs" -l no-color -d 'Alias for `--color=never`'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from logs" -l show-id -d 'Prefix each line with the session id `[id:N]`. Useful when the same sandbox has many concurrent or sequential exec sessions and you want to tell them apart'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from logs" -l color-sessions -d 'Color each session\'s output a distinct color (cycles through 8 ANSI colors deterministically by session id). Implies `--show-id`. Honors `--color`/`--no-color`/`NO_COLOR`'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from logs" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from logs" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from logs" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from logs" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from logs" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from logs" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from logs" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from inspect" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from inspect" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from inspect" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from inspect" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from inspect" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from inspect" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from inspect" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from inspect" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "run" -d 'Create a sandbox from an image and run a command in it'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "create" -d 'Create a sandbox and boot it in the background'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "restore" -d 'Restore a snapshot into a new detached sandbox'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "modify" -d 'Modify sandbox configuration'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "start" -d 'Start a stopped sandbox'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "stop" -d 'Stop one or more running sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "pause" -d 'Suspend a resident sandbox without creating a snapshot'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "branch" -d 'Branch running execution into a new local CoW child without a durable full snapshot'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "resume" -d 'Resume a user-paused resident sandbox'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "restart" -d 'Restart one or more sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "ping" -d 'Check whether one or more sandbox agents are reachable'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "touch" -d 'Refresh idle activity for one or more running sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "list" -d 'List all sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "status" -d 'Show sandbox status'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "metrics" -d 'Show live metrics for a running sandbox'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "remove" -d 'Remove one or more sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "exec" -d 'Run a command in a running sandbox'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "copy" -d 'Copy files between the host and a sandbox'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "logs" -d 'Show captured output from a sandbox'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "inspect" -d 'Show detailed sandbox configuration and status'
complete -c msb -n "__fish_msb_using_subcommand sandbox; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "run" -d 'Create a sandbox from an image and run a command in it'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "create" -d 'Create a sandbox and boot it in the background'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "restore" -d 'Restore a snapshot into a new detached sandbox'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "modify" -d 'Modify sandbox configuration'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "mod" -d 'Modify sandbox configuration'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "start" -d 'Start a stopped sandbox'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "stop" -d 'Stop one or more running sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "pause" -d 'Suspend a resident sandbox without creating a snapshot'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "branch" -d 'Branch running execution into a new local CoW child without a durable full snapshot'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "resume" -d 'Resume a user-paused resident sandbox'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "restart" -d 'Restart one or more sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "ping" -d 'Check whether one or more sandbox agents are reachable'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "touch" -d 'Refresh idle activity for one or more running sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "list" -d 'List all sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "ls" -d 'List all sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "status" -d 'Show sandbox status'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "ps" -d 'Show sandbox status'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "metrics" -d 'Show live metrics for a running sandbox'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "remove" -d 'Remove one or more sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "rm" -d 'Remove one or more sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "exec" -d 'Run a command in a running sandbox'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "copy" -d 'Copy files between the host and a sandbox'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "cp" -d 'Copy files between the host and a sandbox'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "logs" -d 'Show captured output from a sandbox'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "inspect" -d 'Show detailed sandbox configuration and status'
complete -c msb -n "__fish_msb_using_subcommand sbx; and not __fish_seen_subcommand_from run create restore modify mod start stop pause branch resume restart ping touch list ls status ps metrics remove rm exec copy cp logs inspect help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l timeout -d 'Kill the command after this duration (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l rlimit -d 'Set a POSIX resource limit (e.g. nofile=1024, nproc=64, as=1073741824)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l detach-keys -d 'Key sequence to detach from interactive session (default: ctrl-])' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l conf -d 'Load a sparse single-sandbox configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l net-conf -d 'Load an unwrapped network configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l resource-conf -d 'Load an unwrapped resource and lifecycle configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l runtime-conf -d 'Load an unwrapped runtime configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l fs-conf -d 'Load an unwrapped filesystem configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l secret-conf -d 'Load an unwrapped secret-name map' -r -F
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l script-conf -d 'Load an unwrapped script-name map' -r -F
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -s n -l name -d 'Name for the sandbox. Auto-generated if omitted. Maximum 128 UTF-8 bytes' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -s c -l cpus -d 'Number of virtual CPUs to allocate' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l max-cpus -d 'Boot-time maximum possible virtual CPUs' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l cpu-placement -d 'Host CPU placement policy (inherit, auto, spread, compact)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l placement-profile -d 'Host-defined placement profile name' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -s m -l memory -d 'Amount of memory to allocate (e.g. 512M, 1G)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l max-memory -d 'Boot-time maximum hotpluggable memory (e.g. 1G, 8G)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l thp -d 'Guest transparent huge-page policy selected at boot' -r -f -a "always\t''
madvise\t''
never\t''"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -s v -l volume -d 'Mount a host path or named volume into the sandbox (`SOURCE:DEST[:OPTIONS]`). OPTIONS may include paired `uid=<N>,gid=<N>` for directory-backed mounts' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l mount-dir -d 'Explicitly mount a host directory into the sandbox (`SOURCE:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l mount-file -d 'Explicitly mount a host file into the sandbox (`SOURCE:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l mount-disk -d 'Explicitly mount a disk image into the sandbox (`SOURCE:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l mount-named -d 'Explicitly mount a named volume into the sandbox (`NAME:DEST[:OPTIONS]`). OPTIONS may include paired `uid=<N>,gid=<N>` when the volume is a directory' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l mount-owned -d 'Create a private volume removed with this sandbox (`DEST[:OPTIONS]`). Defaults to a directory; use `kind=disk,size=10G` for an ext4 disk' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -s w -l workdir -d 'Set the default working directory for commands' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l shell -d 'Shell to use for interactive sessions (default: /bin/sh)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -s e -l env -d 'Set an environment variable (KEY=value)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l label -d 'Attach a label to the sandbox for metrics attribution (`KEY=VALUE`, or bare `KEY` for a valueless marker). Repeatable. Surfaced as attributes on the sandbox\'s metrics' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l replace-with-timeout -d 'Timeout the existing sandbox gets after SIGTERM before it is SIGKILLed during a replace. Accepts `0`, `500ms`, `5s`, `2m`. Implies `--replace`. Default 10s when `--replace` is set on its own. An expired timeout force-kills the prior sandbox; the `create` call still proceeds' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l tmpfs -d 'Mount a temporary in-memory filesystem (PATH, PATH:SIZE, or PATH:SIZE:OPTIONS)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l security -d 'In-guest security profile (default or restricted)' -r -f -a "default\t''
restricted\t''"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l deployment-profile -d 'Host-runtime deployment profile (single-tenant or multi-tenant). Managed backends may enforce their own profile' -r -f -a "single-tenant\t''
multi-tenant\t''"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l script -d 'Register a shell snippet as a named script (NAME=BODY). The body supports `\\n`, `\\t`, `\\r`, `\\\\`, `\\"`, `\\\'` escapes; unknown escapes are preserved verbatim. The snippet is wrapped with a shebang derived from `--shell` (default `/bin/sh`) and made executable at `/.msb/scripts/<name>`; the directory is on `PATH`' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l script-raw -d 'Register exact inline script contents (NAME=BODY). No escape decoding or shebang is added, so the caller must include a `#!` line if the script should be directly executable' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l script-path -d 'Register a script from a host file (NAME:PATH). Same destination as `--script`; the file\'s contents are read verbatim at launch time' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l copy -d 'Copy a host file or directory into the guest rootfs before boot (SRC:DST)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l copy-file -d 'Copy a host file into the guest rootfs before boot (SRC:DST)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l copy-dir -d 'Copy a host directory into the guest rootfs before boot (SRC:DST)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l mkdir -d 'Create a directory in the guest rootfs before boot' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l rm -d 'Hide/remove a path from the guest rootfs before boot' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l entrypoint -d 'Override the image\'s default entrypoint command' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l init -d 'Hand off PID 1 to this init binary inside the guest after agentd finishes setup. Use `auto` to honor a known init at the start of the image ENTRYPOINT (for example /init in s6-overlay images), preserving attached init-entrypoint commands when needed, or to probe common distro init paths when the image does not declare one' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l init-arg -d 'Append an argv entry to the handoff init. Repeatable. Defaults to `[<--init>]` when empty' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l init-env -d 'Set an env var for the handoff init (KEY=VALUE). Repeatable. Merged on top of the inherited env' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -s H -l hostname -d 'Set the guest hostname (defaults to a sandbox-name-derived hostname)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -s u -l user -d 'Run commands as the specified user (e.g. nobody, 1000, 1000:1000)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l pull -d 'When to pull the image: always, if-missing (default), never' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l root-disk -d 'Root disk for OCI images (e.g. 8G, tmpfs:2G, flat:8G, ./scratch.img, ./scratch.qcow2:format=qcow2,fstype=ext4)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l oci-upper-size -d 'Deprecated alias for `--root-disk <SIZE>`' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l log-level -d 'Log verbosity for the sandbox runtime (error, warn, info, debug, trace)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l max-duration -d 'Kill the sandbox after this duration (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l idle-timeout -d 'Stop the sandbox after this period of inactivity (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l vsock -d 'Expose a host local-IPC endpoint on a guest-to-host vsock port' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -s p -l port -d 'Forward a host port to the sandbox (HOST:GUEST, BIND_ADDR:HOST:GUEST, and /udp variants)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l net -d 'High-level network profile. Repeatable and comma-separated. Profiles (`public`, `private`, `host`) compose and automatically enable gateway DNS. `all` and `none` are terminal policies and cannot be combined with profiles. Explicit `--net-rule` entries take precedence' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l dns-nameserver -d 'Nameserver to forward DNS queries to (repeatable). Overrides the nameservers in the host\'s `/etc/resolv.conf`. Accepts `IP` (port defaults to 53) or `IP:PORT`' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l dns-query-timeout-ms -d 'Per-DNS-query timeout in milliseconds. Default: 5000' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l net-ipv4-pool -d 'IPv4 pool used for per-sandbox /30 guest subnets. Default: 172.16.0.0/12' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l net-ipv6-pool -d 'IPv6 pool used for per-sandbox /64 guest prefixes. Default: fd42:6d73:62::/48' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l net-rule -d 'Network rule. Repeatable; each value is a comma-separated list of rule tokens. Token grammar: `<action>[:<direction>]@<target>[:<proto>[:<ports>]]`' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l net-default -d 'Default action for traffic in both directions that doesn\'t match any `--net-rule`. Sets egress and ingress symmetrically; use `--net-default-egress` / `--net-default-ingress` to set them independently' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l net-default-egress -d 'Default action for egress traffic that doesn\'t match any `--net-rule`. Default: deny (with an implicit allow@public rule when no other rules are present)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l net-default-ingress -d 'Default action for ingress traffic that doesn\'t match any `--net-rule`. Default: allow (preserves today\'s unfiltered published-port behavior when no ingress rules are set)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l net-egress-bandwidth -d 'Limit outbound (egress) bandwidth, e.g. 1M/1s. SIZE accepts raw bytes plus K, M, and G suffixes; the interval defaults to one second when omitted. Applies on the next sandbox start' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l net-egress-bandwidth-burst -d 'One-time startup burst for the egress bandwidth limit, e.g. 512K. Requires --net-egress-bandwidth' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l net-egress-ops -d 'Limit outbound (egress) packet rate, e.g. 1000/1s. The interval defaults to one second when omitted' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l net-egress-ops-burst -d 'One-time startup burst for the egress packet-rate limit. Requires --net-egress-ops' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l net-ingress-bandwidth -d 'Limit inbound (ingress) bandwidth, e.g. 1M/1s. Same syntax as --net-egress-bandwidth' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l net-ingress-bandwidth-burst -d 'One-time startup burst for the ingress bandwidth limit. Requires --net-ingress-bandwidth' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l net-ingress-ops -d 'Limit inbound (ingress) packet rate, e.g. 1000/1s' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l net-ingress-ops-burst -d 'One-time startup burst for the ingress packet-rate limit. Requires --net-ingress-ops' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l max-connections -d 'Deprecated alias for --max-tcp-connections' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l max-tcp-connections -d 'Limit TCP connections; zero means unlimited' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l max-udp-connections -d 'Limit UDP relay sessions (default: unlimited single-tenant, 1024 multi-tenant; zero means unlimited)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l proxy -d 'Dial all outbound sandbox connections through this proxy. Supports the socks4:// and socks5:// protocols' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l socks4-user-id -d 'Optional user ID for a SOCKS4 proxy' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l socks5-username -d 'Username for SOCKS5 username/password authentication' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l socks5-password-env -d 'Host environment variable containing the SOCKS5 password' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l tls-intercept-port -d 'TCP port to apply TLS interception on (default: 443)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l tls-bypass -d 'Skip TLS interception for this domain (e.g. *.internal.com)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l tls-intercept-ca-cert -d 'Use a custom CA certificate for TLS interception (PEM file)' -r -F
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l tls-intercept-ca-key -d 'Use a custom CA private key for TLS interception (PEM file)' -r -F
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l tls-upstream-ca-cert -d 'Trust an additional CA certificate for upstream server verification (PEM file). Can be specified multiple times' -r -F
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l tls-upstream-ca-cert-for -d 'Trust an additional CA certificate only for matching upstream hosts (PATTERN=PATH). Can be specified multiple times' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l tls-no-verify-upstream-for -d 'Disable upstream certificate verification for matching upstream hosts. Can be specified multiple times' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l secret -d 'Configure a protected secret (`ENV[:OPTIONS]@HOST[,HOST...]`). The value is read from the host environment variable ENV at start time and stored only as a source reference, never inlined in the sandbox config. Inline `ENV=VALUE@HOST` is rejected; export the value and use `ENV[:OPTIONS]@HOST[,HOST...]`' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l secret-violation-action -d 'Action when a secret placeholder is blocked (block, block-and-log, block-and-terminate)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -s d -l detach -d 'Run the resolved image command in the background and print the sandbox name'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -s t -l tty -d 'Allocate a pseudo-terminal (enables colors, line editing)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l no-tty -d 'Disable pseudo-terminal allocation and run non-interactively'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l replace -d 'Replace an existing sandbox with the same name'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l no-net -d 'Disable all network access by default. Sugar for `--net-default deny`. Combine with `--net-rule allow@<target>` entries to build an allowlist; without rules, the guest has no network reachability'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l no-dns-rebind-protection -d 'Allow DNS responses pointing to private/internal IP addresses'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l net-strict -d 'Require hostname-based network allows to use inspectable request authority'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l trust-host-cas -d 'Ship the host\'s trusted root CAs into the guest. Opt in to make outbound TLS work behind corporate MITM proxies (Warp Zero Trust, Zscaler, etc.) whose gateway CA is installed on the host but unknown to the guest\'s stock Mozilla bundle'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l tls-intercept -d 'Intercept and inspect HTTPS traffic via a built-in TLS proxy'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l no-block-quic -d 'Allow QUIC/HTTP3 traffic (blocked by default when TLS interception is on)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from run" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l conf -d 'Load a sparse single-sandbox configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l net-conf -d 'Load an unwrapped network configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l resource-conf -d 'Load an unwrapped resource and lifecycle configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l runtime-conf -d 'Load an unwrapped runtime configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l fs-conf -d 'Load an unwrapped filesystem configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l secret-conf -d 'Load an unwrapped secret-name map' -r -F
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l script-conf -d 'Load an unwrapped script-name map' -r -F
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -s n -l name -d 'Name for the sandbox. Auto-generated if omitted. Maximum 128 UTF-8 bytes' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -s c -l cpus -d 'Number of virtual CPUs to allocate' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l max-cpus -d 'Boot-time maximum possible virtual CPUs' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l cpu-placement -d 'Host CPU placement policy (inherit, auto, spread, compact)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l placement-profile -d 'Host-defined placement profile name' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -s m -l memory -d 'Amount of memory to allocate (e.g. 512M, 1G)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l max-memory -d 'Boot-time maximum hotpluggable memory (e.g. 1G, 8G)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l thp -d 'Guest transparent huge-page policy selected at boot' -r -f -a "always\t''
madvise\t''
never\t''"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -s v -l volume -d 'Mount a host path or named volume into the sandbox (`SOURCE:DEST[:OPTIONS]`). OPTIONS may include paired `uid=<N>,gid=<N>` for directory-backed mounts' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l mount-dir -d 'Explicitly mount a host directory into the sandbox (`SOURCE:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l mount-file -d 'Explicitly mount a host file into the sandbox (`SOURCE:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l mount-disk -d 'Explicitly mount a disk image into the sandbox (`SOURCE:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l mount-named -d 'Explicitly mount a named volume into the sandbox (`NAME:DEST[:OPTIONS]`). OPTIONS may include paired `uid=<N>,gid=<N>` when the volume is a directory' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l mount-owned -d 'Create a private volume removed with this sandbox (`DEST[:OPTIONS]`). Defaults to a directory; use `kind=disk,size=10G` for an ext4 disk' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -s w -l workdir -d 'Set the default working directory for commands' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l shell -d 'Shell to use for interactive sessions (default: /bin/sh)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -s e -l env -d 'Set an environment variable (KEY=value)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l label -d 'Attach a label to the sandbox for metrics attribution (`KEY=VALUE`, or bare `KEY` for a valueless marker). Repeatable. Surfaced as attributes on the sandbox\'s metrics' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l replace-with-timeout -d 'Timeout the existing sandbox gets after SIGTERM before it is SIGKILLed during a replace. Accepts `0`, `500ms`, `5s`, `2m`. Implies `--replace`. Default 10s when `--replace` is set on its own. An expired timeout force-kills the prior sandbox; the `create` call still proceeds' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l tmpfs -d 'Mount a temporary in-memory filesystem (PATH, PATH:SIZE, or PATH:SIZE:OPTIONS)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l security -d 'In-guest security profile (default or restricted)' -r -f -a "default\t''
restricted\t''"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l deployment-profile -d 'Host-runtime deployment profile (single-tenant or multi-tenant). Managed backends may enforce their own profile' -r -f -a "single-tenant\t''
multi-tenant\t''"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l script -d 'Register a shell snippet as a named script (NAME=BODY). The body supports `\\n`, `\\t`, `\\r`, `\\\\`, `\\"`, `\\\'` escapes; unknown escapes are preserved verbatim. The snippet is wrapped with a shebang derived from `--shell` (default `/bin/sh`) and made executable at `/.msb/scripts/<name>`; the directory is on `PATH`' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l script-raw -d 'Register exact inline script contents (NAME=BODY). No escape decoding or shebang is added, so the caller must include a `#!` line if the script should be directly executable' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l script-path -d 'Register a script from a host file (NAME:PATH). Same destination as `--script`; the file\'s contents are read verbatim at launch time' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l copy -d 'Copy a host file or directory into the guest rootfs before boot (SRC:DST)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l copy-file -d 'Copy a host file into the guest rootfs before boot (SRC:DST)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l copy-dir -d 'Copy a host directory into the guest rootfs before boot (SRC:DST)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l mkdir -d 'Create a directory in the guest rootfs before boot' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l rm -d 'Hide/remove a path from the guest rootfs before boot' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l entrypoint -d 'Override the image\'s default entrypoint command' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l init -d 'Hand off PID 1 to this init binary inside the guest after agentd finishes setup. Use `auto` to honor a known init at the start of the image ENTRYPOINT (for example /init in s6-overlay images), preserving attached init-entrypoint commands when needed, or to probe common distro init paths when the image does not declare one' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l init-arg -d 'Append an argv entry to the handoff init. Repeatable. Defaults to `[<--init>]` when empty' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l init-env -d 'Set an env var for the handoff init (KEY=VALUE). Repeatable. Merged on top of the inherited env' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -s H -l hostname -d 'Set the guest hostname (defaults to a sandbox-name-derived hostname)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -s u -l user -d 'Run commands as the specified user (e.g. nobody, 1000, 1000:1000)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l pull -d 'When to pull the image: always, if-missing (default), never' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l root-disk -d 'Root disk for OCI images (e.g. 8G, tmpfs:2G, flat:8G, ./scratch.img, ./scratch.qcow2:format=qcow2,fstype=ext4)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l oci-upper-size -d 'Deprecated alias for `--root-disk <SIZE>`' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l log-level -d 'Log verbosity for the sandbox runtime (error, warn, info, debug, trace)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l max-duration -d 'Kill the sandbox after this duration (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l idle-timeout -d 'Stop the sandbox after this period of inactivity (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l vsock -d 'Expose a host local-IPC endpoint on a guest-to-host vsock port' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -s p -l port -d 'Forward a host port to the sandbox (HOST:GUEST, BIND_ADDR:HOST:GUEST, and /udp variants)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l net -d 'High-level network profile. Repeatable and comma-separated. Profiles (`public`, `private`, `host`) compose and automatically enable gateway DNS. `all` and `none` are terminal policies and cannot be combined with profiles. Explicit `--net-rule` entries take precedence' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l dns-nameserver -d 'Nameserver to forward DNS queries to (repeatable). Overrides the nameservers in the host\'s `/etc/resolv.conf`. Accepts `IP` (port defaults to 53) or `IP:PORT`' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l dns-query-timeout-ms -d 'Per-DNS-query timeout in milliseconds. Default: 5000' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l net-ipv4-pool -d 'IPv4 pool used for per-sandbox /30 guest subnets. Default: 172.16.0.0/12' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l net-ipv6-pool -d 'IPv6 pool used for per-sandbox /64 guest prefixes. Default: fd42:6d73:62::/48' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l net-rule -d 'Network rule. Repeatable; each value is a comma-separated list of rule tokens. Token grammar: `<action>[:<direction>]@<target>[:<proto>[:<ports>]]`' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l net-default -d 'Default action for traffic in both directions that doesn\'t match any `--net-rule`. Sets egress and ingress symmetrically; use `--net-default-egress` / `--net-default-ingress` to set them independently' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l net-default-egress -d 'Default action for egress traffic that doesn\'t match any `--net-rule`. Default: deny (with an implicit allow@public rule when no other rules are present)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l net-default-ingress -d 'Default action for ingress traffic that doesn\'t match any `--net-rule`. Default: allow (preserves today\'s unfiltered published-port behavior when no ingress rules are set)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l net-egress-bandwidth -d 'Limit outbound (egress) bandwidth, e.g. 1M/1s. SIZE accepts raw bytes plus K, M, and G suffixes; the interval defaults to one second when omitted. Applies on the next sandbox start' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l net-egress-bandwidth-burst -d 'One-time startup burst for the egress bandwidth limit, e.g. 512K. Requires --net-egress-bandwidth' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l net-egress-ops -d 'Limit outbound (egress) packet rate, e.g. 1000/1s. The interval defaults to one second when omitted' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l net-egress-ops-burst -d 'One-time startup burst for the egress packet-rate limit. Requires --net-egress-ops' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l net-ingress-bandwidth -d 'Limit inbound (ingress) bandwidth, e.g. 1M/1s. Same syntax as --net-egress-bandwidth' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l net-ingress-bandwidth-burst -d 'One-time startup burst for the ingress bandwidth limit. Requires --net-ingress-bandwidth' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l net-ingress-ops -d 'Limit inbound (ingress) packet rate, e.g. 1000/1s' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l net-ingress-ops-burst -d 'One-time startup burst for the ingress packet-rate limit. Requires --net-ingress-ops' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l max-connections -d 'Deprecated alias for --max-tcp-connections' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l max-tcp-connections -d 'Limit TCP connections; zero means unlimited' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l max-udp-connections -d 'Limit UDP relay sessions (default: unlimited single-tenant, 1024 multi-tenant; zero means unlimited)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l proxy -d 'Dial all outbound sandbox connections through this proxy. Supports the socks4:// and socks5:// protocols' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l socks4-user-id -d 'Optional user ID for a SOCKS4 proxy' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l socks5-username -d 'Username for SOCKS5 username/password authentication' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l socks5-password-env -d 'Host environment variable containing the SOCKS5 password' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l tls-intercept-port -d 'TCP port to apply TLS interception on (default: 443)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l tls-bypass -d 'Skip TLS interception for this domain (e.g. *.internal.com)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l tls-intercept-ca-cert -d 'Use a custom CA certificate for TLS interception (PEM file)' -r -F
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l tls-intercept-ca-key -d 'Use a custom CA private key for TLS interception (PEM file)' -r -F
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l tls-upstream-ca-cert -d 'Trust an additional CA certificate for upstream server verification (PEM file). Can be specified multiple times' -r -F
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l tls-upstream-ca-cert-for -d 'Trust an additional CA certificate only for matching upstream hosts (PATTERN=PATH). Can be specified multiple times' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l tls-no-verify-upstream-for -d 'Disable upstream certificate verification for matching upstream hosts. Can be specified multiple times' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l secret -d 'Configure a protected secret (`ENV[:OPTIONS]@HOST[,HOST...]`). The value is read from the host environment variable ENV at start time and stored only as a source reference, never inlined in the sandbox config. Inline `ENV=VALUE@HOST` is rejected; export the value and use `ENV[:OPTIONS]@HOST[,HOST...]`' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l secret-violation-action -d 'Action when a secret placeholder is blocked (block, block-and-log, block-and-terminate)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l replace -d 'Replace an existing sandbox with the same name'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l no-net -d 'Disable all network access by default. Sugar for `--net-default deny`. Combine with `--net-rule allow@<target>` entries to build an allowlist; without rules, the guest has no network reachability'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l no-dns-rebind-protection -d 'Allow DNS responses pointing to private/internal IP addresses'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l net-strict -d 'Require hostname-based network allows to use inspectable request authority'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l trust-host-cas -d 'Ship the host\'s trusted root CAs into the guest. Opt in to make outbound TLS work behind corporate MITM proxies (Warp Zero Trust, Zscaler, etc.) whose gateway CA is installed on the host but unknown to the guest\'s stock Mozilla bundle'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l tls-intercept -d 'Intercept and inspect HTTPS traffic via a built-in TLS proxy'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l no-block-quic -d 'Allow QUIC/HTTP3 traffic (blocked by default when TLS interception is on)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -s n -l name -d 'Unique name of the destination sandbox' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l snapshot-base -d 'Exact base snapshot or archive for a dependent export' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l vsock -d 'Bind a host socket/named pipe to a guest-to-host vsock port: PATH:PORT[/stream|/dgram]' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -s v -l volume -d 'Map `SOURCE:GUEST[:OPTIONS]`, or select a captured private disk with GUEST alone' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -s p -l port -d 'Publish a child listener: `[BIND:]HOST:GUEST[/tcp|udp]`' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -s u -l user -d 'Default user for new exec commands; captured processes keep their credentials' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l external-mount-policy -d 'Validate explicitly mapped filesystems strictly or allow supported stale resources' -r -f -a "strict\t''
relaxed\t''"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -s c -l cpus -d 'Guest CPU count for disk boot; full restore requires the captured count' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -s m -l memory -d 'Guest memory for disk boot; full restore requires the captured size' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l security -d 'Guest security profile for disk boot; rejected for full execution restore' -r -f -a "default\t''
restricted\t''"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l max-duration -d 'Maximum lifetime of the destination sandbox (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l idle-timeout -d 'Stop after this much inactivity in the destination sandbox' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l net-default -d 'Default action for both traffic directions in the destination host policy' -r -f -a "allow\t''
deny\t''"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l net-rule -d 'Destination host policy rules, using the same syntax as create/run (repeatable). Requires --net-default or --no-net so the complete replacement policy is explicit' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l max-connections -d 'Deprecated alias for --max-tcp-connections' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l max-tcp-connections -d 'Concurrent TCP limit; zero explicitly selects unlimited' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l max-udp-connections -d 'Concurrent UDP session limit; zero explicitly selects unlimited' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l forked -d 'Restore captured RAM using private copy-on-write mappings'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l disk-only -d 'Cold-boot only the captured disk, without restoring processes or RAM'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l allow-missing-resources -d 'Allow missing full-restore resources with warnings instead of refusing activation'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l dangerously-inherit-resources -d 'Fill unspecified bindings from validated source-local records; may share host resources'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l no-net -d 'Deny traffic by default; combine with --net-rule to allow selected destinations'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -s q -l quiet -d 'Suppress progress output, but not unavailable-resource warnings'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restore" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l layers -d 'Merge up to N oldest sealed physical layers per disk, including the base (minimum 2)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l disk -d 'Compact only this owned disk\'s guest mount path (`/` selects the root)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -s c -l cpus -d 'Desired effective vCPU count' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l max-cpus -d 'Desired boot-time maximum possible vCPU count' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -s m -l memory -d 'Desired effective guest memory size, such as `512M` or `4G`' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l max-memory -d 'Desired boot-time maximum hotpluggable memory, such as `4G` or `16G`' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l root-disk -d 'Desired root disk size, such as `8G` (managed: grow-only; tmpfs: any direction, next boot)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l oci-upper-size -d 'Deprecated alias for `--root-disk <SIZE>`' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -s e -l env -d 'Set an environment variable for future execs (`KEY=VALUE`)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l env-rm -d 'Remove an environment variable by key' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l label -d 'Set a label (`KEY=VALUE`)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l label-rm -d 'Remove a label by key' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -s w -l workdir -d 'Working directory for future execs' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l secret -d 'Add or rotate a secret from a host environment variable (`NAME@HOST[,HOST...]`)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l secret-rm -d 'Remove a secret by name' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l format -d 'Output format' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l compact -d 'Compact sealed layers of the root and sandbox-owned data disks without changing snapshots'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l root-disk-only -d 'Compact only the root disk'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l dry-run -d 'Show the plan without applying anything'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l next-start -d 'Save changes for the next start without mutating a running VM'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l restart -d 'Restart if needed so restart-required changes become active now'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from modify" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l layers -d 'Merge up to N oldest sealed physical layers per disk, including the base (minimum 2)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l disk -d 'Compact only this owned disk\'s guest mount path (`/` selects the root)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -s c -l cpus -d 'Desired effective vCPU count' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l max-cpus -d 'Desired boot-time maximum possible vCPU count' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -s m -l memory -d 'Desired effective guest memory size, such as `512M` or `4G`' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l max-memory -d 'Desired boot-time maximum hotpluggable memory, such as `4G` or `16G`' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l root-disk -d 'Desired root disk size, such as `8G` (managed: grow-only; tmpfs: any direction, next boot)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l oci-upper-size -d 'Deprecated alias for `--root-disk <SIZE>`' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -s e -l env -d 'Set an environment variable for future execs (`KEY=VALUE`)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l env-rm -d 'Remove an environment variable by key' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l label -d 'Set a label (`KEY=VALUE`)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l label-rm -d 'Remove a label by key' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -s w -l workdir -d 'Working directory for future execs' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l secret -d 'Add or rotate a secret from a host environment variable (`NAME@HOST[,HOST...]`)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l secret-rm -d 'Remove a secret by name' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l format -d 'Output format' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l compact -d 'Compact sealed layers of the root and sandbox-owned data disks without changing snapshots'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l root-disk-only -d 'Compact only the root disk'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l dry-run -d 'Show the plan without applying anything'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l next-start -d 'Save changes for the next start without mutating a running VM'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l restart -d 'Restart if needed so restart-required changes become active now'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from mod" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from start" -l label -d 'Start every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from start" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from start" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from start" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from start" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from start" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from start" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from start" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from start" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from stop" -l label -d 'Stop every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from stop" -s t -l timeout -d 'Graceful completion budget in seconds; timeout fails without killing. Omit to wait indefinitely' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from stop" -s f -l force -d 'Immediately kill the sandbox without graceful shutdown. Pending writes that the workload hasn\'t `fsync`\'d may be lost'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from stop" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from stop" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from stop" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from stop" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from stop" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from stop" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from stop" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from stop" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from pause" -l guest-flush -d 'Optional guest writeback: auto, required, or skip. Required establishes a flushed pause' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from pause" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from pause" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from pause" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from pause" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from pause" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from pause" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from pause" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from pause" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from branch" -l guest-flush -d 'Optional guest writeback: auto, required, or skip. Auto preserves dirty RAM' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from branch" -s n -l name -d 'Name of the new child sandbox' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from branch" -l names -d 'Capture once for these independent children, in input order' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from branch" -l vsock -d 'Bind a host socket/named pipe to a guest-to-host vsock port: PATH:PORT[/stream|/dgram]' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from branch" -s v -l volume -d 'Map `SOURCE:GUEST[:OPTIONS]`, or select a captured private disk with GUEST alone' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from branch" -s p -l port -d 'Publish a child listener: `[BIND:]HOST:GUEST[/tcp|udp]`' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from branch" -s u -l user -d 'Default user for new exec commands; captured processes keep their credentials' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from branch" -l external-mount-policy -d 'Validate explicitly mapped filesystems strictly or allow supported stale resources' -r -f -a "strict\t''
relaxed\t''"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from branch" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from branch" -l integrity -d 'Compute and record disk content integrity for the captured layers'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from branch" -l dangerously-inherit-resources -d 'Fill unspecified bindings from validated source-local records; may share host resources'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from branch" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from branch" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from branch" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from branch" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from branch" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from branch" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from branch" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from resume" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from resume" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from resume" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from resume" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from resume" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from resume" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from resume" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from resume" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restart" -l label -d 'Restart every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restart" -s t -l timeout -d 'Total graceful-completion budget in seconds; expiry fails without killing' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restart" -s f -l force -d 'Immediately kill the sandbox without graceful shutdown. Pending writes that the workload hasn\'t `fsync`\'d may be lost'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restart" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restart" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restart" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restart" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restart" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restart" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restart" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from restart" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ping" -l label -d 'Ping every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ping" -l touch -d 'Refresh the sandbox idle timer after a successful ping'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ping" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ping" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ping" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ping" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ping" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ping" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ping" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ping" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from touch" -l label -d 'Touch every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from touch" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from touch" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from touch" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from touch" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from touch" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from touch" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from touch" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from touch" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from list" -l label -d 'Show only sandboxes carrying this label (`KEY=VALUE`). Repeatable; AND-matched' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from list" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from list" -l running -d 'Show only running sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from list" -l stopped -d 'Show only stopped sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Show only sandbox names'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from list" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from list" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from list" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from list" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from list" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from list" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ls" -l label -d 'Show only sandboxes carrying this label (`KEY=VALUE`). Repeatable; AND-matched' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ls" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ls" -l running -d 'Show only running sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ls" -l stopped -d 'Show only stopped sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Show only sandbox names'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ls" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ls" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ls" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ls" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ls" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ls" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from status" -l label -d 'Show only sandboxes carrying this label (`KEY=VALUE`). Repeatable; AND-matched' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from status" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from status" -s a -l all -d 'Show all sandboxes, not just running ones'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from status" -s q -l quiet -d 'Show only sandbox names'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from status" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from status" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from status" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from status" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from status" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from status" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from status" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ps" -l label -d 'Show only sandboxes carrying this label (`KEY=VALUE`). Repeatable; AND-matched' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ps" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ps" -s a -l all -d 'Show all sandboxes, not just running ones'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ps" -s q -l quiet -d 'Show only sandbox names'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ps" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ps" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ps" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ps" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ps" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ps" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from ps" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from metrics" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from metrics" -l interval -d 'Refresh interval for --watch/--follow (e.g. 500ms, 2s)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from metrics" -l sort -d 'Sort rows by column' -r -f -a "name\t''
cpu\t''
mem\t''"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from metrics" -s w -l watch -d 'Continuously refresh the table in place. Ctrl-C to quit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from metrics" -s f -l follow -d 'Stream one JSON Lines object per sandbox per interval to stdout'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from metrics" -s a -l all -d 'Include exited sandboxes whose terminal metrics are still recorded'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from metrics" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from metrics" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from metrics" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from metrics" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from metrics" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from metrics" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from metrics" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from remove" -l label -d 'Remove every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from remove" -s f -l force -d 'Stop the sandbox if running, then remove it'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from remove" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from remove" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from remove" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from remove" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from remove" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from remove" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from remove" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from remove" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from rm" -l label -d 'Remove every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from rm" -s f -l force -d 'Stop the sandbox if running, then remove it'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from rm" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from rm" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from rm" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from rm" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from rm" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from rm" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from rm" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from rm" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from exec" -s e -l env -d 'Set an environment variable (KEY=value)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from exec" -s w -l workdir -d 'Set the working directory for the command' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from exec" -s u -l user -d 'Run the command as the specified guest user' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from exec" -l timeout -d 'Kill the command after this duration (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from exec" -l rlimit -d 'Set a POSIX resource limit (e.g. nofile=1024, nproc=64, as=1073741824)' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from exec" -s t -l tty -d 'Allocate a pseudo-terminal (enables colors, line editing)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from exec" -l no-tty -d 'Disable pseudo-terminal allocation and run non-interactively'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from exec" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from exec" -l stream -d 'Stream stdin/stdout bidirectionally without a PTY (no echo/CRLF translation — safe for JSON lines)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from exec" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from exec" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from exec" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from exec" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from exec" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from exec" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from exec" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from copy" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from copy" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from copy" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from copy" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from copy" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from copy" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from copy" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from copy" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from cp" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from cp" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from cp" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from cp" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from cp" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from cp" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from cp" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from cp" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from logs" -l tail -d 'Show only the last N entries' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from logs" -l since -d 'Show only entries at or after this point. Accepts an RFC 3339 timestamp or a relative duration like `5m`, `2h`, `1d`' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from logs" -l until -d 'Show only entries strictly before this point. Same accepted formats as `--since`' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from logs" -l source -d 'Sources to include. Repeat or comma-separate to include multiple. Defaults to `stdout,stderr` (the captured user-program output)' -r -f -a "stdout\t'Captured stdout from the primary exec session (pipe mode)'
stderr\t'Captured stderr from the primary exec session (pipe mode)'
output\t'Merged stdout+stderr from the primary session running in pty mode (pty allocation merges streams in the kernel before they leave the guest)'
system\t'Synthetic system entries injected by the host writer (lifecycle markers) plus runtime/kernel diagnostics merged at read time'
all\t'All sources: `stdout`, `stderr`, `output`, and `system`'"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from logs" -l grep -d 'Filter entries to those whose body matches this regex' -r
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from logs" -l color -d 'ANSI color handling' -r -f -a "auto\t'Pass ANSI through to TTYs, strip on pipes'
always\t'Always pass ANSI through'
never\t'Always strip ANSI'"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from logs" -s f -l follow -d 'Follow the log: keep reading new entries as they are written. Exits cleanly when the sandbox stops or on Ctrl-C'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from logs" -l timestamps -d 'Prefix each line with the entry\'s timestamp'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from logs" -l json -d 'Emit JSON Lines to stdout without decoding (one entry per line)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from logs" -l no-color -d 'Alias for `--color=never`'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from logs" -l show-id -d 'Prefix each line with the session id `[id:N]`. Useful when the same sandbox has many concurrent or sequential exec sessions and you want to tell them apart'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from logs" -l color-sessions -d 'Color each session\'s output a distinct color (cycles through 8 ANSI colors deterministically by session id). Implies `--show-id`. Honors `--color`/`--no-color`/`NO_COLOR`'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from logs" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from logs" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from logs" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from logs" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from logs" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from logs" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from logs" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from inspect" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from inspect" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from inspect" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from inspect" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from inspect" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from inspect" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from inspect" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from inspect" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "run" -d 'Create a sandbox from an image and run a command in it'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "create" -d 'Create a sandbox and boot it in the background'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "restore" -d 'Restore a snapshot into a new detached sandbox'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "modify" -d 'Modify sandbox configuration'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "start" -d 'Start a stopped sandbox'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "stop" -d 'Stop one or more running sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "pause" -d 'Suspend a resident sandbox without creating a snapshot'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "branch" -d 'Branch running execution into a new local CoW child without a durable full snapshot'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "resume" -d 'Resume a user-paused resident sandbox'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "restart" -d 'Restart one or more sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "ping" -d 'Check whether one or more sandbox agents are reachable'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "touch" -d 'Refresh idle activity for one or more running sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "list" -d 'List all sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "status" -d 'Show sandbox status'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "metrics" -d 'Show live metrics for a running sandbox'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "remove" -d 'Remove one or more sandboxes'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "exec" -d 'Run a command in a running sandbox'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "copy" -d 'Copy files between the host and a sandbox'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "logs" -d 'Show captured output from a sandbox'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "inspect" -d 'Show detailed sandbox configuration and status'
complete -c msb -n "__fish_msb_using_subcommand sbx; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand run" -l timeout -d 'Kill the command after this duration (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l rlimit -d 'Set a POSIX resource limit (e.g. nofile=1024, nproc=64, as=1073741824)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l detach-keys -d 'Key sequence to detach from interactive session (default: ctrl-])' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l conf -d 'Load a sparse single-sandbox configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand run" -l net-conf -d 'Load an unwrapped network configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand run" -l resource-conf -d 'Load an unwrapped resource and lifecycle configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand run" -l runtime-conf -d 'Load an unwrapped runtime configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand run" -l fs-conf -d 'Load an unwrapped filesystem configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand run" -l secret-conf -d 'Load an unwrapped secret-name map' -r -F
complete -c msb -n "__fish_msb_using_subcommand run" -l script-conf -d 'Load an unwrapped script-name map' -r -F
complete -c msb -n "__fish_msb_using_subcommand run" -s n -l name -d 'Name for the sandbox. Auto-generated if omitted. Maximum 128 UTF-8 bytes' -r
complete -c msb -n "__fish_msb_using_subcommand run" -s c -l cpus -d 'Number of virtual CPUs to allocate' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l max-cpus -d 'Boot-time maximum possible virtual CPUs' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l cpu-placement -d 'Host CPU placement policy (inherit, auto, spread, compact)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l placement-profile -d 'Host-defined placement profile name' -r
complete -c msb -n "__fish_msb_using_subcommand run" -s m -l memory -d 'Amount of memory to allocate (e.g. 512M, 1G)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l max-memory -d 'Boot-time maximum hotpluggable memory (e.g. 1G, 8G)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l thp -d 'Guest transparent huge-page policy selected at boot' -r -f -a "always\t''
madvise\t''
never\t''"
complete -c msb -n "__fish_msb_using_subcommand run" -s v -l volume -d 'Mount a host path or named volume into the sandbox (`SOURCE:DEST[:OPTIONS]`). OPTIONS may include paired `uid=<N>,gid=<N>` for directory-backed mounts' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l mount-dir -d 'Explicitly mount a host directory into the sandbox (`SOURCE:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l mount-file -d 'Explicitly mount a host file into the sandbox (`SOURCE:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l mount-disk -d 'Explicitly mount a disk image into the sandbox (`SOURCE:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l mount-named -d 'Explicitly mount a named volume into the sandbox (`NAME:DEST[:OPTIONS]`). OPTIONS may include paired `uid=<N>,gid=<N>` when the volume is a directory' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l mount-owned -d 'Create a private volume removed with this sandbox (`DEST[:OPTIONS]`). Defaults to a directory; use `kind=disk,size=10G` for an ext4 disk' -r
complete -c msb -n "__fish_msb_using_subcommand run" -s w -l workdir -d 'Set the default working directory for commands' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l shell -d 'Shell to use for interactive sessions (default: /bin/sh)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -s e -l env -d 'Set an environment variable (KEY=value)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l label -d 'Attach a label to the sandbox for metrics attribution (`KEY=VALUE`, or bare `KEY` for a valueless marker). Repeatable. Surfaced as attributes on the sandbox\'s metrics' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l replace-with-timeout -d 'Timeout the existing sandbox gets after SIGTERM before it is SIGKILLed during a replace. Accepts `0`, `500ms`, `5s`, `2m`. Implies `--replace`. Default 10s when `--replace` is set on its own. An expired timeout force-kills the prior sandbox; the `create` call still proceeds' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l tmpfs -d 'Mount a temporary in-memory filesystem (PATH, PATH:SIZE, or PATH:SIZE:OPTIONS)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l security -d 'In-guest security profile (default or restricted)' -r -f -a "default\t''
restricted\t''"
complete -c msb -n "__fish_msb_using_subcommand run" -l deployment-profile -d 'Host-runtime deployment profile (single-tenant or multi-tenant). Managed backends may enforce their own profile' -r -f -a "single-tenant\t''
multi-tenant\t''"
complete -c msb -n "__fish_msb_using_subcommand run" -l script -d 'Register a shell snippet as a named script (NAME=BODY). The body supports `\\n`, `\\t`, `\\r`, `\\\\`, `\\"`, `\\\'` escapes; unknown escapes are preserved verbatim. The snippet is wrapped with a shebang derived from `--shell` (default `/bin/sh`) and made executable at `/.msb/scripts/<name>`; the directory is on `PATH`' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l script-raw -d 'Register exact inline script contents (NAME=BODY). No escape decoding or shebang is added, so the caller must include a `#!` line if the script should be directly executable' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l script-path -d 'Register a script from a host file (NAME:PATH). Same destination as `--script`; the file\'s contents are read verbatim at launch time' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l copy -d 'Copy a host file or directory into the guest rootfs before boot (SRC:DST)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l copy-file -d 'Copy a host file into the guest rootfs before boot (SRC:DST)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l copy-dir -d 'Copy a host directory into the guest rootfs before boot (SRC:DST)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l mkdir -d 'Create a directory in the guest rootfs before boot' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l rm -d 'Hide/remove a path from the guest rootfs before boot' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l entrypoint -d 'Override the image\'s default entrypoint command' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l init -d 'Hand off PID 1 to this init binary inside the guest after agentd finishes setup. Use `auto` to honor a known init at the start of the image ENTRYPOINT (for example /init in s6-overlay images), preserving attached init-entrypoint commands when needed, or to probe common distro init paths when the image does not declare one' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l init-arg -d 'Append an argv entry to the handoff init. Repeatable. Defaults to `[<--init>]` when empty' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l init-env -d 'Set an env var for the handoff init (KEY=VALUE). Repeatable. Merged on top of the inherited env' -r
complete -c msb -n "__fish_msb_using_subcommand run" -s H -l hostname -d 'Set the guest hostname (defaults to a sandbox-name-derived hostname)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -s u -l user -d 'Run commands as the specified user (e.g. nobody, 1000, 1000:1000)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l pull -d 'When to pull the image: always, if-missing (default), never' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l root-disk -d 'Root disk for OCI images (e.g. 8G, tmpfs:2G, flat:8G, ./scratch.img, ./scratch.qcow2:format=qcow2,fstype=ext4)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l oci-upper-size -d 'Deprecated alias for `--root-disk <SIZE>`' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l log-level -d 'Log verbosity for the sandbox runtime (error, warn, info, debug, trace)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l max-duration -d 'Kill the sandbox after this duration (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l idle-timeout -d 'Stop the sandbox after this period of inactivity (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l vsock -d 'Expose a host local-IPC endpoint on a guest-to-host vsock port' -r
complete -c msb -n "__fish_msb_using_subcommand run" -s p -l port -d 'Forward a host port to the sandbox (HOST:GUEST, BIND_ADDR:HOST:GUEST, and /udp variants)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l net -d 'High-level network profile. Repeatable and comma-separated. Profiles (`public`, `private`, `host`) compose and automatically enable gateway DNS. `all` and `none` are terminal policies and cannot be combined with profiles. Explicit `--net-rule` entries take precedence' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l dns-nameserver -d 'Nameserver to forward DNS queries to (repeatable). Overrides the nameservers in the host\'s `/etc/resolv.conf`. Accepts `IP` (port defaults to 53) or `IP:PORT`' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l dns-query-timeout-ms -d 'Per-DNS-query timeout in milliseconds. Default: 5000' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l net-ipv4-pool -d 'IPv4 pool used for per-sandbox /30 guest subnets. Default: 172.16.0.0/12' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l net-ipv6-pool -d 'IPv6 pool used for per-sandbox /64 guest prefixes. Default: fd42:6d73:62::/48' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l net-rule -d 'Network rule. Repeatable; each value is a comma-separated list of rule tokens. Token grammar: `<action>[:<direction>]@<target>[:<proto>[:<ports>]]`' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l net-default -d 'Default action for traffic in both directions that doesn\'t match any `--net-rule`. Sets egress and ingress symmetrically; use `--net-default-egress` / `--net-default-ingress` to set them independently' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l net-default-egress -d 'Default action for egress traffic that doesn\'t match any `--net-rule`. Default: deny (with an implicit allow@public rule when no other rules are present)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l net-default-ingress -d 'Default action for ingress traffic that doesn\'t match any `--net-rule`. Default: allow (preserves today\'s unfiltered published-port behavior when no ingress rules are set)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l net-egress-bandwidth -d 'Limit outbound (egress) bandwidth, e.g. 1M/1s. SIZE accepts raw bytes plus K, M, and G suffixes; the interval defaults to one second when omitted. Applies on the next sandbox start' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l net-egress-bandwidth-burst -d 'One-time startup burst for the egress bandwidth limit, e.g. 512K. Requires --net-egress-bandwidth' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l net-egress-ops -d 'Limit outbound (egress) packet rate, e.g. 1000/1s. The interval defaults to one second when omitted' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l net-egress-ops-burst -d 'One-time startup burst for the egress packet-rate limit. Requires --net-egress-ops' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l net-ingress-bandwidth -d 'Limit inbound (ingress) bandwidth, e.g. 1M/1s. Same syntax as --net-egress-bandwidth' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l net-ingress-bandwidth-burst -d 'One-time startup burst for the ingress bandwidth limit. Requires --net-ingress-bandwidth' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l net-ingress-ops -d 'Limit inbound (ingress) packet rate, e.g. 1000/1s' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l net-ingress-ops-burst -d 'One-time startup burst for the ingress packet-rate limit. Requires --net-ingress-ops' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l max-connections -d 'Deprecated alias for --max-tcp-connections' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l max-tcp-connections -d 'Limit TCP connections; zero means unlimited' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l max-udp-connections -d 'Limit UDP relay sessions (default: unlimited single-tenant, 1024 multi-tenant; zero means unlimited)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l proxy -d 'Dial all outbound sandbox connections through this proxy. Supports the socks4:// and socks5:// protocols' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l socks4-user-id -d 'Optional user ID for a SOCKS4 proxy' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l socks5-username -d 'Username for SOCKS5 username/password authentication' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l socks5-password-env -d 'Host environment variable containing the SOCKS5 password' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l tls-intercept-port -d 'TCP port to apply TLS interception on (default: 443)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l tls-bypass -d 'Skip TLS interception for this domain (e.g. *.internal.com)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l tls-intercept-ca-cert -d 'Use a custom CA certificate for TLS interception (PEM file)' -r -F
complete -c msb -n "__fish_msb_using_subcommand run" -l tls-intercept-ca-key -d 'Use a custom CA private key for TLS interception (PEM file)' -r -F
complete -c msb -n "__fish_msb_using_subcommand run" -l tls-upstream-ca-cert -d 'Trust an additional CA certificate for upstream server verification (PEM file). Can be specified multiple times' -r -F
complete -c msb -n "__fish_msb_using_subcommand run" -l tls-upstream-ca-cert-for -d 'Trust an additional CA certificate only for matching upstream hosts (PATTERN=PATH). Can be specified multiple times' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l tls-no-verify-upstream-for -d 'Disable upstream certificate verification for matching upstream hosts. Can be specified multiple times' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l secret -d 'Configure a protected secret (`ENV[:OPTIONS]@HOST[,HOST...]`). The value is read from the host environment variable ENV at start time and stored only as a source reference, never inlined in the sandbox config. Inline `ENV=VALUE@HOST` is rejected; export the value and use `ENV[:OPTIONS]@HOST[,HOST...]`' -r
complete -c msb -n "__fish_msb_using_subcommand run" -l secret-violation-action -d 'Action when a secret placeholder is blocked (block, block-and-log, block-and-terminate)' -r
complete -c msb -n "__fish_msb_using_subcommand run" -s d -l detach -d 'Run the resolved image command in the background and print the sandbox name'
complete -c msb -n "__fish_msb_using_subcommand run" -s t -l tty -d 'Allocate a pseudo-terminal (enables colors, line editing)'
complete -c msb -n "__fish_msb_using_subcommand run" -l no-tty -d 'Disable pseudo-terminal allocation and run non-interactively'
complete -c msb -n "__fish_msb_using_subcommand run" -l replace -d 'Replace an existing sandbox with the same name'
complete -c msb -n "__fish_msb_using_subcommand run" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand run" -l no-net -d 'Disable all network access by default. Sugar for `--net-default deny`. Combine with `--net-rule allow@<target>` entries to build an allowlist; without rules, the guest has no network reachability'
complete -c msb -n "__fish_msb_using_subcommand run" -l no-dns-rebind-protection -d 'Allow DNS responses pointing to private/internal IP addresses'
complete -c msb -n "__fish_msb_using_subcommand run" -l net-strict -d 'Require hostname-based network allows to use inspectable request authority'
complete -c msb -n "__fish_msb_using_subcommand run" -l trust-host-cas -d 'Ship the host\'s trusted root CAs into the guest. Opt in to make outbound TLS work behind corporate MITM proxies (Warp Zero Trust, Zscaler, etc.) whose gateway CA is installed on the host but unknown to the guest\'s stock Mozilla bundle'
complete -c msb -n "__fish_msb_using_subcommand run" -l tls-intercept -d 'Intercept and inspect HTTPS traffic via a built-in TLS proxy'
complete -c msb -n "__fish_msb_using_subcommand run" -l no-block-quic -d 'Allow QUIC/HTTP3 traffic (blocked by default when TLS interception is on)'
complete -c msb -n "__fish_msb_using_subcommand run" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand run" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand run" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand run" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand run" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand run" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand run" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c msb -n "__fish_msb_using_subcommand create" -l conf -d 'Load a sparse single-sandbox configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand create" -l net-conf -d 'Load an unwrapped network configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand create" -l resource-conf -d 'Load an unwrapped resource and lifecycle configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand create" -l runtime-conf -d 'Load an unwrapped runtime configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand create" -l fs-conf -d 'Load an unwrapped filesystem configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand create" -l secret-conf -d 'Load an unwrapped secret-name map' -r -F
complete -c msb -n "__fish_msb_using_subcommand create" -l script-conf -d 'Load an unwrapped script-name map' -r -F
complete -c msb -n "__fish_msb_using_subcommand create" -s n -l name -d 'Name for the sandbox. Auto-generated if omitted. Maximum 128 UTF-8 bytes' -r
complete -c msb -n "__fish_msb_using_subcommand create" -s c -l cpus -d 'Number of virtual CPUs to allocate' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l max-cpus -d 'Boot-time maximum possible virtual CPUs' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l cpu-placement -d 'Host CPU placement policy (inherit, auto, spread, compact)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l placement-profile -d 'Host-defined placement profile name' -r
complete -c msb -n "__fish_msb_using_subcommand create" -s m -l memory -d 'Amount of memory to allocate (e.g. 512M, 1G)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l max-memory -d 'Boot-time maximum hotpluggable memory (e.g. 1G, 8G)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l thp -d 'Guest transparent huge-page policy selected at boot' -r -f -a "always\t''
madvise\t''
never\t''"
complete -c msb -n "__fish_msb_using_subcommand create" -s v -l volume -d 'Mount a host path or named volume into the sandbox (`SOURCE:DEST[:OPTIONS]`). OPTIONS may include paired `uid=<N>,gid=<N>` for directory-backed mounts' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l mount-dir -d 'Explicitly mount a host directory into the sandbox (`SOURCE:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l mount-file -d 'Explicitly mount a host file into the sandbox (`SOURCE:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l mount-disk -d 'Explicitly mount a disk image into the sandbox (`SOURCE:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l mount-named -d 'Explicitly mount a named volume into the sandbox (`NAME:DEST[:OPTIONS]`). OPTIONS may include paired `uid=<N>,gid=<N>` when the volume is a directory' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l mount-owned -d 'Create a private volume removed with this sandbox (`DEST[:OPTIONS]`). Defaults to a directory; use `kind=disk,size=10G` for an ext4 disk' -r
complete -c msb -n "__fish_msb_using_subcommand create" -s w -l workdir -d 'Set the default working directory for commands' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l shell -d 'Shell to use for interactive sessions (default: /bin/sh)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -s e -l env -d 'Set an environment variable (KEY=value)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l label -d 'Attach a label to the sandbox for metrics attribution (`KEY=VALUE`, or bare `KEY` for a valueless marker). Repeatable. Surfaced as attributes on the sandbox\'s metrics' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l replace-with-timeout -d 'Timeout the existing sandbox gets after SIGTERM before it is SIGKILLed during a replace. Accepts `0`, `500ms`, `5s`, `2m`. Implies `--replace`. Default 10s when `--replace` is set on its own. An expired timeout force-kills the prior sandbox; the `create` call still proceeds' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l tmpfs -d 'Mount a temporary in-memory filesystem (PATH, PATH:SIZE, or PATH:SIZE:OPTIONS)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l security -d 'In-guest security profile (default or restricted)' -r -f -a "default\t''
restricted\t''"
complete -c msb -n "__fish_msb_using_subcommand create" -l deployment-profile -d 'Host-runtime deployment profile (single-tenant or multi-tenant). Managed backends may enforce their own profile' -r -f -a "single-tenant\t''
multi-tenant\t''"
complete -c msb -n "__fish_msb_using_subcommand create" -l script -d 'Register a shell snippet as a named script (NAME=BODY). The body supports `\\n`, `\\t`, `\\r`, `\\\\`, `\\"`, `\\\'` escapes; unknown escapes are preserved verbatim. The snippet is wrapped with a shebang derived from `--shell` (default `/bin/sh`) and made executable at `/.msb/scripts/<name>`; the directory is on `PATH`' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l script-raw -d 'Register exact inline script contents (NAME=BODY). No escape decoding or shebang is added, so the caller must include a `#!` line if the script should be directly executable' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l script-path -d 'Register a script from a host file (NAME:PATH). Same destination as `--script`; the file\'s contents are read verbatim at launch time' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l copy -d 'Copy a host file or directory into the guest rootfs before boot (SRC:DST)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l copy-file -d 'Copy a host file into the guest rootfs before boot (SRC:DST)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l copy-dir -d 'Copy a host directory into the guest rootfs before boot (SRC:DST)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l mkdir -d 'Create a directory in the guest rootfs before boot' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l rm -d 'Hide/remove a path from the guest rootfs before boot' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l entrypoint -d 'Override the image\'s default entrypoint command' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l init -d 'Hand off PID 1 to this init binary inside the guest after agentd finishes setup. Use `auto` to honor a known init at the start of the image ENTRYPOINT (for example /init in s6-overlay images), preserving attached init-entrypoint commands when needed, or to probe common distro init paths when the image does not declare one' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l init-arg -d 'Append an argv entry to the handoff init. Repeatable. Defaults to `[<--init>]` when empty' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l init-env -d 'Set an env var for the handoff init (KEY=VALUE). Repeatable. Merged on top of the inherited env' -r
complete -c msb -n "__fish_msb_using_subcommand create" -s H -l hostname -d 'Set the guest hostname (defaults to a sandbox-name-derived hostname)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -s u -l user -d 'Run commands as the specified user (e.g. nobody, 1000, 1000:1000)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l pull -d 'When to pull the image: always, if-missing (default), never' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l root-disk -d 'Root disk for OCI images (e.g. 8G, tmpfs:2G, flat:8G, ./scratch.img, ./scratch.qcow2:format=qcow2,fstype=ext4)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l oci-upper-size -d 'Deprecated alias for `--root-disk <SIZE>`' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l log-level -d 'Log verbosity for the sandbox runtime (error, warn, info, debug, trace)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l max-duration -d 'Kill the sandbox after this duration (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l idle-timeout -d 'Stop the sandbox after this period of inactivity (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l vsock -d 'Expose a host local-IPC endpoint on a guest-to-host vsock port' -r
complete -c msb -n "__fish_msb_using_subcommand create" -s p -l port -d 'Forward a host port to the sandbox (HOST:GUEST, BIND_ADDR:HOST:GUEST, and /udp variants)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l net -d 'High-level network profile. Repeatable and comma-separated. Profiles (`public`, `private`, `host`) compose and automatically enable gateway DNS. `all` and `none` are terminal policies and cannot be combined with profiles. Explicit `--net-rule` entries take precedence' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l dns-nameserver -d 'Nameserver to forward DNS queries to (repeatable). Overrides the nameservers in the host\'s `/etc/resolv.conf`. Accepts `IP` (port defaults to 53) or `IP:PORT`' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l dns-query-timeout-ms -d 'Per-DNS-query timeout in milliseconds. Default: 5000' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l net-ipv4-pool -d 'IPv4 pool used for per-sandbox /30 guest subnets. Default: 172.16.0.0/12' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l net-ipv6-pool -d 'IPv6 pool used for per-sandbox /64 guest prefixes. Default: fd42:6d73:62::/48' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l net-rule -d 'Network rule. Repeatable; each value is a comma-separated list of rule tokens. Token grammar: `<action>[:<direction>]@<target>[:<proto>[:<ports>]]`' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l net-default -d 'Default action for traffic in both directions that doesn\'t match any `--net-rule`. Sets egress and ingress symmetrically; use `--net-default-egress` / `--net-default-ingress` to set them independently' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l net-default-egress -d 'Default action for egress traffic that doesn\'t match any `--net-rule`. Default: deny (with an implicit allow@public rule when no other rules are present)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l net-default-ingress -d 'Default action for ingress traffic that doesn\'t match any `--net-rule`. Default: allow (preserves today\'s unfiltered published-port behavior when no ingress rules are set)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l net-egress-bandwidth -d 'Limit outbound (egress) bandwidth, e.g. 1M/1s. SIZE accepts raw bytes plus K, M, and G suffixes; the interval defaults to one second when omitted. Applies on the next sandbox start' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l net-egress-bandwidth-burst -d 'One-time startup burst for the egress bandwidth limit, e.g. 512K. Requires --net-egress-bandwidth' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l net-egress-ops -d 'Limit outbound (egress) packet rate, e.g. 1000/1s. The interval defaults to one second when omitted' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l net-egress-ops-burst -d 'One-time startup burst for the egress packet-rate limit. Requires --net-egress-ops' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l net-ingress-bandwidth -d 'Limit inbound (ingress) bandwidth, e.g. 1M/1s. Same syntax as --net-egress-bandwidth' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l net-ingress-bandwidth-burst -d 'One-time startup burst for the ingress bandwidth limit. Requires --net-ingress-bandwidth' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l net-ingress-ops -d 'Limit inbound (ingress) packet rate, e.g. 1000/1s' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l net-ingress-ops-burst -d 'One-time startup burst for the ingress packet-rate limit. Requires --net-ingress-ops' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l max-connections -d 'Deprecated alias for --max-tcp-connections' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l max-tcp-connections -d 'Limit TCP connections; zero means unlimited' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l max-udp-connections -d 'Limit UDP relay sessions (default: unlimited single-tenant, 1024 multi-tenant; zero means unlimited)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l proxy -d 'Dial all outbound sandbox connections through this proxy. Supports the socks4:// and socks5:// protocols' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l socks4-user-id -d 'Optional user ID for a SOCKS4 proxy' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l socks5-username -d 'Username for SOCKS5 username/password authentication' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l socks5-password-env -d 'Host environment variable containing the SOCKS5 password' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l tls-intercept-port -d 'TCP port to apply TLS interception on (default: 443)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l tls-bypass -d 'Skip TLS interception for this domain (e.g. *.internal.com)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l tls-intercept-ca-cert -d 'Use a custom CA certificate for TLS interception (PEM file)' -r -F
complete -c msb -n "__fish_msb_using_subcommand create" -l tls-intercept-ca-key -d 'Use a custom CA private key for TLS interception (PEM file)' -r -F
complete -c msb -n "__fish_msb_using_subcommand create" -l tls-upstream-ca-cert -d 'Trust an additional CA certificate for upstream server verification (PEM file). Can be specified multiple times' -r -F
complete -c msb -n "__fish_msb_using_subcommand create" -l tls-upstream-ca-cert-for -d 'Trust an additional CA certificate only for matching upstream hosts (PATTERN=PATH). Can be specified multiple times' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l tls-no-verify-upstream-for -d 'Disable upstream certificate verification for matching upstream hosts. Can be specified multiple times' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l secret -d 'Configure a protected secret (`ENV[:OPTIONS]@HOST[,HOST...]`). The value is read from the host environment variable ENV at start time and stored only as a source reference, never inlined in the sandbox config. Inline `ENV=VALUE@HOST` is rejected; export the value and use `ENV[:OPTIONS]@HOST[,HOST...]`' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l secret-violation-action -d 'Action when a secret placeholder is blocked (block, block-and-log, block-and-terminate)' -r
complete -c msb -n "__fish_msb_using_subcommand create" -l replace -d 'Replace an existing sandbox with the same name'
complete -c msb -n "__fish_msb_using_subcommand create" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand create" -l no-net -d 'Disable all network access by default. Sugar for `--net-default deny`. Combine with `--net-rule allow@<target>` entries to build an allowlist; without rules, the guest has no network reachability'
complete -c msb -n "__fish_msb_using_subcommand create" -l no-dns-rebind-protection -d 'Allow DNS responses pointing to private/internal IP addresses'
complete -c msb -n "__fish_msb_using_subcommand create" -l net-strict -d 'Require hostname-based network allows to use inspectable request authority'
complete -c msb -n "__fish_msb_using_subcommand create" -l trust-host-cas -d 'Ship the host\'s trusted root CAs into the guest. Opt in to make outbound TLS work behind corporate MITM proxies (Warp Zero Trust, Zscaler, etc.) whose gateway CA is installed on the host but unknown to the guest\'s stock Mozilla bundle'
complete -c msb -n "__fish_msb_using_subcommand create" -l tls-intercept -d 'Intercept and inspect HTTPS traffic via a built-in TLS proxy'
complete -c msb -n "__fish_msb_using_subcommand create" -l no-block-quic -d 'Allow QUIC/HTTP3 traffic (blocked by default when TLS interception is on)'
complete -c msb -n "__fish_msb_using_subcommand create" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand create" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand create" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand create" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand create" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand create" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand create" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c msb -n "__fish_msb_using_subcommand restore" -s n -l name -d 'Unique name of the destination sandbox' -r
complete -c msb -n "__fish_msb_using_subcommand restore" -l snapshot-base -d 'Exact base snapshot or archive for a dependent export' -r
complete -c msb -n "__fish_msb_using_subcommand restore" -l vsock -d 'Bind a host socket/named pipe to a guest-to-host vsock port: PATH:PORT[/stream|/dgram]' -r
complete -c msb -n "__fish_msb_using_subcommand restore" -s v -l volume -d 'Map `SOURCE:GUEST[:OPTIONS]`, or select a captured private disk with GUEST alone' -r
complete -c msb -n "__fish_msb_using_subcommand restore" -s p -l port -d 'Publish a child listener: `[BIND:]HOST:GUEST[/tcp|udp]`' -r
complete -c msb -n "__fish_msb_using_subcommand restore" -s u -l user -d 'Default user for new exec commands; captured processes keep their credentials' -r
complete -c msb -n "__fish_msb_using_subcommand restore" -l external-mount-policy -d 'Validate explicitly mapped filesystems strictly or allow supported stale resources' -r -f -a "strict\t''
relaxed\t''"
complete -c msb -n "__fish_msb_using_subcommand restore" -s c -l cpus -d 'Guest CPU count for disk boot; full restore requires the captured count' -r
complete -c msb -n "__fish_msb_using_subcommand restore" -s m -l memory -d 'Guest memory for disk boot; full restore requires the captured size' -r
complete -c msb -n "__fish_msb_using_subcommand restore" -l security -d 'Guest security profile for disk boot; rejected for full execution restore' -r -f -a "default\t''
restricted\t''"
complete -c msb -n "__fish_msb_using_subcommand restore" -l max-duration -d 'Maximum lifetime of the destination sandbox (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand restore" -l idle-timeout -d 'Stop after this much inactivity in the destination sandbox' -r
complete -c msb -n "__fish_msb_using_subcommand restore" -l net-default -d 'Default action for both traffic directions in the destination host policy' -r -f -a "allow\t''
deny\t''"
complete -c msb -n "__fish_msb_using_subcommand restore" -l net-rule -d 'Destination host policy rules, using the same syntax as create/run (repeatable). Requires --net-default or --no-net so the complete replacement policy is explicit' -r
complete -c msb -n "__fish_msb_using_subcommand restore" -l max-connections -d 'Deprecated alias for --max-tcp-connections' -r
complete -c msb -n "__fish_msb_using_subcommand restore" -l max-tcp-connections -d 'Concurrent TCP limit; zero explicitly selects unlimited' -r
complete -c msb -n "__fish_msb_using_subcommand restore" -l max-udp-connections -d 'Concurrent UDP session limit; zero explicitly selects unlimited' -r
complete -c msb -n "__fish_msb_using_subcommand restore" -l forked -d 'Restore captured RAM using private copy-on-write mappings'
complete -c msb -n "__fish_msb_using_subcommand restore" -l disk-only -d 'Cold-boot only the captured disk, without restoring processes or RAM'
complete -c msb -n "__fish_msb_using_subcommand restore" -l allow-missing-resources -d 'Allow missing full-restore resources with warnings instead of refusing activation'
complete -c msb -n "__fish_msb_using_subcommand restore" -l dangerously-inherit-resources -d 'Fill unspecified bindings from validated source-local records; may share host resources'
complete -c msb -n "__fish_msb_using_subcommand restore" -l no-net -d 'Deny traffic by default; combine with --net-rule to allow selected destinations'
complete -c msb -n "__fish_msb_using_subcommand restore" -s q -l quiet -d 'Suppress progress output, but not unavailable-resource warnings'
complete -c msb -n "__fish_msb_using_subcommand restore" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand restore" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand restore" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand restore" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand restore" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand restore" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand restore" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand modify" -l layers -d 'Merge up to N oldest sealed physical layers per disk, including the base (minimum 2)' -r
complete -c msb -n "__fish_msb_using_subcommand modify" -l disk -d 'Compact only this owned disk\'s guest mount path (`/` selects the root)' -r
complete -c msb -n "__fish_msb_using_subcommand modify" -s c -l cpus -d 'Desired effective vCPU count' -r
complete -c msb -n "__fish_msb_using_subcommand modify" -l max-cpus -d 'Desired boot-time maximum possible vCPU count' -r
complete -c msb -n "__fish_msb_using_subcommand modify" -s m -l memory -d 'Desired effective guest memory size, such as `512M` or `4G`' -r
complete -c msb -n "__fish_msb_using_subcommand modify" -l max-memory -d 'Desired boot-time maximum hotpluggable memory, such as `4G` or `16G`' -r
complete -c msb -n "__fish_msb_using_subcommand modify" -l root-disk -d 'Desired root disk size, such as `8G` (managed: grow-only; tmpfs: any direction, next boot)' -r
complete -c msb -n "__fish_msb_using_subcommand modify" -l oci-upper-size -d 'Deprecated alias for `--root-disk <SIZE>`' -r
complete -c msb -n "__fish_msb_using_subcommand modify" -s e -l env -d 'Set an environment variable for future execs (`KEY=VALUE`)' -r
complete -c msb -n "__fish_msb_using_subcommand modify" -l env-rm -d 'Remove an environment variable by key' -r
complete -c msb -n "__fish_msb_using_subcommand modify" -l label -d 'Set a label (`KEY=VALUE`)' -r
complete -c msb -n "__fish_msb_using_subcommand modify" -l label-rm -d 'Remove a label by key' -r
complete -c msb -n "__fish_msb_using_subcommand modify" -s w -l workdir -d 'Working directory for future execs' -r
complete -c msb -n "__fish_msb_using_subcommand modify" -l secret -d 'Add or rotate a secret from a host environment variable (`NAME@HOST[,HOST...]`)' -r
complete -c msb -n "__fish_msb_using_subcommand modify" -l secret-rm -d 'Remove a secret by name' -r
complete -c msb -n "__fish_msb_using_subcommand modify" -l format -d 'Output format' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand modify" -l compact -d 'Compact sealed layers of the root and sandbox-owned data disks without changing snapshots'
complete -c msb -n "__fish_msb_using_subcommand modify" -l root-disk-only -d 'Compact only the root disk'
complete -c msb -n "__fish_msb_using_subcommand modify" -l dry-run -d 'Show the plan without applying anything'
complete -c msb -n "__fish_msb_using_subcommand modify" -l next-start -d 'Save changes for the next start without mutating a running VM'
complete -c msb -n "__fish_msb_using_subcommand modify" -l restart -d 'Restart if needed so restart-required changes become active now'
complete -c msb -n "__fish_msb_using_subcommand modify" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand modify" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand modify" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand modify" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand modify" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand modify" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand modify" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand mod" -l layers -d 'Merge up to N oldest sealed physical layers per disk, including the base (minimum 2)' -r
complete -c msb -n "__fish_msb_using_subcommand mod" -l disk -d 'Compact only this owned disk\'s guest mount path (`/` selects the root)' -r
complete -c msb -n "__fish_msb_using_subcommand mod" -s c -l cpus -d 'Desired effective vCPU count' -r
complete -c msb -n "__fish_msb_using_subcommand mod" -l max-cpus -d 'Desired boot-time maximum possible vCPU count' -r
complete -c msb -n "__fish_msb_using_subcommand mod" -s m -l memory -d 'Desired effective guest memory size, such as `512M` or `4G`' -r
complete -c msb -n "__fish_msb_using_subcommand mod" -l max-memory -d 'Desired boot-time maximum hotpluggable memory, such as `4G` or `16G`' -r
complete -c msb -n "__fish_msb_using_subcommand mod" -l root-disk -d 'Desired root disk size, such as `8G` (managed: grow-only; tmpfs: any direction, next boot)' -r
complete -c msb -n "__fish_msb_using_subcommand mod" -l oci-upper-size -d 'Deprecated alias for `--root-disk <SIZE>`' -r
complete -c msb -n "__fish_msb_using_subcommand mod" -s e -l env -d 'Set an environment variable for future execs (`KEY=VALUE`)' -r
complete -c msb -n "__fish_msb_using_subcommand mod" -l env-rm -d 'Remove an environment variable by key' -r
complete -c msb -n "__fish_msb_using_subcommand mod" -l label -d 'Set a label (`KEY=VALUE`)' -r
complete -c msb -n "__fish_msb_using_subcommand mod" -l label-rm -d 'Remove a label by key' -r
complete -c msb -n "__fish_msb_using_subcommand mod" -s w -l workdir -d 'Working directory for future execs' -r
complete -c msb -n "__fish_msb_using_subcommand mod" -l secret -d 'Add or rotate a secret from a host environment variable (`NAME@HOST[,HOST...]`)' -r
complete -c msb -n "__fish_msb_using_subcommand mod" -l secret-rm -d 'Remove a secret by name' -r
complete -c msb -n "__fish_msb_using_subcommand mod" -l format -d 'Output format' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand mod" -l compact -d 'Compact sealed layers of the root and sandbox-owned data disks without changing snapshots'
complete -c msb -n "__fish_msb_using_subcommand mod" -l root-disk-only -d 'Compact only the root disk'
complete -c msb -n "__fish_msb_using_subcommand mod" -l dry-run -d 'Show the plan without applying anything'
complete -c msb -n "__fish_msb_using_subcommand mod" -l next-start -d 'Save changes for the next start without mutating a running VM'
complete -c msb -n "__fish_msb_using_subcommand mod" -l restart -d 'Restart if needed so restart-required changes become active now'
complete -c msb -n "__fish_msb_using_subcommand mod" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand mod" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand mod" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand mod" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand mod" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand mod" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand mod" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand start" -l label -d 'Start every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand start" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand start" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand start" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand start" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand start" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand start" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand start" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand start" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand stop" -l label -d 'Stop every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand stop" -s t -l timeout -d 'Graceful completion budget in seconds; timeout fails without killing. Omit to wait indefinitely' -r
complete -c msb -n "__fish_msb_using_subcommand stop" -s f -l force -d 'Immediately kill the sandbox without graceful shutdown. Pending writes that the workload hasn\'t `fsync`\'d may be lost'
complete -c msb -n "__fish_msb_using_subcommand stop" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand stop" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand stop" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand stop" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand stop" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand stop" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand stop" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand stop" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand pause" -l guest-flush -d 'Optional guest writeback: auto, required, or skip. Required establishes a flushed pause' -r
complete -c msb -n "__fish_msb_using_subcommand pause" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand pause" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand pause" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand pause" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand pause" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand pause" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand pause" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand pause" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand branch" -l guest-flush -d 'Optional guest writeback: auto, required, or skip. Auto preserves dirty RAM' -r
complete -c msb -n "__fish_msb_using_subcommand branch" -s n -l name -d 'Name of the new child sandbox' -r
complete -c msb -n "__fish_msb_using_subcommand branch" -l names -d 'Capture once for these independent children, in input order' -r
complete -c msb -n "__fish_msb_using_subcommand branch" -l vsock -d 'Bind a host socket/named pipe to a guest-to-host vsock port: PATH:PORT[/stream|/dgram]' -r
complete -c msb -n "__fish_msb_using_subcommand branch" -s v -l volume -d 'Map `SOURCE:GUEST[:OPTIONS]`, or select a captured private disk with GUEST alone' -r
complete -c msb -n "__fish_msb_using_subcommand branch" -s p -l port -d 'Publish a child listener: `[BIND:]HOST:GUEST[/tcp|udp]`' -r
complete -c msb -n "__fish_msb_using_subcommand branch" -s u -l user -d 'Default user for new exec commands; captured processes keep their credentials' -r
complete -c msb -n "__fish_msb_using_subcommand branch" -l external-mount-policy -d 'Validate explicitly mapped filesystems strictly or allow supported stale resources' -r -f -a "strict\t''
relaxed\t''"
complete -c msb -n "__fish_msb_using_subcommand branch" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand branch" -l integrity -d 'Compute and record disk content integrity for the captured layers'
complete -c msb -n "__fish_msb_using_subcommand branch" -l dangerously-inherit-resources -d 'Fill unspecified bindings from validated source-local records; may share host resources'
complete -c msb -n "__fish_msb_using_subcommand branch" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand branch" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand branch" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand branch" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand branch" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand branch" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand branch" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand resume" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand resume" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand resume" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand resume" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand resume" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand resume" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand resume" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand resume" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand restart" -l label -d 'Restart every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand restart" -s t -l timeout -d 'Total graceful-completion budget in seconds; expiry fails without killing' -r
complete -c msb -n "__fish_msb_using_subcommand restart" -s f -l force -d 'Immediately kill the sandbox without graceful shutdown. Pending writes that the workload hasn\'t `fsync`\'d may be lost'
complete -c msb -n "__fish_msb_using_subcommand restart" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand restart" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand restart" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand restart" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand restart" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand restart" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand restart" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand restart" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand ping" -l label -d 'Ping every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand ping" -l touch -d 'Refresh the sandbox idle timer after a successful ping'
complete -c msb -n "__fish_msb_using_subcommand ping" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand ping" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand ping" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ping" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ping" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ping" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ping" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand ping" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand touch" -l label -d 'Touch every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand touch" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand touch" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand touch" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand touch" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand touch" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand touch" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand touch" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand touch" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand list" -l label -d 'Show only sandboxes carrying this label (`KEY=VALUE`). Repeatable; AND-matched' -r
complete -c msb -n "__fish_msb_using_subcommand list" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand list" -l running -d 'Show only running sandboxes'
complete -c msb -n "__fish_msb_using_subcommand list" -l stopped -d 'Show only stopped sandboxes'
complete -c msb -n "__fish_msb_using_subcommand list" -s q -l quiet -d 'Show only sandbox names'
complete -c msb -n "__fish_msb_using_subcommand list" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand list" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand list" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand list" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand list" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand list" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand list" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand ls" -l label -d 'Show only sandboxes carrying this label (`KEY=VALUE`). Repeatable; AND-matched' -r
complete -c msb -n "__fish_msb_using_subcommand ls" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand ls" -l running -d 'Show only running sandboxes'
complete -c msb -n "__fish_msb_using_subcommand ls" -l stopped -d 'Show only stopped sandboxes'
complete -c msb -n "__fish_msb_using_subcommand ls" -s q -l quiet -d 'Show only sandbox names'
complete -c msb -n "__fish_msb_using_subcommand ls" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand ls" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ls" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ls" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ls" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ls" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand ls" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand status" -l label -d 'Show only sandboxes carrying this label (`KEY=VALUE`). Repeatable; AND-matched' -r
complete -c msb -n "__fish_msb_using_subcommand status" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand status" -s a -l all -d 'Show all sandboxes, not just running ones'
complete -c msb -n "__fish_msb_using_subcommand status" -s q -l quiet -d 'Show only sandbox names'
complete -c msb -n "__fish_msb_using_subcommand status" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand status" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand status" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand status" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand status" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand status" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand status" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand ps" -l label -d 'Show only sandboxes carrying this label (`KEY=VALUE`). Repeatable; AND-matched' -r
complete -c msb -n "__fish_msb_using_subcommand ps" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand ps" -s a -l all -d 'Show all sandboxes, not just running ones'
complete -c msb -n "__fish_msb_using_subcommand ps" -s q -l quiet -d 'Show only sandbox names'
complete -c msb -n "__fish_msb_using_subcommand ps" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand ps" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ps" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ps" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ps" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ps" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand ps" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand metrics" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand metrics" -l interval -d 'Refresh interval for --watch/--follow (e.g. 500ms, 2s)' -r
complete -c msb -n "__fish_msb_using_subcommand metrics" -l sort -d 'Sort rows by column' -r -f -a "name\t''
cpu\t''
mem\t''"
complete -c msb -n "__fish_msb_using_subcommand metrics" -s w -l watch -d 'Continuously refresh the table in place. Ctrl-C to quit'
complete -c msb -n "__fish_msb_using_subcommand metrics" -s f -l follow -d 'Stream one JSON Lines object per sandbox per interval to stdout'
complete -c msb -n "__fish_msb_using_subcommand metrics" -s a -l all -d 'Include exited sandboxes whose terminal metrics are still recorded'
complete -c msb -n "__fish_msb_using_subcommand metrics" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand metrics" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand metrics" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand metrics" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand metrics" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand metrics" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand metrics" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand remove" -l label -d 'Remove every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand remove" -s f -l force -d 'Stop the sandbox if running, then remove it'
complete -c msb -n "__fish_msb_using_subcommand remove" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand remove" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand remove" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand remove" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand remove" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand remove" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand remove" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand remove" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand rm" -l label -d 'Remove every sandbox carrying this label (`KEY=VALUE`). Repeatable; AND-matched. Unioned with any explicitly named sandboxes' -r
complete -c msb -n "__fish_msb_using_subcommand rm" -s f -l force -d 'Stop the sandbox if running, then remove it'
complete -c msb -n "__fish_msb_using_subcommand rm" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand rm" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand rm" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand rm" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand rm" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand rm" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand rm" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand rm" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand exec" -s e -l env -d 'Set an environment variable (KEY=value)' -r
complete -c msb -n "__fish_msb_using_subcommand exec" -s w -l workdir -d 'Set the working directory for the command' -r
complete -c msb -n "__fish_msb_using_subcommand exec" -s u -l user -d 'Run the command as the specified guest user' -r
complete -c msb -n "__fish_msb_using_subcommand exec" -l timeout -d 'Kill the command after this duration (e.g. 30s, 5m, 1h)' -r
complete -c msb -n "__fish_msb_using_subcommand exec" -l rlimit -d 'Set a POSIX resource limit (e.g. nofile=1024, nproc=64, as=1073741824)' -r
complete -c msb -n "__fish_msb_using_subcommand exec" -s t -l tty -d 'Allocate a pseudo-terminal (enables colors, line editing)'
complete -c msb -n "__fish_msb_using_subcommand exec" -l no-tty -d 'Disable pseudo-terminal allocation and run non-interactively'
complete -c msb -n "__fish_msb_using_subcommand exec" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand exec" -l stream -d 'Stream stdin/stdout bidirectionally without a PTY (no echo/CRLF translation — safe for JSON lines)'
complete -c msb -n "__fish_msb_using_subcommand exec" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand exec" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand exec" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand exec" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand exec" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand exec" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand exec" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c msb -n "__fish_msb_using_subcommand copy" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand copy" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand copy" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand copy" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand copy" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand copy" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand copy" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand copy" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand cp" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand cp" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand cp" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand cp" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand cp" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand cp" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand cp" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand cp" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand logs" -l tail -d 'Show only the last N entries' -r
complete -c msb -n "__fish_msb_using_subcommand logs" -l since -d 'Show only entries at or after this point. Accepts an RFC 3339 timestamp or a relative duration like `5m`, `2h`, `1d`' -r
complete -c msb -n "__fish_msb_using_subcommand logs" -l until -d 'Show only entries strictly before this point. Same accepted formats as `--since`' -r
complete -c msb -n "__fish_msb_using_subcommand logs" -l source -d 'Sources to include. Repeat or comma-separate to include multiple. Defaults to `stdout,stderr` (the captured user-program output)' -r -f -a "stdout\t'Captured stdout from the primary exec session (pipe mode)'
stderr\t'Captured stderr from the primary exec session (pipe mode)'
output\t'Merged stdout+stderr from the primary session running in pty mode (pty allocation merges streams in the kernel before they leave the guest)'
system\t'Synthetic system entries injected by the host writer (lifecycle markers) plus runtime/kernel diagnostics merged at read time'
all\t'All sources: `stdout`, `stderr`, `output`, and `system`'"
complete -c msb -n "__fish_msb_using_subcommand logs" -l grep -d 'Filter entries to those whose body matches this regex' -r
complete -c msb -n "__fish_msb_using_subcommand logs" -l color -d 'ANSI color handling' -r -f -a "auto\t'Pass ANSI through to TTYs, strip on pipes'
always\t'Always pass ANSI through'
never\t'Always strip ANSI'"
complete -c msb -n "__fish_msb_using_subcommand logs" -s f -l follow -d 'Follow the log: keep reading new entries as they are written. Exits cleanly when the sandbox stops or on Ctrl-C'
complete -c msb -n "__fish_msb_using_subcommand logs" -l timestamps -d 'Prefix each line with the entry\'s timestamp'
complete -c msb -n "__fish_msb_using_subcommand logs" -l json -d 'Emit JSON Lines to stdout without decoding (one entry per line)'
complete -c msb -n "__fish_msb_using_subcommand logs" -l no-color -d 'Alias for `--color=never`'
complete -c msb -n "__fish_msb_using_subcommand logs" -l show-id -d 'Prefix each line with the session id `[id:N]`. Useful when the same sandbox has many concurrent or sequential exec sessions and you want to tell them apart'
complete -c msb -n "__fish_msb_using_subcommand logs" -l color-sessions -d 'Color each session\'s output a distinct color (cycles through 8 ANSI colors deterministically by session id). Implies `--show-id`. Honors `--color`/`--no-color`/`NO_COLOR`'
complete -c msb -n "__fish_msb_using_subcommand logs" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand logs" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand logs" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand logs" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand logs" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand logs" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand logs" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c msb -n "__fish_msb_using_subcommand inspect" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand inspect" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand inspect" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand inspect" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand inspect" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand inspect" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand inspect" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand inspect" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand __schema-baseline" -l json -d 'Print downgrade compatibility metadata as JSON'
complete -c msb -n "__fish_msb_using_subcommand __schema-baseline" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand __schema-baseline" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand __schema-baseline" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand __schema-baseline" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand __schema-baseline" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand __schema-baseline" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand __schema-baseline" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand context" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand context" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand context" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand context" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand context" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand context" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand context" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand context" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand ctx" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand ctx" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand ctx" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ctx" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ctx" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ctx" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ctx" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand ctx" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand image; and not __fish_seen_subcommand_from pull list ls inspect load save remove rm prune help" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand image; and not __fish_seen_subcommand_from pull list ls inspect load save remove rm prune help" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and not __fish_seen_subcommand_from pull list ls inspect load save remove rm prune help" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and not __fish_seen_subcommand_from pull list ls inspect load save remove rm prune help" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and not __fish_seen_subcommand_from pull list ls inspect load save remove rm prune help" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and not __fish_seen_subcommand_from pull list ls inspect load save remove rm prune help" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand image; and not __fish_seen_subcommand_from pull list ls inspect load save remove rm prune help" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand image; and not __fish_seen_subcommand_from pull list ls inspect load save remove rm prune help" -f -a "pull" -d 'Download an image from a container registry'
complete -c msb -n "__fish_msb_using_subcommand image; and not __fish_seen_subcommand_from pull list ls inspect load save remove rm prune help" -f -a "list" -d 'List locally cached images'
complete -c msb -n "__fish_msb_using_subcommand image; and not __fish_seen_subcommand_from pull list ls inspect load save remove rm prune help" -f -a "ls" -d 'List locally cached images'
complete -c msb -n "__fish_msb_using_subcommand image; and not __fish_seen_subcommand_from pull list ls inspect load save remove rm prune help" -f -a "inspect" -d 'Show detailed image information'
complete -c msb -n "__fish_msb_using_subcommand image; and not __fish_seen_subcommand_from pull list ls inspect load save remove rm prune help" -f -a "load" -d 'Load an image archive from tar'
complete -c msb -n "__fish_msb_using_subcommand image; and not __fish_seen_subcommand_from pull list ls inspect load save remove rm prune help" -f -a "save" -d 'Save one or more cached images to a tar archive'
complete -c msb -n "__fish_msb_using_subcommand image; and not __fish_seen_subcommand_from pull list ls inspect load save remove rm prune help" -f -a "remove" -d 'Delete one or more cached images'
complete -c msb -n "__fish_msb_using_subcommand image; and not __fish_seen_subcommand_from pull list ls inspect load save remove rm prune help" -f -a "rm" -d 'Delete one or more cached images'
complete -c msb -n "__fish_msb_using_subcommand image; and not __fish_seen_subcommand_from pull list ls inspect load save remove rm prune help" -f -a "prune" -d 'Remove cached images not used by sandboxes'
complete -c msb -n "__fish_msb_using_subcommand image; and not __fish_seen_subcommand_from pull list ls inspect load save remove rm prune help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from pull" -l ca-certs -d 'Path to a PEM file containing additional CA root certificates to trust' -r
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from pull" -l materialize -d 'Rootfs artifacts to prepare in addition to downloaded OCI content' -r -f -a "layered\t'Prepare the existing stitched layered rootfs'
flat\t'Prepare reusable EROFS layers and one flat ext4 rootfs, skipping fsmeta/VMDK'
all\t'Prepare both layered and flat rootfs artifacts'"
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from pull" -s f -l force -d 'Re-download even if the image is already cached'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from pull" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from pull" -l insecure -d 'Connect to the registry over plain HTTP instead of HTTPS'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from pull" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from pull" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from pull" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from pull" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from pull" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from pull" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from pull" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from list" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Show only image references'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from list" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from list" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from list" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from list" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from list" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from list" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from ls" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Show only image references'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from ls" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from ls" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from ls" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from ls" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from ls" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from ls" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from inspect" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from inspect" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from inspect" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from inspect" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from inspect" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from inspect" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from inspect" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from inspect" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from load" -s i -l input -d 'Read archive from a tar file instead of stdin' -r -F
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from load" -s t -l tag -d 'Add a local image reference to the first imported image' -r
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from load" -s q -l quiet -d 'Suppress output'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from load" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from load" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from load" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from load" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from load" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from load" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from load" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from save" -l format -d 'Archive format to write' -r -f -a "docker\t'Docker `docker save` compatible archive'
oci\t'OCI Image Layout archive'"
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from save" -s o -l output -d 'Write archive to a tar file instead of stdout' -r -F
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from save" -s q -l quiet -d 'Suppress output'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from save" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from save" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from save" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from save" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from save" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from save" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from save" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from remove" -s f -l force -d 'Remove even if the image is used by existing sandboxes'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from remove" -s q -l quiet -d 'Suppress output'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from remove" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from remove" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from remove" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from remove" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from remove" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from remove" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from remove" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from rm" -s f -l force -d 'Remove even if the image is used by existing sandboxes'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from rm" -s q -l quiet -d 'Suppress output'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from rm" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from rm" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from rm" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from rm" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from rm" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from rm" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from rm" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from prune" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from prune" -s y -l yes -d 'Do not prompt for confirmation'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from prune" -s q -l quiet -d 'Suppress output'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from prune" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from prune" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from prune" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from prune" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from prune" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from prune" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from prune" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from help" -f -a "pull" -d 'Download an image from a container registry'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from help" -f -a "list" -d 'List locally cached images'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from help" -f -a "inspect" -d 'Show detailed image information'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from help" -f -a "load" -d 'Load an image archive from tar'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from help" -f -a "save" -d 'Save one or more cached images to a tar archive'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from help" -f -a "remove" -d 'Delete one or more cached images'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from help" -f -a "prune" -d 'Remove cached images not used by sandboxes'
complete -c msb -n "__fish_msb_using_subcommand image; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand pull" -l ca-certs -d 'Path to a PEM file containing additional CA root certificates to trust' -r
complete -c msb -n "__fish_msb_using_subcommand pull" -l materialize -d 'Rootfs artifacts to prepare in addition to downloaded OCI content' -r -f -a "layered\t'Prepare the existing stitched layered rootfs'
flat\t'Prepare reusable EROFS layers and one flat ext4 rootfs, skipping fsmeta/VMDK'
all\t'Prepare both layered and flat rootfs artifacts'"
complete -c msb -n "__fish_msb_using_subcommand pull" -s f -l force -d 'Re-download even if the image is already cached'
complete -c msb -n "__fish_msb_using_subcommand pull" -s q -l quiet -d 'Suppress progress output'
complete -c msb -n "__fish_msb_using_subcommand pull" -l insecure -d 'Connect to the registry over plain HTTP instead of HTTPS'
complete -c msb -n "__fish_msb_using_subcommand pull" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand pull" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand pull" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand pull" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand pull" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand pull" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand pull" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c msb -n "__fish_msb_using_subcommand load" -s i -l input -d 'Read archive from a tar file instead of stdin' -r -F
complete -c msb -n "__fish_msb_using_subcommand load" -s t -l tag -d 'Add a local image reference to the first imported image' -r
complete -c msb -n "__fish_msb_using_subcommand load" -s q -l quiet -d 'Suppress output'
complete -c msb -n "__fish_msb_using_subcommand load" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand load" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand load" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand load" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand load" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand load" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand load" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand save" -l format -d 'Archive format to write' -r -f -a "docker\t'Docker `docker save` compatible archive'
oci\t'OCI Image Layout archive'"
complete -c msb -n "__fish_msb_using_subcommand save" -s o -l output -d 'Write archive to a tar file instead of stdout' -r -F
complete -c msb -n "__fish_msb_using_subcommand save" -s q -l quiet -d 'Suppress output'
complete -c msb -n "__fish_msb_using_subcommand save" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand save" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand save" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand save" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand save" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand save" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand save" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c msb -n "__fish_msb_using_subcommand registry; and not __fish_seen_subcommand_from login logout list ls help" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand registry; and not __fish_seen_subcommand_from login logout list ls help" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registry; and not __fish_seen_subcommand_from login logout list ls help" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registry; and not __fish_seen_subcommand_from login logout list ls help" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registry; and not __fish_seen_subcommand_from login logout list ls help" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registry; and not __fish_seen_subcommand_from login logout list ls help" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand registry; and not __fish_seen_subcommand_from login logout list ls help" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand registry; and not __fish_seen_subcommand_from login logout list ls help" -f -a "login" -d 'Store credentials for a registry in the OS credential store'
complete -c msb -n "__fish_msb_using_subcommand registry; and not __fish_seen_subcommand_from login logout list ls help" -f -a "logout" -d 'Remove stored credentials for a registry'
complete -c msb -n "__fish_msb_using_subcommand registry; and not __fish_seen_subcommand_from login logout list ls help" -f -a "list" -d 'List configured registries without printing secrets'
complete -c msb -n "__fish_msb_using_subcommand registry; and not __fish_seen_subcommand_from login logout list ls help" -f -a "ls" -d 'List configured registries without printing secrets'
complete -c msb -n "__fish_msb_using_subcommand registry; and not __fish_seen_subcommand_from login logout list ls help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from login" -s u -l username -d 'Registry username' -r
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from login" -l password-stdin -d 'Read the password/token from stdin'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from login" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from login" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from login" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from login" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from login" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from login" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from login" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from logout" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from logout" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from logout" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from logout" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from logout" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from logout" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from logout" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from list" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from list" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from list" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from list" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from list" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from list" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from ls" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from ls" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from ls" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from ls" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from ls" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from ls" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from help" -f -a "login" -d 'Store credentials for a registry in the OS credential store'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from help" -f -a "logout" -d 'Remove stored credentials for a registry'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from help" -f -a "list" -d 'List configured registries without printing secrets'
complete -c msb -n "__fish_msb_using_subcommand registry; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand ssh; and not __fish_seen_subcommand_from connect serve authorize help" -s n -l name -d 'Explicit sandbox name. Useful when the sandbox is named like a subcommand' -r
complete -c msb -n "__fish_msb_using_subcommand ssh; and not __fish_seen_subcommand_from connect serve authorize help" -l inactivity-timeout -d 'Disconnect after this duration without SSH traffic. Use 0 to disable' -r
complete -c msb -n "__fish_msb_using_subcommand ssh; and not __fish_seen_subcommand_from connect serve authorize help" -l no-inactivity-timeout -d 'Disable the SSH session inactivity timeout'
complete -c msb -n "__fish_msb_using_subcommand ssh; and not __fish_seen_subcommand_from connect serve authorize help" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand ssh; and not __fish_seen_subcommand_from connect serve authorize help" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ssh; and not __fish_seen_subcommand_from connect serve authorize help" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ssh; and not __fish_seen_subcommand_from connect serve authorize help" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ssh; and not __fish_seen_subcommand_from connect serve authorize help" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ssh; and not __fish_seen_subcommand_from connect serve authorize help" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand ssh; and not __fish_seen_subcommand_from connect serve authorize help" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand ssh; and not __fish_seen_subcommand_from connect serve authorize help" -a "connect" -d 'Connect to a sandbox over SSH'
complete -c msb -n "__fish_msb_using_subcommand ssh; and not __fish_seen_subcommand_from connect serve authorize help" -a "serve" -d 'Serve a sandbox over SSH'
complete -c msb -n "__fish_msb_using_subcommand ssh; and not __fish_seen_subcommand_from connect serve authorize help" -a "authorize" -d 'Add a public key to microsandbox SSH authorization'
complete -c msb -n "__fish_msb_using_subcommand ssh; and not __fish_seen_subcommand_from connect serve authorize help" -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from connect" -s n -l name -d 'Explicit sandbox name. Useful when the sandbox is named like a subcommand' -r
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from connect" -l inactivity-timeout -d 'Disconnect after this duration without SSH traffic. Use 0 to disable' -r
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from connect" -l no-inactivity-timeout -d 'Disable the SSH session inactivity timeout'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from connect" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from connect" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from connect" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from connect" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from connect" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from connect" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from connect" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from serve" -l host -d 'Listener host' -r
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from serve" -s p -l port -d 'Listener port' -r
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from serve" -l inactivity-timeout -d 'Disconnect after this duration without SSH traffic. Use 0 to disable' -r
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from serve" -l stdio -d 'Serve one SSH transport over stdin/stdout'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from serve" -l no-inactivity-timeout -d 'Disable the SSH session inactivity timeout'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from serve" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from serve" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from serve" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from serve" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from serve" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from serve" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from serve" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from authorize" -l file -d 'Read a public key from this file' -r -F
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from authorize" -l key -d 'Public key string' -r
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from authorize" -l stdin -d 'Read a public key from stdin'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from authorize" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from authorize" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from authorize" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from authorize" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from authorize" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from authorize" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from authorize" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from help" -f -a "connect" -d 'Connect to a sandbox over SSH'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from help" -f -a "serve" -d 'Serve a sandbox over SSH'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from help" -f -a "authorize" -d 'Add a public key to microsandbox SSH authorization'
complete -c msb -n "__fish_msb_using_subcommand ssh; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand images" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand images" -s q -l quiet -d 'Show only image references'
complete -c msb -n "__fish_msb_using_subcommand images" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand images" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand images" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand images" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand images" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand images" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand images" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand volumes" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand volumes" -s q -l quiet -d 'Show only volume names'
complete -c msb -n "__fish_msb_using_subcommand volumes" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand volumes" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volumes" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volumes" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volumes" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volumes" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand volumes" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snapshots" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand snapshots" -s q -l quiet -d 'Show only digests'
complete -c msb -n "__fish_msb_using_subcommand snapshots" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snapshots" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshots" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshots" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshots" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshots" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snapshots" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand registries" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand registries" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registries" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registries" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registries" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand registries" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand registries" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand rmi" -s f -l force -d 'Remove even if the image is used by existing sandboxes'
complete -c msb -n "__fish_msb_using_subcommand rmi" -s q -l quiet -d 'Suppress output'
complete -c msb -n "__fish_msb_using_subcommand rmi" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand rmi" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand rmi" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand rmi" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand rmi" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand rmi" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand rmi" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand volume; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand volume; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand volume; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand volume; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -f -a "create" -d 'Create a new named volume'
complete -c msb -n "__fish_msb_using_subcommand volume; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -f -a "list" -d 'List all volumes'
complete -c msb -n "__fish_msb_using_subcommand volume; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -f -a "ls" -d 'List all volumes'
complete -c msb -n "__fish_msb_using_subcommand volume; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -f -a "inspect" -d 'Show detailed volume information'
complete -c msb -n "__fish_msb_using_subcommand volume; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -f -a "remove" -d 'Delete one or more volumes'
complete -c msb -n "__fish_msb_using_subcommand volume; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -f -a "rm" -d 'Delete one or more volumes'
complete -c msb -n "__fish_msb_using_subcommand volume; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from create" -s n -l name -d 'Name for the new volume' -r
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from create" -l kind -d 'Volume kind' -r -f -a "dir\t''
disk\t''"
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from create" -l size -d 'Disk capacity for disk volumes (e.g. 10G, 512M)' -r
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from create" -s q -l quiet -d 'Suppress output'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from create" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from create" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from create" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from create" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from create" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from create" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from list" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Show only volume names'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from list" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from list" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from list" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from list" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from list" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from list" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from ls" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Show only volume names'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from ls" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from ls" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from ls" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from ls" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from ls" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from ls" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from inspect" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from inspect" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from inspect" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from inspect" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from inspect" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from inspect" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from inspect" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from remove" -s q -l quiet -d 'Suppress output'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from remove" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from remove" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from remove" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from remove" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from remove" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from remove" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from remove" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from rm" -s q -l quiet -d 'Suppress output'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from rm" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from rm" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from rm" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from rm" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from rm" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from rm" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from rm" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from help" -f -a "create" -d 'Create a new named volume'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from help" -f -a "list" -d 'List all volumes'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from help" -f -a "inspect" -d 'Show detailed volume information'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from help" -f -a "remove" -d 'Delete one or more volumes'
complete -c msb -n "__fish_msb_using_subcommand volume; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand vol; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand vol; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand vol; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand vol; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -f -a "create" -d 'Create a new named volume'
complete -c msb -n "__fish_msb_using_subcommand vol; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -f -a "list" -d 'List all volumes'
complete -c msb -n "__fish_msb_using_subcommand vol; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -f -a "ls" -d 'List all volumes'
complete -c msb -n "__fish_msb_using_subcommand vol; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -f -a "inspect" -d 'Show detailed volume information'
complete -c msb -n "__fish_msb_using_subcommand vol; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -f -a "remove" -d 'Delete one or more volumes'
complete -c msb -n "__fish_msb_using_subcommand vol; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -f -a "rm" -d 'Delete one or more volumes'
complete -c msb -n "__fish_msb_using_subcommand vol; and not __fish_seen_subcommand_from create list ls inspect remove rm help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from create" -s n -l name -d 'Name for the new volume' -r
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from create" -l kind -d 'Volume kind' -r -f -a "dir\t''
disk\t''"
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from create" -l size -d 'Disk capacity for disk volumes (e.g. 10G, 512M)' -r
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from create" -s q -l quiet -d 'Suppress output'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from create" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from create" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from create" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from create" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from create" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from create" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from list" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Show only volume names'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from list" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from list" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from list" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from list" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from list" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from list" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from ls" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Show only volume names'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from ls" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from ls" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from ls" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from ls" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from ls" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from ls" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from inspect" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from inspect" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from inspect" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from inspect" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from inspect" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from inspect" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from inspect" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from remove" -s q -l quiet -d 'Suppress output'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from remove" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from remove" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from remove" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from remove" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from remove" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from remove" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from remove" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from rm" -s q -l quiet -d 'Suppress output'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from rm" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from rm" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from rm" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from rm" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from rm" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from rm" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from rm" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from help" -f -a "create" -d 'Create a new named volume'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from help" -f -a "list" -d 'List all volumes'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from help" -f -a "inspect" -d 'Show detailed volume information'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from help" -f -a "remove" -d 'Delete one or more volumes'
complete -c msb -n "__fish_msb_using_subcommand vol; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "create" -d 'Create a disk snapshot, or include memory and execution state with --full'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "list" -d 'List indexed snapshots'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "ls" -d 'List indexed snapshots'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "inspect" -d 'Show detailed snapshot information'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "verify" -d 'Verify recorded snapshot content integrity'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "remove" -d 'Delete one or more snapshots'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "rm" -d 'Delete one or more snapshots'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "reindex" -d 'Rebuild the local index from artifacts on disk'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "save" -d 'Save a snapshot into a `.msb` archive (tar + zstd)'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "load" -d 'Load a snapshot archive into the snapshots directory'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "head" -d 'Read a group\'s head, or select a member as its head'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from create" -l group -d 'Snapshot group to create or add to (defaults to the source sandbox name)' -r
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from create" -l from-sandbox -d 'Source sandbox name. Disk capture also supports running and user-paused sources' -r
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from create" -l dest-dir -d 'Parent directory to create the artifact in, instead of the default snapshots directory. The group is created under this root' -r -F
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from create" -s o -l output -d 'Write directly to an archive without installing a snapshot directory' -r -F
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from create" -l label -d 'Add a `key=value` label. May be repeated' -r
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from create" -l guest-flush -d 'Guest writeback: auto (disk-only default), required, or skip. Mandatory barriers remain' -r
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from create" -l plain-tar -d 'Write a plain tar archive instead of zstd-compressed tar'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from create" -s f -l force -d 'Overwrite an existing archive file; installed group members are immutable'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from create" -l integrity -d 'Compute and record content integrity while creating the snapshot'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from create" -l full -d 'Capture disk, memory, execution, and device state from a running sandbox'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from create" -s q -l quiet -d 'Suppress output'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from create" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from create" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from create" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from create" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from create" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from create" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from list" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Show only digests'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from list" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from list" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from list" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from list" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from list" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from list" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from ls" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Show only digests'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from ls" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from ls" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from ls" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from ls" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from ls" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from ls" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from inspect" -l verify -d 'Also verify recorded content integrity'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from inspect" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from inspect" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from inspect" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from inspect" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from inspect" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from inspect" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from inspect" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from verify" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from verify" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from verify" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from verify" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from verify" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from verify" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from verify" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from remove" -s f -l force -d 'Remove even if the snapshot has indexed children'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from remove" -s q -l quiet -d 'Suppress output'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from remove" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from remove" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from remove" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from remove" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from remove" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from remove" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from remove" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from rm" -s f -l force -d 'Remove even if the snapshot has indexed children'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from rm" -s q -l quiet -d 'Suppress output'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from rm" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from rm" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from rm" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from rm" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from rm" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from rm" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from rm" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from reindex" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from reindex" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from reindex" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from reindex" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from reindex" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from reindex" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from reindex" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from save" -l since -d 'Omit disk layers and RAM objects supplied by an exact base snapshot or standalone archive' -r
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from save" -l last-layers -d 'Export only the newest N sealed disk layers (load requires the omitted base)' -r
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from save" -l with-parents -d 'Walk the parent chain and include each ancestor in the archive'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from save" -l with-image -d 'Include the OCI image artifacts (EROFS layers + VMDK) so the archive boots offline on the target machine'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from save" -l plain-tar -d 'Write plain tar instead of zstd-compressed tar. Tradeoff: smaller CPU but much larger file for sparse uppers'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from save" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from save" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from save" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from save" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from save" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from save" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from save" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from load" -l dest -d 'Destination directory (defaults to `~/.microsandbox/snapshots/`)' -r -F
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from load" -l base -d 'External base snapshot or standalone archive if batch/group members cannot supply dependencies' -r
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from load" -l group -d 'Import into this group (generated when omitted)' -r
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from load" -l set-head -d 'Select the batch\'s unique tip as head even if it is not a fast-forward'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from load" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from load" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from load" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from load" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from load" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from load" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from load" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from head" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from head" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from head" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from head" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from head" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from head" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from head" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from head" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from help" -f -a "create" -d 'Create a disk snapshot, or include memory and execution state with --full'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from help" -f -a "list" -d 'List indexed snapshots'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from help" -f -a "inspect" -d 'Show detailed snapshot information'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from help" -f -a "verify" -d 'Verify recorded snapshot content integrity'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from help" -f -a "remove" -d 'Delete one or more snapshots'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from help" -f -a "reindex" -d 'Rebuild the local index from artifacts on disk'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from help" -f -a "save" -d 'Save a snapshot into a `.msb` archive (tar + zstd)'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from help" -f -a "load" -d 'Load a snapshot archive into the snapshots directory'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from help" -f -a "head" -d 'Read a group\'s head, or select a member as its head'
complete -c msb -n "__fish_msb_using_subcommand snapshot; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand snap; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snap; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snap; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snap; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "create" -d 'Create a disk snapshot, or include memory and execution state with --full'
complete -c msb -n "__fish_msb_using_subcommand snap; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "list" -d 'List indexed snapshots'
complete -c msb -n "__fish_msb_using_subcommand snap; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "ls" -d 'List indexed snapshots'
complete -c msb -n "__fish_msb_using_subcommand snap; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "inspect" -d 'Show detailed snapshot information'
complete -c msb -n "__fish_msb_using_subcommand snap; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "verify" -d 'Verify recorded snapshot content integrity'
complete -c msb -n "__fish_msb_using_subcommand snap; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "remove" -d 'Delete one or more snapshots'
complete -c msb -n "__fish_msb_using_subcommand snap; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "rm" -d 'Delete one or more snapshots'
complete -c msb -n "__fish_msb_using_subcommand snap; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "reindex" -d 'Rebuild the local index from artifacts on disk'
complete -c msb -n "__fish_msb_using_subcommand snap; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "save" -d 'Save a snapshot into a `.msb` archive (tar + zstd)'
complete -c msb -n "__fish_msb_using_subcommand snap; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "load" -d 'Load a snapshot archive into the snapshots directory'
complete -c msb -n "__fish_msb_using_subcommand snap; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "head" -d 'Read a group\'s head, or select a member as its head'
complete -c msb -n "__fish_msb_using_subcommand snap; and not __fish_seen_subcommand_from create list ls inspect verify remove rm reindex save load head help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from create" -l group -d 'Snapshot group to create or add to (defaults to the source sandbox name)' -r
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from create" -l from-sandbox -d 'Source sandbox name. Disk capture also supports running and user-paused sources' -r
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from create" -l dest-dir -d 'Parent directory to create the artifact in, instead of the default snapshots directory. The group is created under this root' -r -F
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from create" -s o -l output -d 'Write directly to an archive without installing a snapshot directory' -r -F
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from create" -l label -d 'Add a `key=value` label. May be repeated' -r
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from create" -l guest-flush -d 'Guest writeback: auto (disk-only default), required, or skip. Mandatory barriers remain' -r
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from create" -l plain-tar -d 'Write a plain tar archive instead of zstd-compressed tar'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from create" -s f -l force -d 'Overwrite an existing archive file; installed group members are immutable'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from create" -l integrity -d 'Compute and record content integrity while creating the snapshot'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from create" -l full -d 'Capture disk, memory, execution, and device state from a running sandbox'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from create" -s q -l quiet -d 'Suppress output'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from create" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from create" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from create" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from create" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from create" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from create" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from create" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from list" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Show only digests'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from list" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from list" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from list" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from list" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from list" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from list" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from ls" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from ls" -s q -l quiet -d 'Show only digests'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from ls" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from ls" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from ls" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from ls" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from ls" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from ls" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from ls" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from inspect" -l verify -d 'Also verify recorded content integrity'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from inspect" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from inspect" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from inspect" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from inspect" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from inspect" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from inspect" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from inspect" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from verify" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from verify" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from verify" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from verify" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from verify" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from verify" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from verify" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from remove" -s f -l force -d 'Remove even if the snapshot has indexed children'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from remove" -s q -l quiet -d 'Suppress output'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from remove" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from remove" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from remove" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from remove" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from remove" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from remove" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from remove" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from rm" -s f -l force -d 'Remove even if the snapshot has indexed children'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from rm" -s q -l quiet -d 'Suppress output'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from rm" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from rm" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from rm" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from rm" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from rm" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from rm" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from rm" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from reindex" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from reindex" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from reindex" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from reindex" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from reindex" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from reindex" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from reindex" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from save" -l since -d 'Omit disk layers and RAM objects supplied by an exact base snapshot or standalone archive' -r
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from save" -l last-layers -d 'Export only the newest N sealed disk layers (load requires the omitted base)' -r
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from save" -l with-parents -d 'Walk the parent chain and include each ancestor in the archive'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from save" -l with-image -d 'Include the OCI image artifacts (EROFS layers + VMDK) so the archive boots offline on the target machine'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from save" -l plain-tar -d 'Write plain tar instead of zstd-compressed tar. Tradeoff: smaller CPU but much larger file for sparse uppers'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from save" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from save" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from save" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from save" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from save" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from save" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from save" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from load" -l dest -d 'Destination directory (defaults to `~/.microsandbox/snapshots/`)' -r -F
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from load" -l base -d 'External base snapshot or standalone archive if batch/group members cannot supply dependencies' -r
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from load" -l group -d 'Import into this group (generated when omitted)' -r
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from load" -l set-head -d 'Select the batch\'s unique tip as head even if it is not a fast-forward'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from load" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from load" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from load" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from load" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from load" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from load" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from load" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from head" -l format -d 'Output format (json)' -r -f -a "json\t''"
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from head" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from head" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from head" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from head" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from head" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from head" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from head" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from help" -f -a "create" -d 'Create a disk snapshot, or include memory and execution state with --full'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from help" -f -a "list" -d 'List indexed snapshots'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from help" -f -a "inspect" -d 'Show detailed snapshot information'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from help" -f -a "verify" -d 'Verify recorded snapshot content integrity'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from help" -f -a "remove" -d 'Delete one or more snapshots'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from help" -f -a "reindex" -d 'Rebuild the local index from artifacts on disk'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from help" -f -a "save" -d 'Save a snapshot into a `.msb` archive (tar + zstd)'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from help" -f -a "load" -d 'Load a snapshot archive into the snapshots directory'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from help" -f -a "head" -d 'Read a group\'s head, or select a member as its head'
complete -c msb -n "__fish_msb_using_subcommand snap; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand install" -l conf -d 'Load a sparse single-sandbox configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand install" -l net-conf -d 'Load an unwrapped network configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand install" -l resource-conf -d 'Load an unwrapped resource and lifecycle configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand install" -l runtime-conf -d 'Load an unwrapped runtime configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand install" -l fs-conf -d 'Load an unwrapped filesystem configuration' -r -F
complete -c msb -n "__fish_msb_using_subcommand install" -l secret-conf -d 'Load an unwrapped secret-name map' -r -F
complete -c msb -n "__fish_msb_using_subcommand install" -l script-conf -d 'Load an unwrapped script-name map' -r -F
complete -c msb -n "__fish_msb_using_subcommand install" -s n -l name -d 'Command name for the alias (defaults to image name)' -r
complete -c msb -n "__fish_msb_using_subcommand install" -s c -l cpus -d 'Number of virtual CPUs to allocate' -r
complete -c msb -n "__fish_msb_using_subcommand install" -s m -l memory -d 'Amount of memory to allocate (e.g. 512M, 1G)' -r
complete -c msb -n "__fish_msb_using_subcommand install" -s v -l volume -d 'Mount a host path or named volume into the sandbox (`SOURCE:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand install" -l mount-dir -d 'Explicitly mount a host directory into the sandbox (`SOURCE:DEST[:OPTIONS]`). OPTIONS may include `quota=<size>`' -r
complete -c msb -n "__fish_msb_using_subcommand install" -l mount-file -d 'Explicitly mount a host file into the sandbox (`SOURCE:DEST[:OPTIONS]`). OPTIONS may include `quota=<size>`' -r
complete -c msb -n "__fish_msb_using_subcommand install" -l mount-disk -d 'Explicitly mount a disk image into the sandbox (`SOURCE:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand install" -l mount-named -d 'Explicitly mount a named volume into the sandbox (`NAME:DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand install" -l mount-owned -d 'Create private storage removed with the sandbox (`DEST[:OPTIONS]`)' -r
complete -c msb -n "__fish_msb_using_subcommand install" -s w -l workdir -d 'Set the default working directory for commands' -r
complete -c msb -n "__fish_msb_using_subcommand install" -l shell -d 'Shell to use for interactive sessions (default: /bin/sh)' -r
complete -c msb -n "__fish_msb_using_subcommand install" -s e -l env -d 'Set an environment variable (KEY=value)' -r
complete -c msb -n "__fish_msb_using_subcommand install" -s f -l force -d 'Overwrite an existing alias with the same name'
complete -c msb -n "__fish_msb_using_subcommand install" -l no-pull -d 'Don\'t pull the image before installing'
complete -c msb -n "__fish_msb_using_subcommand install" -l tmp -d 'Create a fresh sandbox on every invocation (no persistent state)'
complete -c msb -n "__fish_msb_using_subcommand install" -s l -l list -d 'List all installed sandbox commands'
complete -c msb -n "__fish_msb_using_subcommand install" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand install" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand install" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand install" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand install" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand install" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand install" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand uninstall" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand uninstall" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand uninstall" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand uninstall" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand uninstall" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand uninstall" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand uninstall" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand doctor" -l fix -d 'Attempt supported host virtualization setup fixes'
complete -c msb -n "__fish_msb_using_subcommand doctor" -s y -l yes -d 'Apply fixes without prompting for confirmation'
complete -c msb -n "__fish_msb_using_subcommand doctor" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand doctor" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand doctor" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand doctor" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand doctor" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand doctor" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand doctor" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand update" -s f -l force -d 'Re-download even if already on the latest version'
complete -c msb -n "__fish_msb_using_subcommand update" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand update" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand update" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand update" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand update" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand update" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand update" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand upgrade" -s f -l force -d 'Re-download even if already on the latest version'
complete -c msb -n "__fish_msb_using_subcommand upgrade" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand upgrade" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand upgrade" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand upgrade" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand upgrade" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand upgrade" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand upgrade" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand downgrade" -s y -l yes -d 'Skip destructive-step confirmations'
complete -c msb -n "__fish_msb_using_subcommand downgrade" -s f -l force -d 'Re-download and reinstall the target release'
complete -c msb -n "__fish_msb_using_subcommand downgrade" -l keep-cache -d 'Keep the image cache even when rollback metadata marks it affected'
complete -c msb -n "__fish_msb_using_subcommand downgrade" -l no-backup -d 'Skip the database backup before rolling back local state'
complete -c msb -n "__fish_msb_using_subcommand downgrade" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand downgrade" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand downgrade" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand downgrade" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand downgrade" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand downgrade" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand downgrade" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand self; and not __fish_seen_subcommand_from doctor check update upgrade downgrade uninstall help" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand self; and not __fish_seen_subcommand_from doctor check update upgrade downgrade uninstall help" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and not __fish_seen_subcommand_from doctor check update upgrade downgrade uninstall help" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and not __fish_seen_subcommand_from doctor check update upgrade downgrade uninstall help" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and not __fish_seen_subcommand_from doctor check update upgrade downgrade uninstall help" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and not __fish_seen_subcommand_from doctor check update upgrade downgrade uninstall help" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand self; and not __fish_seen_subcommand_from doctor check update upgrade downgrade uninstall help" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand self; and not __fish_seen_subcommand_from doctor check update upgrade downgrade uninstall help" -f -a "doctor" -d 'Check local runtime and host virtualization prerequisites'
complete -c msb -n "__fish_msb_using_subcommand self; and not __fish_seen_subcommand_from doctor check update upgrade downgrade uninstall help" -f -a "check" -d 'Check local runtime and host virtualization prerequisites'
complete -c msb -n "__fish_msb_using_subcommand self; and not __fish_seen_subcommand_from doctor check update upgrade downgrade uninstall help" -f -a "update" -d 'Update msb and libkrunfw to the latest release'
complete -c msb -n "__fish_msb_using_subcommand self; and not __fish_seen_subcommand_from doctor check update upgrade downgrade uninstall help" -f -a "upgrade" -d 'Update msb and libkrunfw to the latest release'
complete -c msb -n "__fish_msb_using_subcommand self; and not __fish_seen_subcommand_from doctor check update upgrade downgrade uninstall help" -f -a "downgrade" -d 'Downgrade msb and local state to an older supported release'
complete -c msb -n "__fish_msb_using_subcommand self; and not __fish_seen_subcommand_from doctor check update upgrade downgrade uninstall help" -f -a "uninstall" -d 'Remove msb, libkrunfw, and command links'
complete -c msb -n "__fish_msb_using_subcommand self; and not __fish_seen_subcommand_from doctor check update upgrade downgrade uninstall help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from doctor" -l fix -d 'Attempt supported host virtualization setup fixes'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from doctor" -s y -l yes -d 'Apply fixes without prompting for confirmation'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from doctor" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from doctor" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from doctor" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from doctor" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from doctor" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from doctor" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from doctor" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from check" -l fix -d 'Attempt supported host virtualization setup fixes'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from check" -s y -l yes -d 'Apply fixes without prompting for confirmation'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from check" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from check" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from check" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from check" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from check" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from check" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from check" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from update" -s f -l force -d 'Re-download even if already on the latest version'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from update" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from update" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from update" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from update" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from update" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from update" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from update" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from upgrade" -s f -l force -d 'Re-download even if already on the latest version'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from upgrade" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from upgrade" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from upgrade" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from upgrade" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from upgrade" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from upgrade" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from upgrade" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from downgrade" -s y -l yes -d 'Skip destructive-step confirmations'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from downgrade" -s f -l force -d 'Re-download and reinstall the target release'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from downgrade" -l keep-cache -d 'Keep the image cache even when rollback metadata marks it affected'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from downgrade" -l no-backup -d 'Skip the database backup before rolling back local state'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from downgrade" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from downgrade" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from downgrade" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from downgrade" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from downgrade" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from downgrade" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from downgrade" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from uninstall" -s y -l yes -d 'Skip confirmation prompt and remove everything'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from uninstall" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from uninstall" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from uninstall" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from uninstall" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from uninstall" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from uninstall" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from uninstall" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from help" -f -a "doctor" -d 'Check local runtime and host virtualization prerequisites'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from help" -f -a "update" -d 'Update msb and libkrunfw to the latest release'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from help" -f -a "downgrade" -d 'Downgrade msb and local state to an older supported release'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from help" -f -a "uninstall" -d 'Remove msb, libkrunfw, and command links'
complete -c msb -n "__fish_msb_using_subcommand self; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand completion" -l tree -d 'Print the full command tree and exit'
complete -c msb -n "__fish_msb_using_subcommand completion" -l error -d 'Show error-level diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand completion" -l warn -d 'Show warning and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand completion" -l info -d 'Show info, warning, and error diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand completion" -l debug -d 'Show debug and higher diagnostic logs'
complete -c msb -n "__fish_msb_using_subcommand completion" -l trace -d 'Show all diagnostic logs (most verbose)'
complete -c msb -n "__fish_msb_using_subcommand completion" -s h -l help -d 'Print help'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "machine" -d 'Run the VM process (internal)'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "__launch-protocol" -d 'Report launch wire capabilities without initializing a backend'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "sandbox" -d 'Manage sandboxes (also available as top-level commands)'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "run" -d 'Create a sandbox from an image and run a command in it'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "create" -d 'Create a sandbox and boot it in the background'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "restore" -d 'Restore a snapshot into a new detached sandbox'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "modify" -d 'Modify sandbox configuration'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "start" -d 'Start a stopped sandbox'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "stop" -d 'Stop one or more running sandboxes'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "pause" -d 'Suspend a resident sandbox without creating a snapshot'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "branch" -d 'Branch running execution into a new local CoW child without a durable full snapshot'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "resume" -d 'Resume a user-paused resident sandbox'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "restart" -d 'Restart one or more sandboxes'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "ping" -d 'Check whether one or more sandbox agents are reachable'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "touch" -d 'Refresh idle activity for one or more running sandboxes'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "list" -d 'List all sandboxes'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "status" -d 'Show sandbox status'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "metrics" -d 'Show live metrics for a running sandbox'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "remove" -d 'Remove one or more sandboxes'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "exec" -d 'Run a command in a running sandbox'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "copy" -d 'Copy files between the host and a sandbox'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "logs" -d 'Show captured output from a sandbox'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "inspect" -d 'Show detailed sandbox configuration and status'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "__schema-baseline" -d 'Print the schema baseline owned by this binary (internal)'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "context" -d 'Show the active backend and its selection source'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "image" -d 'Manage OCI images'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "pull" -d 'Download an image from a registry'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "load" -d 'Load an image archive from tar'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "save" -d 'Save one or more cached images to a tar archive'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "registry" -d 'Manage registry credentials'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "ssh" -d 'Connect to a sandbox over SSH'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "images" -d 'List cached images (alias for `image ls`)'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "volumes" -d 'List named volumes (alias for `volume ls`)'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "snapshots" -d 'List disk snapshots (alias for `snapshot ls`)'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "registries" -d 'List configured registries (alias for `registry ls`)'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "rmi" -d 'Remove a cached image (alias for `image rm`)'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "volume" -d 'Manage named volumes'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "snapshot" -d 'Manage disk snapshots'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "install" -d 'Install a sandbox as a system command'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "uninstall" -d 'Remove an installed sandbox command'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "doctor" -d 'Check local runtime and host virtualization prerequisites'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "update" -d 'Update msb and libkrunfw to the latest release (alias for `self update`)'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "downgrade" -d 'Downgrade msb and local state to an older supported release (alias for `self downgrade`)'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "self" -d 'Manage the msb installation'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "completion" -d 'Generate a shell completion script'
complete -c msb -n "__fish_msb_using_subcommand help; and not __fish_seen_subcommand_from machine __launch-protocol sandbox run create restore modify start stop pause branch resume restart ping touch list status metrics remove exec copy logs inspect __schema-baseline context image pull load save registry ssh images volumes snapshots registries rmi volume snapshot install uninstall doctor update downgrade self completion help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from sandbox" -f -a "run" -d 'Create a sandbox from an image and run a command in it'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from sandbox" -f -a "create" -d 'Create a sandbox and boot it in the background'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from sandbox" -f -a "restore" -d 'Restore a snapshot into a new detached sandbox'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from sandbox" -f -a "modify" -d 'Modify sandbox configuration'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from sandbox" -f -a "start" -d 'Start a stopped sandbox'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from sandbox" -f -a "stop" -d 'Stop one or more running sandboxes'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from sandbox" -f -a "pause" -d 'Suspend a resident sandbox without creating a snapshot'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from sandbox" -f -a "branch" -d 'Branch running execution into a new local CoW child without a durable full snapshot'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from sandbox" -f -a "resume" -d 'Resume a user-paused resident sandbox'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from sandbox" -f -a "restart" -d 'Restart one or more sandboxes'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from sandbox" -f -a "ping" -d 'Check whether one or more sandbox agents are reachable'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from sandbox" -f -a "touch" -d 'Refresh idle activity for one or more running sandboxes'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from sandbox" -f -a "list" -d 'List all sandboxes'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from sandbox" -f -a "status" -d 'Show sandbox status'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from sandbox" -f -a "metrics" -d 'Show live metrics for a running sandbox'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from sandbox" -f -a "remove" -d 'Remove one or more sandboxes'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from sandbox" -f -a "exec" -d 'Run a command in a running sandbox'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from sandbox" -f -a "copy" -d 'Copy files between the host and a sandbox'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from sandbox" -f -a "logs" -d 'Show captured output from a sandbox'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from sandbox" -f -a "inspect" -d 'Show detailed sandbox configuration and status'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from image" -f -a "pull" -d 'Download an image from a container registry'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from image" -f -a "list" -d 'List locally cached images'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from image" -f -a "inspect" -d 'Show detailed image information'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from image" -f -a "load" -d 'Load an image archive from tar'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from image" -f -a "save" -d 'Save one or more cached images to a tar archive'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from image" -f -a "remove" -d 'Delete one or more cached images'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from image" -f -a "prune" -d 'Remove cached images not used by sandboxes'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from registry" -f -a "login" -d 'Store credentials for a registry in the OS credential store'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from registry" -f -a "logout" -d 'Remove stored credentials for a registry'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from registry" -f -a "list" -d 'List configured registries without printing secrets'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from ssh" -f -a "connect" -d 'Connect to a sandbox over SSH'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from ssh" -f -a "serve" -d 'Serve a sandbox over SSH'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from ssh" -f -a "authorize" -d 'Add a public key to microsandbox SSH authorization'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from volume" -f -a "create" -d 'Create a new named volume'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from volume" -f -a "list" -d 'List all volumes'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from volume" -f -a "inspect" -d 'Show detailed volume information'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from volume" -f -a "remove" -d 'Delete one or more volumes'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from snapshot" -f -a "create" -d 'Create a disk snapshot, or include memory and execution state with --full'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from snapshot" -f -a "list" -d 'List indexed snapshots'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from snapshot" -f -a "inspect" -d 'Show detailed snapshot information'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from snapshot" -f -a "verify" -d 'Verify recorded snapshot content integrity'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from snapshot" -f -a "remove" -d 'Delete one or more snapshots'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from snapshot" -f -a "reindex" -d 'Rebuild the local index from artifacts on disk'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from snapshot" -f -a "save" -d 'Save a snapshot into a `.msb` archive (tar + zstd)'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from snapshot" -f -a "load" -d 'Load a snapshot archive into the snapshots directory'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from snapshot" -f -a "head" -d 'Read a group\'s head, or select a member as its head'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from self" -f -a "doctor" -d 'Check local runtime and host virtualization prerequisites'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from self" -f -a "update" -d 'Update msb and libkrunfw to the latest release'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from self" -f -a "downgrade" -d 'Downgrade msb and local state to an older supported release'
complete -c msb -n "__fish_msb_using_subcommand help; and __fish_seen_subcommand_from self" -f -a "uninstall" -d 'Remove msb, libkrunfw, and command links'
