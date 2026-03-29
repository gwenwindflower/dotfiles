# Fish completion for vt (Val Town CLI)

# Disable file completions by default
complete -c vt -f

# Global options
complete -c vt -s h -l help -d "Show this help"
complete -c vt -s V -l version -d "Show the version number for this program"

# Commands
complete -c vt -n __fish_use_subcommand -a profile -d "Get information about the currently authenticated user"
complete -c vt -n __fish_use_subcommand -a me -d "Get information about the currently authenticated user"
complete -c vt -n __fish_use_subcommand -a upgrade -d "Upgrade vt executable to latest or given version"
complete -c vt -n __fish_use_subcommand -a clone -d "Clone a Val"
complete -c vt -n __fish_use_subcommand -a push -d "Push local changes to a Val"
complete -c vt -n __fish_use_subcommand -a pull -d "Pull the latest changes for the current Val"
complete -c vt -n __fish_use_subcommand -a status -d "Show the working tree status"
complete -c vt -n __fish_use_subcommand -a branch -d "List or delete branches"
complete -c vt -n __fish_use_subcommand -a checkout -d "Check out a different branch"
complete -c vt -n __fish_use_subcommand -a watch -d "Watch for changes and automatically sync with Val Town"
complete -c vt -n __fish_use_subcommand -a browse -d "Open a Val's main page in a web browser"
complete -c vt -n __fish_use_subcommand -a create -d "Create a new Val"
complete -c vt -n __fish_use_subcommand -a remix -d "Remix a Val"
complete -c vt -n __fish_use_subcommand -a config -d "Manage vt configuration"
complete -c vt -n __fish_use_subcommand -a delete -d "Delete the current Val"
complete -c vt -n __fish_use_subcommand -a list -d "List all your Vals"
complete -c vt -n __fish_use_subcommand -a tail -d "Stream logs of a Val"

# Subcommand-specific completions

# clone [valUri] [targetDir] [branchName] - allow directory completion for targetDir
complete -c vt -n "__fish_seen_subcommand_from clone" -F -d "Target directory"

# checkout <existingBranchName> - no file completion needed
complete -c vt -n "__fish_seen_subcommand_from checkout" -f

# create <valName> [targetDir] - allow directory completion
complete -c vt -n "__fish_seen_subcommand_from create" -F -d "Target directory"

# remix <fromValUri> [newValName] [targetDir] - allow directory completion
complete -c vt -n "__fish_seen_subcommand_from remix" -F -d "Target directory"

# list [offset] - no file completion
complete -c vt -n "__fish_seen_subcommand_from list" -f

# tail [valUri] [branchName] - no file completion
complete -c vt -n "__fish_seen_subcommand_from tail" -f

# Commands with no arguments
complete -c vt -n "__fish_seen_subcommand_from profile me upgrade push pull status branch watch browse config delete" -f
