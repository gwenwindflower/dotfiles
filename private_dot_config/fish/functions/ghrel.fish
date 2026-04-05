function ghrel -d "Create a GitHub release via git-cliff + gh CLI"
    argparse h/help d/draft p/prerelease n/dry-run no-changelog -- $argv
    or return

    if set -q _flag_help
        echo "Create a GitHub release using git-cliff for version bumping and release notes."
        logirl help_usage "ghrel [OPTIONS]"
        logirl help_header Options
        logirl help_flag h/help "Show this help message"
        logirl help_flag d/draft "Create the release as a draft"
        logirl help_flag p/prerelease "Mark the release as a prerelease"
        logirl help_flag n/dry-run "Print what would happen without creating anything"
        logirl help_flag "" no-changelog "Skip updating CHANGELOG.md"
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

    # Dry run: show what would happen without side effects
    # Note: release notes shown here may include the changelog commit pattern
    # since we haven't actually committed it yet — the real run filters it out
    if set -q _flag_dry_run
        set -l notes (git cliff --bump --unreleased --strip all 2>/dev/null)
        logirl warning "DRY-RUN mode"
        printf "\n"
        logirl info "Tag:        $tag"
        logirl info "Draft:      "(set -q _flag_draft; and echo yes; or echo no)
        logirl info "Prerelease: "(set -q _flag_prerelease; and echo yes; or echo no)
        logirl info "Changelog:  "(set -q _flag_no_changelog; and echo skip; or echo update)
        printf "\n"
        logirl special "Release Notes"
        printf "%s\n" $notes
        return 0
    end

    # Update CHANGELOG.md first so the commit gets filtered from release notes
    if not set -q _flag_no_changelog
        logirl info "Updating CHANGELOG.md..."

        # --prepend requires the file to exist; create it for first release
        test -f CHANGELOG.md; or touch CHANGELOG.md

        if not git cliff --bump --unreleased --prepend CHANGELOG.md 2>/dev/null
            logirl error "git-cliff could not update CHANGELOG.md"
            return 1
        end

        git add CHANGELOG.md
        git commit -m "chore(release): update changelog for $tag"

        if test $status -ne 0
            logirl error "Failed to commit CHANGELOG.md"
            return 1
        end
    end

    # Push so the release tag points to a commit that exists on the remote
    if not set -q _flag_no_changelog
        logirl info "Pushing changelog commit..."

        if not git push 2>/dev/null
            logirl error "git push failed"
            return 1
        end
    end

    # Generate release notes (after changelog commit so it gets filtered out)
    logirl info "Generating release notes..."
    set -l notes (git cliff --bump --unreleased --strip all 2>/dev/null)

    if test $status -ne 0; or test -z "$notes"
        logirl error "git-cliff could not generate release notes"
        return 1
    end

    # Build gh release create command
    set -l gh_args release create $tag --title $tag -F -

    if set -q _flag_draft
        set -a gh_args --draft
    end

    if set -q _flag_prerelease
        set -a gh_args --prerelease
    end

    # Create the release (tag is created at current HEAD, which now includes the changelog commit)
    logirl special "Creating release $tag..."

    printf "%s\n" $notes | gh $gh_args

    if test $status -ne 0
        logirl error "gh release create failed"
        return 1
    end

    logirl success "Release $tag created"
end
