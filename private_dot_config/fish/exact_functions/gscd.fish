function gscd -d "cd to a gh stack layer in whichever worktree holds it"
    set -l target (gh stack $argv --print-path)
    or return
    if test -z "$target"
        echo "gh stack returned an empty path" >&2
        return 1
    end
    cd -- $target
end
