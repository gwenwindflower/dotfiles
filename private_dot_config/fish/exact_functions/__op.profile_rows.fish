function __op.profile_rows -d "Print configured 1Password profiles as profile/domain rows"
    if not set -q OP_ENV_DIR
        return 0
    end

    set -l profiles_file "$OP_ENV_DIR/profiles.toml"
    if not test -f "$profiles_file"
        return 0
    end

    if not type -q yq
        return 127
    end

    yq -p toml -o yaml -r 'to_entries | .[] | select(.value.domain != null and .value.domain != "") | .key + "\t" + .value.domain' "$profiles_file"
end
