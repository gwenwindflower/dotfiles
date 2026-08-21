function git-wash -d "Classify, review, back up, and safely remove stale remote branches"
    if test (count $argv) -eq 0; or contains -- $argv[1] -h --help
        echo "Classify stale remote branches, preserve a recovery bundle, and delete only SHA-matched targets."
        logirl help_usage "git-wash <command> <repo> [target] [OPTIONS]"
        logirl help_header Workflow
        printf "  1. list      Generate tier reports, retention evidence, and reviews.json\n"
        printf "  2. snapshot  Back up every remote branch before deleting anything\n"
        printf "  3. inspect   Review Tier 1–2; use agents to annotate Tier 3 in reviews.json\n"
        printf "  4. preview   Run wash without --execute and resolve pending human review\n"
        printf "  5. execute   Delete only branches that still match their recorded SHA\n"
        logirl help_header Commands
        printf "  %-10s %s\n" list "Fetch branch evidence and write git-wash/*.json"
        printf "  %-10s %s\n" snapshot "Create and verify a portable Git branch bundle"
        printf "  %-10s %s\n" wash "Preview or delete a manifest target"
        logirl help_header "Wash targets"
        printf "  %-10s %s\n" tier1 "Ancestry-merged or exact merged-PR tips"
        printf "  %-10s %s\n" tier2 "Patch-equivalent commits on the default branch"
        printf "  %-10s %s\n" tier3 "Unproven branches; direct washing requires exceptional intent"
        printf "  %-10s %s\n" reviewed "Tier 3 branches explicitly recommended for deletion"
        printf "  %-10s %s\n" test "Up to ten of the oldest Tier 1 branches"
        logirl help_header Examples
        printf "  git-wash list ~/Code/lightdash --github-repo lightdash/lightdash\n"
        printf "  git-wash snapshot ~/Code/lightdash\n"
        printf "  git-wash wash ~/Code/lightdash reviewed\n"
        printf "  git-wash wash ~/Code/lightdash reviewed --execute\n"
        logirl help_header Help
        printf "  Run git-wash <command> --help for command-specific options.\n"
        return 0
    end

    for dependency in chezmoi deno
        if not type -q $dependency
            logirl error "$dependency not found in PATH"
            return 127
        end
    end

    set -l source_dir (chezmoi source-path)
    or return
    set -l script "$source_dir/.utils/git-wash.ts"
    if not test -f "$script"
        logirl error "Git Wash source not found: $script"
        return 1
    end

    command deno run \
        --allow-read \
        --allow-write \
        --allow-run=git,gh \
        $script $argv
end
