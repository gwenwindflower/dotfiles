function opa -d "Switch the active 1Password account (OP_ACCOUNT) for the current shell"
    argparse h/help s/show -- $argv
    or return

    set -l default_domain my.1password.com
    set -l profiles_file "$OP_ENV_DIR/profiles.toml"

    set -l profiles default
    set -l domains $default_domain
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

    for row in $profile_rows
        set -l parts (string split -m 1 \t -- $row)
        set -l profile $parts[1]
        set -l domain $parts[2]
        if test -z "$profile"; or test -z "$domain"; or test "$domain" = "$default_domain"
            continue
        end
        set -a profiles $profile
        set -a domains $domain
    end

    if set -q _flag_help
        echo "Switch OP_ACCOUNT for the current shell via a gum picker."
        logirl help_usage opa
        logirl help_header Options
        logirl help_flag h/help "Show this help"
        logirl help_flag s/show "Print the active account and exit"
        logirl help_header Accounts
        for i in (seq (count $domains))
            printf "  %s  (%s)\n" $domains[$i] $profiles[$i]
        end
        logirl help_header "Profile config"
        printf "  Add profiles to %s:\n" $profiles_file
        printf "  [work]\n"
        printf "  domain = \"example.1password.com\"\n"
        return 0
    end

    if set -q _flag_show
        if test -z "$OP_ACCOUNT"
            echo "(unset)"
        else
            for i in (seq (count $domains))
                if test "$OP_ACCOUNT" = "$domains[$i]"
                    echo "$OP_ACCOUNT ($profiles[$i])"
                    return 0
                end
            end
            echo "$OP_ACCOUNT"
        end
        return 0
    end

    if not type -q gum
        logirl error "gum not found in PATH"
        logirl info "Install with: brew install gum"
        return 127
    end

    set -l rows
    set -l selected_row
    for i in (seq (count $domains))
        set -l d $domains[$i]
        set -l marker ○
        if test "$d" = "$OP_ACCOUNT"
            set marker ●
        end
        set -l label "$d  ($profiles[$i])"
        set -l row "$marker $label"
        set -a rows $row
        if test "$d" = "$OP_ACCOUNT"
            set selected_row $row
        end
    end

    if test -z "$selected_row"
        set selected_row $rows[1]
    end

    set -l choice (gum choose \
        --header "Current: $OP_ACCOUNT" \
        --selected "$selected_row" \
        $rows)

    if test $status -ne 0; or test -z "$choice"
        logirl info "No change"
        return 0
    end

    for i in (seq (count $rows))
        if test "$rows[$i]" = "$choice"
            set -gx OP_ACCOUNT $domains[$i]
            logirl success "OP_ACCOUNT → $domains[$i]"
            return 0
        end
    end
end
