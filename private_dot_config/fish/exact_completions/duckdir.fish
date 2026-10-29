complete -c duckdir -f
complete -c duckdir -s h -l help -d 'Show help'
complete -c duckdir -n __fish_is_first_arg -a '(__fish_complete_directories)' -d 'Directory to load'
