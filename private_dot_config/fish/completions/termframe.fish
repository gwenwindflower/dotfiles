complete -c termframe -l config -d 'Configuration file path' -r
complete -c termframe -s W -l width -d 'Terminal width: N|auto|MIN..MAX[:STEP][@INIT]' -r
complete -c termframe -s H -l height -d 'Terminal height: N|auto|MIN..MAX[:STEP][@INIT]' -r
complete -c termframe -l padding -d 'Override padding for the inner text in font size units' -r
complete -c termframe -l font-family -d 'Font family' -r
complete -c termframe -l font-size -d 'Font size' -r
complete -c termframe -l font-weight -d 'Normal font weight' -r
complete -c termframe -l embed-fonts -d 'Embed fonts' -r -f -a "true\t''
false\t''"
complete -c termframe -l subset-fonts -d 'Subset fonts' -r -f -a "true\t''
false\t''"
complete -c termframe -l bold-is-bright -d 'Bright bold text' -r -f -a "true\t''
false\t''"
complete -c termframe -l bold-font-weight -d 'Bold text font weight' -r
complete -c termframe -l faint-opacity -d 'Faint text opacity' -r
complete -c termframe -l faint-font-weight -d 'Faint text font weight' -r
complete -c termframe -l line-height -d 'Line height, factor of the font size' -r
complete -c termframe -l mode -d 'Appearance' -r -f -a "auto\t''
dark\t''
light\t''"
complete -c termframe -l theme -d 'Color theme' -r
complete -c termframe -l window -d 'Enable window' -r -f -a "true\t''
false\t''"
complete -c termframe -l window-shadow -d 'Enable window shadow' -r -f -a "true\t''
false\t''"
complete -c termframe -l window-margin -d 'Override window margin' -r
complete -c termframe -l window-style -d 'Window style' -r
complete -c termframe -l title -d 'Window title' -r
complete -c termframe -l show-command -d 'Show command' -r -f -a "true\t''
false\t''"
complete -c termframe -l command-prompt -d 'Command prompt to show before the executed command' -r
complete -c termframe -l syntax-theme -d 'Syntax theme' -r
complete -c termframe -l var-palette -d 'Build CSS palette' -r -f -a "true\t''
false\t''"
complete -c termframe -s o -l output -d 'Output file' -r
complete -c termframe -l timeout -d 'Command timeout' -r
complete -c termframe -l list-themes -d 'List themes' -r -f -a "dark\t''
light\t''"
complete -c termframe -l list-syntax-themes -d 'List syntax highlighting themes' -r -f -a "dark\t''
light\t''"
complete -c termframe -l help -d 'Print help' -r -f -a "short\t''
long\t''"
complete -c termframe -l shell-completions -d 'Completions' -r -f -a "bash\t''
elvish\t''
fish\t''
powershell\t''
zsh\t''"
complete -c termframe -l list-window-styles -d 'List window styles'
complete -c termframe -l list-fonts -d 'List fonts'
complete -c termframe -l man-page -d 'Print man page and exit'
complete -c termframe -s V -l version -d 'Print version'
