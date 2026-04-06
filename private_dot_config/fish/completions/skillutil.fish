# Fish completions for skillutil - Cross-agent Skill management CLI

# Skill directory locations
set -l skills_dir "$HOME/.agents/skills"
set -l deactivated_dir "$HOME/.agents/skills/_deactivated"

# Helper: list active skill names (directories in skills_dir, excluding internals)
function __skillutil_active_skills
    set -l skills_dir "$HOME/.agents/skills"
    if test -d "$skills_dir"
        for entry in $skills_dir/*/
            set -l name (string replace -r '.*/' '' -- (string trim -r -c / -- $entry))
            # Skip internal dirs (prefixed with _)
            if not string match -q '_*' -- $name
                echo $name
            end
        end
    end
end

# Helper: list deactivated skill names
function __skillutil_deactivated_skills
    set -l deactivated_dir "$HOME/.agents/skills/_deactivated"
    if test -d "$deactivated_dir"
        for entry in $deactivated_dir/*/
            set -l name (string replace -r '.*/' '' -- (string trim -r -c / -- $entry))
            echo $name
        end
    end
end

# Helper: list all skill names (active + deactivated)
function __skillutil_all_skills
    __skillutil_active_skills
    __skillutil_deactivated_skills
end

# Condition: no subcommand yet
function __skillutil_no_subcommand
    set -l cmd (commandline -opc)
    for subcmd in init validate refresh-docs activate deactivate list add completion
        if contains -- $subcmd $cmd
            return 1
        end
    end
    return 0
end

# Condition helpers for specific subcommands
function __skillutil_using_subcommand
    set -l cmd (commandline -opc)
    contains -- $argv[1] $cmd
end

# Disable file completions for skillutil by default
complete -c skillutil -f

# Global options
complete -c skillutil -n __skillutil_no_subcommand -l help -s h -d "Show help"
complete -c skillutil -n __skillutil_no_subcommand -l version -s V -d "Show version"

# Subcommands
complete -c skillutil -n __skillutil_no_subcommand -a init -d "Initialize a new skill from template"
complete -c skillutil -n __skillutil_no_subcommand -a validate -d "Validate skill structure and frontmatter"
complete -c skillutil -n __skillutil_no_subcommand -a refresh-docs -d "Fetch latest Anthropic skill documentation"
complete -c skillutil -n __skillutil_no_subcommand -a activate -d "Move skill from deactivated to active"
complete -c skillutil -n __skillutil_no_subcommand -a deactivate -d "Move skill from active to deactivated"
complete -c skillutil -n __skillutil_no_subcommand -a list -d "List skills"
complete -c skillutil -n __skillutil_no_subcommand -a add -d "Add skill(s) from a GitHub tree URL"
complete -c skillutil -n __skillutil_no_subcommand -a completion -d "Output shell completion script"

# init: skill name arg (suggest existing for reference, but free-form is fine)
complete -c skillutil -n '__skillutil_using_subcommand init' -l path -s p -r -d "Base path for new skill" -F
complete -c skillutil -n '__skillutil_using_subcommand init' -l fork -s f -r -d "GitHub repo URL to fork as skill basis"
complete -c skillutil -n '__skillutil_using_subcommand init' -l help -s h -d "Show help"

# validate: expects a directory path, enable file/dir completions
complete -c skillutil -n '__skillutil_using_subcommand validate' -F
complete -c skillutil -n '__skillutil_using_subcommand validate' -l help -s h -d "Show help"

# refresh-docs: no arguments
complete -c skillutil -n '__skillutil_using_subcommand refresh-docs' -l help -s h -d "Show help"

# activate: complete with deactivated skill names
complete -c skillutil -n '__skillutil_using_subcommand activate' -a '(__skillutil_deactivated_skills)' -d "Deactivated skill"
complete -c skillutil -n '__skillutil_using_subcommand activate' -l help -s h -d "Show help"

# deactivate: complete with active skill names
complete -c skillutil -n '__skillutil_using_subcommand deactivate' -a '(__skillutil_active_skills)' -d "Active skill"
complete -c skillutil -n '__skillutil_using_subcommand deactivate' -l help -s h -d "Show help"

# list
complete -c skillutil -n '__skillutil_using_subcommand list' -l all -s a -d "Include deactivated skills"
complete -c skillutil -n '__skillutil_using_subcommand list' -l help -s h -d "Show help"

# add: expects a GitHub URL (free-form), plus --path flag
complete -c skillutil -n '__skillutil_using_subcommand add' -l path -s p -r -d "Destination directory for added skills" -F
complete -c skillutil -n '__skillutil_using_subcommand add' -l help -s h -d "Show help"

# completion: complete with shell names
complete -c skillutil -n '__skillutil_using_subcommand completion' -a 'fish bash zsh' -d "Shell type"
complete -c skillutil -n '__skillutil_using_subcommand completion' -l help -s h -d "Show help"
