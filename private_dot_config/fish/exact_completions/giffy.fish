function __giffy_needs_input
    set -l tokens (commandline -opc)
    set -e tokens[1]

    argparse \
        h/help \
        'w/width=' \
        'f/fps=' \
        's/speed=' \
        'q/quality=' \
        'p/preset=' \
        'l/loop=' \
        'o/output=' \
        quiet -- $tokens 2>/dev/null
    or return 1

    test (count $argv) -eq 0
end

complete -c giffy -f
complete -c giffy -s h -l help -d "Show help"
complete -c giffy -s w -l width -d "Output width in pixels; 0 preserves source width" -x
complete -c giffy -s f -l fps -d "Output frame rate" -x
complete -c giffy -s s -l speed -d "Playback speed multiplier" -x
complete -c giffy -s q -l quality -d "Palette quality" -x -a "low\t'Smaller 128-color palette' med\t'Balanced 256-color palette' high\t'Full-frame 256-color palette'"
complete -c giffy -s p -l preset -d "Encoding preset" -x -a "docs\t'800px · 15fps · 1.5x · high' tiny\t'600px · 12fps · 2x · medium' smooth\t'900px · 24fps · 1x · high' raw\t'Source width · 24fps · 1x · high'"
complete -c giffy -s l -l loop -d "Loop behavior" -x -a "0\t'Loop forever' 1\t'Play once'"
complete -c giffy -s o -l output -d "Output GIF path" -r -F
complete -c giffy -l quiet -d "Suppress ffmpeg progress output"
complete -c giffy -n __giffy_needs_input -a "(__fish_complete_suffix mp4 mov m4v mkv webm avi)"
