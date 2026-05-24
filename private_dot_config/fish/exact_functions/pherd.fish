function pherd -d "Start a herdr session for the current project with a dotfiles workspace alongside"
    argparse a/attach h/help -- $argv
    or return

    if set -q _flag_help
        echo "Start (if needed) the default herdr server, create a workspace for the current"
        echo "project, and add a second workspace pointing at this dotfiles repo."
        logirl help_usage "pherd [OPTIONS]"
        logirl help_header Options
        logirl help_flag h/help "Show this help message"
        logirl help_flag a/attach "Attach to the herdr session after setup"
        return 0
    end

    if not type -q herdr
        logirl error "herdr not found in PATH"
        logirl info "Install with: $(set_color brmagenta)brew install supermodellabs/tap/herdr$(set_color normal)"
        return 127
    end
    if not type -q jq
        logirl error "jq not found in PATH"
        return 127
    end

    set -l dotfiles_dir "$HOME/.local/share/chezmoi"

    set -l running (herdr session list --json | jq -r '.sessions[] | select(.default == true) | .running')
    if test "$running" != true
        logirl info "No herdr server running, starting one..."
        herdr server </dev/null >/dev/null 2>&1 &
        disown
        for i in (seq 1 25)
            sleep 0.2
            set running (herdr session list --json 2>/dev/null | jq -r '.sessions[] | select(.default == true) | .running')
            test "$running" = true; and break
        end
        if test "$running" != true
            logirl error "Herdr server did not become ready in time"
            return 1
        end
        logirl success "Herdr server started"
    else
        logirl info "Herdr server already running"
    end

    set -l proj (path basename $PWD)
    set -l in_dotfiles 1
    test (path resolve $PWD) = (path resolve $dotfiles_dir); or set in_dotfiles 0

    if test $in_dotfiles -eq 1
        if herdr workspace create --cwd $PWD --label dotfiles --no-focus >/dev/null
            logirl success "Created 'dotfiles' workspace"
        else
            logirl error "Failed to create dotfiles workspace"
            return 1
        end
    else
        if herdr workspace create --cwd $PWD --no-focus >/dev/null
            logirl success "Created workspace for $proj"
        else
            logirl error "Failed to create workspace for $proj"
            return 1
        end
        if herdr workspace create --cwd $dotfiles_dir --label dotfiles --no-focus >/dev/null
            logirl success "Created 'dotfiles' workspace"
        else
            logirl error "Failed to create dotfiles workspace"
            return 1
        end
    end

    if set -q _flag_attach
        exec herdr
    else
        logirl success "Your herdr session for $proj is ready - have fun!"
        return 0
    end
end
