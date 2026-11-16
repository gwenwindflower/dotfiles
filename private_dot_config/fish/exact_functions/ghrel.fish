function ghrel -d "Plan or create a GitHub release via git-cliff + gh CLI"
    argparse h/help x/execute n/dry-run d/draft p/prerelease no-changelog -- $argv
    or return

    if set -q _flag_help
        echo "Plan a GitHub release with git-cliff, then create it with gh."
        echo "Runs as a dry run by default; nothing changes until you pass --execute."
        logirl help_usage "ghrel [OPTIONS]"
        logirl help_header Options
        logirl help_flag h/help "Show this help message"
        logirl help_flag x/execute "Run the release for real (default is a dry run)"
        logirl help_flag n/dry-run "Preview only; the default, and an error with --execute"
        logirl help_flag d/draft "Create the release as a draft"
        logirl help_flag p/prerelease "Mark the release as a prerelease"
        logirl help_flag no-changelog "Skip updating, committing, and pushing CHANGELOG.md"
        logirl help_header "Release process"
        printf "  1. Calculate the next version from conventional commits since the last tag\n"
        printf "     (git cliff --bumped-version), adding a 'v' prefix to form the tag.\n"
        printf "  2. Stop if that tag already exists.\n"
        printf "  3. Prepend the unreleased section to CHANGELOG.md, creating the file if\n"
        printf "     needed, and commit it as 'chore(release): update changelog for <tag>'.\n"
        printf "  4. Push the current branch to its upstream so the tag's commit exists remotely.\n"
        printf "  5. Generate release notes for the unreleased commits.\n"
        printf "  6. Run 'gh release create <tag>', which tags the current HEAD on GitHub\n"
        printf "     and publishes the notes.\n"
        printf "\n  --no-changelog skips steps 3 and 4. A dry run does steps 1, 2, and 5, then\n"
        printf "  prints the plan and notes without committing, pushing, or tagging.\n"
        logirl help_header Examples
        printf "  ghrel                 # preview the next release and its notes\n"
        printf "  ghrel -d              # preview a draft release\n"
        printf "  ghrel -x              # cut the release for real\n"
        printf "  ghrel -x -p           # cut a prerelease\n"
        printf "  ghrel -x --no-changelog  # release from HEAD without touching CHANGELOG.md\n"
        logirl help_header Requirements
        printf "  git-cliff, gh, git; run from the repo root with a clean, pushed branch\n"
        return 0
    end

    if set -q _flag_execute; and set -q _flag_dry_run
        logirl error "--execute and --dry-run cannot be combined"
        return 2
    end

    for cmd in git-cliff gh git
        if not type -q $cmd
            logirl error "$cmd not found in PATH"
            return 127
        end
    end

    if not git rev-parse --is-inside-work-tree &>/dev/null
        logirl error "Not inside a git repository"
        return 1
    end

    logirl info "Calculating next version..."
    set -l rel_version (git cliff --bumped-version 2>/dev/null)

    if test $status -ne 0; or test -z "$rel_version"
        logirl error "git-cliff could not calculate a bumped version"
        logirl info "This usually means there are no conventional commits since the last tag"
        return 1
    end

    set -l tag $rel_version
    if not string match -q 'v*' -- $tag
        set tag "v$tag"
    end

    if git rev-parse "refs/tags/$tag" &>/dev/null
        logirl error "Tag '$tag' already exists"
        return 1
    end

    set -l gh_args release create $tag --title $tag -F -
    set -q _flag_draft; and set -a gh_args --draft
    set -q _flag_prerelease; and set -a gh_args --prerelease

    if not set -q _flag_execute
        set -l notes (git cliff --bump --unreleased --strip all 2>/dev/null)
        set -l branch (git branch --show-current)
        set -l upstream (git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)
        test -n "$upstream"; or set upstream "(no upstream set)"

        logirl warning "DRY RUN: nothing will be committed, pushed, or tagged"
        printf "\n"
        logirl info "Tag:        $tag"
        logirl info "Branch:     $branch → $upstream"
        logirl info "Draft:      "(set -q _flag_draft; and echo yes; or echo no)
        logirl info "Prerelease: "(set -q _flag_prerelease; and echo yes; or echo no)
        logirl info "Changelog:  "(set -q _flag_no_changelog; and echo skip; or echo update)
        printf "\n"
        logirl special "Planned steps"
        if not set -q _flag_no_changelog
            printf "  • git cliff --bump --unreleased --prepend CHANGELOG.md\n"
            printf "  • git commit -m \"chore(release): update changelog for %s\"\n" $tag
            printf "  • git push\n"
        end
        printf "  • gh %s\n" (string join ' ' -- $gh_args)
        printf "\n"
        logirl special "Release notes"
        printf "%s\n" $notes
        printf "\n"
        logirl info "Re-run with -x/--execute to create the release"
        return 0
    end

    # The changelog commit goes first so git-cliff filters it out of the release notes
    if not set -q _flag_no_changelog
        logirl info "Updating CHANGELOG.md..."

        # --prepend requires the file to exist
        test -f CHANGELOG.md; or touch CHANGELOG.md

        if not git cliff --bump --unreleased --prepend CHANGELOG.md 2>/dev/null
            logirl error "git-cliff could not update CHANGELOG.md"
            return 1
        end

        git add CHANGELOG.md
        if not git commit -m "chore(release): update changelog for $tag"
            logirl error "Failed to commit CHANGELOG.md"
            return 1
        end

        # The release tag must point to a commit that exists on the remote
        logirl info "Pushing changelog commit..."
        if not git push 2>/dev/null
            logirl error "git push failed"
            return 1
        end
    end

    logirl info "Generating release notes..."
    set -l notes (git cliff --bump --unreleased --strip all 2>/dev/null)

    if test $status -ne 0; or test -z "$notes"
        logirl error "git-cliff could not generate release notes"
        return 1
    end

    logirl special "Creating release $tag..."
    printf "%s\n" $notes | gh $gh_args

    if test $status -ne 0
        logirl error "gh release create failed"
        return 1
    end

    logirl success "Release $tag created"
end
