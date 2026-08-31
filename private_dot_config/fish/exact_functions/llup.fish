function llup -d "Manage the local llama.cpp embedding server via launchd"
    argparse h/help -- $argv
    or return

    set -l label local.llama-embed
    set -l plist ~/.config/llama-embed/$label.plist
    set -l domain gui/(id -u)
    set -l service $domain/$label
    set -l url http://127.0.0.1:8383

    if set -q _flag_help
        echo "Manage the local llama.cpp embedding server (Qwen3-Embedding on port 8383) via launchd."
        logirl help_usage "llup [COMMAND]"
        logirl help_header "Commands"
        printf "  %s\n" "start    Load and start the server (restarts itself on crash while loaded)"
        printf "  %s\n" "stop     Stop and unload the server"
        printf "  %s\n" "restart  Restart the loaded server"
        printf "  %s\n" "status   Show launchd state and model readiness (default)"
        printf "  %s\n" "logs     Show recent server log lines"
        return 0
    end

    if not type -q launchctl
        logirl error "launchctl not found — llup is macOS-only"
        return 127
    end

    set -l cmd status
    if set -q argv[1]
        set cmd $argv[1]
    end

    switch $cmd
        case start
            if launchctl print $service >/dev/null 2>&1
                logirl info "$label is already loaded"
                llup status
                return 0
            end
            launchctl bootstrap $domain $plist
            or begin
                logirl error "Failed to bootstrap $plist"
                return 1
            end
            logirl success "Started $label — model loads in the background; check with llup status"
        case stop
            if not launchctl bootout $service 2>/dev/null
                logirl info "$label is not loaded"
                return 0
            end
            logirl success "Stopped $label"
        case restart
            launchctl kickstart -k $service
            or begin
                logirl error "$label is not loaded; use llup start"
                return 1
            end
            logirl success "Restarted $label"
        case status
            if not launchctl print $service >/dev/null 2>&1
                logirl info "$label: not loaded — start with llup start"
                return 0
            end
            set -l health (curl -fsS -m 2 $url/health 2>/dev/null)
            if string match -q '*ok*' -- $health
                logirl success "$label: serving embeddings on $url"
            else
                logirl warning "$label: loaded but not ready (model still loading, or crashed — llup logs)"
            end
        case logs
            tail -n 40 ~/Library/Logs/llama-embed.log
        case '*'
            logirl error "Unknown command: $cmd"
            printf "Try: llup --help\n"
            return 2
    end
end
