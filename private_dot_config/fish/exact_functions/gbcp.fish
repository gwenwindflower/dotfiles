function gbcp -d "Copy the current branch, worktree, or worktree.branch"
    argparse h/help n/dry-run w/with-worktree -- $argv
    or return 2

    if set -q _flag_help
        printf "Copy the current Git name, or print it with --dry-run.\n\n"
        printf "Usage: gbcp [OPTIONS] [branch|worktree|worktree.branch]\n\n"
        printf "Options:\n"
        printf "  -n, --dry-run       Print the value instead of copying it\n"
        printf "  -w, --with-worktree Include the base repo name for the main worktree\n"
        printf "  -h, --help          Show this help\n"
        return 0
    end

    if test (count $argv) -gt 1
        printf "gbcp: expected at most one output kind\n" >&2
        return 2
    end

    set -l output_kind $argv[1]
    test -n "$output_kind"; or set output_kind branch

    switch $output_kind
        case b branch
            set output_kind branch
        case w worktree
            set output_kind worktree
        case wb 'worktree.branch'
            set output_kind worktree.branch
        case '*'
            printf "gbcp: unknown output kind: %s\n" "$output_kind" >&2
            printf "gbcp: use branch, worktree, or worktree.branch\n" >&2
            return 2
    end

    set -l branch (command git branch --show-current)
    if test $status -ne 0; or test -z "$branch"
        printf "gbcp: the current HEAD is detached or not in a Git repository\n" >&2
        return 1
    end

    set -l worktree_path (command git rev-parse --show-toplevel 2>/dev/null)
    if test $status -ne 0
        printf "gbcp: could not find the current worktree\n" >&2
        return 1
    end

    set -l worktree_name (string split / -- $worktree_path)[-1]
    set -l base_worktree_path (command git worktree list --porcelain | string match -r '^worktree .*' | string replace 'worktree ' '')[1]
    set -l base_worktree_name (string split / -- $base_worktree_path)[-1]
    set -l is_base_worktree false
    test "$worktree_path" = "$base_worktree_path"; and set is_base_worktree true

    set -l value $branch
    if test "$output_kind" != branch
        if $is_base_worktree; and not set -q _flag_with_worktree
            printf "gbcp: using only the branch because the main worktree is the repo itself; use --with-worktree to include '%s'\n" "$base_worktree_name" >&2
        else
            set value $worktree_name
            if test "$output_kind" = worktree.branch
                set value "$worktree_name.$branch"
            end
        end
    end

    if set -q _flag_dry_run
        printf "%s\n" "$value"
    else
        printf "%s\n" "$value" | fish_clipboard_copy
    end
end
