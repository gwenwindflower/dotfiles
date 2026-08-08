# Dynamic completions for linear-cli (fish)
# Source this file or save to ~/.config/fish/completions/linear-cli-dynamic.fish:
#   linear-cli completions dynamic fish > ~/.config/fish/completions/linear-cli-dynamic.fish

# Team completions
complete -c linear-cli -l team -s t -x -a '(linear-cli _complete --type teams 2>/dev/null | string replace \t "\t")'

# Status completions (tries to pick up --team from current command line)
complete -c linear-cli -l status -s s -x -a '(linear-cli _complete --type statuses 2>/dev/null | string replace \t "\t")'

# Project completions
complete -c linear-cli -l project -x -a '(linear-cli _complete --type projects 2>/dev/null | string replace \t "\t")'

# Label completions
complete -c linear-cli -l label -s l -x -a '(linear-cli _complete --type labels 2>/dev/null | string replace \t "\t")'

# User completions
complete -c linear-cli -l assignee -x -a '(linear-cli _complete --type users 2>/dev/null | string replace \t "\t")'
complete -c linear-cli -l user -x -a '(linear-cli _complete --type users 2>/dev/null | string replace \t "\t")'

# Issue ID completions for subcommands that take an issue
for subcmd in get update start close done archive unarchive comment link assign move transfer open
    complete -c linear-cli -n "__fish_seen_subcommand_from $subcmd" -x -a '(linear-cli _complete --type issues 2>/dev/null | string replace \t "\t")'
end
