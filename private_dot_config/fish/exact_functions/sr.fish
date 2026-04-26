function sr -d "Search with rg, then replace all matches with sd"
    argparse h/help n/dry-run i/ignore-case 'd/max-depth=' 'p/path=' -- $argv
    or return

    if set -q _flag_help
        echo "Search for a pattern with ripgrep, then replace all matches with sd."
        logirl help_usage "sr [OPTIONS] <search> <replace>"
        logirl help_header Options
        logirl help_flag h/help "Show this help message"
        logirl help_flag n/dry-run "Preview changes without writing files"
        logirl help_flag i/ignore-case "Case-insensitive search and replace"
        logirl help_flag d/max-depth N "Limit recursion depth (1 = current dir only)"
        logirl help_flag p/path "<path>" "Search within <path> instead of current directory"
        logirl help_header Examples
        printf "  sr 'oldName' 'newName'\n"
        printf "  sr -n 'foo' 'bar'           # preview only\n"
        printf "  sr -i 'TODO' 'DONE'         # case-insensitive\n"
        printf "  sr -d 1 'foo' 'bar'         # current dir only, no recursion\n"
        printf "  sr -p ./src 'foo' 'bar'     # restrict to ./src\n"
        return 0
    end

    if not type -q rg
        logirl error "rg (ripgrep) not found in PATH"
        logirl info "Install with: brew install ripgrep"
        return 127
    end

    if not type -q sd
        logirl error "sd not found in PATH"
        logirl info "Install with: brew install sd"
        return 127
    end

    if test (count $argv) -lt 2
        logirl error "Missing required arguments"
        printf "Try: sr --help\n"
        return 2
    end

    set -l search_term $argv[1]
    set -l replace_term $argv[2]

    set -l rg_base --hidden -g '!.git'
    set -l sd_flags
    if set -q _flag_ignore_case
        set rg_base $rg_base -i
        set sd_flags $sd_flags -f i
    end
    if set -q _flag_max_depth
        if not string match -qr '^\d+$' -- $_flag_max_depth
            logirl error "--max-depth must be a positive integer (got: $_flag_max_depth)"
            return 2
        end
        set rg_base $rg_base --max-depth $_flag_max_depth
    end

    set -l search_path .
    if set -q _flag_path
        if not test -e "$_flag_path"
            logirl error "Path does not exist: $_flag_path"
            return 1
        end
        set search_path $_flag_path
    end

    set -l files (rg -l $rg_base $search_term $search_path)
    if test (count $files) -eq 0
        logirl info "No matches found for: $search_term"
        return 0
    end

    logirl info "Found matches in "(count $files)" file(s)"

    if set -q _flag_dry_run
        logirl warning "DRY-RUN: previewing replacements"
        rg -n --heading --color=always $rg_base -r $replace_term $search_term $search_path
        return 0
    end

    rg -n --heading --color=always $rg_base $search_term $search_path
    for file in $files
        sd $sd_flags $search_term $replace_term $file
    end
    logirl success "Replaced '$search_term' with '$replace_term' in "(count $files)" file(s)"
end
