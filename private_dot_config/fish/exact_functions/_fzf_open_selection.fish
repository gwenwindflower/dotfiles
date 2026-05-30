function _fzf_open_selection --description "Open fzf selection(s) in \$EDITOR; warn legibly if not a file or directory."
    for sel in $argv
        if not test -e "$sel"
            printf "fzf: not a file or directory: %s\n" "$sel" >/dev/tty
            return 1
        end
    end
    $EDITOR $argv &>/dev/tty
end
