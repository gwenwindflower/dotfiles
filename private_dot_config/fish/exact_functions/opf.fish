function opf --description "Decrypt global 1Password environment mappings with fzf"
    argparse h/help -- $argv
    or return

    if set -q _flag_help
        echo "Search and decrypt environment mappings from \$OP_ENV_DIR/global.env."
        logirl help_usage opf
        logirl help_header Bindings
        logirl help_cmd Enter "Decrypt and load selected mappings into the environment"
        logirl help_cmd Ctrl-Y "Copy selected variable names"
        logirl help_cmd Alt-Y "Copy selected mapped values"
        logirl help_header Selection
        logirl help_cmd Tab "Toggle the current mapping"
        logirl help_cmd Shift-Tab "Toggle the current mapping and move up"
        return 0
    end

    if not set -q OP_ENV_DIR
        logirl error "OP_ENV_DIR is not set"
        return 1
    end

    set -l env_file "$OP_ENV_DIR/global.env"
    if not test -f "$env_file"
        logirl error "Global environment file not found: $env_file"
        return 1
    end

    set -l mappings
    set -l mapping_names
    set -l mapping_values
    while read -l line
        if string match -qr '^\s*(#|$)' -- $line
            continue
        end

        set -l mapping (string split -m 1 = -- $line)
        if test (count $mapping) -ne 2
            logirl warning "Skipping malformed environment mapping: $line"
            continue
        end

        set -l name $mapping[1]
        set -l value $mapping[2]
        if not string match -rq '^[A-Z_][A-Z0-9_]*$' -- $name
            logirl warning "Skipping invalid environment variable name: $name"
            continue
        end
        if not string match -rq '^op://.+/.+/.+$' -- $value; and not string match -rq '^\$[A-Z_][A-Z0-9_]*$' -- $value
            logirl warning "Skipping unsupported value for $name"
            continue
        end

        set -a mappings (string join \t -- $name $value)
        set -a mapping_names $name
        set -a mapping_values $value
    end <"$env_file"

    if test (count $mappings) -eq 0
        logirl error "No valid environment mappings found in $env_file"
        return 1
    end

    set -l selection (
        printf '%s\n' $mappings |
            _fzf_wrapper \
                --multi \
                --no-preview \
                --delimiter '\t' \
                --with-nth 1 \
                --prompt '1Password environment> ' \
                --header 'Enter: decrypt + load  Ctrl-Y: copy name  Alt-Y: copy value  Tab: toggle' \
                --bind 'enter:print(load)+accept' \
                --bind 'ctrl-y:print(copy-name)+accept' \
                --bind 'alt-y:print(copy-value)+accept'
    )
    or return

    if test (count $selection) -lt 2
        logirl error "Could not determine the selected environment action"
        return 1
    end

    set -l action $selection[1]
    set -l names
    set -l values
    for selected_mapping in $selection[2..]
        set -l mapping (string split -m 1 \t -- $selected_mapping)
        set -a names $mapping[1]
        set -a values $mapping[2]
    end

    switch $action
        case load
            set -l decrypted_values
            set -l decrypted_uris
            set -l decrypted_secrets

            for value in $values
                set -l resolved_value $value
                set -l referenced_names
                while string match -rq '^\$[A-Z_][A-Z0-9_]*$' -- $resolved_value
                    set -l referenced_name (string sub --start 2 -- $resolved_value)
                    if contains -- $referenced_name $referenced_names
                        logirl error "Cyclic environment reference: $referenced_name"
                        return 1
                    end
                    set -a referenced_names $referenced_name

                    set -l mapping_index (contains -i -- $referenced_name $mapping_names)
                    if test -n "$mapping_index"
                        set resolved_value $mapping_values[$mapping_index]
                    else if set -q $referenced_name
                        set resolved_value $$referenced_name
                    else
                        logirl error "Environment reference is not defined: $referenced_name"
                        return 1
                    end
                end

                if string match -q 'op://*' -- $resolved_value
                    set -l decrypted_index (contains -i -- $resolved_value $decrypted_uris)
                    if test -n "$decrypted_index"
                        set -a decrypted_values $decrypted_secrets[$decrypted_index]
                    else if set -l secret (op read --no-newline "$resolved_value")
                        set -a decrypted_uris $resolved_value
                        set -a decrypted_secrets "$secret"
                        set -a decrypted_values "$secret"
                    else
                        logirl error "Could not decrypt selected 1Password secret"
                        return 1
                    end
                else
                    set -a decrypted_values "$resolved_value"
                end
            end

            for index in (seq (count $names))
                set -gx "$names[$index]" "$decrypted_values[$index]"
            end
            set -l loaded_count (count $names)
            logirl success "Decrypted and loaded $loaded_count environment mapping(s)"
        case copy-name
            string join \n -- $names | fish_clipboard_copy
            set -l copied_count (count $names)
            logirl success "Copied $copied_count environment variable name(s)"
        case copy-value
            string join \n -- $values | fish_clipboard_copy
            set -l copied_count (count $values)
            logirl success "Copied $copied_count mapped value(s)"
        case '*'
            logirl error "Unsupported environment action: $action"
            return 1
    end
end
