function supermodel_school -d "Apply Supermodel Labs unified standards to a repo (settings, labels, Discussions)"
    argparse h/help -- $argv
    or return

    if set -q _flag_help
        echo "Apply Supermodel Labs unified standards to a repo."
        logirl help_usage "supermodel_school"
        logirl help_header Options
        logirl help_flag h/help "Show this help message"
        logirl help_header "Configures repo settings"
        printf "  * squash+rebase merge\n"
        printf "  * auto-delete branches\n"
        printf "  * allow pulling updates to branch from PR\n"
        printf "  * enable Discussions\n\n"
        printf "Then runs the bundled Deno script that audits and fixes labels and Discussions categories.\n"
        return 0
    end

    set -l org supermodellabs
    set -l deno_script "$HOME/.local/share/chezmoi/.utils/provision-repo.ts"

    if test (count $argv) -ne 0
        logirl error "Unexpected arguments: $argv"
        logirl info "Try: supermodel_school --help"
        return 2
    end

    if not test -x $deno_script
        logirl error "'$deno_script' does not exist or is not executable"
        logirl info "Try: chmod +x $deno_script"
        return 2
    end

    if not type -q gh
        logirl error "gh not found in PATH"
        logirl info "Install with: brew install gh"
        return 127
    end

    read -P "Target repo name (under $org/): " target_repo

    if test -z "$target_repo"
        logirl error "No repo name provided"
        return 2
    end

    set -l full_repo "$org/$target_repo"

    logirl special Preflight

    if not gh auth status >/dev/null 2>&1
        logirl error "gh is not authenticated"
        logirl info "Run: gh auth login"
        return 1
    end
    logirl success "gh authenticated"

    if not gh repo view $full_repo >/dev/null 2>&1
        logirl error "Repo '$full_repo' not found or inaccessible"
        return 1
    end
    logirl success "Repo $full_repo exists"

    logirl special "Applying repo settings"
    logirl info "Enabling squash+rebase merge, disabling merge commits, auto-delete branches, Discussions; disabling Wiki and Projects"

    if not gh repo edit $full_repo \
            --enable-squash-merge \
            --enable-rebase-merge \
            --enable-merge-commit=false \
            --delete-branch-on-merge \
            --allow-update-branch \
            --squash-merge-commit-message=pr-title-commits \
            --enable-discussions \
            --enable-wiki=false \
            --enable-projects=false
        logirl error "Failed to update repo settings"
        return 1
    end
    logirl success "Repo settings applied"

    logirl special "Labels + Discussions categories (Deno)"

    # Resolve token from gh so the Deno script doesn't need its own auth flow.
    # The script declares --allow-env=GITHUB_TOKEN, so this is the only env it sees.
    set -l token (gh auth token 2>/dev/null)
    if test -z "$token"
        logirl error "Could not resolve GitHub token from gh"
        return 1
    end

    GITHUB_TOKEN=$token $deno_script $target_repo
    set -l deno_status $status

    if test $deno_status -eq 0
        logirl success "$full_repo standardized cleanly"
        return 0
    else
        logirl warning "$full_repo provisioned with drift — see Reconciliation Report above"
        return $deno_status
    end
end
