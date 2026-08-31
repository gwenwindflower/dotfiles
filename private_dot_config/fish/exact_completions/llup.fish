complete -c llup -f
complete -c llup -s h -l help -d "Show help"
complete -c llup -n __fish_use_subcommand -a start -d "Load and start the embedding server"
complete -c llup -n __fish_use_subcommand -a stop -d "Stop and unload the embedding server"
complete -c llup -n __fish_use_subcommand -a restart -d "Restart the loaded server"
complete -c llup -n __fish_use_subcommand -a status -d "Show launchd state and model readiness"
complete -c llup -n __fish_use_subcommand -a logs -d "Show recent server log lines"
