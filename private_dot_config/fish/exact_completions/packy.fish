set -l packy_subcommands add a remove rm list ls diff d check c upgrade up sync s

complete -c packy -f

complete -c packy -n "not __fish_seen_subcommand_from $packy_subcommands" -a add -d "Install and track packages"
complete -c packy -n "not __fish_seen_subcommand_from $packy_subcommands" -a remove -d "Uninstall and untrack packages"
complete -c packy -n "not __fish_seen_subcommand_from $packy_subcommands" -a list -d "Show tracked packages"
complete -c packy -n "not __fish_seen_subcommand_from $packy_subcommands" -a diff -d "Show manifest drift"
complete -c packy -n "not __fish_seen_subcommand_from $packy_subcommands" -a check -d "Check for cross-profile duplicates"
complete -c packy -n "not __fish_seen_subcommand_from $packy_subcommands" -a upgrade -d "Upgrade packages"
complete -c packy -n "not __fish_seen_subcommand_from $packy_subcommands" -a sync -d "Install missing tracked packages"

complete -c packy -s h -l help -d "Show help"
complete -c packy -s d -l dry-run -d "Preview without changing packages or the manifest"
complete -c packy -s v -l verbose -d "Show extra detail"
complete -c packy -s m -l manager -d "Limit the package manager" -r -f -a "formula cask tap cargo uv"
complete -c packy -n "__fish_seen_subcommand_from add a" -s p -l profile -d "Set the target profile" -r -f -a "core personal work"
