#!/usr/bin/env fish
# fish completion support for rei v0.1.0

function __fish_rei_using_command
  set -l cmds __rei __rei_init __rei_validate __rei_refresh_docs __rei_activate __rei_deactivate __rei_list __rei_add __rei_completions __rei_completions_bash __rei_completions_fish __rei_completions_zsh
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

complete -c rei -n '__fish_rei_using_command __rei' -s h -l help -x -k -f -d 'Show this help.'
complete -c rei -n '__fish_rei_using_command __rei' -s V -l version -x -k -f -d 'Show the version number for this program.'
complete -c rei -n '__fish_rei_using_command __rei' -k -f -a init -d 'Initialize a new skill from template'
complete -c rei -n '__fish_rei_using_command __rei_init' -k -f -a '(rei completions complete string init)'
complete -c rei -n '__fish_rei_using_command __rei_init' -s h -l help -x -k -f -d 'Show this help.'
complete -c rei -n '__fish_rei_using_command __rei_init' -s p -l path -k -f -r -a '(rei completions complete string init)' -d 'Base path for new skill'
complete -c rei -n '__fish_rei_using_command __rei_init' -s f -l fork -k -f -r -a '(rei completions complete string init)' -d 'Use a GitHub repo as the skill basis (main branch HEAD)'
complete -c rei -n '__fish_rei_using_command __rei' -k -f -a validate -d 'Validate skill structure and frontmatter'
complete -c rei -n '__fish_rei_using_command __rei_validate' -k -f -a '(rei completions complete string validate)'
complete -c rei -n '__fish_rei_using_command __rei_validate' -s h -l help -x -k -f -d 'Show this help.'
complete -c rei -n '__fish_rei_using_command __rei' -k -f -a refresh-docs -d 'Fetch latest Anthropic skill documentation'
complete -c rei -n '__fish_rei_using_command __rei_refresh_docs' -s h -l help -x -k -f -d 'Show this help.'
complete -c rei -n '__fish_rei_using_command __rei' -k -f -a activate -d 'Move skill from deactivated to active'
complete -c rei -n '__fish_rei_using_command __rei_activate' -k -f -a '(rei completions complete deactivated-skill activate)'
complete -c rei -n '__fish_rei_using_command __rei_activate' -s h -l help -x -k -f -d 'Show this help.'
complete -c rei -n '__fish_rei_using_command __rei' -k -f -a deactivate -d 'Move skill from active to deactivated'
complete -c rei -n '__fish_rei_using_command __rei_deactivate' -k -f -a '(rei completions complete active-skill deactivate)'
complete -c rei -n '__fish_rei_using_command __rei_deactivate' -s h -l help -x -k -f -d 'Show this help.'
complete -c rei -n '__fish_rei_using_command __rei' -k -f -a list -d 'List skills'
complete -c rei -n '__fish_rei_using_command __rei_list' -s h -l help -x -k -f -d 'Show this help.'
complete -c rei -n '__fish_rei_using_command __rei_list' -s a -l all -k -f -d 'Include deactivated skills'
complete -c rei -n '__fish_rei_using_command __rei' -k -f -a add -d 'Add skill(s) from a GitHub tree URL — single skill or a whole skills directory'
complete -c rei -n '__fish_rei_using_command __rei_add' -k -f -a '(rei completions complete string add)'
complete -c rei -n '__fish_rei_using_command __rei_add' -s h -l help -x -k -f -d 'Show this help.'
complete -c rei -n '__fish_rei_using_command __rei_add' -s p -l path -k -f -r -a '(rei completions complete string add)' -d 'Destination directory for added skills'
complete -c rei -n '__fish_rei_using_command __rei' -k -f -a completions -d 'Generate shell completions.'
complete -c rei -n '__fish_rei_using_command __rei_completions' -s h -l help -x -k -f -d 'Show this help.'
complete -c rei -n '__fish_rei_using_command __rei_completions' -k -f -a bash -d 'Generate shell completions for bash.'
complete -c rei -n '__fish_rei_using_command __rei_completions_bash' -s h -l help -x -k -f -d 'Show this help.'
complete -c rei -n '__fish_rei_using_command __rei_completions_bash' -s n -l name -k -f -r -a '(rei completions complete string completions bash)' -d 'The name of the main command.'
complete -c rei -n '__fish_rei_using_command __rei_completions' -k -f -a fish -d 'Generate shell completions for fish.'
complete -c rei -n '__fish_rei_using_command __rei_completions_fish' -s h -l help -x -k -f -d 'Show this help.'
complete -c rei -n '__fish_rei_using_command __rei_completions_fish' -s n -l name -k -f -r -a '(rei completions complete string completions fish)' -d 'The name of the main command.'
complete -c rei -n '__fish_rei_using_command __rei_completions' -k -f -a zsh -d 'Generate shell completions for zsh.'
complete -c rei -n '__fish_rei_using_command __rei_completions_zsh' -s h -l help -x -k -f -d 'Show this help.'
complete -c rei -n '__fish_rei_using_command __rei_completions_zsh' -s n -l name -k -f -r -a '(rei completions complete string completions zsh)' -d 'The name of the main command.'
