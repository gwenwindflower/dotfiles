function __tackle_installed_repos
    set -l manifest (chezmoi source-path 2>/dev/null)/.utils/fish-plugins.yaml
    test -r $manifest || return
    string match --regex --groups-only '^\s+- repo:\s+(\S+)' <$manifest
end

function __tackle_using_subcommand
    set -l cmd (commandline -opc)
    test (count $cmd) -ge 2 || return 1
    contains -- $cmd[2] $argv
end

set -l tackle_subs list ls add remove rm sync update help

complete -c tackle -f
complete -c tackle -n "not __tackle_using_subcommand $tackle_subs" -a list -d "List installed plugins"
complete -c tackle -n "not __tackle_using_subcommand $tackle_subs" -a add -d "Install a plugin"
complete -c tackle -n "not __tackle_using_subcommand $tackle_subs" -a remove -d "Uninstall a plugin"
complete -c tackle -n "not __tackle_using_subcommand $tackle_subs" -a sync -d "Update plugins (all if no repo given)"
complete -c tackle -n "not __tackle_using_subcommand $tackle_subs" -a help -d "Show help"

complete -c tackle -n "__tackle_using_subcommand remove rm sync update" -a "(__tackle_installed_repos)"
complete -c tackle -n "__tackle_using_subcommand sync update" -l force -d "Re-download even if SHA unchanged"
