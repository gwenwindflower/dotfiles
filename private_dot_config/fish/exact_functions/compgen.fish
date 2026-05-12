function compgen -d "Probe a CLI for fish completion output and install to ~/.config/fish/completions/"
    argparse h/help f/force n/dry-run v/verbose -- $argv
    or return

    if set -q _flag_help
        echo "Probe a CLI for fish completion output and install it."
        logirl help_usage "compgen [OPTIONS] <command>"
        logirl help_header Options
        logirl help_flag h/help "Show this help message"
        logirl help_flag f/force "Overwrite existing completions file"
        logirl help_flag n/dry-run "Show what would be written without writing"
        logirl help_flag v/verbose "Print each probe attempt"
        logirl help_header Examples
        printf "  compgen zizmor\n"
        printf "  compgen agent-browser\n"
        printf "  compgen -f mytool        # overwrite existing\n"
        return 0
    end

    if test (count $argv) -ne 1
        logirl error "Expected exactly one command name"
        printf "Try: compgen --help\n"
        return 2
    end

    set -l cmd_name $argv[1]

    if not type -q $cmd_name
        logirl error "$cmd_name not found in PATH"
        return 127
    end

    set -l completions_dir "$HOME/.config/fish/completions"
    set -l target "$completions_dir/$cmd_name.fish"

    if not test -d $completions_dir
        mkdir -p $completions_dir
        or begin
            logirl error "Could not create $completions_dir"
            return 1
        end
    end

    if test -f $target; and not set -q _flag_force; and not set -q _flag_dry_run
        logirl warning "$target already exists (use --force to overwrite)"
        return 1
    end

    # Snapshot target mtime to detect tools that write the file directly
    set -l before_mtime 0
    if test -f $target
        set before_mtime (stat -f %m $target 2>/dev/null; or stat -c %Y $target 2>/dev/null; or echo 0)
    end

    # Probe patterns, ordered roughly by popularity across Rust/Clap, Go/Cobra,
    # and homegrown CLIs. Each probe is a space-separated argv string.
    set -l probes \
        "completions fish" \
        "--completions fish" \
        "completion fish" \
        "--completion fish" \
        "completions generate fish" \
        "completion generate fish" \
        "generate-completions fish" \
        "generate-completion fish" \
        "--completions=fish" \
        "--completion=fish" \
        "completions --shell fish" \
        "completion --shell fish"

    for probe in $probes
        set -l probe_args (string split " " -- $probe)

        set -q _flag_verbose; and logirl dim "trying: $cmd_name $probe"

        set -l output ($cmd_name $probe_args 2>/dev/null)
        set -l exit_code $status

        if test $exit_code -ne 0
            continue
        end

        # Did the probe write the target file itself (some tools do)?
        if test -f $target
            set -l current_mtime (stat -f %m $target 2>/dev/null; or stat -c %Y $target 2>/dev/null; or echo 0)
            if test "$current_mtime" != "$before_mtime"
                logirl success "$cmd_name wrote completions to $target via '$probe'"
                return 0
            end
        end

        # Stdout path: must look like a fish completion file
        if test (count $output) -eq 0
            continue
        end
        set -l joined (string join \n -- $output)
        if not string match -q -r '(?m)^\s*complete\s' -- $joined
            continue
        end

        if set -q _flag_dry_run
            logirl info "Would write "(count $output)" lines from '$cmd_name $probe' to $target"
            return 0
        end

        printf "%s\n" $output >$target
        or begin
            logirl error "Failed to write $target"
            return 1
        end
        logirl success "Wrote completions for $cmd_name via '$probe'"
        logirl info "Target: $target"
        return 0
    end

    logirl error "No completion probe succeeded for $cmd_name"
    logirl info "Check '$cmd_name --help' for the right invocation and add it to compgen"
    return 1
end
