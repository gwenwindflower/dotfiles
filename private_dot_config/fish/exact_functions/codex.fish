function codex --wraps codex -d "Launch Codex with sibling worktree permissions"
    set -l worktree (path basename "$PWD")
    set -l parts (string split -m 1 . -- "$worktree")
    set -l args

    if test (count $parts) -eq 2; and test -n "$parts[1]"; and test -n "$parts[2]"
        set -l git_dir (path dirname "$PWD")/"$parts[1]"/.git
        if test -f "$PWD/.git"; and test -d "$git_dir"
            set -a args --add-dir "$PWD"
            set -a args -c "permissions.dev.filesystem={\"$git_dir\"=\"write\",\"$git_dir/worktrees/$worktree\"=\"write\"}"
        end
    end

    command codex $args $argv
end
