function prockill -d "Find processes with procs and kill matching PIDs"
    argparse h/help x/execute -- $argv
    or return 2

    if set -q _flag_help
        echo "Find processes matching a query and kill them when explicitly requested."
        logirl help_usage "prockill [OPTIONS] <query>"
        logirl help_header Options
        logirl help_flag h/help "Show this help message"
        logirl help_flag x/execute "Kill matching processes"
        logirl help_header Examples
        printf "  prockill 'node server'\n"
        printf "  prockill --execute 'node server'\n"
        return 0
    end

    if test (count $argv) -ne 1
        logirl error "Expected exactly one process query"
        logirl info "Try `prockill --help`"
        return 2
    end

    if not type -q procs
        logirl error "procs not found in PATH"
        return 127
    end

    if not type -q jq
        logirl error "jq not found in PATH"
        return 127
    end

    set -l query $argv[1]
    set -l process_json (command procs --json --pager disable --color disable -- $query | string collect)
    set -l procs_status $pipestatus[1]

    if test $procs_status -ne 0
        logirl error "Could not query processes"
        return $procs_status
    end

    set -l matches (printf '%s\n' "$process_json" | command jq -r '.[] | "\(.PID)\t\(.Command)"')
    if test $status -ne 0
        logirl error "Could not parse procs output"
        return 1
    end

    if test (count $matches) -eq 0
        logirl info "No processes matched: $query"
        return 0
    end

    set -l match_count (count $matches)
    if set -q _flag_execute
        logirl warning "Killing $match_count process(es) matching: $query"
    else
        logirl info "Dry run — matching process(es) for: $query"
    end

    for match in $matches
        set -l fields (string split -m 1 \t -- $match)
        set -l pid $fields[1]
        set -l command_name $fields[2]

        if set -q _flag_execute
            command kill $pid
            if test $status -eq 0
                logirl success "Killed PID $pid ($command_name)"
            else
                logirl error "Could not kill PID $pid ($command_name)"
            end
        else
            logirl info "Would kill PID $pid ($command_name)"
        end
    end
end
