complete -c gbcp -f
complete -c gbcp -s h -l help -d "Show help"
complete -c gbcp -s n -l dry-run -d "Print the value instead of copying it"
complete -c gbcp -s w -l with-worktree -d "Include the base repo name for the main worktree"
complete -c gbcp -n "not __fish_seen_subcommand_from branch worktree worktree.branch b w wb" -a "branch\t'Copy the current branch' worktree\t'Copy the current worktree' worktree.branch\t'Copy worktree.branch'"
