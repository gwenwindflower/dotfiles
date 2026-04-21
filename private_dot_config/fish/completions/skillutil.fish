#!/usr/bin/env fish
# fish completion support for skillutil v0.1.0

function __fish_skillutil_using_command
  set -l cmds __skillutil __skillutil_init __skillutil_validate __skillutil_refresh_docs __skillutil_activate __skillutil_deactivate __skillutil_list __skillutil_add __skillutil_completions __skillutil_completions_bash __skillutil_completions_fish __skillutil_completions_zsh
  set -l words (commandline -opc)
  set -l cmd "_"
  for word in $words
    switch $word
      case '-*'
        continue
      case '*'
        set word (string replace -r -a '\W' '_' $word)
        set -l cmd_tmp $cmd"_$word"
        if contains $cmd_tmp $cmds
          set cmd $cmd_tmp
        end
    end
  end
  if test "$cmd" = "$argv[1]"
    return 0
  end
  return 1
end

complete -c skillutil -n '__fish_skillutil_using_command __skillutil' -s h -l help -x -k -f -d 'Show this help.'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil' -s V -l version -x -k -f -d 'Show the version number for this program.'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil' -k -f -a init -d 'Initialize a new skill from template'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_init' -k -f -a '(skillutil completions complete string init)'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_init' -s h -l help -x -k -f -d 'Show this help.'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_init' -s p -l path -k -f -r -a '(skillutil completions complete string init)' -d 'Base path for new skill'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_init' -s f -l fork -k -f -r -a '(skillutil completions complete string init)' -d 'Use a GitHub repo as the skill basis (main branch HEAD)'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil' -k -f -a validate -d 'Validate skill structure and frontmatter'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_validate' -k -f -a '(skillutil completions complete string validate)'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_validate' -s h -l help -x -k -f -d 'Show this help.'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil' -k -f -a refresh-docs -d 'Fetch latest Anthropic skill documentation'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_refresh_docs' -s h -l help -x -k -f -d 'Show this help.'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil' -k -f -a activate -d 'Move skill from deactivated to active'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_activate' -k -f -a '(skillutil completions complete deactivated-skill activate)'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_activate' -s h -l help -x -k -f -d 'Show this help.'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil' -k -f -a deactivate -d 'Move skill from active to deactivated'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_deactivate' -k -f -a '(skillutil completions complete active-skill deactivate)'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_deactivate' -s h -l help -x -k -f -d 'Show this help.'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil' -k -f -a list -d 'List skills'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_list' -s h -l help -x -k -f -d 'Show this help.'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_list' -s a -l all -k -f -d 'Include deactivated skills'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil' -k -f -a add -d 'Add skill(s) from a GitHub tree URL — single skill or a whole skills directory'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_add' -k -f -a '(skillutil completions complete string add)'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_add' -s h -l help -x -k -f -d 'Show this help.'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_add' -s p -l path -k -f -r -a '(skillutil completions complete string add)' -d 'Destination directory for added skills'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil' -k -f -a completions -d 'Generate shell completions.'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_completions' -s h -l help -x -k -f -d 'Show this help.'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_completions' -k -f -a bash -d 'Generate shell completions for bash.'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_completions_bash' -s h -l help -x -k -f -d 'Show this help.'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_completions_bash' -s n -l name -k -f -r -a '(skillutil completions complete string completions bash)' -d 'The name of the main command.'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_completions' -k -f -a fish -d 'Generate shell completions for fish.'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_completions_fish' -s h -l help -x -k -f -d 'Show this help.'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_completions_fish' -s n -l name -k -f -r -a '(skillutil completions complete string completions fish)' -d 'The name of the main command.'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_completions' -k -f -a zsh -d 'Generate shell completions for zsh.'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_completions_zsh' -s h -l help -x -k -f -d 'Show this help.'
complete -c skillutil -n '__fish_skillutil_using_command __skillutil_completions_zsh' -s n -l name -k -f -r -a '(skillutil completions complete string completions zsh)' -d 'The name of the main command.'
