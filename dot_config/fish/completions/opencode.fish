###-begin-opencode-completions-###
#
# yargs command completion script (fish, with descriptions)
#
# Installation:
#   Save as ~/.config/fish/completions/opencode.fish
#   fish auto-loads completions from this path.
#

function __fish_opencode_yargs_completions
    set -l args (commandline -opc)
    set -l raw (opencode --get-yargs-completions $args 2>/dev/null)

    for line in $raw
        # If backend already returns fish-native "completion<TAB>description", pass through.
        if string match -qr '\t' -- $line
            echo $line
            continue
        end

        # Also accept "completion - description" and convert to fish format.
        if string match -qr '^[^[:space:]].+[[:space:]]-[[:space:]].+$' -- $line
            set -l parts (string split -m 1 ' - ' -- $line)
            if test (count $parts) -eq 2
                echo "$parts[1]\t$parts[2]"
                continue
            end
        end

        # Plain completion (no description)
        echo $line
    end
end

# Keep file completion fallback by not using -f
complete -c opencode -a '(__fish_opencode_yargs_completions)'
###-end-opencode-completions-###
