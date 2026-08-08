function gbdr -d "Delete rebased branches whose patches are covered upstream"
    argparse h/help n/dry-run 'u/upstream=' -- $argv
    or return 2

    if set -q _flag_help
        echo "Delete local branches whose commits have patch-equivalent commits upstream."
        logirl help_usage "gbdr [OPTIONS] [TARGET]"
        logirl help_header Options
        logirl help_flag h/help "Show this help message"
        logirl help_flag n/dry-run "List covered branches without deleting them"
        logirl help_flag u/upstream REF "Compare branches with REF"
        logirl help_header Details
        printf "  Pass TARGET to check only that local branch; omit it to check all.\n"
        printf "  The default upstream is origin's default branch, then origin/<default>,\n"
        printf "  then the local default branch. Run git fetch before gbdr when remote\n"
        printf "  tracking refs may be stale. Branches containing unmerged merge commits\n"
        printf "  are skipped because git cherry does not compare merge commits.\n"
        return 0
    end

    if test (count $argv) -gt 1
        logirl error "Expected at most one target branch"
        logirl info "Try `gbdr --help`"
        return 2
    end

    set -l target_branch $argv[1]

    if not command git rev-parse --git-dir &>/dev/null
        logirl error "Not inside a Git repository"
        return 1
    end

    set -l default_branch (__git.default_branch)
    set -l upstream

    if set -q _flag_upstream
        set upstream $_flag_upstream
    else
        set upstream (command git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null)

        if test -z "$upstream"; and command git rev-parse --verify --quiet "refs/remotes/origin/$default_branch^{commit}" >/dev/null
            set upstream "origin/$default_branch"
        end

        if test -z "$upstream"
            set upstream $default_branch
        end
    end

    set -l upstream_ref (command git rev-parse --symbolic-full-name "$upstream" 2>/dev/null)
    if test $status -ne 0; or test -z "$upstream_ref"
        logirl error "Upstream ref does not exist: $upstream"
        return 1
    end

    set -l upstream_branch
    if string match -q 'refs/heads/*' -- $upstream_ref
        set upstream_branch (string replace 'refs/heads/' '' -- $upstream_ref)
    else if string match -q 'refs/remotes/*' -- $upstream_ref
        set upstream_branch (string replace -r '^refs/remotes/[^/]+/' '' -- $upstream_ref)
    end

    set -l current_branch (__git.current_branch)

    if test -n "$target_branch"; and not command git show-ref --verify --quiet "refs/heads/$target_branch"
        logirl error "Local branch does not exist: $target_branch"
        return 1
    end

    set -l branch_records (command git for-each-ref --format='%(refname:short)%09%(worktreepath)' refs/heads)
    set -l refs_status $status

    if test $refs_status -ne 0
        logirl error "Could not list local branches"
        return $refs_status
    end

    set -l covered_branches

    for record in $branch_records
        set -l fields (string split -m 1 \t -- $record)
        set -l branch $fields[1]
        set -l worktree_path $fields[2]

        if test -n "$target_branch"; and test "$branch" != "$target_branch"
            continue
        end

        if test "$branch" = "$current_branch"; or test "$branch" = "$default_branch"; or test "$branch" = "$upstream_branch"
            if test -n "$target_branch"
                logirl error "Refusing to delete protected branch: $branch"
                return 1
            end
            continue
        end

        if test -n "$worktree_path"
            if test -n "$target_branch"
                logirl error "Branch is checked out in another worktree: $branch"
                return 1
            end
            continue
        end

        set -l exclusive_merges (command git rev-list --merges "$upstream..$branch" 2>/dev/null)
        set -l merge_status $status

        if test $merge_status -ne 0
            logirl error "Could not inspect branch: $branch"
            return $merge_status
        end

        if test (count $exclusive_merges) -gt 0
            continue
        end

        set -l coverage (command git cherry "$upstream" "$branch" 2>/dev/null)
        set -l cherry_status $status

        if test $cherry_status -ne 0
            logirl error "Could not compare $branch with $upstream"
            return $cherry_status
        end

        if test (count $coverage) -eq 0
            continue
        end

        set -l covered_patches (string match -r '^- ' -- $coverage)
        if test (count $covered_patches) -eq (count $coverage)
            set -a covered_branches $branch
        end
    end

    if test (count $covered_branches) -eq 0
        if test -n "$target_branch"
            logirl info "$target_branch is not fully covered by $upstream"
        else
            logirl info "No rebased branches are fully covered by $upstream"
        end
        return 0
    end

    if set -q _flag_dry_run
        if test -n "$target_branch"
            logirl success "$target_branch is fully covered by $upstream"
        else
            logirl info "Branches fully covered by $upstream:"
            printf "  %s\n" $covered_branches
        end
        return 0
    end

    for branch in $covered_branches
        command git branch -D -- "$branch"
        set -l delete_status $status

        if test $delete_status -ne 0
            logirl error "Could not delete branch: $branch"
            return $delete_status
        end
    end

    if test -n "$target_branch"
        logirl success "Deleted rebased branch: $target_branch"
    else
        logirl success "Deleted "(count $covered_branches)" rebased branch(es)"
    end
end
