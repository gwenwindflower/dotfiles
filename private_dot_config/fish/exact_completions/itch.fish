complete -c itch -f

complete -c itch -s h -l help -d "Show help"
complete -c itch -s n -l name -d "Repository directory name" -r
complete -c itch -s w -l worktree -d "Add a sibling worktree on a new pushed branch" -r
complete -c itch -s c -l commits -d "Commits on main" -r
complete -c itch -l no-remote -d "Skip the bare origin; branches stay local"
complete -c itch -s p -l parent -d "Directory to create the itch-* root in" -r -a "(__fish_complete_directories)"
