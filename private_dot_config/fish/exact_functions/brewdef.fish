function brewdef -d "Find Homebrew formulae whose installed runtime deps differ from their current definition"
    argparse h/help u/update -- $argv
    or return 2

    if set -q _flag_help
        echo "Find installed formulae whose language runtime deps differ from their current definition."
        logirl help_usage "brewdef [OPTIONS]"
        logirl help_header Options
        logirl help_flag h/help "Show this help message"
        logirl help_flag u/update "Reinstall stale formulae, then run brew autoremove"
        logirl help_header Examples
        printf "  brewdef            # list stale formulae\n"
        printf "  brewdef --update   # reinstall them and clean up orphaned runtimes\n"
        return 0
    end

    for cmd in brew jq
        if not type -q $cmd
            logirl error "$cmd not found in PATH"
            return 127
        end
    end

    # Homebrew only upgrades on version or revision bumps, so a dep swap shipped as a bottle rebuild never reaches installed formulae
    set -l runtimes python node
    set -l runtime_pattern "^("(string join '|' $runtimes)")(@|\$)"

    set -l stale (brew info --json=v2 --installed 2>/dev/null | jq -r --arg re $runtime_pattern '
        .formulae[]
        | select(.installed | length > 0)
        | {
            name,
            want: ([.dependencies[] | select(test($re))] | sort),
            have: ([.installed[0].runtime_dependencies[]?
                | select(.declared_directly // true)
                | .full_name
                | select(test($re))] | sort)
        }
        | select(.want != .have)
        | [.name, (.have | join(", ")), (.want | join(", "))]
        | @tsv')

    if test (count $stale) -eq 0
        logirl success "No stale runtime deps for: $runtimes"
        return 0
    end

    set -l formulae
    for row in $stale
        set -l fields (string split \t -- $row)
        set -a formulae $fields[1]
        printf "  %s: %s → %s\n" $fields[1] (string replace -r '^$' none -- $fields[2]) (string replace -r '^$' none -- $fields[3])
    end

    if not set -q _flag_update
        logirl info (count $formulae)" stale formula(e). Run 'brewdef --update' to reinstall them."
        return 0
    end

    logirl special "brew reinstall "(count $formulae)" formula(e)..."
    brew reinstall $formulae
    or begin
        set -l reinstall_status $status
        logirl error "brew reinstall exited with status $reinstall_status"
        return $reinstall_status
    end

    logirl special "brew autoremove..."
    brew autoremove
    or begin
        set -l autoremove_status $status
        logirl error "brew autoremove exited with status $autoremove_status"
        return $autoremove_status
    end

    logirl success "Reinstalled: $formulae"
end
