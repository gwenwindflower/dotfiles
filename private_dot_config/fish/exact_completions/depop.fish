# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_depop_global_optspecs
    string join \n dry-run strict python typescript rust uv deno bun aube pnpm npm cargo go no-python no-typescript no-rust no-uv no-deno no-bun no-aube no-pnpm no-npm no-cargo no-go h/help V/version
end

function __fish_depop_needs_command
    # Figure out if the current invocation already has a command.
    set -l cmd (commandline -opc)
    set -e cmd[1]
    argparse -s (__fish_depop_global_optspecs) -- $cmd 2>/dev/null
    or return
    if set -q argv[1]
        # Also print the command, so this can be used to figure out what it is.
        echo $argv[1]
        return 1
    end
    return 0
end

function __fish_depop_using_subcommand
    set -l cmd (__fish_depop_needs_command)
    test -z "$cmd"
    and return 1
    contains -- $cmd[1] $argv
end

complete -c depop -n "__fish_depop_needs_command" -l dry-run -d 'Print the commands without running them'
complete -c depop -n "__fish_depop_needs_command" -l strict -d 'Exit non-zero when any sync command fails'
complete -c depop -n "__fish_depop_needs_command" -l python -d 'Sync Python dependencies'
complete -c depop -n "__fish_depop_needs_command" -l typescript -d 'Sync TypeScript and JavaScript dependencies'
complete -c depop -n "__fish_depop_needs_command" -l rust -d 'Sync Rust dependencies'
complete -c depop -n "__fish_depop_needs_command" -l uv -d 'Sync uv'
complete -c depop -n "__fish_depop_needs_command" -l deno -d 'Sync deno'
complete -c depop -n "__fish_depop_needs_command" -l bun -d 'Sync bun'
complete -c depop -n "__fish_depop_needs_command" -l aube -d 'Sync aube'
complete -c depop -n "__fish_depop_needs_command" -l pnpm -d 'Sync pnpm'
complete -c depop -n "__fish_depop_needs_command" -l npm -d 'Sync npm when established by package.json or package-lock.json'
complete -c depop -n "__fish_depop_needs_command" -l cargo -d 'Sync Cargo dependencies'
complete -c depop -n "__fish_depop_needs_command" -l go -d 'Sync Go modules'
complete -c depop -n "__fish_depop_needs_command" -l no-python -d 'Skip Python dependencies'
complete -c depop -n "__fish_depop_needs_command" -l no-typescript -d 'Skip TypeScript and JavaScript dependencies'
complete -c depop -n "__fish_depop_needs_command" -l no-rust -d 'Skip Rust dependencies'
complete -c depop -n "__fish_depop_needs_command" -l no-uv -d 'Skip uv'
complete -c depop -n "__fish_depop_needs_command" -l no-deno -d 'Skip deno'
complete -c depop -n "__fish_depop_needs_command" -l no-bun -d 'Skip bun'
complete -c depop -n "__fish_depop_needs_command" -l no-aube -d 'Skip aube'
complete -c depop -n "__fish_depop_needs_command" -l no-pnpm -d 'Skip pnpm'
complete -c depop -n "__fish_depop_needs_command" -l no-npm -d 'Skip npm'
complete -c depop -n "__fish_depop_needs_command" -l no-cargo -d 'Skip Cargo dependencies'
complete -c depop -n "__fish_depop_needs_command" -l no-go -d 'Skip Go modules'
complete -c depop -n "__fish_depop_needs_command" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c depop -n "__fish_depop_needs_command" -s V -l version -d 'Print version'
complete -c depop -n "__fish_depop_needs_command" -a "completions" -d 'Print a shell completion script to stdout'
complete -c depop -n "__fish_depop_using_subcommand completions" -s h -l help -d 'Print help'
