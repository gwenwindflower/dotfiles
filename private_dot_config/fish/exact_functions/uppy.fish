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
        "Herdr plugins" _uppy_refresh_herdr_plugins

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

function _uppy_refresh_herdr_plugins -d "Refresh installed Herdr plugins"
    argparse n/dry-run -- $argv
    or return

    set -l plugins_json (herdr plugin list --json)
    set -l list_status $status
    if test $list_status -ne 0
        logirl error "Could not list installed Herdr plugins"
        return $list_status
    end

    set -l plugin_rows (printf '%s\n' "$plugins_json" | jq -r '
        .result.plugins[] |
        [
            .plugin_id,
            (.enabled | tostring),
            .source.kind,
            (if .source.kind == "github"
                then "\(.source.owner)/\(.source.repo)"
                elif .source.kind == "local"
                then .plugin_root
                else ""
            end)
        ] | @tsv
    ')
    set -l parse_status $status
    if test $parse_status -ne 0
        logirl error "Could not parse installed Herdr plugins"
        return $parse_status
    end

    if test (count $plugin_rows) -eq 0
        logirl info "No Herdr plugins installed"
        return 0
    end

    set -l failed_plugins
    set -l tab (printf '\t')
    for row in $plugin_rows
        set -l fields (string split $tab -- $row)
        set -l plugin_id $fields[1]
        set -l enabled $fields[2]
        set -l source_kind $fields[3]
        set -l source $fields[4]
        set -l command_string

        switch $source_kind
            case github
                set command_string "herdr plugin install "(string escape -- $source)" --yes"
            case local
                set -l enabled_flag --enabled
                if test "$enabled" != true
                    set enabled_flag --disabled
                end
                set command_string "herdr plugin link "(string escape -- $source)" $enabled_flag"
            case '*'
                set -a failed_plugins $plugin_id
                logirl warning "Skipping $plugin_id with unsupported source: $source_kind"
                continue
        end

        logirl info "$plugin_id"
        logirl dim "\$ $command_string"
        if set -q _flag_dry_run
            continue
        end

        eval "$command_string"
        set -l refresh_status $status
        if test $refresh_status -ne 0
            set -a failed_plugins $plugin_id
            logirl warning "$plugin_id failed with status $refresh_status; continuing"
        end
    end

    if test (count $failed_plugins) -gt 0
        logirl error "Herdr plugin failures: "(string join ", " $failed_plugins)
        return 1
    end

    return 0
end

# Drop-in replacement for _uppy_refresh_herdr_plugins, pending a trust period on
# diegopzz/herdr-updater. Unlike the blind reinstall above, it only moves a
# plugin when the upstream revision is a clean fast-forward, and holds local
# checkouts. Requires `herdr plugin install diegopzz/herdr-updater` and the
# config stashed at wip/herdr-updater-config.toml in the chezmoi repo.
#
# function _uppy_herdr_plugins -d "Update Herdr plugins with the herdr-updater plugin"
#     argparse n/dry-run -- $argv
#     or return
#
#     if not type -q herdr-updater
#         logirl warning "herdr-updater is not installed; skipping Herdr plugins"
#         logirl info "Install it with: herdr plugin install diegopzz/herdr-updater"
#         return 0
#     end
#
#     if set -q _flag_dry_run
#         herdr-updater plan --plugins-only
#         # herdr-updater exits 1 when an update is pending, which a plan reports
#         # rather than fails on
#         if test $status -le 1
#             return 0
#         end
#         return $status
#     end
#
#     herdr-updater apply --plugins-only
# end
