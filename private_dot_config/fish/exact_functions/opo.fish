function opo -d "Run a command via 'op run' with a tool-scoped env file matching the command name"
    argparse --stop-nonopt h/help 'a/account=' 'p/profile=' -- $argv
    or return

    if set -q _flag_help
        echo "Run a command via 'op run' using \$OP_ENV_DIR/<command>.env."
        logirl help_usage "opo [OPTIONS] <command> [args...]"
        logirl help_header Options
        logirl help_flag h/help "Show this help"
        logirl help_flag a/account "Use <account>.1password.com"
        logirl help_flag p/profile "Use a profile from \$OP_ENV_DIR/profiles.toml"
        logirl help_header "Profile config"
        printf "  [work]\n"
        printf "  domain = \"cooljob.1password.com\"\n"
        return 0
    end

    if set -q _flag_account; and set -q _flag_profile
        logirl error "Use either --account or --profile, not both"
        return 2
    end

    if test (count $argv) -eq 0
        logirl error "Requires at least a command name as the first argument"
        echo "Runs <command> via 'op run' using \$OP_ENV_DIR/<command>.env"
        logirl help_usage "opo [OPTIONS] <command> [args...]"
        return 1
    end

    set -l cmd_name $argv[1]
    if not type -q $cmd_name
        logirl error "The command '$cmd_name' was not found, please check your PATH"
        return 1
    end

    if not set -q OP_ENV_DIR
        logirl error "The OP_ENV_DIR variable is not set"
        return 1
    end

    set -l env_file "$OP_ENV_DIR/$cmd_name.env"
    if not test -f $env_file
        logirl error "Corresponding env file not found: $env_file"
        return 1
    end

    set -l op_args run --env-file=$env_file --no-masking
    if set -q _flag_account
        set -a op_args --account "$_flag_account.1password.com"
    else if set -q _flag_profile
        set -l profiles_file "$OP_ENV_DIR/profiles.toml"
        if not test -f "$profiles_file"
            logirl error "1Password profiles file not found: $profiles_file"
            return 1
        end

        set -l profile_rows (__op.profile_rows)
        set -l profile_status $status
        if test $profile_status -eq 127
            logirl error "yq not found in PATH"
            logirl info "Install with: brew install yq"
            return 127
        else if test $profile_status -ne 0
            logirl error "Could not read 1Password profiles from $profiles_file"
            return 1
        end

        set -l profile_domain
        for row in $profile_rows
            set -l parts (string split -m 1 \t -- $row)
            if test "$parts[1]" = "$_flag_profile"
                set profile_domain $parts[2]
                break
            end
        end

        if test -z "$profile_domain"
            logirl error "1Password profile not found: $_flag_profile"
            logirl info "Add [$_flag_profile] with a domain property to $profiles_file"
            return 1
        end

        set -a op_args --account "$profile_domain"
    end

    # Tell tmux the real command name so pane-icon.sh and status-left
    # can display it instead of "op" (which is what pane_current_command sees).
    # --lock prevents background processes (like op for git auth) from
    # clearing the hint while the main command is running.
    tmux_hint --lock $cmd_name; and op $op_args -- $argv
    # Clear the hint so subsequent commands show their own name
    tmux_hint
end
