function gdlast -d "Diff HEAD against the last commit for a given path"
    if test (count $argv) -gt 1
        logirl help_usage "gdlast [path]"
        echo "Please provide at most one path argument."
        return 2
    end
    set -l target $argv[1]
    test -z "$target"; and set target "."

    set -l last_commit (git log -1 --format="%H" -- $target)
    if test $status -ne 0
        logirl error "No retrievable commit history for $target"
        return $status
    end

    git diff "$last_commit^" HEAD -- $target
end
