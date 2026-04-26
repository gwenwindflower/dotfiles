# Completions for rip (rm-improved)
# https://github.com/nivekuil/rip

# Flags
complete -c rip -s d -l decompose -d "Permanently delete the entire graveyard"
complete -c rip -s h -l help -d "Print help information"
complete -c rip -s i -l inspect -d "Print info about TARGET before prompting for action"
complete -c rip -s s -l seance -d "Print files that were sent under the current directory"
complete -c rip -s V -l version -d "Print version information"

# Options
complete -c rip -l graveyard -r -d "Directory where deleted files go to rest" -a "(__fish_complete_directories)"
complete -c rip -s u -l unbury -r -d "Undo the last removal, or specify file(s) in graveyard" -a "(__fish_complete_path)"
