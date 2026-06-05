function opa -d "Switch the active 1Password account (OP_ACCOUNT) for the current shell"
    argparse h/help s/show -- $argv
    or return

    set -l personal_domain my.1password.com
    set -l domains_file $OP_ENV_DIR/domains

    set -l domains $personal_domain
    if test -f $domains_file
        for line in (cat $domains_file)
            set -l trimmed (string trim -- $line)
            if test -z "$trimmed"; or test "$trimmed" = "$personal_domain"
                continue
            end
            set -a domains $trimmed
        end
    end

    if set -q _flag_help
        echo "Switch OP_ACCOUNT for the current shell via a gum picker."
        logirl help_usage opa
        logirl help_header Options
        logirl help_flag h/help "Show this help"
        logirl help_flag s/show "Print the active account and exit"
        logirl help_header Accounts
        for d in $domains
            if test "$d" = "$personal_domain"
                printf "  %s  (personal)\n" $d
            else
                printf "  %s\n" $d
            end
        end
        logirl help_header "Extra accounts"
        printf "  Add one domain per line to %s\n" $domains_file
        return 0
    end

    if set -q _flag_show
        if test -z "$OP_ACCOUNT"
            echo "(unset)"
        else if test "$OP_ACCOUNT" = "$personal_domain"
            echo "$OP_ACCOUNT (personal)"
        else
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
    for d in $domains
        set -l marker ○
        if test "$d" = "$OP_ACCOUNT"
            set marker ●
        end
        set -l label $d
        if test "$d" = "$personal_domain"
            set label "$d  (personal)"
        end
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
