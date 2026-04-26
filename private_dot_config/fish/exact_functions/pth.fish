function pth -d "Inspect, clean, and dedupe PATH"
    argparse h/help s/system dry-run -- $argv
    or return

    if set -q _flag_help
        _pth_help
        return 0
    end

    set -l cmd ''
    if test (count $argv) -gt 0
        set cmd $argv[1]
    end

    switch "$cmd"
        case ''
            _pth_print
        case clean
            if set -q _flag_dry_run
                logirl info "--dry-run is a no-op for 'clean' (already interactive)"
            end
            _pth_clean (set -q _flag_system; and echo system; or echo user)
        case dedupe
            _pth_dedupe (set -q _flag_dry_run; and echo true; or echo false)
        case '*'
            logirl error "Unknown command: $cmd"
            echo
            _pth_help
            return 2
    end
end

function _pth_help
    echo "Inspect, clean, and dedupe PATH."
    logirl help_usage "pth [COMMAND] [OPTIONS]"
    logirl help_header Commands
    logirl help_flag "(none)" "Pretty-print PATH; duplicates shown in red italics"
    logirl help_flag clean "Interactively select and remove PATH entries"
    logirl help_flag dedupe "Remove duplicate entries from PATH (preserves first occurrence)"
    logirl help_header Options
    logirl help_flag h/help "Show this help message"
    logirl help_flag s/system "With 'clean': edit \$PATH instead of \$fish_user_paths"
    logirl help_flag dry-run "With 'dedupe': preview changes without modifying PATH"
    logirl help_header Examples
    printf "  pth\n"
    printf "  pth clean\n"
    printf "  pth clean --system\n"
    printf "  pth dedupe --dry-run\n"
end

function _pth_print
    for p in $PATH
        set -l matches (string match -- $p $PATH)
        if test (count $matches) -gt 1
            set_color --italics red
            echo $p
            set_color normal
        else
            echo $p
        end
    end
end

function _pth_clean -a scope
    if not type -q gum
        logirl error "gum not found in PATH"
        logirl info "Install with: brew install gum"
        return 127
    end

    set -l var_name fish_user_paths
    set -l path_list $fish_user_paths
    if test "$scope" = system
        set var_name PATH
        set path_list $PATH
    end

    if test (count $path_list) -eq 0
        logirl info "\$$var_name is empty"
        return 0
    end

    set -l choices (printf '%s\n' $path_list | gum choose --no-limit --header "Select entries to remove from \$$var_name")
    if test (count $choices) -eq 0
        logirl info "Nothing selected"
        return 0
    end

    logirl warning "About to remove "(count $choices)" entr"(test (count $choices) -eq 1; and echo y; or echo ies)" from \$$var_name:"
    printf "  %s\n" $choices
    if not gum confirm "Proceed?"
        logirl info Cancelled
        return 0
    end

    for choice in $choices
        set -l idx (contains --index -- $choice $path_list)
        if test -n "$idx"
            set -e {$var_name}[$idx]
            set -e path_list[$idx]
        end
    end
    logirl success "Removed "(count $choices)" entr"(test (count $choices) -eq 1; and echo y; or echo ies)" from \$$var_name"
end

function _pth_dedupe -a dry_run
    set -l new_path
    set -l removed
    for p in $PATH
        if contains -- $p $new_path
            set removed $removed $p
        else
            set new_path $new_path $p
        end
    end

    if test (count $removed) -eq 0
        logirl info "No duplicates found in \$PATH"
        return 0
    end

    if test "$dry_run" = true
        logirl info "Dry run: would remove "(count $removed)" duplicate entr"(test (count $removed) -eq 1; and echo y; or echo ies)" from \$PATH:"
        printf "  %s\n" $removed
        return 0
    end

    logirl warning "Found "(count $removed)" duplicate entr"(test (count $removed) -eq 1; and echo y; or echo ies)" in \$PATH:"
    printf "  %s\n" $removed
    if not gum confirm "Remove duplicates from \$PATH?"
        logirl info Cancelled
        return 0
    end

    set PATH $new_path
    logirl success "Removed "(count $removed)" duplicate entr"(test (count $removed) -eq 1; and echo y; or echo ies)" from \$PATH"
end
