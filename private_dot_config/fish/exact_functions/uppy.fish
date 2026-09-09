function uppy -d "Upgrade system tools across package and plugin managers"
    argparse h/help n/dry-run -- $argv
    or return

    if set -q _flag_help
        echo "Upgrade system tools across package and plugin managers."
        logirl help_usage "uppy [OPTIONS]"
        logirl help_header Options
        logirl help_flag h/help "Show this help message"
        logirl help_flag n/dry-run "Show the commands and available upgrades without changing anything"
        return 0
    end

    if test (count $argv) -gt 0
        logirl error "Unexpected arguments: $argv"
        logirl info "Try: uppy --help"
        return 2
    end

    set -l source_path (chezmoi source-path)
    set -l source_status $status
    if test $source_status -ne 0
        logirl error "Could not resolve the chezmoi source directory"
        return $source_status
    end

    set -l steps \
        "Packy managers" "packy upgrade" \
        "Mise tools" "mise -C "(string escape -- $source_path)" upgrade" \
        "GitHub CLI extensions" "gh extension upgrade --all" \
        "Herdr plugins" _uppy_update_herdr_plugins

    set -l failures
    if set -q _flag_dry_run
        logirl warning "Dry run — no upgrades will be installed"
    end

    for index in (seq 1 2 (count $steps))
        set -l label $steps[$index]
        set -l command_string $steps[(math $index + 1)]
        if set -q _flag_dry_run
            set command_string "$command_string --dry-run"
        end

        logirl special "$label"
        logirl dim "\$ $command_string"
        eval "$command_string"
        set -l command_status $status

        if test $command_status -ne 0
            set -a failures "$label"
            logirl warning "$label failed with status $command_status; continuing"
        end
    end

    if test (count $failures) -gt 0
        logirl error "Upgrade failures: "(string join ", " $failures)
        return 1
    end

    if set -q _flag_dry_run
        logirl success "Dry run complete"
    else
        logirl success "All update commands completed"
    end
end

function _uppy_update_herdr_plugins -d "Update installed Herdr plugins"
    argparse n/dry-run -- $argv
    or return

    if not type -q herdr-updater
        logirl warning "herdr-updater is not installed; skipping Herdr plugins"
        logirl info "Install it with: herdr plugin install diegopzz/herdr-updater"
        return 0
    end

    if set -q _flag_dry_run
        herdr-updater plan --plugins-only
        set -l plan_status $status
        if test $plan_status -le 1
            return 0
        end
        return $plan_status
    end

    herdr-updater apply --plugins-only
end
