function wizup -d "Install or update dbt-wizard"
    argparse h/help f/force -- $argv
    or return

    if set -q _flag_help
        echo "Install or update the macOS arm64 dbt-wizard build."
        logirl help_usage "wizup [OPTIONS]"
        logirl help_header Options
        logirl help_flag h/help "Show this help message"
        logirl help_flag f/force "Reinstall even when version.lock matches latest"
        logirl help_header Paths
        logirl help_cmd "~/.dbt/wizard-source" "Installed dbt-wizard binary and version.lock"
        logirl help_cmd "~/.local/bin/dbt-wizard" "Symlink refreshed after install"
        return 0
    end

    if test (count $argv) -gt 0
        logirl error "Unexpected argument: $argv[1]"
        printf "Try: wizup --help\n"
        return 2
    end

    for dependency in curl tar mktemp uname
        if not type -q $dependency
            logirl error "$dependency not found in PATH"
            return 127
        end
    end

    set -l platform (uname -s)/(uname -m)
    if test "$platform" != Darwin/arm64; and test "$platform" != Darwin/aarch64
        logirl error "wizup currently supports the dbt-wizard macOS arm64 build only (found $platform)"
        return 1
    end

    set -l source_dir "$HOME/.dbt/wizard-source"
    set -l lock_file "$source_dir/version.lock"
    set -l binary_path "$source_dir/dbt-wizard"
    set -l bin_dir "$HOME/.local/bin"
    set -l bin_link "$bin_dir/dbt-wizard"
    set -l cdn public.cdn.getdbt.com
    set -l target aarch64-apple-darwin
    set -l latest_url "https://$cdn/dbt-wizard/LATEST"
    set -l closing_message "🔮✨ The dbt Wizard awaits your query..."

    if type -q gum
        gum style --bold --foreground 141 "🪄📚 wizup: consulting the SQL spellbook"
    else
        logirl special "🪄📚 Consulting the SQL spellbook..."
    end

    set -l latest_response (curl -fsSL "$latest_url")
    or begin
        logirl error "Could not resolve latest dbt-wizard version"
        logirl info "🗺️ Magic Map (URL): $latest_url"
        return 1
    end

    set -l latest_version (string trim -- $latest_response[1])
    if test -z "$latest_version"
        logirl error "Latest dbt-wizard version was empty"
        return 1
    end

    set -l installed_version ""
    if test -f "$lock_file"
        read installed_version <"$lock_file"
        set installed_version (string trim -- "$installed_version")
    end

    set -l should_install 0
    if set -q _flag_force
        set should_install 1
        logirl warning "Forcibly summoning the spirits from $latest_version"
    else if not test -d "$source_dir"
        set should_install 1
        logirl info "Existing magical academy not found; enrolling you for Wizard School"
    else if not test -f "$lock_file"
        set should_install 1
        logirl info "No syllabus found at the magic academy; preparing a fresh summon..."
    else if test "$installed_version" != "$latest_version"
        set should_install 1
        logirl special "A stronger spell is available! $installed_version → $latest_version"
    else if not test -x "$binary_path"
        set should_install 1
        logirl warning "The academy syllabus says $latest_version, but the Wizard is not on campus"
    end

    if test $should_install -eq 0
        logirl success "The Wizard is already in class $latest_version at the academy at $source_dir"

        if test -e "$bin_link"; and not test -L "$bin_link"
            logirl error "$bin_link exists and is not a portal 🌀 (symlink)"
            logirl info "Please cast a vanishing spell before refreshing the portal 🌀"
            return 1
        end

        mkdir -p "$bin_dir"
        or begin
            logirl error "Could not create $bin_dir"
            return 1
        end

        ln -sfn "$binary_path" "$bin_link"
        or begin
            logirl error "Could not refresh portal 🌀: $bin_link"
            return 1
        end

        logirl success "🌀 Portal refreshed: $bin_link → $binary_path"
        if type -q gum
            gum style --bold --foreground 141 "$closing_message"
        else
            logirl special "$closing_message"
        end
        return 0
    end

    if test -e "$source_dir"; and not test -d "$source_dir"
        logirl error "$source_dir exists but it's not the Academy's castle 🏰. Clear the land if you want to build the academy."
        return 1
    end

    if test -L "$source_dir"
        logirl error "$source_dir is a portal 🌀; this spell requires the Academy to be located in a castle 🏰 (directory)!"
        return 1
    end

    if test -e "$bin_link"; and not test -L "$bin_link"
        logirl error "$bin_link exists and is not a portal 🌀 (symlink)"
        logirl info "Please cast a vanishing spell before refreshing the portal 🌀"
        return 1
    end

    set -l parent_dir (path dirname "$source_dir")
    mkdir -p "$parent_dir" "$bin_dir"
    or begin
        logirl error "Could not build the Magic Academy's castle 🏰 (directory)"
        return 1
    end

    set -l stage_dir (mktemp -d "$parent_dir/.wizard-source.next.XXXXXX")
    or begin
        logirl error "Could not create a temporary cauldron 🧙"
        return 1
    end

    set -l url "https://$cdn/dbt-wizard/dbt-wizard-v$latest_version-$target.tar.gz"
    logirl special "Summoning the Wizard @ $latest_version"
    logirl info "Spell scroll: $url"

    if not curl -fsSL "$url" | tar -xzf - -C "$stage_dir"
        set -l download_status $pipestatus
        rm -rf "$stage_dir"
        logirl error "Expansion spell exploded 💥 (curl=$download_status[1], tar=$download_status[2])"
        return 1
    end

    if not test -f "$stage_dir/dbt-wizard"
        rm -rf "$stage_dir"
        logirl error "The grimoire did not have the right spell! 😫 There's no wizard to summon."
        return 1
    end

    chmod +x "$stage_dir/dbt-wizard"
    or begin
        rm -rf "$stage_dir"
        logirl error "Could not activate the Wizard's magic!"
        return 1
    end

    printf "%s\n" "$latest_version" >"$stage_dir/version.lock"
    or begin
        rm -rf "$stage_dir"
        logirl error "Could not record the ritual in the grimoire (failed to write lockfile)"
        return 1
    end

    set -l old_dir ""
    if test -d "$source_dir"
        set old_dir (mktemp -d "$parent_dir/.wizard-source.old.XXXXXX")
        or begin
            rm -rf "$stage_dir"
            logirl error "Could not create a horcrux (backup)"
            return 1
        end
        rmdir "$old_dir"
        mv "$source_dir" "$old_dir"
        or begin
            rm -rf "$stage_dir"
            logirl error "Could not rebuild the Magical Academy 🏰"
            return 1
        end
    end

    mv "$stage_dir" "$source_dir"
    or begin
        if test -n "$old_dir"; and test -d "$old_dir"
            mv "$old_dir" "$source_dir"
        end
        rm -rf "$stage_dir"
        logirl error "Could not enroll the Wizard in the Academy @ $source_dir"
        return 1
    end

    if test -n "$old_dir"; and test -d "$old_dir"
        rm -rf "$old_dir"
    end

    if test -e "$bin_link"; and not test -L "$bin_link"
        logirl error "$bin_link exists and is not a portal 🌀"
        logirl info "The Wizard is in class at $latest_version, but the existing portal 🌀 needs a manual vanishing spell"
        return 1
    end

    ln -sfn "$binary_path" "$bin_link"
    or begin
        logirl error "Got the Wizard to the Academy, but could not recast the portal 🌀: $bin_link"
        return 1
    end

    logirl success "The wizard is in class $latest_version at the Magic Academy in $source_dir"
    logirl success "portal 🌀 opened: $bin_link → $binary_path"
    if type -q gum
        gum style --bold --foreground 141 "$closing_message"
    else
        logirl special "$closing_message"
    end
end
