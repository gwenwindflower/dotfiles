complete -c termshot -s h -l help -d "Show help"
complete -c termshot -s o -l output -d "Write PNG to this path" -r
complete -c termshot -l keep-svg -d "Keep the intermediate SVG"
complete -c termshot -l no-keep-svg -d "Remove the SVG after rendering"
complete -c termshot -l svg-only -d "Create SVG without rendering PNG"
complete -c termshot -l fonts-dir -d "Use fonts from this directory" -r
complete -c termshot -l zoom -d "Set PNG raster scale" -r -f -a "1 2 3 4"

complete -c termshot -l title -d "Set the window title" -r
complete -c termshot -l theme -d "Set the termframe color theme" -r
complete -c termshot -l mode -d "Set light or dark appearance" -r -f -a "auto dark light"
complete -c termshot -l padding -d "Set inner text padding in em" -r
complete -c termshot -l margin -d "Set window margin in pixels" -r
complete -c termshot -s W -l width -d "Set fixed or ranged terminal width" -r
complete -c termshot -s H -l height -d "Set fixed or ranged terminal height" -r
complete -c termshot -l timeout -d "Set command timeout in seconds" -r
complete -c termshot -l show-command -d "Include the command line"

complete -c termshot -l transparent -d "Leave the SVG background transparent"
complete -c termshot -l from -d "Set gradient start color" -r -f
complete -c termshot -l mid -d "Set gradient midpoint color" -r -f
complete -c termshot -l to -d "Set gradient end color" -r -f
complete -c termshot -l angle -d "Set gradient angle in degrees" -r
complete -c termshot -l radius -d "Set outer corner radius in pixels" -r
complete -c termshot -l grain -d "Set grain opacity from 0 to 1" -r
