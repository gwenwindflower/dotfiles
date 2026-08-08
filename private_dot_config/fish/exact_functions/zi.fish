function zi --description "Jump to a zoxide directory selected with fzf"
    set -l directory (
        command zoxide query --list -- $argv |
            command fzf \
                --no-multi \
                '--bind=enter:accept' \
                '--layout=reverse' \
                '--height=90%' \
                '--prompt=zoxide> ' \
                '--scheme=path' \
                '--preview=lsd --tree --depth=2 --color=always --group-directories-first -- {}'
    )
    or return

    test -n "$directory"; and __zoxide_cd -- "$directory"
end
