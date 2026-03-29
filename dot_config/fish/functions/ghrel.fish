function ghrel -d "Create a GitHub release via git-cliff + gh CLI"
    argparse h/help d/draft p/prerelease n/dry-run -- $argv
    or return

    if set -q _flag_help
        echo "Create a GitHub release using git-cliff for version bumping and release notes."
        logirl help_usage "ghrel [OPTIONS]"
        logirl help_header Options
        logirl help_flag h/help "Show this help message"
        logirl help_flag d/draft "Create the release as a draft"
        logirl help_flag p/prerelease "Mark the release as a prerelease"
        logirl help_flag n/dry-run "Print what would happen without creating anything"
        logirl help_header Requirements
        printf "  git-cliff, gh, git\n"
        return 0
    end

    # Validate dependencies
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

    # Calculate bumped version
    logirl info "Calculating next version..."
    set -l rel_version (git cliff --bumped-version 2>/dev/null)

    if test $status -ne 0; or test -z "$rel_version"
        logirl error "git-cliff could not calculate a bumped version"
        logirl info "This usually means there are no conventional commits since the last tag"
        return 1
    end

    # Ensure version has a 'v' prefix for the tag
    set -l tag $rel_version
    if not string match -q 'v*' -- $tag
        set tag "v$tag"
    end

    # Check for existing tag
    if git rev-parse "refs/tags/$tag" &>/dev/null
        logirl error "Tag '$tag' already exists"
        return 1
    end

    # Generate release notes
    logirl info "Generating release notes..."
    set -l notes (git cliff --bump --unreleased --strip all 2>/dev/null)

    if test $status -ne 0; or test -z "$notes"
        logirl error "git-cliff could not generate release notes"
        return 1
    end

    # Dry run output
    if set -q _flag_dry_run
        logirl warning "DRY-RUN mode"
        printf "\n"
        logirl info "Tag:        $tag"
        logirl info "Draft:      "(set -q _flag_draft; and echo yes; or echo no)
        logirl info "Prerelease: "(set -q _flag_prerelease; and echo yes; or echo no)
        printf "\n"
        logirl special "Release Notes"
        printf "%s\n" $notes
        return 0
    end

    # Build gh release create command
    set -l gh_args release create $tag --title $tag -F -

    if set -q _flag_draft
        set -a gh_args --draft
    end

    if set -q _flag_prerelease
        set -a gh_args --prerelease
    end

    # Create the release
    logirl special "Creating release $tag..."

    printf "%s\n" $notes | gh $gh_args

    if test $status -ne 0
        logirl error "gh release create failed"
        return 1
    end

    logirl success "Release $tag created"
end
